#!/bin/sh

set -e

[ -z $NAME ] && NAME=matrix
IMAGE=/tmp/$NAME.raw

[ -z $ROOTFS         ] && ROOTFS=$(mktemp -d $NAME.XXX -t)
[ -z $ALPINE_VERSION ] && ALPINE_VERSION=3.13
[ -z $ALPINE_RELEASE ] && ALPINE_RELEASE=1

ALPINE_TARBALL=alpine-minirootfs-$ALPINE_VERSION.$ALPINE_RELEASE-x86_64.tar.gz

[ -f $IMAGE.raw      ] && rm $IMAGE.raw
[ -f $ALPINE_TARBALL ] || wget http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/releases/x86_64/$ALPINE_TARBALL

mkdir -p $ROOTFS
tar xf $ALPINE_TARBALL -C $ROOTFS/ \
    ./etc ./usr ./lib ./bin ./sbin ./var

chmod 755 $ROOTFS

mkdir -p \
    $ROOTFS/etc/systemd/system \
    $ROOTFS/var/{lib,run,tmp} \
    $ROOTFS/{dev,tmp,proc,root,run,sys} \
    $ROOTFS/etc/$NAME \
    $ROOTFS/var/lib/$NAME \
    $ROOTFS/run/systemd/unit-root/var/tmp

touch $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf
cp -a systemd/${NAME}* $ROOTFS/etc/systemd/system/
cp conf/os-release $ROOTFS/etc/os-release

sudo systemd-nspawn --directory $ROOTFS/ \
                    --bind=$PWD/scripts/install-$NAME.sh:/root/install.sh \
                    /bin/sh /root/install.sh

sudo mksquashfs $ROOTFS/ $IMAGE -all-root -noappend
sudo systemctl stop $IMAGE || true
sudo portablectl detach $IMAGE || true
sudo portablectl attach $IMAGE
sudo systemctl restart $NAME.service
