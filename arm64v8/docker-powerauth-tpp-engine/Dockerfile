FROM arm64v8/tomcat:9-jre11@sha256:0464902846f45cf1bbcfc52adc2be69cd53d3954569e3c709c346614f19ecad0
LABEL maintainer="roman.strobl@wultra.com"

# Prepare environment variables
ENV JAVA_HOME /opt/java/openjdk
ENV TOMCAT_HOME /usr/local/tomcat

# Clear root context
RUN rm -rf $TOMCAT_HOME/webapps/*

# Copy libraries
ADD ../deploy/lib/ojdbc6.jar $TOMCAT_HOME/lib/
ADD ../deploy/lib/postgresql.jar $TOMCAT_HOME/lib/

# Deploy and run applications
ADD ../deploy/conf/powerauth-tpp-engine.xml $TOMCAT_HOME/conf/Catalina/localhost/
ADD ../deploy/images/powerauth-tpp-engine.war $TOMCAT_HOME/webapps/

# Create user tomcat and run Tomcat under this user
RUN groupadd -r tomcat
RUN useradd -r -g tomcat -d $TOMCAT_HOME -s /sbin/nologin tomcat
RUN chown -R tomcat:tomcat $TOMCAT_HOME

USER tomcat
CMD ["catalina.sh", "run"]
