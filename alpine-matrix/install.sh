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
    npm \
    python3-dev \
    zlib-dev

pip3 install --upgrade pip setuptools
pip3 install https://github.com/matrix-org/synapse/tarball/master
pip3 install mautrix-telegram

npm install matrix-appservice-irc --global

apk del .synapse-build

# Runtime packages.
apk --no-cache add \
    libjpeg-turbo \
    libmagic \
    libressl2.7-libssl \
    nodejs \
    python3

find /usr -name "__pycache__" -exec rm -rf {} +
find /usr -name "*.pyc" -exec rm {} +
rm -rf /root/.cache \
       /root/.config \
       /root/.npm \
       /etc/apk
