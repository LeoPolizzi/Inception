FROM	alpine:3.20

RUN		apk update && apk upgrade && apk add --no-cache nginx mariadb mariadb-cient mariadb-server-utils

COPY	./conf/setup.sh /setup.sh

RUN		chmod +x /setup.sh

ENTRYPOINT	["sh", "/setup.sh"]
