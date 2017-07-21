#!/bin/bash

mkdir ./build
# curl -L https://github.com/lime-company/lime-security-powerauth-admin/releases/download/$PA_ADMIN_VERSION/powerauth-admin.war > ./build/powerauth-admin.war
curl -L https://dl.dropboxusercontent.com/u/6405782/tmp_pa_development/powerauth-admin.war > ./build/powerauth-admin.war

docker build -t powerauth-admin ./

rm -rf ./build
