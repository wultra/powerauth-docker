#!/bin/bash

mkdir ./build
curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar > ./build/mysql-connector-java.jar
curl -L http://assets.powerauth.com/dev/powerauth-credential-server-sample.war > ./build/powerauth-credential-server-sample.war

docker build -t powerauth-credential-server-sample ./

rm -rf ./build
