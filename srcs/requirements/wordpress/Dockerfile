FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive \
    PHP_FPM_LISTEN=9000

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update && \
    apt-get install -y \
        php \
        php-mysql \
        php-fpm \ 
        php-curl \
        php-gd \
        php-intl \
        php-mbstring \
        php-soap \
        php-xml \
        php-xmlrpc \
        php-zip \
        mariadb-client \
        curl && \
        # * Deletes cached package list files to reduce image size
        #   package lists tell `apt` what packages exist in each repository and which versions are available, speeds up when re-installing/update
        #   Since these packages are not installed in the container the package lists are unecessary
        rm -rf /var/lib/apt/lists/*


# Even though mounted volumes will overwrite it at runtime,
#   you still want the image itself to be self-consistent when no volumes are used.
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
