#!/bin/bash

# Replace environment variables in the nginx configuration file
envsubst '${DOMAIN_NAME} ${NGINX_PORT} ${WP_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Start nginx in the foreground
exec nginx -g "daemon off;"
