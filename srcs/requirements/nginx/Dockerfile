FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

# Install NGINX & OpenSSL
RUN apt-get update && \
    apt-get install -y \
		nginx \
		openssl \
        # for testing purposes
        curl && \
        # Deletes cached package list files to reduce image size
        rm -rf /var/lib/apt/lists/*

# Prepare NGINX directories (like systemd tmpfiles does)
RUN mkdir -p /var/cache/nginx /etc/nginx/certs && \
    chown -R www-data:www-data /var/cache/nginx

# Generate self-signed certificate
RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -subj "/C=MY/ST=Selangor/L=KualaLumpur/O=MyOrg/OU=IT/CN=localhost" \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt

# Generate Diffie-Hellman parameters (slow, but separate for caching)
RUN openssl dhparam -out /etc/nginx/dhparam.pem 2048

# Copy NGINX config (enforce TLSv1.2 and TLSv1.3)
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Even though mounted volumes will overwrite it at runtime,
#   you still want the image itself to be self-consistent when no volumes are used.
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Expose HTTPS
EXPOSE 443
# EXPOSE 80

# Copy and make entrypoint executable
# COPY docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
