FROM	alpine:3.20

# Update the package index and install necessary packages
RUN		apk update && apk upgrade && apk add --no-cache nginx mariadb mariadb-client mariadb-server-utils bash

# Create secrets directory
RUN		mkdir /secrets

# Copy the setup script
COPY	./conf/setup.sh /setup.sh

# Make the setup script executable
RUN		chmod +x /setup.sh

# Expose the necessary ports
EXPOSE	3306

# Run the setup script as the entrypoint
CMD		["bash", "/setup.sh"]
