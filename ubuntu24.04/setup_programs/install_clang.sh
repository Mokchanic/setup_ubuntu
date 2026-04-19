#!/bin/bash
set -e

echo "=================================================="
echo " Clang Installation"
echo "=================================================="

# Install default Clang toolchain (Ubuntu 24.04 ships Clang 18)
sudo apt-get update -q
sudo apt-get install -y clang clang-format clang-tidy

echo "------------------------------"
clang --version | head -1
echo "------------------------------"
echo "Clang installation completed."
