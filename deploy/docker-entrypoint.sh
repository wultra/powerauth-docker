#!/usr/bin/env sh

liquibase --changeLogFile=$LIQUIBASE_HOME/data/changelog.xml --username=$POWERAUTH_SERVER_DATASOURCE_USERNAME --password=$POWERAUTH_SERVER_DATASOURCE_PASSWORD --url=$POWERAUTH_SERVER_DATASOURCE_URL update

exec "$@"
