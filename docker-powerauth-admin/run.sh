#!/bin/bash
PA_NAME="powerauth-admin"
PA_NETWORK="limesecuritypowerauthdocker_default"

if ! docker network ls | awk -v app="$PA_NETWORK" 'NR>1{  ($(NF) == app )  }'; then
    docker network create $PA_NETWORK;
fi

if docker ps | awk -v app="$PA_NAME" 'NR>1{  ($(NF) == app )  }'; then
    docker stop $PA_NAME && docker rm $PA_NAME;
fi

docker run -d \
    --network=$PA_NETWORK \
    -p18080:8080 \
    --name=$PA_NAME \
    powerauth-admin
