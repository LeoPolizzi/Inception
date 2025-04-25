FROM	alpine:3.20

# Define arguments for user and group
ARG		WP_PHP_USER
ARG		WP_PHP_GROUP

# Set default values for user and group if not provided
ENV		WP_PHP_USER=${WP_PHP_USER}
ENV		WP_PHP_GROUP=${WP_PHP_GROUP}

# Update the package index and install necessary packages
RUN		apk update && apk add --no-cache \
			php82 \
			php82-fpm \
			php82-phar \
			php82-mysqli \
			php82-xml \
			php82-mbstring \
			curl \
			wget \
			gettext \
			mariadb-client

# Create secrets directory
RUN		mkdir /secrets

# Copy the configuration files and setup script
COPY	./conf/* ./

# Setup user and group permissions as well as the wp-cli. Also make the setup script executable
RUN		adduser -S ${WP_PHP_USER} \
		&& addgroup -S ${WP_PHP_GROUP} \
		&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar \
		&& mv -f wp-cli.phar /usr/local/bin/wp \
		&& chmod +x setup.sh

# Expose the necessary ports
EXPOSE	9000

# Set the setup script as the entrypoint
CMD		["sh", "setup.sh"]
