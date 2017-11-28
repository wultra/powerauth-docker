#!/bin/bash

## Check prerequisites

if ! type "docker" > /dev/null; then
    echo "Error: 'docker' command must be installed on the system.";
    exit
fi

## Build Database Images
docker build -t powerauth-server-mysql -f docker-powerauth-server-mysql/Dockerfile .
docker build -t powerauth-push-mysql -f docker-powerauth-push-mysql/Dockerfile .
docker build -t powerauth-webflow-mysql -f docker-powerauth-webflow-mysql/Dockerfile .

## Build Application Images
docker build -t powerauth-server -f docker-powerauth-server/Dockerfile .
docker build -t powerauth-push-server -f docker-powerauth-push-server/Dockerfile .
docker build -t powerauth-nextstep -f docker-powerauth-nextstep/Dockerfile .
docker build -t powerauth-webflow -f docker-powerauth-webflow/Dockerfile .
