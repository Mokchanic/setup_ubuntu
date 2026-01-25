#!/bin/bash

echo "Start Full Setup of Useful Programs!"
sudo apt-get update

# 1. Monitoring & Networking
echo "Installing Monitoring & Network tools..."
# net-tools(ifconfig), htop(CPU), nvtop(GPU), wireshark(Network)
sudo apt-get install -y net-tools htop nvtop wireshark

# 2. Graphics & Media
echo "Installing Graphics & Media tools..."
# kolourpaint(Edit), peek(GIF record)
sudo apt-get install -y kolourpaint peek
sudo snap install vlc
sudo snap install blender --classic

# 3. Productivity & Documentation
echo "Installing Productivity tools..."
# Notion & Slack (Community/Official via Snap)
sudo snap install notion-snap-reborn
sudo snap install slack

# 4. Engineering & Robotics Specific (Essential for Clo-Bot)
echo "Installing Engineering & Robotics tools..."
sudo snap install freecad
sudo snap install plotjuggler
sudo snap install foxglove-studio

echo "--------------------------------------------------"
echo "All useful programs have been installed successfully!"
echo "--------------------------------------------------"
