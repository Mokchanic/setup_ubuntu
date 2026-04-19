#!/bin/bash
set -e

echo "=================================================="
echo " IDE Installation"
echo "=================================================="

# curl is required to fetch GPG keys and .deb packages
if ! command -v curl &>/dev/null; then
    echo "curl not found. Installing curl first..."
    sudo apt-get update -q && sudo apt-get install -y curl
fi

sudo apt-get update -q

# --------------------------------------------------
# Visual Studio Code (via snap)
# --------------------------------------------------
echo "Installing Visual Studio Code..."
sudo snap install code --classic

# --------------------------------------------------
# Cursor (via official .deb — registers APT repo automatically)
# --------------------------------------------------
echo "Installing Cursor..."
CURSOR_API="https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
CURSOR_DEB_URL=$(curl -fsSL "$CURSOR_API" | grep -oE '"debUrl":"[^"]+"' | cut -d'"' -f4)
if [ -z "$CURSOR_DEB_URL" ]; then
    echo "ERROR: Failed to resolve Cursor .deb URL from $CURSOR_API" >&2
    exit 1
fi
CURSOR_DEB="/tmp/cursor-latest.deb"
curl -fsSL "$CURSOR_DEB_URL" -o "$CURSOR_DEB"
sudo apt-get install -y "$CURSOR_DEB"
rm -f "$CURSOR_DEB"

# --------------------------------------------------
# Google Antigravity (via official APT repo)
# --------------------------------------------------
echo "Installing Google Antigravity..."
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg \
    | sudo gpg --dearmor -o /usr/share/keyrings/google-antigravity.gpg
sudo chmod go+r /usr/share/keyrings/google-antigravity.gpg

printf '%s\n' \
    'Types: deb' \
    'URIs: https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/' \
    'Suites: antigravity-debian' \
    'Components: main' \
    'Signed-By: /usr/share/keyrings/google-antigravity.gpg' \
    | sudo tee /etc/apt/sources.list.d/google-antigravity.sources > /dev/null

sudo apt-get update -q
sudo apt-get install -y antigravity

echo "--------------------------------------------------"
echo "Setup Summary:"
echo "  - VS Code:    installed"
echo "  - Cursor:     installed"
echo "  - Antigravity: installed"
echo "--------------------------------------------------"
echo "IDE installation completed."
