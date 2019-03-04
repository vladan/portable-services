#!/bin/sh

ROOTFS=/tmp/matrix

wget http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/x86_64/alpine-minirootfs-3.9.0-x86_64.tar.gz

mkdir -p $ROOTFS
tar xf alpine-minirootfs-3.9.0-x86_64.tar.gz -C $ROOTFS/ \
    ./etc/apk ./etc/os-release ./usr ./lib ./bin ./sbin ./var

mkdir -p $ROOTFS/etc/systemd/system \
         $ROOTFS/var/{lib,run,tmp} \
         $ROOTFS/{dev,tmp,proc,root,run,sys} \
         $ROOTFS/etc/matrix \
         $ROOTFS/var/lib/matrix-{synapse,appservice-irc}
touch    $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf

touch $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf
cp systemd/* $ROOTFS/etc/systemd/system/

sudo systemd-nspawn --bind=$PWD/scripts/install.sh:/root/install.sh -D $ROOTFS/ /bin/sh /root/install.sh
mksquashfs $ROOTFS/ /tmp/matrix.raw
