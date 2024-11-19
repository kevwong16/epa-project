#!/bin/bash
# sudo apt -y install git
sudo apt -y update
sudo apt -y upgrade
sudo git clone https://github.com/kevwong16/epa-project.git /root/epa-project
sudo chmod -R 755 /root/epa-project
sudo bash /root/epa-project/lemp-setup.sh
