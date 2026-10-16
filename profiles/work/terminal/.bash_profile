# Git Bash Login Profile

export USER="${USER:-$USERNAME}"

# Source .bashrc for login shells
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
