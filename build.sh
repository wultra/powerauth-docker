#!/bin/bash

## Check Prerequisites

if ! type "docker" > /dev/null; then
    echo "Error: 'docker' command must be installed on the system.";
    exit
fi

# Prepare Build Number
if [ -z ${TAG+x} ]; then
    export PRODUCT_VERSION="2022.12"
    if [ -z ${BUILD+x} ]; then
        export BUILD=$(date +%s)
    fi
    export TAG=$PRODUCT_VERSION.$BUILD
fi

## Build Database Images
docker build -t powerauth/server-postgresql:$TAG -t powerauth/server-postgresql:latest -f docker-powerauth-server-postgresql/Dockerfile .
docker build -t powerauth/push-postgresql:$TAG -t powerauth/push-postgresql:latest -f docker-powerauth-push-postgresql/Dockerfile .
docker build -t powerauth/webflow-postgresql:$TAG -t powerauth/webflow-postgresql:latest -f docker-powerauth-webflow-postgresql/Dockerfile .

## Build Application Images
docker build -t powerauth/server:$TAG -t powerauth/server:latest -f docker-powerauth-server/Dockerfile .
docker build -t powerauth/push-server:$TAG -t powerauth/push-server:latest -f docker-powerauth-push-server/Dockerfile .
docker build -t powerauth/nextstep:$TAG -t powerauth/nextstep:latest -f docker-powerauth-nextstep/Dockerfile .
docker build -t powerauth/data-adapter:$TAG -t powerauth/data-adapter:latest -f docker-powerauth-data-adapter/Dockerfile .
docker build -t powerauth/webflow:$TAG -t powerauth/webflow:latest -f docker-powerauth-webflow/Dockerfile .
docker build -t powerauth/tpp-engine:$TAG -t powerauth/tpp-engine:latest -f docker-powerauth-tpp-engine/Dockerfile .

echo "TAG: $TAG"
