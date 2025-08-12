#!/bin/bash
set -e

# Load environment variables from .env file if it exists
if [ -f "/var/www/html/.env" ]; then
    export $(grep -v '^#' /var/www/html/.env | xargs)
fi

# Wait for the database to be ready
echo "Waiting for MariaDB at $WORDPRESS_DB_HOST..."
until mariadb -h"${WORDPRESS_DB_HOST%%:*}" -P"${WORDPRESS_DB_HOST##*:}" \
       -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SELECT 1;" &>/dev/null; do
    sleep 2
done
echo "MariaDB is ready!"

# Install WordPress if not already installed
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --skip-check

    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL"
fi

# Ensure correct file permissions
chown -R www-data:www-data /var/www/html

# Run the default CMD (PHP-FPM)
exec "$@"
