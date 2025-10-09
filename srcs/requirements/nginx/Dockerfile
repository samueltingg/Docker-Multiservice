FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

# Install NGINX & OpenSSL
RUN apt-get update && \
    apt-get install -y \
		nginx \
        # for testing purposes, can be removed later
        curl 
		# openssl

# Deletes cached package list files to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Prepare NGINX directories (like systemd tmpfiles does)
RUN mkdir -p /var/cache/nginx /etc/nginx/certs && \
    chown -R www-data:www-data /var/cache/nginx

# Copy NGINX config (enforce TLSv1.2 and TLSv1.3)
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Even though mounted volumes will overwrite it at runtime,
#   you still want the image itself to be self-consistent when no volumes are used.
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Expose HTTPS
# EXPOSE 443
EXPOSE 80

# Copy and make entrypoint executable
# COPY docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
