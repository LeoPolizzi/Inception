FROM	alpine:3.20

# Update the package index and install necessary packages
RUN		apk update && apk upgrade && apk add --no-cache nginx mariadb mariadb-client mariadb-server-utils

# Copy the setup script
COPY	./conf/setup.sh /setup.sh

# Make the setup script executable
RUN		chmod +x /setup.sh

# Run the setup script as the entrypoint
ENTRYPOINT	["sh", "/setup.sh"]

# Run mysql in the foreground
CMD		["/usr/bin/mysqld" "--user=mysql" "--console"]
