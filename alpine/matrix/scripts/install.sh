#!/bin/sh

apk --no-cache add --no-scripts --no-commit-hooks --initramfs-diskless-boot synapse

find /usr -name "__pycache__" -exec rm -rf {} +
find /usr -name "*.pyc" -exec rm {} +

apk del alpine-keys alpine-baselayout

rm -rf /etc/apk \
       /etc/ssl \
       /etc/terminfo \
       /etc/synapse \
       /root/.cache \
       /root/.config \
       /var/cache/*
