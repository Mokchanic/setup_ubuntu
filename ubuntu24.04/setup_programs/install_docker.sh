#!/bin/bash
set -e

echo "=================================================="
echo " Docker + NVIDIA Container Toolkit Installation"
echo "=================================================="

# 1. Remove legacy Docker packages
echo ""
echo "[1/6] Removing legacy Docker packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg 2>/dev/null || true
done
echo "Done."

# 2. Set up Docker's official GPG key and APT repository
echo ""
echo "[2/6] Configuring Docker APT repository..."
sudo apt-get update -q
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Handle Ubuntu derivatives (Mint, Pop!_OS, etc.) by falling back to UBUNTU_CODENAME
CODENAME=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
${CODENAME} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Done (codename: ${CODENAME})"

# 3. Install Docker Engine + CLI + plugins
echo ""
echo "[3/6] Installing Docker Engine..."
sudo apt-get update -q
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "$(docker --version) installed."

# 4. Add current user to the docker group (takes effect after re-login)
echo ""
echo "[4/6] Adding user to docker group..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "${USER}"
echo "'${USER}' added to docker group."
echo "NOTE: group change takes effect after logout or 'newgrp docker'."

# 5. NVIDIA Container Toolkit (for GPU support)
echo ""
echo "[5/6] Installing NVIDIA Container Toolkit..."

DEB_ARCH=$(dpkg --print-architecture)
IS_JETSON=false
if [ -f /etc/nv_tegra_release ] \
   || grep -qi 'tegra\|jetson' /proc/device-tree/model 2>/dev/null; then
    IS_JETSON=true
fi

# Skip toolkit entirely on non-Jetson arm64 (no NVIDIA GPU expected).
if [ "$DEB_ARCH" = "arm64" ] && [ "$IS_JETSON" = false ]; then
    echo "Non-Jetson arm64 platform detected — skipping NVIDIA Container Toolkit."
    echo ""
    echo "=================================================="
    echo " Docker installation completed (without NVIDIA runtime)!"
    echo ""
    echo " IMPORTANT: re-login or run 'newgrp docker' before using docker as a non-root user."
    echo ""
    echo " Verify with:"
    echo "   docker run hello-world"
    echo "=================================================="
    exit 0
fi

# Driver / platform detection
if [ "$IS_JETSON" = true ]; then
    echo "Jetson platform detected (L4T / JetPack)."
    if [ -f /etc/nv_tegra_release ]; then
        echo "  L4T: $(head -1 /etc/nv_tegra_release)"
    fi
    echo "  GPU driver is provided by JetPack — no separate driver install needed."
else
    # x86_64
    if ! command -v nvidia-smi &>/dev/null; then
        echo "WARNING: nvidia-smi not found."
        echo "  The NVIDIA driver does not appear to be installed."
        echo "  Toolkit install will continue, but GPU workloads will not work"
        echo "  until you install the driver (see install_nvidia_driver.sh)."
    else
        echo "NVIDIA driver detected: $(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -1)"
    fi
fi

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

sudo apt-get update -q
sudo apt-get install -y nvidia-container-toolkit
echo "NVIDIA Container Toolkit installed."

# 6. Wire the NVIDIA runtime into the Docker daemon
echo ""
echo "[6/6] Configuring Docker NVIDIA runtime..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
echo "Docker daemon restarted."

echo ""
echo "=================================================="
echo " Docker installation completed!"
echo ""
echo " IMPORTANT: re-login or run 'newgrp docker' before using docker as a non-root user."
echo ""
echo " Verify with:"
echo "   docker run hello-world"
if [ "$IS_JETSON" = true ]; then
echo "   docker run --rm --runtime=nvidia --gpus all \\"
echo "       nvcr.io/nvidia/l4t-base:r36.2.0"
else
echo "   docker run --rm --runtime=nvidia --gpus all \\"
echo "       nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi"
fi
echo "=================================================="
