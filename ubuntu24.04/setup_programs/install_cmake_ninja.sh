#!/bin/bash

echo "Start CMake & Ninja install..."

# 최신 패키지 리스트 업데이트
sudo apt-get update

# 한 번에 설치 (보통 CMake를 쓸 때 컴파일러와 빌드 필수 도구들이 같이 필요합니다)
sudo apt-get install -y cmake ninja-build build-essential

echo "------------------------------"
# 버전 확인
cmake --version
ninja --version
echo "------------------------------"
echo "Install completed."
