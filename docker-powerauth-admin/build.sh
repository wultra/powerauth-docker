#!/bin/bash

mkdir ./build
curl -L http://assets.powerauth.com/dev/powerauth-admin.war > ./build/powerauth-admin.war

docker build -t powerauth-admin ./

rm -rf ./build
