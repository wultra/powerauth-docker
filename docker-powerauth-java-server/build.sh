#!/bin/bash

mkdir ./build
curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar > ./build/mysql-connector-java.jar
# curl -L https://github.com/lime-company/lime-security-powerauth/releases/download/$PA_VERSION/powerauth-java-server.war > ./build/powerauth-java-server.war
curl -L https://dl.dropboxusercontent.com/u/6405782/tmp_pa_development/powerauth-java-server.war > ./build/powerauth-java-server.war

docker build -t powerauth-java-server ./

rm -rf ./build
