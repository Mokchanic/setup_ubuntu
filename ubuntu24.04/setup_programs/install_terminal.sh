#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install Terminator
# Great for splitting terminals in a GUI environment
echo "Installing Terminator..."
sudo apt-get install -y terminator

# Install Vim editor
# Essential for quick configuration changes in terminal
echo "Installing Vim..."
sudo apt-get install -y vim

# Install tmux
# Perfect for persistent sessions and remote work (especially for robot control)
echo "Installing tmux..."
sudo apt-get install -y tmux

# Verify installations
echo "------------------------------"
terminator --version
vim --version
tmux -V
echo "------------------------------"

echo "Terminal utilities installation completed."
