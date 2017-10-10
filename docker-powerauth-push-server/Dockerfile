FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

RUN rm -rf /usr/local/tomcat/webapps/*

ADD assets/lib/mysql-connector-java.jar /usr/local/tomcat/lib/
ADD assets/lib/ojdbc6.jar /usr/local/tomcat/lib/

ADD assets/conf/powerauth-push-server.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD assets/images/powerauth-push-server.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
