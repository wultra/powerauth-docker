#!/bin/bash
mkdir ./build

cp ./conf/schema.sql ./build/schema.sql
curl -L https://raw.githubusercontent.com/lime-company/lime-security-powerauth-webauth/master/powerauth-webauth-docs/sql/mysql/create_schema.sql >> ./build/schema.sql
curl -L https://raw.githubusercontent.com/lime-company/lime-security-powerauth-webauth/master/powerauth-webauth-docs/sql/mysql/initial_data.sql >> ./build/schema.sql
cat ./conf/data.sql >> ./build/schema.sql

docker build -t powerauth-webauth-mysql ./

rm -rf ./build
