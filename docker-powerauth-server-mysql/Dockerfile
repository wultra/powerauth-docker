FROM mysql:5.7
LABEL maintainer "petr@lime-company.eu"

COPY deploy/data/mysql/my.cnf /etc/my.cnf
ADD deploy/data/mysql/powerauth-server.sql /docker-entrypoint-initdb.d/
