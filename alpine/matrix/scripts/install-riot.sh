#!/bin/sh

apk --no-cache add --no-scripts --no-commit-hooks riot-web nginx

apk del alpine-keys

rm -rf /etc/apk \
       /root/.cache \
       /root/.config \
       /var/cache/*
