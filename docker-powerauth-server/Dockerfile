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

# Deploy and run applications
ADD deploy/conf/powerauth-java-server.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD deploy/images/powerauth-java-server.war /usr/local/tomcat/webapps/

ADD deploy/data/ldap/ldap-local.ldif /usr/local/tomcat/conf/ldap/
ADD deploy/conf/powerauth-admin.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD deploy/images/powerauth-admin.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
