#!/bin/bash

# Update the package list to ensure we have the latest information on available packages
sudo apt update -y

# Upgrade all installed packages to their latest versions
sudo apt upgrade -y

# Install Certbot and the Certbot Nginx plugin to manage SSL certificates
sudo apt install -y certbot python3-certbot-nginx

# Define your email address for use with Certbot (replace 'REPLACE_EMAIL' with your actual email)
EMAIL=REPLACE_EMAIL

# Define your domain name(s) for use with Certbot (replace 'REPLACE_DOMAIN' with your actual domain)
DOMAIN=REPLACE_DOMAIN

# Use Certbot to automatically obtain and install an SSL certificate for the specified domain(s)
# - "--nginx": Configures Nginx automatically
# - "--non-interactive": Runs without user input
# - "--agree-tos": Automatically agree to the terms of service
# - "-d $DOMAIN": Specifies the domain(s) for the SSL certificate
sudo certbot --nginx --non-interactive --agree-tos --email $EMAIL -d $DOMAIN

# Test the Nginx configuration for syntax errors
# If the test is successful, reload Nginx to apply the changes
sudo nginx -t && sudo systemctl reload nginx
