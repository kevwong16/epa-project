#!/bin/bash
sudo apt -y update
sudo apt -y upgrade
sudo touch /root/testing.txt
sudo apt -y install nginx
sudo systemctl start nginx && sudo systemctl enable nginx
sudo systemctl status nginx > /root/testing.txt
sudo apt -y install mariadb-server
sudo systemctl start mariadb && sudo systemctl enable mariadb
sudo systemctl status mariadb >> /root/testing.txt
sudo apt -y install php php-cli php-common php-imap php-fpm php-snmp php-xml php-zip php-mbstring php-curl php-mysqli php-gd php-intl
sudo php -v >> /root/testing.txt
