#! /bin/sh

ROOTFS=`mktemp -d rootfs.XXX -t`
TMPDIR=/tmp
TARBALL=alpine-minirootfs-3.10.1-x86_64.tar.gz
URL=http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/x86_64/$TARBALL

# 6. undo
sudo systemctl stop simple-test
sudo portablectl detach $TMPDIR/simple.raw

[ "$URL" ] && wget -c $URL

# 1. create rootfs
tar xf $TARBALL -C $ROOTFS/ \
    ./etc/os-release ./usr ./lib ./bin ./sbin

# 2. create mount points
chmod 755 $ROOTFS
mkdir -p $ROOTFS/etc/systemd/system $ROOTFS/{proc,sys,dev,run,tmp,var/tmp}
touch $ROOTFS/etc/machine-id $ROOTFS/etc/resolv.conf

# 3. simple service unit
cat <<EOF > $ROOTFS/etc/systemd/system/simple-test.service
[Unit]
Description=Simple portable test service

[Service]
Type=exec
ExecStart=/bin/sh -c 'while /bin/sleep 5; do echo ping; done'
EOF

# 4. create a read-only squashfs rootfs image
mksquashfs $ROOTFS $TMPDIR/simple.raw -all-root -noappend

# 5. attach and start the service
sudo portablectl attach $TMPDIR/simple.raw
sudo systemctl start simple-test
