#!/bin/bash
set -e

# Top-level entry point: update the system, then run the full install pipeline.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. System update & upgrade
./update_ubuntu.sh

# 2. Run the full install pipeline
echo ""
echo "Launching Ubuntu 24.04 setup..."
./ubuntu24.04/setup_programs/total_install_programs.sh

echo "Launching ROS2 Jazzy setup..."
./ubuntu24.04/ROS2_jazzy/install_ROS2_jazzy_full.sh


echo ""
echo "All done. Reboot the system to apply changes."
