#!/bin/bash
mkdir ./build

cp ./conf/schema.sql ./build/schema.sql

curl -L https://raw.githubusercontent.com/lime-company/powerauth-webflow/master/powerauth-webflow-docs/sql/mysql/create_schema.sql >> ./build/schema.sql
curl -L https://raw.githubusercontent.com/lime-company/powerauth-webflow/master/powerauth-webflow-docs/sql/mysql/initial_data.sql >> ./build/schema.sql

cat ./conf/data.sql >> ./build/schema.sql

docker build -t powerauth-webflow-mysql ./

rm -rf ./build
