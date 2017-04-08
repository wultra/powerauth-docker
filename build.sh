#!/bin/bash

## Check prerequisites

if ! foobar_loc="$(type -p "curl")" || [ -z "$foobar_loc" ]; then
    echo "Error: 'curl' command must be installed on the system.";
    exit
fi

if ! foobar_loc="$(type -p "awk")" || [ -z "$foobar_loc" ]; then
    echo "Error: 'awk' command must be installed on the system.";
    exit
fi

if ! foobar_loc="$(type -p "docker")" || [ -z "$foobar_loc" ]; then
    echo "Error: 'docker' command must be installed on the system.";
    exit
fi

if ! foobar_loc="$(type -p "docker-compose")" || [ -z "$foobar_loc" ]; then
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

if [ -z "$MYSQL_VERSION" ]; then
    MYSQL_VERSION="5.1.41"
fi

export PA_VERSION
export PA_ADMIN_VERSION
export MYSQL_VERSION

## Launch build scripts

CURRENT_DIR=`pwd`

cd $CURRENT_DIR/docker-powerauth-mysql ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-java-server ; sh ./build.sh
cd $CURRENT_DIR/docker-powerauth-admin ; sh ./build.sh

cd $CURRENT_DIR/
