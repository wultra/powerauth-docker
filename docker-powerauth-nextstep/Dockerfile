FROM tomcat:9.0.19-jre11
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/mysql-connector-java.jar $TOMCAT_HOME/lib/
ADD deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-nextstep.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-nextstep.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
