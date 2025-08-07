FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Fix: Create directory for MariaDB UNIX socket
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Expose MariaDB port
EXPOSE 3306

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Metadata
LABEL version="1.0"
LABEL description="MariaDB Server with .env support"

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mariadbd"]
