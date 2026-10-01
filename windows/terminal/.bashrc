# Git Bash Environment Configuration (Restricted Workstation)

# POSIX environment compatibility on Windows
export USER="${USER:-$USERNAME}"

# User-space tools in PATH
export PATH="$HOME/.local/bin:$PATH"

# Initialize Starship Prompt (runs at prompt generation, 0ms input latency)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
