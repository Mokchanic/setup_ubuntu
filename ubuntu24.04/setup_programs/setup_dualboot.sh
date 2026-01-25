#!/bin/bash

# 색상 정의 (가독성용)
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=========================================="
echo -e "      Ubuntu 24.04 시스템 최적화 설정"
echo -e "==========================================${NC}"

# 듀얼 부팅 여부 확인
echo "현재 시스템이 듀얼 부팅 환경입니까?"
echo "1) 예 (Windows와 함께 사용)"
echo "2) 아니오 (Ubuntu 단독 사용)"
read -p "선택 (1/2): " CHOICE

case $CHOICE in
    1)
        echo -e "\n${GREEN}[진행] 듀얼 부팅 최적화 설정을 시작합니다.${NC}"
        
        # 1. 시간 설정 (RTC -> Local Time)
        echo -e "\n1. Windows 시간 불일치 해결 설정 중..."
        sudo timedatectl set-local-rtc 1 --adjust-system-clock
        echo -e "결과: ${GREEN}$(timedatectl | grep 'RTC in local TZ')${NC}"

        # 2. GRUB 부팅 설정 변경 (마지막 선택 기억)
        echo -e "\n2. GRUB 부팅 순서 자동 기억 설정 중..."
        GRUB_CONF="/etc/default/grub"
        sudo cp $GRUB_CONF "${GRUB_CONF}.bak"
        echo "백업 완료: ${GRUB_CONF}.bak"

        # GRUB_DEFAULT를 saved로 변경
        sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' $GRUB_CONF
        
        # GRUB_SAVEDEFAULT 옵션이 없으면 추가
        if ! grep -q "GRUB_SAVEDEFAULT=true" "$GRUB_CONF"; then
            echo "GRUB_SAVEDEFAULT=true" | sudo tee -a $GRUB_CONF
        fi

        # GRUB 설정 적용
        echo -e "\nGRUB 설정을 시스템에 적용합니다..."
        sudo update-grub
        
        echo -e "\n${GREEN}모든 설정이 완료되었습니다!${NC}"
        ;;
    2)
        echo -e "\n${YELLOW}[스킵] 듀얼 부팅 설정이 필요하지 않아 종료합니다.${NC}"
        exit 0
        ;;
    *)
        echo -e "\n${YELLOW}[알림] 잘못된 입력입니다. 프로그램을 종료합니다.${NC}"
        exit 1
        ;;
esac
