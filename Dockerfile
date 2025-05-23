FROM alpine:latest

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client

# Create directory for socket and pid files
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

# Copy configuration files
COPY mariadb.cnf /etc/my.cnf.d/my-minimal.cnf

# Set up data directory
RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Copy initialization script
COPY init-db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Expose MySQL port
EXPOSE 3306

# Create volume for data persistence
VOLUME /var/lib/mysql

# Set healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s \
  CMD mysqladmin ping -h localhost || exit 1

# Use an entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld", "--user=mysql"]

