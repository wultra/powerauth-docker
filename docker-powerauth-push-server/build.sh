#!/bin/bash

mkdir ./build
curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar > ./build/mysql-connector-java.jar
curl -L http://assets.powerauth.com/dev/powerauth-push-server.war > ./build/powerauth-push-server.war

docker build -t powerauth-push-server ./

rm -rf ./build
