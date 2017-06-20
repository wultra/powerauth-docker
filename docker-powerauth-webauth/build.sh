#!/bin/bash

mkdir ./build
curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar > ./build/mysql-connector-java.jar
curl -L https://dl.dropboxusercontent.com/u/6405782/tmp_pa_development/powerauth-webauth.war > ./build/powerauth-webauth.war

docker build -t powerauth-webauth ./

rm -rf ./build
