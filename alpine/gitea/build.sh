#!/bin/sh

set -e

[ -z $ROOTFS         ] && ROOTFS=/tmp/gitea
[ -z $ALPINE_VERSION ] && ALPINE_VERSION=3.10
[ -z $ALPINE_RELEASE ] && ALPINE_RELEASE=0

ALPINE_TARBALL=alpine-minirootfs-$ALPINE_VERSION.$ALPINE_RELEASE-x86_64.tar.gz

[ -f $ROOTFS.raw     ] && rm $ROOTFS.raw
[ -f $ALPINE_TARBALL ] || wget http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/releases/x86_64/$ALPINE_TARBALL

(sudo systemctl stop gitea.service && sudo portablectl detach gitea) || echo "Image not attached."

mkdir -p $ROOTFS
tar xf $ALPINE_TARBALL -C $ROOTFS/

chmod 755 $ROOTFS

mkdir -p \
    $ROOTFS/etc/systemd/system \
    $ROOTFS/etc/gitea \
    $ROOTFS/var/lib/gitea \
    $ROOTFS/run/gitea \
    $ROOTFS/root/.ssh

touch  $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf

sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk update
sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk add --no-cache gitea openssh-keygen
sudo systemd-nspawn --directory $ROOTFS/ /bin/rm -rf /etc/apk/* /var/cache/*

cp systemd/* $ROOTFS/etc/systemd/system/

rm -f $ROOTFS.raw
mksquashfs $ROOTFS/ $ROOTFS.raw -all-root -noappend
sudo portablectl attach $ROOTFS.raw
