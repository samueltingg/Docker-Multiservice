#!/bin/bash
set -e

# Ensure socket directory exists (in case /run is tmpfs)
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize MariaDB if not yet initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    echo "Starting temporary MariaDB..."
    mysqld_safe --skip-networking &
    pid="$!"

    echo "Waiting for MariaDB to start..."
    until mariadb-admin ping --silent; do
        sleep 1
    done

    echo "Creating root user and database..."
    # mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
    mariadb -e "FLUSH PRIVILEGES;"

    echo "Shutting down temporary MariaDB..."
    mariadb-admin shutdown
    wait "$pid"
fi

echo "Starting MariaDB..."
exec "$@"
