FROM tomcat:8.5
MAINTAINER powerauth

RUN rm -rf /usr/local/tomcat/webapps/*
ADD build/mysql-connector-java.jar /usr/local/tomcat/lib/
ADD conf/powerauth-java-server.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD build/powerauth-java-server.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
