FROM tomcat:10.1.25-jre21-temurin-jammy@sha256:e13c51d8cc4c4d24027a093997a23d58ae50cb8e8d72631ae1f583cc12c75243
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /opt/java/openjdk
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/ojdbc11.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-tpp-engine.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-tpp-engine.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
