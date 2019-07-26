#!/bin/sh

ROOTFS=/tmp/matrix
ALPINE_TARBALL=alpine-minirootfs-3.9.2-x86_64.tar.gz

wget http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/x86_64/$ALPINE_TARBALL

mkdir -p $ROOTFS
tar xf $ALPINE_TARBALL -C $ROOTFS/ \
    ./etc/apk ./etc/os-release ./usr ./lib ./bin ./sbin ./var

mkdir -p \
    $ROOTFS/etc/systemd/system \
    $ROOTFS/var/{lib,run,tmp} \
    $ROOTFS/{dev,tmp,proc,root,run,sys} \
    $ROOTFS/etc/matrix \
    $ROOTFS/var/lib/matrix-{synapse,appservice-irc}

touch $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf

cp systemd/* $ROOTFS/etc/systemd/system/

sudo systemd-nspawn --bind=$PWD/scripts/install.sh:/root/install.sh -D $ROOTFS/ /bin/sh /root/install.sh
mksquashfs $ROOTFS/ /tmp/matrix.raw
