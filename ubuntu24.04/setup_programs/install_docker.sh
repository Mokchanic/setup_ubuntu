#!/bin/bash

echo "Starting Docker and NVIDIA Container Toolkit installation..."

# 1. Remove old versions
echo "Removing old Docker versions..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg
done

# 2. Add Docker's official GPG key and repository
echo "Setting up Docker repository..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Manage Docker as a non-root user
echo "Configuring Docker user group..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker ${USER}

# 5. Install NVIDIA Container Toolkit (for GPU support)
echo "Installing NVIDIA Container Toolkit..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# 6. Configure Docker to use NVIDIA Runtime
echo "Configuring NVIDIA Runtime for Docker..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

echo "--------------------------------------------------"
echo "Docker installation completed!"
echo "IMPORTANT: Please log out and log back in for group changes to take effect."
echo "Test with: docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.0.1-base-ubuntu22.04 nvidia-smi"
echo "--------------------------------------------------"
