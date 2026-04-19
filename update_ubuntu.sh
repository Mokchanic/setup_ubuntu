#!/bin/bash
set -e

# System update, upgrade, and cleanup
echo "Starting apt update & upgrade..."
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
echo "System update completed."
