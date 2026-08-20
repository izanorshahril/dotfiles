#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
backup_suffix="backup.$(date +%Y%m%d%H%M%S)"

link_file() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname -- "$target")"

  if [[ -L "$target" ]] && [[ "$(readlink -- "$target")" == "$source" ]]; then
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mv -- "$target" "$target.$backup_suffix"
    printf 'Backed up %s to %s.%s\n' "$target" "$target" "$backup_suffix"
  fi

  ln -s -- "$source" "$target"
}

link_file "$repo_root/agents/AGENTS.md" "$HOME/.agents/AGENTS.md"
link_file "$repo_root/agents/AGENTS.md" "$HOME/AGENTS.md"
link_file "$repo_root/agents/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

printf 'Global agent directives linked from %s.\n' "$repo_root/agents"
