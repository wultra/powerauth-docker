FROM postgres:16.5
LABEL maintainer="roman.strobl@wultra.com"

ADD deploy/data/postgresql/enrollment-server.sql /docker-entrypoint-initdb.d/
