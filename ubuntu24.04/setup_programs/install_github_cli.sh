#!/bin/bash

# 1. Install dependency
echo "Checking for curl..."
if ! command -v curl &> /dev/null; then
    echo "curl not found. Installing curl..."
    sudo apt-get update && sudo apt-get install -y curl
fi

# 2. Add GitHub CLI official GPG key
echo "Adding GitHub CLI GPG key..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

# 3. Add repository to source list
echo "Adding GitHub CLI repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# 4. Install GitHub CLI
echo "Updating package lists and installing gh..."
sudo apt-get update
sudo apt-get install -y gh

# 5. Verify installation
echo "------------------------------"
gh --version
echo "------------------------------"

echo "GitHub CLI installation completed."
echo "Tip: Run 'gh auth login' to authenticate."
