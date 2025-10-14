#!/bin/bash
set -e

# MariaDB Unix Socket file is the default socket file,
    # acting as a "meeting point" for communication between MariaDB client(mariaDB CLI) & MariaDB server(mysqld)

# Create runtime directory for MariaDB UNIX socket file
mkdir -p /run/mysqld
# give mysql user ownership of the directory
chown -R mysql:mysql /run/mysqld

# Initialize MariaDB if not yet initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    echo "Starting temporary MariaDB server (for inital setup task)..."
    mysqld_safe --skip-networking &
    pid="$!"

    echo "Waiting for MariaDB to start..."
    until mariadb-admin ping --silent; do
        sleep 1
    done

    # remove the anonymous users from the mysql.user table:
    mariadb -e "DELETE FROM mysql.user WHERE User='';"

    echo "Creating root user and database..."
    # mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -e "FLUSH PRIVILEGES;"

    echo "Shutting down temporary MariaDB..."
    mariadb-admin shutdown
    wait "$pid"
fi

echo "🚀 Starting MariaDB..."
exec gosu mysql "$@"
