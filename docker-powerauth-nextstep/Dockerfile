FROM tomcat:10.1.61-jre21-temurin-noble@sha256:d8e4fa5952ee82a6210f96fda7a1b5c8a89c0cea5faca97702c527602078453b
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME=/opt/java/openjdk
ENV TOMCAT_HOME=/usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/ojdbc11.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-nextstep.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-nextstep.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
