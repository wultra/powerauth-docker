#!/bin/bash

mkdir ./build
curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar > ./build/mysql-connector-java.jar
curl -L http://assets.powerauth.com/dev/powerauth-webauth.war > ./build/powerauth-webauth.war

docker build -t powerauth-webauth ./

rm -rf ./build
