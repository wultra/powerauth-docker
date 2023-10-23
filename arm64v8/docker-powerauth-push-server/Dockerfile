FROM arm64v8/tomcat:10.1.15-jdk17-temurin-jammy@sha256:cc944d8017411bd3b9b8e8c293ebf439246205de8971d2416d121bf67f25e3ab
LABEL maintainer="roman.strobl@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /opt/java/openjdk
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD ../deploy/lib/ojdbc11.jar $TOMCAT_HOME/lib/
ADD ../deploy/lib/postgresql.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD ../deploy/conf/powerauth-push-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD ../deploy/images/powerauth-push-server.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
