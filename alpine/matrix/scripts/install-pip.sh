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

pip3 install --upgrade --force pip setuptools
pip3 install https://github.com/matrix-org/synapse/tarball/master

apk del .synapse-build

# Runtime packages
apk --no-cache add \
    libjpeg-turbo \
    libmagic \
    libressl \
    python3

find /usr -name "__pycache__" -exec rm -rf {} +
find /usr -name "*.pyc" -exec rm {} +

apk del alpine-keys

rm -rf /etc/apk \
       /root/.cache \
       /root/.config \
       /var/cache/*
