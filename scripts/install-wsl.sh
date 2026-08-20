#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -z "${WSL_INTEROP:-}" ]] && ! grep -qi microsoft /proc/version 2>/dev/null; then
  printf 'This installer must run inside WSL2.\n' >&2
  exit 1
fi

printf 'Installing WSL2 base packages...\n'
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  ca-certificates \
  curl \
  fd-find \
  fzf \
  git \
  jq \
  neovim \
  pkg-config \
  ripgrep \
  unzip

export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! command -v bun >/dev/null 2>&1; then
  curl -fsSL https://bun.sh/install | bash
fi

if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

"$repo_root/scripts/setup-git.sh"
"$repo_root/scripts/setup-agent-links.sh"
"$repo_root/scripts/setup-shell.sh"

printf '\nWSL2 dotfiles are installed. Open a new shell, then run scripts/test-env.sh.\n'
