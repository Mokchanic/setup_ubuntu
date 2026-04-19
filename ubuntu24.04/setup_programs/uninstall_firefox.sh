#!/bin/bash
set -e

echo "=================================================="
echo " Uninstall Firefox (snap)"
echo "=================================================="

if snap list firefox &>/dev/null; then
    echo "Removing Firefox snap..."
    sudo snap remove firefox
    echo "Firefox removed."
else
    echo "Firefox snap not installed — skipping."
fi
