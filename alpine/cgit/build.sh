#!/bin/sh

set -e

NAME=cgit
IMAGE=/tmp/$NAME.raw

[ -z $ROOTFS         ] && ROOTFS=$(mktemp -d $NAME.XXX -t)
[ -z $ALPINE_VERSION ] && ALPINE_VERSION=3.10
[ -z $ALPINE_RELEASE ] && ALPINE_RELEASE=0

ALPINE_TARBALL=alpine-minirootfs-$ALPINE_VERSION.$ALPINE_RELEASE-x86_64.tar.gz

[ -f $NAME.raw     ] && rm $NAME.raw
[ -f $ALPINE_TARBALL ] || wget http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/releases/x86_64/$ALPINE_TARBALL

(sudo systemctl stop $NAME.service && sudo portablectl detach $NAME) || echo "Image not attached."

tar xf $ALPINE_TARBALL -C $ROOTFS/

chmod 755 $ROOTFS

mkdir -p \
    $ROOTFS/etc/systemd/system \
    $ROOTFS/etc/$NAME \
    $ROOTFS/var/lib/$NAME \
    $ROOTFS/run/$NAME \
    $ROOTFS/root/.ssh

touch $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf
cp systemd/* $ROOTFS/etc/systemd/system/

sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk update
sudo systemd-nspawn --directory $ROOTFS/ /sbin/apk add cgit uwsgi-cgi
sudo systemd-nspawn --directory $ROOTFS/ /bin/rm -rf /etc/apk/* /var/cache/*

mksquashfs $ROOTFS/ $IMAGE -all-root -noappend
sudo portablectl attach $IMAGE
sudo systemctl restart $NAME.service
