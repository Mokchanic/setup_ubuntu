#!/bin/bash

# Update package lists to ensure we fetch the latest version
echo "Updating package lists..."
sudo apt-get update

# Install curl
echo "Installing curl..."
sudo apt-get install -y curl

# Verify installed version
echo "------------------------------"
curl --version
echo "------------------------------"

echo "Curl installation completed."
