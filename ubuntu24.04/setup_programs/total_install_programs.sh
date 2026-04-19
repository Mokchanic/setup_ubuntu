#!/bin/bash
set -e
set -o pipefail

# --------------------------------------------------------------------
# Master setup script — runs all install steps in dependency order
# --------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure all child scripts are executable
chmod +x ./*.sh

# Log directory (gitignored via top-level .gitignore)
LOG_DIR="${SCRIPT_DIR}/log"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/setup_$(date +%Y%m%d_%H%M%S).log"

# Tee everything (stdout + stderr) into the log file from here on
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=================================================="
echo " [Master Setup] Starting all install steps"
echo " Log file: ${LOG_FILE}"
echo " Start:    $(date)"
echo "=================================================="

# run_step <script> — runs a step and prints a clear banner; aborts on error
run_step() {
    local script="$1"
    echo ""
    echo "####################################################"
    echo "# STEP: ${script}"
    echo "# Time: $(date '+%F %T')"
    echo "####################################################"
    "./${script}"
}

# 1. Interactive step (must run first, before output is piped).
#    Users can skip it non-interactively with DUALBOOT_SKIP=1.
run_step setup_dualboot.sh

# 2. Cleanup / base tooling
run_step uninstall_firefox.sh
run_step install_curl.sh
run_step install_git.sh
run_step install_github_cli.sh

# 3. Compilers & build tools
run_step install_build-essential.sh
run_step install_cmake_ninja.sh
run_step install_clang.sh
run_step install_python.sh

# 4. Editors & user-facing apps
run_step install_terminal.sh
run_step install_IDE.sh
run_step install_apps.sh

# 5. Dev environments
run_step install_conda.sh
run_step setup_bashrc.sh

# 6. GPU stack (driver first, then container runtime)
run_step install_nvidia_driver.sh
run_step install_docker.sh

# 7. Final cleanup
echo ""
echo "=================================================="
echo " Cleaning up apt caches..."
echo "=================================================="
sudo apt-get autoremove -y
sudo apt-get clean

echo ""
echo "=================================================="
echo " [Master Setup] All steps completed"
echo " End:       $(date)"
echo " Log saved: ${LOG_FILE}"
echo ""
echo " Please REBOOT to apply all changes"
echo " (especially NVIDIA driver, Docker group, and Conda init)."
echo "=================================================="
