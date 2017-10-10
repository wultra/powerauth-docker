git clone https://github.com/lime-company/powerauth-docker.git ; \
cd powerauth-docker ; \
git pull ; \
sh build.sh ; \
POWERAUTH_MYSQL_PATH=/tmp/powerauth/mysql \
POWERAUTH_PUSH_MYSQL_PATH=/tmp/powerauth/mysql-push \
POWERAUTH_WEBFLOW_MYSQL_PATH=/tmp/powerauth/mysql-webflow \
docker-compose up -d ; \
cd .. ;
