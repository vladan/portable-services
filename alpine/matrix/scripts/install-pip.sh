#!/bin/sh

apk --no-cache add --virtual .synapse-build \
    build-base \
    git \
    libevent-dev \
    libffi-dev \
    libjpeg-turbo-dev \
    libressl-dev \
    libxslt-dev \
    linux-headers \
    python3-dev \
    py3-pip \
    zlib-dev

pip3 install --upgrade pip setuptools
pip3 install https://github.com/matrix-org/synapse/tarball/master

apk del .synapse-build

# Runtime packages.
apk --no-cache add \
    libjpeg-turbo \
    libmagic \
    libressl2.7-libssl \
    python3

find /usr -name "__pycache__" -exec rm -rf {} +
find /usr -name "*.pyc" -exec rm {} +
find /usr -name "*yarn*" -exec rm -rf {} +

apk del alpine-keys

rm -rf /etc/apk \
       /root/.cache \
       /root/.config \
       /var/cache/*
