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
    yarn \
    zlib-dev

pip3 install --upgrade pip setuptools
pip3 install https://github.com/matrix-org/synapse/tarball/master
pip3 install mautrix-telegram

IRC_DIR=/usr/lib/matrix-appservice-irc/
mkdir ${IRC_DIR}
cd ${IRC_DIR}
yarn add matrix-appservice-irc
ln -s ${IRC_DIR}/node_modules/matrix-appservice-irc/bin/matrix-appservice-irc /usr/local/bin/matrix-appservice-irc

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
find /usr -name "*yarn*" -exec rm -rf {} +
find / -name "*node-gyp*" -exec rm -rf {} +

apk del alpine-keys

rm -rf /etc/apk \
       /root/.cache \
       /root/.config \
       /root/.npm \
       /var/cache/*
