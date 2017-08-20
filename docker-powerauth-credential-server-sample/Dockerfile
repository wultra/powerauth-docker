FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

RUN rm -rf /usr/local/tomcat/webapps/*

ADD build/mysql-connector-java.jar /usr/local/tomcat/lib/
ADD build/powerauth-credential-server-sample.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
