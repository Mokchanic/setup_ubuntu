#!/bin/bash
set -e

echo "=================================================="
echo " GitHub CLI Installation"
echo "=================================================="

# curl is required to fetch the GPG key
if ! command -v curl &>/dev/null; then
    echo "curl not found. Installing curl first..."
    sudo apt-get update -q && sudo apt-get install -y curl
fi

# Add GitHub CLI GPG key
echo "Adding GitHub CLI GPG key..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg status=none
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

# Add GitHub CLI repository
echo "Adding GitHub CLI repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install gh
echo "Installing gh..."
sudo apt-get update -q
sudo apt-get install -y gh

echo "------------------------------"
gh --version | head -1
echo "------------------------------"
echo "GitHub CLI installation completed."
echo "Tip: run 'gh auth login' to authenticate."
