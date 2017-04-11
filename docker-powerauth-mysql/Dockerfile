FROM mysql:5.7
LABEL maintainer "petr@lime-company.eu"

ADD ./build/schema.sql /docker-entrypoint-initdb.d/
