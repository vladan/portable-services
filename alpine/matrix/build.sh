#!/bin/sh

set -e

[ -z $NAME ] && NAME=matrix
IMAGE=/tmp/$NAME.raw

[ -z $ROOTFS         ] && ROOTFS=$(mktemp -d $NAME.XXX -t)
[ -z $ALPINE_VERSION ] && ALPINE_VERSION=3.12
[ -z $ALPINE_RELEASE ] && ALPINE_RELEASE=0

ALPINE_TARBALL=alpine-minirootfs-$ALPINE_VERSION.$ALPINE_RELEASE-x86_64.tar.gz

[ -f $IMAGE.raw      ] && rm $IMAGE.raw
[ -f $ALPINE_TARBALL ] || wget http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/releases/x86_64/$ALPINE_TARBALL

mkdir -p $ROOTFS
tar xf $ALPINE_TARBALL -C $ROOTFS/ \
    ./etc/apk ./usr ./lib ./bin ./sbin ./var

chmod 755 $ROOTFS

mkdir -p \
    $ROOTFS/etc/systemd/system \
    $ROOTFS/var/{lib,run,tmp} \
    $ROOTFS/{dev,tmp,proc,root,run,sys} \
    $ROOTFS/etc/matrix \
    $ROOTFS/var/lib/matrix-synapse \
    $ROOTFS/run/systemd/unit-root/var/tmp

touch $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf
cp systemd/matrix.service $ROOTFS/etc/systemd/system/$NAME.service
cp conf/os-release $ROOTFS/etc/os-release

sudo systemd-nspawn --directory $ROOTFS/ \
                    --bind $HOME/dev/python/pyopenssl:/tmp/pyopenssl \
                    --bind=$PWD/scripts/install.sh:/root/install.sh \
                    /bin/sh /root/install.sh

mksquashfs $ROOTFS/ $IMAGE -all-root -noappend
sudo portablectl detach $IMAGE || true
sudo portablectl attach $IMAGE
sudo systemctl restart $NAME.service
