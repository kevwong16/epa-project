#!/bin/bash

# Create a file to store the output of the LEMP stack unit tests
sudo touch /root/testing.txt

# Install Nginx web server
sudo apt -y install nginx

# Start Nginx service and enable it to run on server boot; the second command executes only if the first succeeds
sudo systemctl start nginx && sudo systemctl enable nginx

# Save the status of the Nginx service to the testing log file
sudo systemctl status nginx > /root/testing.txt

# Install MariaDB database server
sudo apt -y install mariadb-server

# Start MariaDB service and enable it to run on server boot
sudo systemctl start mariadb && sudo systemctl enable mariadb

# Append the status of the MariaDB service to the testing log file
systemctl status mariadb >> /root/testing.txt

# Install PHP and common PHP extensions required for a typical LEMP stack
sudo apt -y install php php-cli php-common php-imap php-fpm php-snmp php-xml php-zip php-mbstring php-curl php-mysqli php-gd php-intl

# Append the installed PHP version to the testing log file
sudo php -v >> /root/testing.txt

sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 512M/g' /etc/php/8.3/fpm/php.ini

sed -i 's/post_max_size = 8M/post_max_size = 512M/g' /etc/php/8.3/fpm/php.ini

sudo systemctl restart php8.3-fpm

# Stop the Apache2 service (as Nginx will be used instead)
sudo systemctl stop apache2

# Disable Apache2 service to prevent it from starting on server boot
sudo systemctl disable apache2

# Optional: Fully remove Apache2 (commented out as it's not being executed)
# sudo apt remove --purge apache2

# Rename the default Apache testing page (if present)
sudo mv /var/www/html/index.html /var/www/html/index.html.old

# Replace the Nginx configuration file with a custom one
sudo mv /home/ubuntu/epa-project/nginx.conf /etc/nginx/conf.d/nginx.conf

# Define the DNS record for the WordPress site.
my_domain=REPLACE_DOMAIN
elastic_ip=REPLACE_MY_ELASTIC_IP

CF_API=REPLACE_CF_API
CF_ZONE_ID=REPLACE_CF_ZONE_ID

curl --request POST \
  --url https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CF_API" \
  --data '{
  "content": "'"$elastic_ip"'",
  "name": "'"$my_domain"'",
  "proxied": true,
  "type": "A",
  "comment": "Automatically adding A record",
  "tags": [],
  "ttl": 3600
}'


# Update the server name in the Nginx configuration file with the DNS record.
sed -i "s/SERVERNAME/$my_domain/g" /etc/nginx/conf.d/nginx.conf

# Test the Nginx configuration for syntax errors and reload Nginx if the test is successful.
nginx -t && systemctl reload nginx

# Run a script to install SSL certificates using Certbot.
# sudo bash /root/epa-project/certbot-ssl-install.sh
