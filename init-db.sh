#!/bin/sh
set -e

# Start MariaDB for initialization
mysqld --user=mysql --bootstrap --verbose=0  << EOF
USE mysql;

FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS myDatabase CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'u-os-host'@'%' IDENTIFIED BY 'some_password';
GRANT ALL ON myDatabase.* TO 'u-os-host'@'%';

CREATE USER 'root'@'%' IDENTIFIED BY 'rootpassword';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF
