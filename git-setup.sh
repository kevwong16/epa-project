#!/bin/bash

# Function to check the exit status of the last executed command
check_exit_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed."
        exit 1
    else
        echo "$1 succeeded."
    fi
}

# Update package lists
sudo apt -y update
check_exit_status "apt update"

# Upgrade installed packages
sudo apt -y upgrade
check_exit_status "apt upgrade"

# Clone the GitHub repository
sudo git clone https://github.com/kevwong16/epa-project.git /root/epa-project
check_exit_status "git clone"

# Change permissions of the cloned repository
sudo chmod -R 755 /root/epa-project
check_exit_status "chmod"

# Run the setup script
sudo bash /root/epa-project/lemp-setup.sh
check_exit_status "lemp-setup.sh script"
