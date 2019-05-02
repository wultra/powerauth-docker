FROM tomcat:9.0.19-jre11
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/jre
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/mysql-connector-java.jar $TOMCAT_HOME/lib/
ADD deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-nextstep.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-nextstep.war $TOMCAT_HOME/webapps/

CMD ["catalina.sh", "run"]
