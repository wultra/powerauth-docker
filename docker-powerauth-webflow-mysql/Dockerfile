FROM mysql:5.7
LABEL maintainer="petr@wultra.com"

COPY deploy/data/mysql/my.cnf /etc/my.cnf
ADD deploy/data/mysql/powerauth-webflow.sql /docker-entrypoint-initdb.d/
