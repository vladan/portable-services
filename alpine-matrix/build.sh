#!/bin/sh

ROOTFS=rootfs

wget http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/x86_64/alpine-minirootfs-3.9.0-x86_64.tar.gz
mkdir -p $ROOTFS

tar xf alpine-minirootfs-3.9.0-x86_64.tar.gz -C $ROOTFS/ \
    ./etc/apk ./etc/os-release ./usr ./lib ./bin ./sbin ./var

mkdir -p $ROOTFS/etc/systemd/system \
         $ROOTFS/var/{lib,run,tmp} \
         $ROOTFS/{dev,tmp,proc,root,run,sys} \
         $ROOTFS/{var/lib,var/log,etc}/synapse
touch    $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf

cp install.sh $ROOTFS/root/
sudo systemd-nspawn -D $ROOTFS/ /bin/sh /root/install.sh

cp *.service $ROOTFS/etc/systemd/system/

mksquashfs $ROOTFS/ synapse.raw
