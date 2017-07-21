#!/bin/bash

mkdir ./build
curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar > ./build/mysql-connector-java.jar
# curl -L https://github.com/lime-company/lime-security-powerauth-push/releases/download/$PA_PUSH_VERSION/powerauth-push-server.war > ./build/powerauth-push-server.war
curl -L https://dl.dropboxusercontent.com/u/6405782/tmp_pa_development/powerauth-push-server.war > ./build/powerauth-push-server.war

docker build -t powerauth-push-server ./

rm -rf ./build
