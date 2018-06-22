FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

# Prepare environment variables
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/mysql-connector-java.jar $TOMCAT_HOME/lib/
ADD deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-data-adapter.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-data-adapter.war $TOMCAT_HOME/webapps/

CMD ["catalina.sh", "run"]
