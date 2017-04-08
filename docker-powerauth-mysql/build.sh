#!/bin/bash
mkdir ./build
curl -L https://raw.githubusercontent.com/lime-company/lime-security-powerauth/master/powerauth-docs/sql/mysql/schema_boot.sql > ./build/schema.sql
curl -L https://raw.githubusercontent.com/lime-company/lime-security-powerauth/master/powerauth-docs/sql/mysql/create_schema.sql >> ./build/schema.sql

docker build -t powerauth-mysql ./

rm -rf ./build
