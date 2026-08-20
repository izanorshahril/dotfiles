#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$HOME/.config"
mkdir -p "$config_dir"
ln -sfn "$repo_root/.config/starship/starship.toml" "$config_dir/starship.toml"
ln -sfn "$repo_root/.config/nvim" "$config_dir/nvim"

bashrc="$HOME/.bashrc"
start_marker='# >>> firstmate dotfiles >>>'
end_marker='# <<< firstmate dotfiles <<<'

if ! grep -Fq "$start_marker" "$bashrc" 2>/dev/null; then
  cat >>"$bashrc" <<'EOF'

# >>> firstmate dotfiles >>>
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
# <<< firstmate dotfiles <<<
EOF
fi

printf 'Bash, Starship, and Neovim links are ready.\n'
