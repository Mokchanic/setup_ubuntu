#!/bin/bash
set -e

echo "=================================================="
echo " curl Installation"
echo "=================================================="

sudo apt-get update -q
sudo apt-get install -y curl

echo "------------------------------"
curl --version | head -1
echo "------------------------------"
echo "curl installation completed."
