#!/bin/bash

mkdir ./build
curl -L https://dl.dropboxusercontent.com/u/6405782/tmp_pa_development/powerauth-credential-server-sample.war > ./build/powerauth-credential-server-sample.war

docker build -t powerauth-credential-server-sample ./

rm -rf ./build
