FROM tomcat:10.1.62-jre21-temurin-noble@sha256:6678c5074f2d282a86b96cc80df43c21b2cb88b30ec6c56a4a5247164b641dc1
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME=/opt/java/openjdk
ENV TOMCAT_HOME=/usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/ojdbc11.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/enrollment-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/enrollment-server.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
