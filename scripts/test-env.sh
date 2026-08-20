#!/usr/bin/env bash
set -u

pass=0
warn=0

check_required() {
  local name="$1"
  local command_name="$2"
  if command -v "$command_name" >/dev/null 2>&1; then
    printf 'OK      %-28s %s\n' "$name" "$(command -v "$command_name")"
    pass=$((pass + 1))
  else
    printf 'MISSING %-28s %s\n' "$name" "$command_name"
    warn=$((warn + 1))
  fi
}

check_optional() {
  local name="$1"
  local command_name="$2"
  if command -v "$command_name" >/dev/null 2>&1; then
    printf 'OK      %-28s %s\n' "$name" "$(command -v "$command_name")"
    pass=$((pass + 1))
  else
    printf 'OPTIONAL %-27s %s\n' "$name" "$command_name"
  fi
}

printf '%s\n' 'WSL2 agent environment'
printf '%s\n' '====================='
if grep -qi microsoft /proc/version 2>/dev/null || [[ -n "${WSL_INTEROP:-}" ]]; then
  printf 'OK      %-28s %s\n' 'WSL environment' "$(uname -r)"
else
  printf 'WARN    %-28s %s\n' 'WSL environment' 'run this script inside WSL2'
  warn=$((warn + 1))
fi

check_required 'Git' git
check_required 'JSON processor' jq
check_required 'Neovim' nvim
check_required 'Starship' starship
check_required 'Python runtime' uv
check_required 'JavaScript runtime' bun
check_required 'GitHub CLI' gh
check_required 'ripgrep' rg
check_required 'fuzzy finder' fzf
check_optional 'mise runtime manager' mise
check_optional 'Herdr multiplexer' herdr
check_optional 'Pi agent' pi
check_optional 'Treehouse isolation' treehouse
check_optional 'Agy CLI' agy
check_optional 'Copilot CLI' copilot
check_optional 'Codex CLI' codex
check_optional 'Claude CLI' claude

printf '\nAXI and automation companions\n'
printf '%s\n' '-----------------------------'
check_optional 'gh-axi' gh-axi
check_optional 'chrome-devtools-axi' chrome-devtools-axi
check_optional 'lavish-axi' lavish-axi
check_optional 'quota-axi' quota-axi
check_optional 'tasks-axi' tasks-axi
check_optional 'no-mistakes' no-mistakes

printf '\nRequired checks passed: %d\nWarnings: %d\n' "$pass" "$warn"
if (( warn > 0 )); then
  exit 1
fi
