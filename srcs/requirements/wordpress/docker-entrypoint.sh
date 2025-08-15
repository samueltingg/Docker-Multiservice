#!/bin/bash
set -e

# Ensure runtime dirs that systemd would normally create
mkdir -p /run/php
chown -R www-data:www-data /run/php

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

    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" wp-config.php
fi

# Fix permissions (systemd would normally ensure service user ownership)
chown -R www-data:www-data /var/www/html
# have to include this command (already present in Dockefile) again,
#   cuz if I mount a Docker volume(from host) to /var/www/html when starting the container,
#   the user permissions are replaced by the ones at the host,
#   resulting in 'www-data' user losing permission to /var/www/html
# In short, this command ensure correct permissions for mounted volumes from host

exec "$@"
