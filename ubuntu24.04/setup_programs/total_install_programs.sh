#!/bin/bash

# 에러 발생 시 즉시 중단 (중요)
set -e

echo "=== [Master Setup] Starting all setup scripts! ==="

# 모든 스크립트에 실행 권한 부여
chmod +x *.sh

# 실행 순서 (의존성을 고려한 최적화 순서)
./setup_dualboot.sh
./uninstall_firefox.sh
./install_curl.sh           # 다른 설치의 기초이므로 앞쪽 배치 추천
./install_git.sh
./install_github_cli.sh
./install_build-essential.sh
./install_cmake_ninja.sh
./install_clang.sh
./install_python.sh
./install_terminal.sh
./install_IDE.sh
./install_apps.sh
./install_conda.sh
./setup_bashrc.sh
./install_docker.sh

# 시스템 정리
echo "Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "=== [Master Setup] All processes are finished! ==="
echo "Please REBOOT your system to apply all changes (especially Docker & Conda)."
