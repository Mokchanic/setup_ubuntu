#!/bin/bash
set -e

# Colors for readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=========================================="
echo -e "   Ubuntu 24.04 Dual-Boot Optimization"
echo -e "==========================================${NC}"

# Allow non-interactive skipping via env var (used by the master installer)
if [ "${DUALBOOT_SKIP:-0}" = "1" ]; then
    echo -e "${YELLOW}[SKIP] DUALBOOT_SKIP=1 — dual-boot setup skipped.${NC}"
    exit 0
fi

echo "Is this machine dual-booting with Windows?"
echo "  1) Yes (Ubuntu + Windows)"
echo "  2) No  (Ubuntu only)"
read -p "Choice (1/2): " CHOICE

case $CHOICE in
    1)
        echo -e "\n${GREEN}[RUN] Applying dual-boot optimizations...${NC}"

        # 1. Make Linux treat the hardware clock as local time
        #    (prevents Windows <-> Linux clock drift)
        echo -e "\n1. Fixing RTC clock mismatch with Windows..."
        sudo timedatectl set-local-rtc 1 --adjust-system-clock
        echo -e "   Result: ${GREEN}$(timedatectl | grep 'RTC in local TZ')${NC}"

        # 2. Make GRUB remember the last selected entry as the default
        echo -e "\n2. Configuring GRUB to remember last choice..."
        GRUB_CONF="/etc/default/grub"
        sudo cp "$GRUB_CONF" "${GRUB_CONF}.bak"
        echo "   Backup saved: ${GRUB_CONF}.bak"

        # GRUB_DEFAULT=saved
        sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$GRUB_CONF"

        # Append GRUB_SAVEDEFAULT=true if not already set
        if ! grep -q "GRUB_SAVEDEFAULT=true" "$GRUB_CONF"; then
            echo "GRUB_SAVEDEFAULT=true" | sudo tee -a "$GRUB_CONF" > /dev/null
        fi

        # Apply
        echo -e "\n   Applying GRUB configuration..."
        sudo update-grub

        echo -e "\n${GREEN}Dual-boot setup completed.${NC}"
        ;;
    2)
        echo -e "\n${YELLOW}[SKIP] Ubuntu-only install — no dual-boot tweaks needed.${NC}"
        exit 0
        ;;
    *)
        echo -e "\n${YELLOW}[WARN] Invalid input — exiting without changes.${NC}"
        exit 0
        ;;
esac
