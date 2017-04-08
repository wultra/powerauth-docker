#!/bin/bash

if [ -z "$PA_VERSION" ]; then
    PA_VERSION="0.15.0"
fi

if [ -z "$PA_ADMIN_VERSION" ]; then
    PA_ADMIN_VERSION="0.15.0"
fi

if [ -z "$MYSQL_VERSION" ]; then
    MYSQL_VERSION="5.1.41"
fi

export PA_VERSION
export PA_ADMIN_VERSION
export MYSQL_VERSION

CURRENT_DIR=`pwd`

cd $CURRENT_DIR/docker-powerauth-mysql ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-java-server ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-admin ; sh ./build.sh

cd $CURRENT_DIR/
