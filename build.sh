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

## Launch build scripts

CURRENT_DIR=`pwd`

## Build Database Images

cd $CURRENT_DIR/docker-powerauth-server-mysql ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-push-mysql ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-webflow-mysql ; sh ./build.sh
cd ..

## Build Application Images
docker build -t powerauth-server -f docker-powerauth-server/Dockerfile .
docker build -t powerauth-push-server -f docker-powerauth-push-server/Dockerfile .
docker build -t powerauth-nextstep -f docker-powerauth-nextstep/Dockerfile .
docker build -t powerauth-webflow -f docker-powerauth-webflow/Dockerfile .
# docker build -t powerauth-webflow-demo -f docker-powerauth-webflow-demo/Dockerfile .

cd $CURRENT_DIR/
