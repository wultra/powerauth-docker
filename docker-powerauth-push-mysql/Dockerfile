FROM mysql:5.7
MAINTAINER Petr Dvorak <petr@lime-company.eu>

COPY deploy/data/mysql/my.cnf /etc/my.cnf
ADD deploy/data/mysql/powerauth-push-server.sql /docker-entrypoint-initdb.d/
