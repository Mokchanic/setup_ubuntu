#!/bin/bash
set -e

echo "=================================================="
echo " Useful Applications Installation"
echo "=================================================="

sudo apt-get update -q

# Pre-seed wireshark-common to suppress the "non-superusers capture" prompt
# (answers "No" — users who want non-root capture can rerun dpkg-reconfigure later)
echo "wireshark-common wireshark-common/install-setuid boolean false" \
    | sudo debconf-set-selections

# 1. Monitoring & Networking
#    net-tools (ifconfig), htop (CPU), nvtop (GPU), wireshark (packet capture)
echo "Installing monitoring & network tools..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    net-tools htop nvtop wireshark

# 2. Graphics & Media
#    kolourpaint (image editor), peek (GIF recorder), vlc, blender
echo "Installing graphics & media tools..."
sudo apt-get install -y kolourpaint peek
sudo snap install vlc
sudo snap install blender --classic

# 3. Productivity & Documentation
echo "Installing productivity tools..."
sudo snap install notion-snap-reborn

# 4. Engineering & Robotics (Clo-Bot essentials)
echo "Installing engineering & robotics tools..."
sudo snap install freecad
sudo snap install plotjuggler
sudo snap install foxglove-studio

echo "--------------------------------------------------"
echo "Useful applications installation completed."
echo "--------------------------------------------------"
