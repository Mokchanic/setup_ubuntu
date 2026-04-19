#!/bin/bash
set -e

echo "=================================================="
echo " Setup .bashrc"
echo "=================================================="

# 1. Git branch prompt
if ! grep -q "parse_git_branch()" ~/.bashrc; then
    echo ""
    echo "[1/2] Adding git-branch prompt..."
    cat << 'EOF' >> ~/.bashrc

# ── Git branch prompt ──────────────────────────────────
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Use tput for terminal-portable color codes
c_cyan=$(tput setaf 6)
c_red=$(tput setaf 1)
c_green=$(tput setaf 2)
c_yellow=$(tput setaf 3)
c_bold=$(tput bold)
c_reset=$(tput sgr0)

# Green if working tree is clean, red if dirty
branch_color() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        if git diff --quiet 2>/dev/null >&2; then
            echo -ne "${c_green}"
        else
            echo -ne "${c_red}"
        fi
    fi
}

export PS1='\[${c_bold}${c_green}\]\u@\h \[${c_reset}${c_bold}${c_cyan}\]\w\[${c_reset}\]\[$(branch_color)\]$(parse_git_branch)\[${c_reset}\]\$ '
# ───────────────────────────────────────────────────────
EOF
    echo "~/.bashrc updated."
    echo "To apply in the current terminal:  source ~/.bashrc"
else
    echo ""
    echo "Git branch prompt already present — skipping."
fi

echo ""
echo "=================================================="
echo " .bashrc setup completed."
echo "=================================================="
