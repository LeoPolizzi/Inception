#!/bin/sh

# Replace env vars in the PHP-FPM config template
envsubst '${WP_PHP_USER} ${WP_PHP_GROUP} ${WP_PHP_LISTEN_OWNER} ${WP_PHP_LISTEN_GROUP}' < ./www.conf.template > ./www.conf

# Fix permissions
chmod 777 /var/www/html

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-load.php ]; then
	wp core download --allow-root --path="/var/www/html"
fi

# Cleanup default config and replace it
rm -f /var/www/html/wp-config.php
rm -f /etc/php8/php-fpm.d/www.conf
cp ./wp-config.php /var/www/html/wp-config.php
cp ./www.conf /etc/php8/php-fpm.d/www.conf

# Load secrets into variables
WP_ADMIN_PWD=$(cat /run/secrets/wordpress/wp_admin_pwd.txt)
WP_ADMIN_MAIL=$(cat /run/secrets/wordpress/wp_admin_mail.txt)
MDB_USER_PWD=$(cat /run/secrets/mariadb/mdb_user_pwd.txt)

# Run WordPress core installation
wp core install \
	--url="https://${DOMAIN_NAME}" \
	--title="Inception" \
	--admin_user="${WP_ADMIN}" \
	--admin_password="${WP_ADMIN_PWD}" \
	--admin_email="${WP_ADMIN_MAIL}" \
	--path="/var/www/html" \
	--allow-root \
	--skip-email

# Create secondary user
wp --allow-root user create \
	"${MDB_USER}" "${WP_ADMIN_MAIL}" \
	--role="author" \
	--user_pass="${MDB_USER_PWD}" \
	--path="/var/www/html"

# Run CMD
exec "$@"
