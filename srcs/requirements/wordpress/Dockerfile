FROM	alpine:3.20

# Define arguments for user and group
ARG		WP_PHP_USER
ARG		WP_PHP_GROUP

# Set default values for user and group if not provided
ENV		WP_PHP_USER=${WP_PHP_USER}
ENV		WP_PHP_GROUP=${WP_PHP_GROUP}

# Update the package index and install necessary packages
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

# Copy the configuration files and setup script
COPY	./conf/* ./

# Setup user and group permissions as well as the wp-cli. Also make the setup script executable
RUN		adduser -S ${WP_PHP_USER} \
		&& addgroup -S ${WP_PHP_GROUP} \
		&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar \
		&& mv -f wp-cli.phar /usr/local/bin/wp \
		&& chmod +x setup.sh

# Set the setup script as the entrypoint
ENTRYPOINT	["sh", "setup.sh"]

# Make php-fpm run in the foreground
CMD		["php-fpm8", "-F"]
