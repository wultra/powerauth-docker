FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

RUN rm -rf /usr/local/tomcat/webapps/*

ADD conf/powerauth-rest-api.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD build/powerauth-rest-api.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
