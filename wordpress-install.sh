#!/bin/bash

# Remove the existing web root directory (force delete)
sudo rm -rf /var/www/html

# Install the `unzip` utility if not already installed
sudo apt -y install unzip

# Download the latest WordPress archive into the `/var/www/` directory
sudo wget -O /var/www/latest.zip https://wordpress.org/latest.zip

# Extract the WordPress archive into `/var/www/`
sudo unzip /var/www/latest.zip -d /var/www/

# Remove the downloaded WordPress archive to free up space
sudo rm /var/www/latest.zip

# Rename the extracted WordPress directory to the standard web root directory
sudo mv /var/www/wordpress /var/www/html

# Generate a random password for the WordPress database user
password=$(tr -dc 'A-Za-z0-9!' < /dev/urandom | head -c 25)
username=$(tr -dc 'A-Za-z' < /dev/urandom | head -c 25)

echo $password > creds.txt
echo $username >> creds.txt

# Create the WordPress database if it doesn't already exist
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $username"

# Create a database user `wpuser` with the generated password, if not already existing
sudo mysql -e "CREATE USER IF NOT EXISTS $username@localhost IDENTIFIED BY '$password'"

# Grant all privileges on the `wordpress` database to the new user
sudo mysql -e "GRANT ALL PRIVILEGES ON $username.* TO $username@localhost"

# Apply the changes made to the database privileges
sudo mysql -e "FLUSH PRIVILEGES"

# Download a pre-configured `wp-config.php` file from the specified S3 bucket
# sudo wget -O /var/www/html/wp-config.php https://kevin-epa-bucket.s3.us-east-1.amazonaws.com/wp-config.php

sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Secure the `wp-config.php` file by setting appropriate permissions
sudo chmod 640 /var/www/html/wp-config.php

# Set ownership of the entire WordPress directory to the `www-data` user and group
sudo chown -R www-data:www-data /var/www/html/

# Replace the placeholder 'password_here' in wp-config.php with the generated password.
sed -i "s/password_here/$password/g" /var/www/html/wp-config.php
sed -i "s/username_here/$username/g" /var/www/html/wp-config.php
sed -i "s/database_name_here/$username/g" /var/www/html/wp-config.php

SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s /var/www/html/wp-config.php

# (Optional) Navigate to the /etc/nginx/conf.d/ directory and create a new Nginx configuration file for WordPress.
# sudo cd /etc/nginx/conf.d/
# sudo touch wordpress.conf pull from s3bucket
