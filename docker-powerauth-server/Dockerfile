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
ADD deploy/lib/bcprov-jdk15on-161.jar $TOMCAT_HOME/lib/

# Configure Bouncy Castle in JRE
RUN echo 'security.provider.14=org.bouncycastle.jce.provider.BouncyCastleProvider' >> $JAVA_HOME/conf/security/java.security

# Deploy and run applications
ADD deploy/conf/powerauth-java-server.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-java-server.war $TOMCAT_HOME/webapps/

ADD deploy/data/ldap/ldap-local.ldif $TOMCAT_HOME/conf/ldap/
ADD deploy/conf/powerauth-admin.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-admin.war $TOMCAT_HOME/webapps/

CMD ["catalina.sh", "run"]
