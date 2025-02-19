#!/bin/bash

echo "Installing moveit2 ..."

source /opt/ros/humble/setup.bash

sudo apt install python3-rosdep

sudo rosdep init
rosdep update
sudo apt update
sudo apt -y dist-upgrade

## Install Colcon the ROS 2 build system with mixin
sudo apt -y install python3-colcon-common-extensions
sudo apt -y install python3-colcon-mixin
colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml
colcon mixin update default

sudo apt install python3-vcstool

## Make moveit2_ws
export MOVEIT_WS=~/robot_workspace/moveit2_ws
mkdir -p ${MOVEIT_WS}/src
cd ${MOVEIT_WS}/src
git clone --branch humble https://github.com/ros-planning/moveit2_tutorials
vcs import < moveit2_tutorials/moveit2_tutorials.repos

sudo apt update && rosdep install -r --from-paths . --ignore-src --rosdistro $ROS_DISTRO -y
cd ${MOVEIT_WS}
colcon build --mixin release --parallel-workers 1

## Setup moveit2_ws
source ${MOVEIT_WS}/install/setup.bash
echo "source ${MOVEIT_WS}/install/local_setup.bash" >> ~/.bashrc

