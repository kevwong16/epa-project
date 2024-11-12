#!/bin/bash
sudo cd /var/www/
sudo rm -rf html
sudo apt -y install unzip
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
sudo rm latest.zip
sudo mv wordpress html
# sudo mariadb -u root
sudo mysql -e "CREATE DATABASE IF NOT EXISTS wordpress"
sudo mysql -e "CREATE USER wpuser@localhost identified by 'theclassof92'"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* to wpuser@localhost"
sudo mysql -e "FLUSH PRIVILEGES"
sudo cd /var/www/html/wordpress
sudo wget https://kevin-epa-bucket.s3.us-east-1.amazonaws.com/wp-config.php
sudo chmod 640 wp-config.php
sudo chown -R www-data:www-data /var/www/html/wordpress
# sudo cd /etc/nginx/conf.d/
# sudo touch wordpress.conf pull from s3bucket
