#!/bin/bash

# 에러 발생 시 즉시 중단
set -e

echo "=== [ROS 2 Jazzy Setup] Starting Installation ==="

# 1. Locale 설정 (한글 환경에서도 터미널 출력이 깨지지 않게 보장)
echo "Configuring Locale..."
sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# 2. Ubuntu Universe 저장소 활성화
echo "Enabling Universe Repository..."
sudo apt -y install software-properties-common
sudo add-apt-repository -y universe

# 3. ROS 2 GPG Key 및 저장소 추가
echo "Adding ROS 2 GPG Key and Repository..."
sudo apt update && sudo apt -y install curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# 4. 개발 도구 및 ROS 2 데스크탑 풀 설치
echo "Installing ROS 2 Jazzy Desktop Full..."
sudo apt update
sudo apt install -y ros-dev-tools
sudo apt install -y ros-jazzy-desktop-full

# 5. 필수 로봇 개발 도구 설치 (의존성 관리 도구 등)
echo "Installing Additional Robot Tools..."
sudo apt install -y python3-colcon-common-extensions python3-rosdep python3-vcstool python3-pip
sudo apt install -y libbullet-dev

# 6. rosdep 초기화 및 업데이트 (sudo 없이 실행 권장되는 부분 처리)
echo "Initializing rosdep..."
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo rosdep init
fi
rosdep update

# 7. 워크스페이스 생성 및 초기 빌드
echo "Creating ROS 2 Workspace..."
ROBOT_WS=~/robot_workspace/robot_ws
mkdir -p ${ROBOT_WS}/src
cd ${ROBOT_WS}
# 현재 쉘에 ROS2 환경 임시 로드 후 빌드
source /opt/ros/jazzy/setup.bash
colcon build --symlink-install

# 8. Cyclone DDS 설치 (DDS 변경이 잦은 로봇 환경용)
sudo apt -y install ros-jazzy-rmw-cyclonedds-cpp

# 9. .bashrc 설정 (중복 추가 방지 및 신규 Alias 포함)
if ! grep -q "ROS 2 Setup" ~/.bashrc; then
echo "Adding ROS 2 settings to .bashrc..."
cat <<EOF >> ~/.bashrc

# ROS 2 Setup
source /opt/ros/jazzy/setup.bash
source ${ROBOT_WS}/install/local_setup.bash
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

# ROS Environment Variables
export ROS_DOMAIN_ID=10
export ROS_NAMESPACE=robot1
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# export RMW_IMPLEMENTATION=rmw_fastrtps_cpp

# Robotics Aliases (Basic)
alias cw='cd ${ROBOT_WS}'
alias cs='cd ${ROBOT_WS}/src'
alias cb='cd ${ROBOT_WS} && colcon build --symlink-install'
alias cbs='colcon build --symlink-install'
alias cbp='colcon build --symlink-install --packages-select'
alias rsl='source ${ROBOT_WS}/install/local_setup.bash'

# ROS 2 CLI Aliases (Enhanced)
alias rt='ros2 topic list'
alias re='ros2 topic echo'
alias rn='ros2 node list'
alias rp='ros2 param list'       # 추가: 파라미터 리스트 확인
alias ri='ros2 interface show'   # 추가: 메시지/서비스 인터페이스 구조 확인
alias rl='ros2 launch'           # 추가: 런치 파일 실행

# Gazebo Tools
alias killgazebo='killall -9 gazebo & killall -9 gzserver & killall -9 gzclient'
EOF
fi

# 즉시 적용
source ~/.bashrc

