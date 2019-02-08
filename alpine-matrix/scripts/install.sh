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

install_appservice() {
    PKG=$1
    LIBDIR=/usr/lib/${PKG}

    mkdir -p ${LIBDIR}
    cd ${LIBDIR}
    yarn add ${PKG}
    ln -s ${IRC_DIR}/node_modules/${PKG}/bin/${PKG} /usr/local/bin/${PKG}
}

install_appservice matrix-appservice-irc
install_appservice matrix-appservice-slack

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
