#!/bin/bash
set -e

echo "=================================================="
echo " NVIDIA Driver Installation (Ubuntu 24.04)"
echo "=================================================="

# Skip if a driver is already active
if command -v nvidia-smi &>/dev/null && nvidia-smi &>/dev/null; then
    CURRENT=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -1)
    echo "NVIDIA driver already active (version ${CURRENT}) — skipping."
    echo "To reinstall, purge first:  sudo apt-get purge '*nvidia*' && sudo reboot"
    exit 0
fi

# Check for an NVIDIA GPU on the PCI bus
if ! lspci | grep -Ei 'vga|3d|2d' | grep -qi nvidia; then
    echo "No NVIDIA GPU detected on PCI bus — nothing to install."
    exit 0
fi

echo "Detected NVIDIA GPU:"
lspci | grep -Ei 'vga|3d|2d' | grep -i nvidia
echo ""

# 1. Install ubuntu-drivers helper
echo "[1/3] Installing ubuntu-drivers-common..."
sudo apt-get update -q
sudo apt-get install -y ubuntu-drivers-common

# 2. Show recommendations for reference
echo ""
echo "[2/3] Driver recommendations:"
ubuntu-drivers devices || true

# 3. Install the recommended proprietary driver
echo ""
echo "[3/3] Installing recommended driver (autoinstall)..."
sudo ubuntu-drivers autoinstall

echo ""
echo "=================================================="
echo " NVIDIA driver installation completed."
echo ""
echo " REBOOT REQUIRED:  sudo reboot"
echo ""
echo " After reboot, verify with:  nvidia-smi"
echo "=================================================="
