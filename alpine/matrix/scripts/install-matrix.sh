#!/bin/sh

apk --no-cache add --no-scripts --no-commit-hooks synapse

find /usr -name "__pycache__" -exec rm -rf {} +
find /usr -name "*.pyc" -exec rm {} +

apk del alpine-keys

rm -rf /etc/apk \
       /root/.cache \
       /root/.config \
       /var/cache/*
