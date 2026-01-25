#!/bin/bash

echo "Start!! Standard Clang 18 install..."
sudo apt update
sudo apt install -y clang clang-format clang-tidy

# 설치 확인
clang --version
