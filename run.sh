#!/bin/bash
cd docker-powerauth-mysql
sh ./run.sh

cd ..
cd docker-powerauth-java-server
sh ./run.sh

cd ..
cd docker-powerauth-admin
sh ./run.sh

cd ..
