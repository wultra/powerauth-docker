FROM tomcat:10.1.33-jre21-temurin-noble@sha256:46e825f321af836f0846f5e80c5959db8c7ce3d89d667bfb4ac3067e65e40136
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /opt/java/openjdk
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/ojdbc11.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-push-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-push-server.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
