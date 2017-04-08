git clone https://github.com/lime-company/lime-security-powerauth-docker.git ; \
cd lime-security-powerauth-docker ; \
sh build.sh ; \
docker-compose up -d ; \
cd ..; \
sleep 10 ; \
open http://localhost:18080/powerauth-admin
