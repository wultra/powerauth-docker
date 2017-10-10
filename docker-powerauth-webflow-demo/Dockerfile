FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

RUN rm -rf /usr/local/tomcat/webapps/*

ADD assets/lib/mysql-connector-java.jar /usr/local/tomcat/lib/
ADD assets/lib/ojdbc6.jar /usr/local/tomcat/lib/

ADD assets/conf/powerauth-webflow-demo.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD assets/images/powerauth-webflow-demo.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
