#!/bin/bash

# Download the `git-setup.sh` script from the specified S3 bucket to the `/root/` directory
sudo wget -O /root/git-setup.sh https://kevin-epa-bucket.s3.us-east-1.amazonaws.com/git-setup.sh

# Set executable permissions for the downloaded `git-setup.sh` script
sudo chmod 755 /root/git-setup.sh

# Execute the `git-setup.sh` script
sudo bash /root/git-setup.sh
