FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

RUN rm -rf /usr/local/tomcat/webapps/*

ADD conf/ldap-local.ldif /usr/local/tomcat/conf/ldap/
ADD conf/powerauth-admin.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD build/powerauth-admin.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
