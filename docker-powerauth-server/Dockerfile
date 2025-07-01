FROM tomcat:10.1.42-jre21-temurin-noble@sha256:e0f633dd965e61a3cd1a9d6e54a57a6bef9954b4a0f8acaeb9b4ff186c64e13e
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME=/opt/java/openjdk
ENV TOMCAT_HOME=/usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/ojdbc11.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-java-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-java-server.war $TOMCAT_HOME/webapps/

ADD deploy/data/ldap/ldap-local.ldif $TOMCAT_HOME/conf/ldap/
ADD deploy/conf/powerauth-admin.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-admin.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
