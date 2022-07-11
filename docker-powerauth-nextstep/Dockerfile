FROM tomcat:jdk11-adoptopenjdk-openj9@sha256:bebb14ffca2a3f01a07492795d73f2c4541c41fa0641bdf1924494a255c0c5af
LABEL maintainer="petr@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /opt/java/openjdk
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/
ADD deploy/lib/postgresql.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-nextstep.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD deploy/images/powerauth-nextstep.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
