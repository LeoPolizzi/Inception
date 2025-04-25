#!/bin/sh

echo "📦 Starting WordPress setup..."

# Replace env vars in the PHP-FPM config template
envsubst '${WP_PHP_USER} ${WP_PHP_GROUP} ${WP_PHP_LISTEN_OWNER} ${WP_PHP_LISTEN_GROUP}' < ./www.conf.template > ./www.conf

# Fix permissions
chmod 777 /var/www/html

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-load.php ]; then
    echo "📥 Downloading WordPress..."
    php82 -d memory_limit=512M /usr/local/bin/wp core download --allow-root --path="/var/www/html"
fi

# Cleanup default config and replace it
rm -f /var/www/html/wp-config.php
cp ./wp-config.php /var/www/html/wp-config.php

# Copy PHP-FPM config
CONF_DIR="/etc/php82/php-fpm.d"
mkdir -p "$CONF_DIR"
rm -f "$CONF_DIR/www.conf"
cp ./www.conf "$CONF_DIR/www.conf"

# Load secrets into variables
WP_ADMIN_PWD=$(cat /secrets/wordpress/wp_admin_pwd.txt)
WP_ADMIN_MAIL=$(cat /secrets/wordpress/wp_admin_mail.txt)
MDB_USER_PWD=$(cat /secrets/mariadb/mdb_user_pwd.txt)

# Install WordPress
php82 -d memory_limit=512M /usr/local/bin/wp core install \
    --url="https://${DOMAIN_NAME}" \
    --title="Inception" \
    --admin_user="${WP_ADMIN}" \
    --admin_password="${WP_ADMIN_PWD}" \
    --admin_email="${WP_ADMIN_MAIL}" \
    --path="/var/www/html" \
    --allow-root \
    --skip-email

# Create secondary user (if not already exists)
if ! php82 /usr/local/bin/wp user get "$MDB_USER" --path="/var/www/html" --allow-root > /dev/null 2>&1; then
    php82 -d memory_limit=512M /usr/local/bin/wp user create \
        "$MDB_USER" "${MDB_USER}@example.com" \
        --role="author" \
        --user_pass="${MDB_USER_PWD}" \
        --path="/var/www/html" \
        --allow-root
fi

# Run WordPress in the foreground with php-fpm82
exec php-fpm82 -F
