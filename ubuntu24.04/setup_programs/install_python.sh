#!/bin/bash
set -e

echo "=================================================="
echo " Python 3 Installation"
echo "=================================================="

sudo apt-get update -q
sudo apt-get install -y python3 python3-pip python3-venv python3-dev

echo "------------------------------"
python3 --version
pip3 --version
echo "------------------------------"
echo "Python 3 installation completed."
echo ""
echo "Note: Ubuntu 24.04 enforces PEP 668 (externally-managed-environment)."
echo "  System-wide 'pip install' is blocked by default."
echo "  Use one of the following instead:"
echo "    - python3 -m venv .venv && source .venv/bin/activate"
echo "    - pipx install <package>        (for CLI tools)"
echo "    - mamba/conda env               (installed by install_conda.sh)"
