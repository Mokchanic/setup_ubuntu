#!/bin/bash

# Ensure dependencies are installed
if [ -f "./install_curl.sh" ]; then
    ./install_curl.sh
fi

# Install Git
echo "Installing Git..."
sudo apt-get update
sudo apt-get install -y git

# Verify installation
echo "------------------------------"
git --version
echo "------------------------------"

echo "Git installation completed."

# Tip: Run the following commands to configure your git profile
# git config --global user.name "mokchanic"
# git config --global user.email "mokok118@kakao.com"
