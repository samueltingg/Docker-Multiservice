#!/bin/bash
set -e # Exit immediately if any command fails.

# Ensure runtime dirs that systemd would normally create
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Fix permissions (systemd would normally ensure service user ownership)
chown -R www-data:www-data /var/www/html
# have to include this command (already present in Dockefile) again,
#   cuz if I mount a Docker volume(from host) to /var/www/html when starting the container,
#   the user permissions are replaced by the volume's own user permissions(usually root)
#   resulting in 'www-data' user losing permission to /var/www/html
# In short, this command ensure correct permissions for mounted volumes from host

# helper to run wp as www-data (as Wordpress disallow running `wp` command as root)`
wp_as_www() {
  runuser -u www-data -- wp "$@"
}

# Wait for MariaDB before continuing
if [ -n "$WORDPRESS_DB_HOST" ]; then # check if env var is non-empty
    echo "Waiting for MariaDB at $WORDPRESS_DB_HOST..."
    until mariadb -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SELECT 1;" &>/dev/null; do
        sleep 2
    done
    echo "MariaDB is ready!"
fi

# If wp-config.php doesn't exist, create it
if [ ! -f wp-config.php ]; then
    echo "Generating wp-config.php..."

    # fresh installation of wordpress doesn't come with 'wp-config.php',
    #   it only as 'wp-config-sample.php'
    cp wp-config-sample.php wp-config.php
    # wp.config.php: tells how WordPress should connect to the database

    # update Database Settings in wp-config.php
    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" wp-config.php
fi

# After wp-config.php creation and before `exec "$@"`
if [ ! -f /var/www/html/.installed ]; then
    echo "Installing WordPress automatically..."

    wp_as_www core install \
        --url="${WORDPRESS_URL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email

    touch /var/www/html/.installed
    echo "WordPress installation completed!"
fi

# Pre-create one user
if ! wp_as_www user get "$WP_USER_NAME" >/dev/null 2>&1; then
    wp_as_www user create "$WP_USER_NAME" "$WP_USER_EMAIL" \
        --role="$WP_USER_ROLE" \
        --user_pass="$WP_USER_PASS"

    echo "WordPress user $WP_USER_NAME created with role $WP_USER_ROLE!"
fi


echo "🚀 Starting php-fpm7.4..."
exec "$@"
# Runs the command from the Dockerfile’s CMD (in this case php-fpm7.4 -F) as PID 1.
