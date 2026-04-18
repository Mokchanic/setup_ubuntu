#!/bin/bash
set -e

echo "=================================================="
echo " ROS 2 Jazzy Desktop-Full Setup"
echo "=================================================="

# 1. Locale — ensures clean UTF-8 output even on Korean systems
echo ""
echo "[1/9] Configuring locale..."
sudo apt-get update -q
sudo apt-get install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# 2. Enable the Ubuntu Universe repository
echo ""
echo "[2/9] Enabling Universe repository..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y universe

# 3. ROS 2 GPG key + APT source
echo ""
echo "[3/9] Adding ROS 2 GPG key and repository..."
sudo apt-get install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# 4. ROS 2 Jazzy Desktop-Full + dev tools
echo ""
echo "[4/9] Installing ROS 2 Jazzy Desktop-Full..."
sudo apt-get update -q
sudo apt-get install -y ros-dev-tools ros-jazzy-desktop-full

# 5. Additional robotics toolchain (colcon, rosdep, vcstool, pip, bullet)
echo ""
echo "[5/9] Installing additional robot tooling..."
sudo apt-get install -y \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    python3-pip \
    libbullet-dev

# 6. rosdep init + update (init is skipped if it has already run)
echo ""
echo "[6/9] Initializing rosdep..."
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo rosdep init
fi
rosdep update

# 7. Create the robot workspace and do an initial empty build
echo ""
echo "[7/9] Creating ROS 2 workspace..."
ROBOT_WS=~/robot_workspace/robot_ws
mkdir -p "${ROBOT_WS}/src"
(
    cd "${ROBOT_WS}"
    # Load ROS 2 into this subshell to run colcon
    # shellcheck disable=SC1091
    source /opt/ros/jazzy/setup.bash
    colcon build --symlink-install
)

# 8. Cyclone DDS RMW (commonly swapped with Fast-DDS in robotics setups)
echo ""
echo "[8/9] Installing Cyclone DDS RMW..."
sudo apt-get install -y ros-jazzy-rmw-cyclonedds-cpp

# 9. Append ROS 2 block to ~/.bashrc (guarded against duplicates)
echo ""
echo "[9/9] Updating ~/.bashrc..."
if ! grep -q "ROS 2 Setup" ~/.bashrc; then
    cat <<EOF >> ~/.bashrc

# ── ROS 2 Setup ────────────────────────────────────────
source /opt/ros/jazzy/setup.bash
source ${ROBOT_WS}/install/local_setup.bash
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

# ROS environment variables
export ROS_DOMAIN_ID=10
export ROS_NAMESPACE=robot1
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# export RMW_IMPLEMENTATION=rmw_fastrtps_cpp

# Workspace aliases
alias cw='cd ${ROBOT_WS}'
alias cs='cd ${ROBOT_WS}/src'
alias cb='cd ${ROBOT_WS} && colcon build --symlink-install'
alias cbs='colcon build --symlink-install'
alias cbp='colcon build --symlink-install --packages-select'
alias rsl='source ${ROBOT_WS}/install/local_setup.bash'

# ROS 2 CLI aliases
alias rt='ros2 topic list'
alias re='ros2 topic echo'
alias rn='ros2 node list'
alias rp='ros2 param list'
alias ri='ros2 interface show'
alias rl='ros2 launch'

# Gazebo helpers
alias killgazebo='killall -9 gazebo gzserver gzclient 2>/dev/null; true'
# ───────────────────────────────────────────────────────
EOF
    echo "~/.bashrc updated."
else
    echo "ROS 2 block already present in ~/.bashrc — skipping."
fi

echo ""
echo "=================================================="
echo " ROS 2 Jazzy installation completed!"
echo ""
echo " Open a new terminal or run:  source ~/.bashrc"
echo "=================================================="
