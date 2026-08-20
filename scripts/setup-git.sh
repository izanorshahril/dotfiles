#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$HOME/.config/git"
mkdir -p "$config_dir"
ln -sfn "$repo_root/.config/git/.gitignore_global" "$config_dir/.gitignore_global"

git config --global include.path "$repo_root/.config/git/.gitconfig"
git config --global core.excludesfile "$config_dir/.gitignore_global"

git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global fetch.prune true

git config --global alias.st 'status -sb'
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.wt worktree
git config --global alias.wtl 'worktree list'
git config --global alias.wta 'worktree add'
git config --global alias.wtr 'worktree remove'

printf 'Git configuration linked from %s.\n' "$repo_root"
