#!/bin/sh

apk add --no-cache --purge -uU \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    coturn sqlite-libs

find /usr -name "__pycache__" -exec rm -rf {} +
find /usr -name "*.pyc" -exec rm {} +

apk del alpine-keys

rm -rf /etc/apk \
       /root/.cache \
       /root/.config \
       /var/cache/*
