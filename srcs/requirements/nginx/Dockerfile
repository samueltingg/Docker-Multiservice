FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Install NGINX & OpenSSL
RUN apt-get update && \
    apt-get install -y \
		nginx \
		openssl

# Deletes cached package list files to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Prepare NGINX directories (like systemd tmpfiles does)
RUN mkdir -p /var/cache/nginx /etc/nginx/certs && \
    chown -R www-data:www-data /var/cache/nginx

# Copy NGINX config (enforce TLSv1.2 and TLSv1.3)
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTPS
EXPOSE 443

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
