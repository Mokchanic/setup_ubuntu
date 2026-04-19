#!/bin/bash
set -e

echo "=================================================="
echo " Git Installation"
echo "=================================================="

sudo apt-get update -q
sudo apt-get install -y git

echo "------------------------------"
git --version
echo "------------------------------"
echo "Git installation completed."
echo ""
