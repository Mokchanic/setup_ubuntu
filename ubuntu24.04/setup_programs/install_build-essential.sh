#!/bin/bash

# Update package lists to ensure latest versions
echo "Updating package lists..."
sudo apt-get update

# Install build-essential
echo "Installing build-essential (gcc, g++, make, etc.)..."
sudo apt-get install -y build-essential

# Verify installation
echo "------------------------------"
echo "Build-essential components version:"
gcc --version
g++ --version
make --version
echo "------------------------------"

echo "build-essential installation completed."
