#!/bin/bash
set -e

# Mimic systemd pre-start: ensure runtime dirs exist
mkdir -p /var/run /var/log/nginx /var/cache/nginx
chown -R www-data:www-data /var/cache/nginx

# Generate self-signed cert if none exists
if [ ! -f /etc/nginx/certs/server.crt ]; then
    echo "[entrypoint] Generating self-signed SSL certificate..."
    openssl req -x509 -nodes -days 365 \
        -subj "/CN=localhost" \
        -newkey rsa:2048 \
        -keyout /etc/nginx/certs/server.key \
        -out /etc/nginx/certs/server.crt
fi

exec "$@"
