#!/bin/bash
PA_NAME="powerauth-mysql"
ROOT_PASSWORD="root"
DATA_VOLUME="/tmp/mysql-datadir"
PA_NETWORK="powerauth"

if ! docker network ls | awk -v app="$PA_NETWORK" 'NR>1{  ($(NF) == app )  }'; then
    docker network create $PA_NETWORK;
fi

rm -rf /tmp/mysql-datadir
if docker ps | awk -v app="$PA_NAME" 'NR>1{  ($(NF) == app )  }'; then
    docker stop $PA_NAME && docker rm $PA_NAME;
fi

docker run -d \
    --network=$PA_NETWORK \
    -p3306:3306 \
    --name=$PA_NAME \
    -e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
    -v $DATA_VOLUME:/var/lib/mysql \
    powerauth-mysql
