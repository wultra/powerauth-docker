#!/bin/bash

mkdir ./build

curl -L https://raw.githubusercontent.com/lime-company/powerauth-server/master/docs/sql/mysql/schema_boot.sql > ./build/schema.sql
curl -L https://raw.githubusercontent.com/lime-company/powerauth-server/master/docs/sql/mysql/create_schema.sql >> ./build/schema.sql

docker build -t powerauth-server-mysql ./

rm -rf ./build
