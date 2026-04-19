#!/bin/bash
set -e

echo "=================================================="
echo " build-essential Installation"
echo "=================================================="

sudo apt-get update -q
sudo apt-get install -y build-essential

echo "------------------------------"
gcc --version | head -1
g++ --version | head -1
make --version | head -1
echo "------------------------------"
echo "build-essential installation completed."
