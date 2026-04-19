#!/bin/bash
set -e

echo "=================================================="
echo " Mamba (Miniforge) Installation"
echo "=================================================="

# Skip if already installed
if [ -d "$HOME/miniforge3" ]; then
    echo "Miniforge already installed at ~/miniforge3 — skipping."
    echo "Remove it manually first if you want a clean reinstall."
    exit 0
fi

# Ensure wget is available (needed to fetch the installer)
if ! command -v wget &>/dev/null; then
    echo "wget not found. Installing wget first..."
    sudo apt-get update -q && sudo apt-get install -y wget
fi

# 1. Download Miniforge installer (arch-aware: x86_64 / aarch64)
echo ""
echo "[1/5] Downloading Miniforge..."
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  MINIFORGE_ARCH="x86_64"  ;;
    aarch64) MINIFORGE_ARCH="aarch64" ;;
    *)
        echo "Unsupported architecture: $ARCH"
        echo "Miniforge officially supports only x86_64 and aarch64 on Linux."
        exit 1
        ;;
esac
echo "Detected architecture: $ARCH (using Miniforge3-Linux-${MINIFORGE_ARCH}.sh)"
wget -q --show-progress \
    "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-${MINIFORGE_ARCH}.sh" \
    -O ~/miniforge.sh
echo "Download completed."

# 2. Run installer (batch mode, no prompts)
echo ""
echo "[2/5] Installing Miniforge..."
bash ~/miniforge.sh -b -p ~/miniforge3
rm -f ~/miniforge.sh
echo "Install completed."

# 3. Shell initialization
#    Note: from mamba 2.x, only `conda init` works — `mamba init` is deprecated.
echo ""
echo "[3/5] Initializing shell..."
export PATH="$HOME/miniforge3/bin:$PATH"
~/miniforge3/bin/conda init bash

# Make conda usable in the current shell session
source ~/miniforge3/etc/profile.d/conda.sh
echo "Shell initialization completed."

# 4. Force conda-forge only (block the paid Anaconda 'defaults' channel)
echo ""
echo "[4/5] Configuring channels (conda-forge only)..."
~/miniforge3/bin/conda config --remove channels defaults 2>/dev/null || true
~/miniforge3/bin/conda config --add channels conda-forge
~/miniforge3/bin/conda config --set channel_priority strict
# Don't auto-activate the base env on every shell start
~/miniforge3/bin/conda config --set auto_activate_base false
echo "Channel configuration completed."

# 5. Verify
echo ""
echo "[5/5] Verifying installation..."
echo ""
echo "--- Mamba version ---"
~/miniforge3/bin/mamba --version

echo ""
echo "--- Configured channels (should be conda-forge only) ---"
~/miniforge3/bin/conda config --show channels

echo ""
echo "=================================================="
echo " Mamba (Miniforge) installation completed!"
echo ""
echo " Open a new terminal or run:  source ~/.bashrc"
echo ""
echo " Usage:"
echo "   mamba install <package>"
echo "   mamba create -n myenv python=3.11"
echo "=================================================="
