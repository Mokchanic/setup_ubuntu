#!/bin/bash

echo "Setup bashrc"

if ! grep -q "parse_git_branch()" ~/.bashrc; then
    echo "Adding git branch display to .bashrc"

    cat << 'EOF' >> ~/.bashrc

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Colors for the prompt
c_cyan=$(tput setaf 6)
c_red=$(tput setaf 1)
c_green=$(tput setaf 2)
c_sgr0=$(tput sgr0)

# Function to set the color based on git status
branch_color() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        color=""
        if git diff --quiet 2>/dev/null >&2; then
            color="${c_green}"
        else
            color=${c_red}
        fi
    else
        return 0
    fi
    echo -ne $color
}

# Setting the prompt
export PS1='\[\e[01;32m\]\u@\h \[\e[34m\]\w\[${c_sgr0}\]\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]\$ '
EOF

    source ~/.bashrc
    echo "~/.bashrc updated successfully"
else
    echo "Git branch display already present in ~/.bashrc"
fi

## Timedatectl
timedatectl set-local-rtc 1 --adjust-system-clock
timedatectl
