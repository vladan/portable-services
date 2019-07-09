#!/bin/sh

[ -z $ROOTFS         ] && ROOTFS=/tmp/gitea
[ -z $ALPINE_VERSION ] && ALPINE_VERSION=3.10
[ -z $ALPINE_RELEASE ] && ALPINE_RELEASE=0

ALPINE_TARBALL=alpine-minirootfs-$ALPINE_VERSION.$ALPINE_RELEASE-x86_64.tar.gz

[ -f $ROOTFS.raw     ] && sudo rm $ROOTFS.raw
[ -f $ALPINE_TARBALL ] || wget http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/releases/x86_64/$ALPINE_TARBALL

sudo systemctl stop gitea.service && sudo portablectl detach gitea

sudo mkdir -p $ROOTFS
sudo tar xf $ALPINE_TARBALL -C $ROOTFS/

sudo mkdir -p \
    $ROOTFS/etc/systemd/system \
    $ROOTFS/var/{lib,run,tmp} \
    $ROOTFS/{dev,tmp,proc,root,run,sys} \
    $ROOTFS/etc/gitea \
    $ROOTFS/var/lib/gitea \
    $ROOTFS/dev/log \
    $ROOTFS/run/systemd/journal \
    $ROOTFS/run/{dbus,gitea} \
    $ROOTFS/{proc,sys,dev} \
    $ROOTFS/var/tmp/ \
    $ROOTFS/root/.ssh

sudo touch  $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf

sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk update
sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk add --no-cache gitea openssh-keygen
# sudo systemd-nspawn --directory $ROOTFS/ /bin/rm -rf /etc/apk /root/.cache /root/.config /var/cache/*

sudo cp systemd/* $ROOTFS/etc/systemd/system/

sudo mksquashfs $ROOTFS/ $ROOTFS.raw -all-root -noappend
#sudo rm -rf $ROOTFS
sudo portablectl attach $ROOTFS.raw
