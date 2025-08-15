FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive \
    PHP_FPM_LISTEN=9000

RUN apt-get update && \
    apt-get install -y \
        php-fpm \
        php-mysql \
        php-curl \
        php-gd \
        php-xml \
        php-mbstring \
        mariadb-client \
        wget \
        curl \
        unzip \
        less \
        nano

# Deletes cached package list files to reduce image size
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm", "-F"]
