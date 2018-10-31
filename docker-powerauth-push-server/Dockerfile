FROM tomcat:8.5
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/mysql-connector-java.jar $TOMCAT_HOME/lib/
ADD deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/

# Add Bouncy Castle to JRE
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
ADD deploy/lib/bcprov-jdk15on-160.jar $JAVA_HOME/lib/ext
RUN echo 'security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider' >> $JAVA_HOME/lib/security/java.security

# Deploy and run applications
ADD deploy/conf/powerauth-push-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-push-server.war $TOMCAT_HOME/webapps/

CMD ["catalina.sh", "run"]
