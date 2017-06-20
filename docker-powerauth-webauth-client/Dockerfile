FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

RUN rm -rf /usr/local/tomcat/webapps/*

ADD build/mysql-connector-java.jar /usr/local/tomcat/lib/
ADD conf/powerauth-webauth-client.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD build/powerauth-webauth-client.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
