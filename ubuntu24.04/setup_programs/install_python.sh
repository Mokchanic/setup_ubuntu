#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install Python3, Pip, and Venv (Recommended for 24.04)
echo "Installing Python3, Pip, and Venv..."
sudo apt-get install -y python3 python3-pip python3-venv

# Verify installed versions
echo "------------------------------"
python3 --version
pip3 --version
echo "------------------------------"

echo "Python3 installation completed."
