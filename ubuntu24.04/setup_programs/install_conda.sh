#!/bin/bash

echo "Starting Miniconda installation..."

# 1. Download and Install Miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

# 2. Initialize Conda
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
~/miniconda3/bin/conda init bash

# 3. Accept Anaconda Terms of Service (Crucial for 2025/2026 versions)
echo "Accepting Anaconda Terms of Service..."
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

echo "Configuring Conda channels..."

# 4. Conda-forge configuration
conda config --add channels conda-forge
conda config --set channel_priority strict

# 5. Install Jupyter and others
echo "Installing Jupyter Notebook and ipykernel..."
conda install -y jupyter notebook ipykernel

# 6. Disable auto-activation
conda config --set auto_activate_base false

echo "--------------------------------------------------"
echo "Miniconda setup is completed successfully!"
echo "--------------------------------------------------"
