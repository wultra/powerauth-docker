FROM arm64v8/tomcat:9-jre11@sha256:7f97013afbda47a97e37548079143f79e4b4561622fdda7bc08681d08d303761
LABEL maintainer="roman.strobl@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /usr/local/openjdk-11
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD ../deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/
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
