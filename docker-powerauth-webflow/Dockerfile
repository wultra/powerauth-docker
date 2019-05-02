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
ADD deploy/lib/bcprov-jdk15on-161.jar $JAVA_HOME/lib/ext
RUN echo 'security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider' >> $JAVA_HOME/lib/security/java.security

# Add valve for proxy with SSL termination
RUN sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" remoteIpHeader="X-Forwarded-For" protocolHeader="X-Forwarded-Proto"\/><\/Host>/' $TOMCAT_HOME/conf/server.xml

# Deploy and run applications
ADD deploy/conf/powerauth-webflow.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-webflow.war $TOMCAT_HOME/webapps/

# Customize web app resources
ADD deploy/data/ext-resources /opt/ext-resources

CMD ["catalina.sh", "run"]
