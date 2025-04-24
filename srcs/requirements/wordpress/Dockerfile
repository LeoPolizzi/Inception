FROM	alpine:3.20

ARG		WP_PHP_USER
ARG		WP_PHP_GROUP

ENV		WP_PHP_USER=${WP_PHP_USER}
ENV		WP_PHP_GROUP=${WP_PHP_GROUP}

RUN		apk update && apk add --no-cache \
			php8 \
			php8-fpm \
			php8-mysqli \
			php8-pdo \
			php8-pdo_mysql \
			php8-curl \
			php8-gd \
			php8-zip \
			php8-xml \
			php8-mbstring \
			php8-session \
			php8-openssl \
			php8-json \
			php8-tokenizer \
			php8-fileinfo \
			php8-exif \
			php8-dom \
			php8-simplexml \
			php8-opcache \
			curl \
			wget \
			tar \
			mariadb-client

COPY	./conf/* ./

RUN		adduser -S ${WP_PHP_USER} \
		&& addgroup -S ${WP_PHP_GROUP} \
		&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar \
		&& mv -f wp-cli.phar /usr/local/bin/wp \
		&& chmod +x setup.sh

ENTRYPOINT	["sh", "setup.sh"]

CMD		["php-fpm8", "-F"]
