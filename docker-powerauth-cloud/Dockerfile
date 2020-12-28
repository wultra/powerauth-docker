FROM tomcat:9-jdk11

LABEL maintainer="Petr Dvořák <petr@wultra.com>"

# NGINX Docker image installation
# This setup was inspired by https://hub.docker.com/_/nginx/ (stable)
# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/

USER root

ENV NGINX_VERSION 1.18.0
ENV NJS_VERSION   0.4.4
ENV PKG_RELEASE   2~buster

# Download certificate and key from the customer portal (https://cs.nginx.com)
# and copy to the build context
#COPY deploy/nginx/nginx-repo.crt /etc/ssl/nginx/
#COPY deploy/nginx/nginx-repo.key /etc/ssl/nginx/

ENV NGINX_GPGKEY 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup --system --gid 101 nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates \
    && \
    NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
    found=''; \
    for server in \
        ha.pool.sks-keyservers.net \
        hkp://keyserver.ubuntu.com:80 \
        hkp://p80.pool.sks-keyservers.net:80 \
        pgp.mit.edu \
    ; do \
        echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
        apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
    apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture)" \
    && nginxPackages=" \
        nginx=${NGINX_VERSION}-${PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-${PKG_RELEASE} \
    " \
    && case "$dpkgArch" in \
        amd64|i386|arm64) \
# arches officialy built by upstream
            echo "deb https://nginx.org/packages/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list \
            && apt-get update \
            ;; \
        *) \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published source packages
            echo "deb-src https://nginx.org/packages/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list \
            \
# new directory for storing sources and .deb files
            && tempDir="$(mktemp -d)" \
            && chmod 777 "$tempDir" \
# (777 to ensure APT's "_apt" user can access it too)
            \
# save list of currently-installed packages so build dependencies can be cleanly removed later
            && savedAptMark="$(apt-mark showmanual)" \
            \
# build .deb files from upstream's source packages (which are verified by apt-get)
            && apt-get update \
            && apt-get build-dep -y $nginxPackages \
            && ( \
                cd "$tempDir" \
                && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)" \
                    apt-get source --compile $nginxPackages \
            ) \
# we don't remove APT lists here because they get re-downloaded and removed later
            \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
# (which is done after we install the built packages so we don't have to redownload any overlapping dependencies)
            && apt-mark showmanual | xargs apt-mark auto > /dev/null \
            && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; } \
            \
# create a temporary local APT repo to install from (so that dependency resolution can be handled by APT, as it should be)
            && ls -lAFh "$tempDir" \
            && ( cd "$tempDir" && dpkg-scanpackages . > Packages ) \
            && grep '^Package: ' "$tempDir/Packages" \
            && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list \
# work around the following APT issue by using "Acquire::GzipIndexes=false" (overriding "/etc/apt/apt.conf.d/docker-gzip-indexes")
#   Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
#   ...
#   E: Failed to fetch store:/var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages  Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
            && apt-get -o Acquire::GzipIndexes=false update \
            ;; \
    esac \
    \
    && apt-get install --no-install-recommends --no-install-suggests -y \
                        $nginxPackages \
                        gettext-base \
                        curl \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
    \
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
    && if [ -n "$tempDir" ]; then \
        apt-get purge -y --auto-remove \
        && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
    fi \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
# create a docker-entrypoint.d directory
    && mkdir /docker-entrypoint.d

# Forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy nginx configuration
ADD deploy/nginx/nginx.conf /etc/nginx/

# Powerauth Server Cloud

# Prepare environment variables
ENV JAVA_HOME /usr/local/openjdk-11
ENV LIQUIBASE_HOME /usr/local/liquibase
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/mysql-connector-java.jar $TOMCAT_HOME/lib/
ADD deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/
ADD deploy/lib/postgresql.jar $TOMCAT_HOME/lib/
ADD deploy/lib/bcprov-jdk15on-165.jar $TOMCAT_HOME/lib/

# Configure Bouncy Castle in JRE
RUN echo 'security.provider.14=org.bouncycastle.jce.provider.BouncyCastleProvider' >> $JAVA_HOME/conf/security/java.security

# Deploy and run applications
## Powerauth Server
ADD deploy/conf/powerauth-java-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-java-server.war $TOMCAT_HOME/webapps/

## Powerauth Push Server
ADD deploy/conf/powerauth-push-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-push-server.war $TOMCAT_HOME/webapps/

## Powerauth Enrollment Server
ADD deploy/conf/enrollment-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/enrollment-server.war $TOMCAT_HOME/webapps/

## Powerauth Cloud
ADD deploy/conf/powerauth-cloud.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-cloud.war $TOMCAT_HOME/webapps/

# Create user tomcat
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME --shell /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME


# Liquibase - binaries
# This setup was inspired by https://hub.docker.com/r/liquibase/liquibase/dockerfile

USER root

# Install GNUPG for package vefification and WGET for file download
RUN apt-get update \
    && apt-get -y install gnupg wget \
    && rm -rf /var/lib/apt/lists/*

# Add the liquibase user and step in the directory
RUN addgroup --gid 1001 liquibase
RUN adduser --disabled-password --uid 1001 --ingroup liquibase liquibase

# Make /liquibase directory and change owner to liquibase
RUN mkdir -p $LIQUIBASE_HOME && chown liquibase $LIQUIBASE_HOME
WORKDIR $LIQUIBASE_HOME

# Change to the liquibase user
USER liquibase

ENV TZ Eruope/Prague
ENV PATH $PATH:$LIQUIBASE_HOME

ARG LIQUIBASE_VERSION=3.10.3
ENV LIQUIBASE_VERSION 3.10.3

# Download, verify, extract
ARG LB_SHA256=b34b0dbf35fba557d8f3cbf9ae08e0027e288ef2a35c6fa9dbe16536d070f7a8
RUN set -x \
  && wget -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" \
  && echo "$LB_SHA256  liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - \
  && tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz

ADD deploy/lib/mysql-connector-java.jar $LIQUIBASE_HOME/lib/
ADD deploy/lib/postgresql.jar $LIQUIBASE_HOME/lib/

# Liquibase - changesets
RUN rm -rf $LIQUIBASE_HOME/data
ADD deploy/liquibase/data $LIQUIBASE_HOME/data

# Docker configuration
EXPOSE 80
STOPSIGNAL SIGQUIT

COPY deploy/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Tomcat
USER tomcat
CMD ["catalina.sh", "run"]

# Run NGINX
USER nginx
CMD ["nginx", "-g", "daemon off;"]
