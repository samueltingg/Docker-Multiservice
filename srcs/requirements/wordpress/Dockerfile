# 1. Base image
FROM debian:bullseye

# 2. Environment settings
ENV DEBIAN_FRONTEND=noninteractive \
    PHP_FPM_LISTEN=9000

# 3. Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    less \
    mariadb-client \
    ca-certificates \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    php-fpm \
    php-mysql \
    php-gd \
    php-zip \
    php-curl \
    php-mbstring \
    php-xml \
    && rm -rf /var/lib/apt/lists/*

# 4. Install WP-CLI (WordPress command line tool)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 5. Set working directory for WordPress files
WORKDIR /var/www/html

# 6. Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 7. Expose PHP-FPM port
EXPOSE 9000

# 8. Set entrypoint and default command
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm", "-F"]
