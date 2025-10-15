FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

# Install MariaDB server + client
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client gosu

# Deletes cached package list files to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# By default, mariadDB bind-address is 127.0.0.1 (only accept connections from same container)
# Change MariaDB config file bind-address to accept all connections
RUN sed -i 's/^\(bind-address\s*=\s*\).*/\1 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Clears out default MariaDB data directory to start with clean database state
RUN rm -rf /var/lib/mysql/*

# Expose MariaDB port
EXPOSE 3306

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe"]
