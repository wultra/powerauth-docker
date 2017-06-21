#!/bin/bash

## Check prerequisites

if ! type  "curl" > /dev/null; then
    echo "Error: 'curl' command must be installed on the system.";
    exit
fi

if ! type "awk" > /dev/null; then
    echo "Error: 'awk' command must be installed on the system.";
    exit
fi

if ! type "docker" > /dev/null; then
    echo "Error: 'docker' command must be installed on the system.";
    exit
fi

if ! type "docker-compose" > /dev/null; then
    echo "Error: 'docker-compose' command must be installed on the system.";
    exit
fi

## Make sure environment variables are correctly set

if [ -z "$PA_VERSION" ]; then
    PA_VERSION="0.15.0"
fi

if [ -z "$PA_ADMIN_VERSION" ]; then
    PA_ADMIN_VERSION="0.15.0"
fi

if [ -z "$PA_PUSH_VERSION" ]; then
    PA_PUSH_VERSION="0.15.1-alpha"
fi

if [ -z "$PA_REST_API_VERSION" ]; then
    PA_REST_API_VERSION="0.15.0"
fi

if [ -z "$MYSQL_VERSION" ]; then
    MYSQL_VERSION="5.1.41"
fi

export PA_VERSION
export PA_ADMIN_VERSION
export PA_PUSH_VERSION
export PA_REST_API_VERSION
export MYSQL_VERSION
export ALPN_BOOT_VERSION

## Launch build scripts

CURRENT_DIR=`pwd`

## Build Database Images
cd $CURRENT_DIR/docker-powerauth-mysql ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-push-mysql ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-webauth-mysql ; sh ./build.sh

## Build Application Images
cd $CURRENT_DIR/docker-powerauth-java-server ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-admin ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-push-server ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-rest-api ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-nextstep ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-credential-server-sample ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-webauth ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-webauth-client ; sh ./build.sh

cd $CURRENT_DIR/
