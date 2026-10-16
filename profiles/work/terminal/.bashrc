# Git Bash interactive profile
# Location: ~/.bashrc

# Evaluate Starship prompt if installed
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Clean path aliases
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
