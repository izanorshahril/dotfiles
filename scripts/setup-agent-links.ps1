# Minimalist Global Agent Directives Setup
# Based on the official Agentic AI Foundation (AAIF) specification:
# - All modern harnesses (OpenCode, Pi-Agent, Codex, Kilo, Antigravity, Cursor, Goose, Aider, etc.)
#   natively read the standard global ~/.agents/AGENTS.md and ~/AGENTS.md.
# - CLAUDE.md is strictly isolated to ~/.claude/CLAUDE.md (where Claude Code uniquely looks).
# - Zero redundant per-harness dot-folder copies required.

param(
    [switch]$Force
)

$sourceAgentsInDotfiles = Join-Path $PSScriptRoot "..\agents\AGENTS.md"
$sourceClaudeInDotfiles = Join-Path $PSScriptRoot "..\agents\CLAUDE.md"

$canonicalAgents = "$env:USERPROFILE\.agents\AGENTS.md"
$homeAgents = "$env:USERPROFILE\AGENTS.md"
$canonicalClaude = "$env:USERPROFILE\.claude\CLAUDE.md"

# Ensure base directories exist
if (-not (Test-Path "$env:USERPROFILE\.agents")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.agents" -Force | Out-Null }
if (-not (Test-Path "$env:USERPROFILE\.claude")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force | Out-Null }

# Sync canonical sources from dotfiles repository
Copy-Item $sourceAgentsInDotfiles $canonicalAgents -Force
Copy-Item $sourceClaudeInDotfiles $canonicalClaude -Force

Write-Host "`n🚀 DEPLOYING MINIMALIST GLOBAL AGENT DIRECTIVES..." -ForegroundColor Cyan
Write-Host "──────────────────────────────────────────────────────" -ForegroundColor DarkCyan

# 1. Clean up redundant per-harness copies
$redundantPaths = @(
    "$env:USERPROFILE\CLAUDE.md",
    "$env:USERPROFILE\.agents\CLAUDE.md",
    "$env:USERPROFILE\.aider\AGENTS.md",
    "$env:USERPROFILE\.amp\AGENTS.md",
    "$env:USERPROFILE\.antigravity\AGENTS.md",
    "$env:USERPROFILE\.antigravity-ide\AGENTS.md",
    "$env:USERPROFILE\.claude\AGENTS.md",
    "$env:USERPROFILE\.codex\AGENTS.md",
    "$env:USERPROFILE\.codex\instructions.md",
    "$env:USERPROFILE\.codex\CLAUDE.md",
    "$env:USERPROFILE\.config\agents",
    "$env:USERPROFILE\.config\claude",
    "$env:USERPROFILE\.config\codex",
    "$env:USERPROFILE\.config\kilo",
    "$env:USERPROFILE\.config\opencode",
    "$env:USERPROFILE\.config\pi",
    "$env:USERPROFILE\.config\goose",
    "$env:USERPROFILE\.cursor\rules\AGENTS.md",
    "$env:USERPROFILE\.cursorrules",
    "$env:USERPROFILE\.droid\AGENTS.md",
    "$env:USERPROFILE\.gemini\AGENTS.md",
    "$env:USERPROFILE\.gemini\GEMINI.md",
    "$env:USERPROFILE\.gemini\antigravity-cli\AGENTS.md",
    "$env:USERPROFILE\.goose",
    "$env:USERPROFILE\.goosehints",
    "$env:USERPROFILE\.hermes\AGENTS.md",
    "$env:USERPROFILE\.kilo\AGENTS.md",
    "$env:USERPROFILE\.kilocode\AGENTS.md",
    "$env:USERPROFILE\.opencode\AGENTS.md",
    "$env:USERPROFILE\.pi\AGENTS.md",
    "$env:USERPROFILE\.pi\CLAUDE.md",
    "$env:USERPROFILE\.pi-agent\AGENTS.md",
    "$env:USERPROFILE\.qoder\AGENTS.md"
)

Write-Host "🧹 Purging redundant dot-folder copies..." -ForegroundColor DarkGray
foreach ($path in $redundantPaths) {
    if (Test-Path $path) {
        Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# 2. Hardlink home root AGENTS.md to canonical ~/.agents/AGENTS.md
if (Test-Path $homeAgents) {
    Remove-Item $homeAgents -Force -ErrorAction SilentlyContinue
}
try {
    New-Item -ItemType HardLink -Path $homeAgents -Target $canonicalAgents -Force -ErrorAction Stop | Out-Null
    Write-Host "  🔗 [Home Root] $homeAgents -> $canonicalAgents" -ForegroundColor Green
} catch {
    Copy-Item $canonicalAgents $homeAgents -Force
    Write-Host "  📋 [Home Root] (Copy) $homeAgents" -ForegroundColor Yellow
}

Write-Host "`n══════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ ULTRA-CLEAN TOPOLOGY ACTIVE:" -ForegroundColor Green
Write-Host "   1. ~/.agents/AGENTS.md   (Canonical global AAIF standard)" -ForegroundColor White
Write-Host "   2. ~/AGENTS.md           (Direct root hardlink)" -ForegroundColor White
Write-Host "   3. ~/.claude/CLAUDE.md   (Claude Code exclusive)" -ForegroundColor White
Write-Host "   4. ./AGENTS.md           (Project-level repo root)" -ForegroundColor White
Write-Host "══════════════════════════════════════════════════════`n" -ForegroundColor Green
