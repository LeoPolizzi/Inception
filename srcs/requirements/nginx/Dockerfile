FROM	alpine:3.20

# Change working directory
WORKDIR	/var/www/html

# Install dependencies
RUN		apk update && apk upgrade && apk add --no-cache nginx gettext

# Create secrets directory
RUN		mkdir /secrets

# Delete default nginx.conf
RUN		rm -f /etc/nginx/nginx.conf

# Copy custom nginx.conf
COPY	./conf/nginx.conf.template /etc/nginx/nginx.conf.template

# Copy entrypoint script and make it executable
COPY	./conf/entrypoint.sh /entrypoint.sh
RUN		chmod +x /entrypoint.sh

# Expose ports
EXPOSE	443

# Execute entrypoint script
CMD		["sh", "/entrypoint.sh"]
