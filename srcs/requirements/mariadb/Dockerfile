FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB server + client
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client

# Deletes cached package list files to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Clears out default MariaDB data directory to start with clean database state
RUN rm -rf /var/lib/mysql/*

# switch to mysql user for runtime
USER mysql

# Expose MariaDB port
EXPOSE 3306

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe"]
