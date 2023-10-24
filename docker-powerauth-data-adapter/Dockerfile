FROM tomcat:10.1.15-jdk17-temurin-jammy@sha256:5a66a88c8f473215c2692f8938991ba5739b941f25e23613d4c1f0e4c6bbbcbe
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /opt/java/openjdk
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/ojdbc11.jar $TOMCAT_HOME/lib/
ADD deploy/lib/postgresql.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-data-adapter.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-data-adapter.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
