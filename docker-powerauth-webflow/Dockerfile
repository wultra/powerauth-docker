FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

# Clear root context
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy libraries
ADD deploy/lib/mysql-connector-java.jar /usr/local/tomcat/lib/
ADD deploy/lib/ojdbc6.jar /usr/local/tomcat/lib/

# Add Bouncy Castle to JRE
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
ADD deploy/lib/bcprov-jdk15on-158.jar $JAVA_HOME/lib/ext
RUN echo 'security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider' >> $JAVA_HOME/lib/security/java.security

# Add valve for proxy with SSL termination
RUN sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" remoteIpHeader="X-Forwarded-For" protocolHeader="X-Forwarded-Proto"\/><\/Host>/' /usr/local/tomcat/conf/server.xml

# Deploy and run applications
ADD deploy/conf/powerauth-webflow.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD deploy/images/powerauth-webflow.war /usr/local/tomcat/webapps/

ADD deploy/conf/powerauth-data-adapter.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD deploy/images/powerauth-data-adapter.war /usr/local/tomcat/webapps/

# Customize web app resources
ADD deploy/data/ext-resources /opt/ext-resources

CMD ["catalina.sh", "run"]
