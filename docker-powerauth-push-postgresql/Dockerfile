FROM postgres:15.4
LABEL maintainer="roman.strobl@wultra.com"

ADD deploy/data/postgresql/powerauth-push-server.sql /docker-entrypoint-initdb.d/
