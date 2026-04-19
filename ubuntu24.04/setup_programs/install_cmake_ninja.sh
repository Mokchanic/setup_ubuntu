#!/bin/bash
set -e

echo "=================================================="
echo " CMake & Ninja Installation"
echo "=================================================="

sudo apt-get update -q
# build-essential is typically required alongside CMake
sudo apt-get install -y cmake ninja-build build-essential

echo "------------------------------"
cmake --version | head -1
ninja --version
echo "------------------------------"
echo "CMake & Ninja installation completed."
