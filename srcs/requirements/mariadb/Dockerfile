FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB server + client
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/mysql/*

# Create runtime directory for MariaDB UNIX socket
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

# Expose MariaDB port
EXPOSE 3306

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe"]
