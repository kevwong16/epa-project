#!/bin/bash
sudo apt -y install git
sudo git clone https://github.com/kevwong16/epa-project.git /root
sudo chmod -R 755 epa-project
sudo bash epa-project/lemp-setup.sh
