#!/bin/bash
sudo rm -rf /var/www/html
sudo apt -y install unzip
sudo wget -O /var/www/latest.zip https://wordpress.org/latest.zip
sudo unzip /var/www/latest.zip
sudo rm /var/www/latest.zip
sudo mv /var/www/wordpress /var/www/html 
# sudo mariadb -u root
sudo mysql -e "CREATE DATABASE IF NOT EXISTS wordpress"
sudo mysql -e "CREATE USER IF NOT EXISTS wpuser@localhost identified by 'theclassof92'"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* to wpuser@localhost"
sudo mysql -e "FLUSH PRIVILEGES"
sudo wget -O /var/www/html/wp-config.php https://kevin-epa-bucket.s3.us-east-1.amazonaws.com/wp-config.php
sudo chmod 640 /var/www/html/wp-config.php 
sudo chown -R www-data:www-data /var/www/html/
# sudo cd /etc/nginx/conf.d/
# sudo touch wordpress.conf pull from s3bucket
