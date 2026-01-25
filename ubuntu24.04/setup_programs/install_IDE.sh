k#!/bin/bash

echo "Installing IDEs..."

# 1. Update system
sudo apt-get update

# 2. Install PyCharm Community
# Uncomment the following lines if you need PyCharm in the future
# echo "Installing PyCharm Community..."
# sudo snap install pycharm-community --classic

# 3. Install VS Code
echo "Installing Visual Studio Code..."
sudo snap install code --classic

echo "--------------------------------------------------"
echo "Setup Summary:"
echo "- IDEs: VS Code installed."
# echo "- IDEs: PyCharm Community (Commented out)"
echo "--------------------------------------------------"

echo "Installation completed."
