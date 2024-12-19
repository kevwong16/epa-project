#!/bin/bash

# Set the AWS RDS endpoint, username, and password for the database connection
aws_rds_endpoint=AWS_RDS_ENDPOINT
rds_username=RDS_USER
rds_password=RDS_PASSWORD

# Remove the existing web root directory (force delete to ensure a clean state)
sudo rm -rf /var/www/html

# Install the `unzip` utility if it is not already installed (non-interactive)
sudo apt -y install unzip

# Download the latest WordPress archive from the official website into the `/var/www/` directory
sudo wget -O /var/www/latest.zip https://wordpress.org/latest.zip

# Extract the contents of the downloaded WordPress archive into `/var/www/`
sudo unzip /var/www/latest.zip -d /var/www/

# Delete the downloaded WordPress archive to save disk space
sudo rm /var/www/latest.zip

# Rename the extracted WordPress directory to `html`, which is the standard web root directory
sudo mv /var/www/wordpress /var/www/html

# Move the sample configuration file to its final location and rename it as `wp-config.php`
sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Set secure permissions for `wp-config.php` to restrict access
sudo chmod 640 /var/www/html/wp-config.php

# Change ownership of the WordPress directory to the `www-data` user and group for web server access
sudo chown -R www-data:www-data /var/www/html/

# Create a new database on the RDS server if it does not already exist
mysql -h $aws_rds_endpoint -u $rds_username -p$rds_password -e "CREATE DATABASE IF NOT EXISTS $rds_username;"

# Replace placeholders in `wp-config.php` with actual database credentials and endpoint
sed -i "s/password_here/$rds_password/g" /var/www/html/wp-config.php
sed -i "s/username_here/$rds_username/g" /var/www/html/wp-config.php
sed -i "s/database_name_here/$rds_username/g" /var/www/html/wp-config.php
sed -i "s/localhost/$aws_rds_endpoint/g" /var/www/html/wp-config.php

# Fetch unique WordPress salts from the official API for improved security
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)

# Replace the placeholder text 'put your unique phrase here' in `wp-config.php` with the fetched salts
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s /var/www/html/wp-config.php
