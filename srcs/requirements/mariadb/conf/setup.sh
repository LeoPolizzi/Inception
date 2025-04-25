#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Fails if required secrets are missing
for secret in /secrets/mariadb/mdb_root_pwd.txt /secrets/mariadb/mdb_user_pwd.txt; do
    if [ ! -f "$secret" ]; then
        echo "Error: Missing required secret file: $secret"
        exit 1
    fi
done

# Load secrets into variables
MDB_USER_PWD=$(cat /secrets/mariadb/mdb_user_pwd.txt)
MDB_ROOT_PWD=$(cat /secrets/mariadb/mdb_root_pwd.txt)

# Fails if required environment variables are not set
for var in MDB_ROOT MDB_HOST MDB_NAME MDB_USER; do
    if [ -z "${!var}" ]; then
        echo "Error: Environment variable '$var' is not set"
        exit 1
    fi
done

# Checks if the /run/mysqld directory exists, and if not, creates it with the appropriate permissions.
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld
    chmod 750 /run/mysqld
fi

# Checks if the /var/lib/mysql directory exists, and if not, creates it with the appropriate permissions. Also, it initializes the MySQL database.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

	# Creates a temporary file to store MySQL commands. If file creation fails, it returns an error.
    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        echo "Error: Failed to create temporary file"
        exit 1
    fi

	# Puts MySQL commands into the temporary file. The commands include flushing privileges,
	# deleting anonymous users, dropping the default test database, and creating a new database and user with specific privileges.
    cat << EOF > "$tfile"
    USE mysql;
    FLUSH PRIVILEGES;
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test';
    DELETE FROM mysql.user WHERE User='${MDB_ROOT}' AND Host NOT IN ('${MDB_HOST}', '127.0.0.1', '::1');
    ALTER USER 'root'@'${MDB_HOST}' IDENTIFIED BY '${MDB_ROOT_PWD}';
    CREATE DATABASE IF NOT EXISTS \`${MDB_NAME}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
    CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_USER_PWD}';
    GRANT ALL PRIVILEGES ON \`${MDB_NAME}\`.* TO '${MDB_USER}'@'%';
    GRANT ALL PRIVILEGES ON *.* TO '${MDB_USER}'@'${MDB_HOST}' IDENTIFIED BY '${MDB_USER_PWD}';
    FLUSH PRIVILEGES;
EOF

    /usr/bin/mysqld --user=mysql --bootstrap < "$tfile"
    rm -f "$tfile"
fi

# Replaces MySQL default config to allow external connections
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Starts MariaDB server in foreground with any passed command
exec /usr/bin/mysqld --user=mysql --console
