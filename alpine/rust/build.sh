#!/bin/sh

ROOTFS=/tmp/cgit
ALPINE_TARBALL=alpine-minirootfs-3.9.2-x86_64.tar.gz

# wget http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/x86_64/$ALPINE_TARBALL

mkdir -p $ROOTFS
tar xf $ALPINE_TARBALL -C $ROOTFS/ \
    ./etc/apk ./etc/os-release ./usr ./lib ./bin ./sbin ./var

mkdir -p $ROOTFS/etc/systemd/system \
         $ROOTFS/var/{lib,run,tmp} \
         $ROOTFS/{dev,tmp,proc,root,run,sys} \
         $ROOTFS/etc/git \
         $ROOTFS/var/lib/git
touch    $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf

sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk update
sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk add cgit uwsgi-cgi
cp systemd/* $ROOTFS/etc/systemd/system/

mksquashfs $ROOTFS/ $ROOTFS.raw
