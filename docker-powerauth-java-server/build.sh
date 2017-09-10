#!/bin/bash

mkdir ./build
curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar > ./build/mysql-connector-java.jar
curl -L http://assets.powerauth.com/dev/powerauth-java-server.war > ./build/powerauth-java-server.war

docker build -t powerauth-java-server ./

rm -rf ./build
