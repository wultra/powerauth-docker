#!/bin/bash

mkdir ./build
curl -L https://github.com/lime-company/lime-security-powerauth/releases/download/$PA_REST_API_VERSION/powerauth-restful-server-spring.war > ./build/powerauth-rest-api.war

docker build -t powerauth-rest-api ./

rm -rf ./build
