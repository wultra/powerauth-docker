#!/bin/bash

## Check Prerequisites

if ! type "docker" > /dev/null; then
    echo "Error: 'docker' command must be installed on the system.";
    exit
fi

# Prepare Build Number
if [ -z ${TAG+x} ]; then
    export PRODUCT_VERSION="2019.05"
    if [ -z ${BUILD+x} ]; then
        export BUILD=$(date +%s)
    fi
    export TAG=$PRODUCT_VERSION.$BUILD
fi

## Build Database Images
docker build -t powerauth/server-mysql:$TAG -t powerauth/server-mysql:latest -f docker-powerauth-server-mysql/Dockerfile .
docker build -t powerauth/push-mysql:$TAG -t powerauth/push-mysql:latest -f docker-powerauth-push-mysql/Dockerfile .
docker build -t powerauth/webflow-mysql:$TAG -t powerauth/webflow-mysql:latest -f docker-powerauth-webflow-mysql/Dockerfile .

## Build Application Images
docker build -t powerauth/server:$TAG -t powerauth/server:latest -f docker-powerauth-server/Dockerfile .
docker build -t powerauth/push-server:$TAG -t powerauth/push-server:latest -f docker-powerauth-push-server/Dockerfile .
docker build -t powerauth/nextstep:$TAG -t powerauth/nextstep:latest -f docker-powerauth-nextstep/Dockerfile .
docker build -t powerauth/data-adapter:$TAG -t powerauth/data-adapter:latest -f docker-powerauth-data-adapter/Dockerfile .
docker build -t powerauth/webflow:$TAG -t powerauth/webflow:latest -f docker-powerauth-webflow/Dockerfile .

echo "TAG: $TAG"
