#!/bin/bash
set -e

echo "=================================================="
echo " Terminal Utilities Installation"
echo "=================================================="

sudo apt-get update -q

# terminator: GUI terminal with split panes
# vim:        quick in-terminal config editing
# tmux:       persistent sessions, essential for remote robot work
sudo apt-get install -y terminator vim tmux

echo "------------------------------"
terminator --version
vim --version | head -1
tmux -V
echo "------------------------------"
echo "Terminal utilities installation completed."
