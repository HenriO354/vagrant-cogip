#!/bin/bash

DBHOST=localhost
DBNAME=cogip
DBUSER=cogip
DBPASSWD=cogippass

# Update Packages
apt update > /dev/null 2>&1
# Upgrade Packages
apt upgrade -y > /dev/null 2>&1

# Apache
apt install -y apache2 > /dev/null 2>&1

# Enable Apache Mods
a2enmod rewrite

# restart apache
service apache2 restart

# Set MySQL Pass
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Install MySQL
apt install -y mysql-server > /dev/null 2>&1

# Create cogip database
mysql -uroot -proot -e "CREATE DATABASE $DBNAME;"
# Create non-root user and grant priviledge on cogip database
mysql -uroot -proot -e "CREATE USER '$DBUSER'@'$DBHOST' IDENTIFIED BY '$DBPASSWD';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'$DBHOST';"
mysql -uroot -proot -e "FLUSH PRIVILEGES;"

# Create tables into cogip database
mysql -uroot -proot $DBNAME < /var/www/html/database/cogip.sql
# Insert a user into user table
mysql -uroot -proot $DBNAME -e "INSERT INTO user(username,password,mode) VALUES('Henri','henripassword','winner');"

# PHP, PHP Apache Mod and PHP-MYSQL lib
apt install -y php libapache2-mod-php php-mysql > /dev/null 2>&1

# Edit apache default config
cp /var/www/html/conf/cogip.conf /etc/apache2/sites-available/000-default.conf

# Restart Apache
service apache2 restart