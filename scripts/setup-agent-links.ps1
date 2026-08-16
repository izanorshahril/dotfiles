# Minimal Multi-Harness Agent Directives Linker
# Streamlined setup:
# - CLAUDE.md is strictly restricted to ~/.claude/CLAUDE.md (where Claude Code expects it).
# - AGENTS.md is the universal standard originating from ~/.agents/AGENTS.md.
# - Codex CLI and Goose natively load standard AGENTS.md (legacy instructions.md and .goosehints removed).

param(
    [switch]$Force
)

$sourceAgentsInDotfiles = Join-Path $PSScriptRoot "..\agents\AGENTS.md"
$sourceClaudeInDotfiles = Join-Path $PSScriptRoot "..\agents\CLAUDE.md"

$canonicalAgents = "$env:USERPROFILE\.agents\AGENTS.md"
$canonicalClaude = "$env:USERPROFILE\.claude\CLAUDE.md"

# Ensure base directories exist
if (-not (Test-Path "$env:USERPROFILE\.agents")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.agents" -Force | Out-Null }
if (-not (Test-Path "$env:USERPROFILE\.claude")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force | Out-Null }

# Sync from dotfiles repo
Copy-Item $sourceAgentsInDotfiles $canonicalAgents -Force
Copy-Item $sourceClaudeInDotfiles $canonicalClaude -Force

Write-Host "`n🚀 DEPLOYING STREAMLINED AGENT DIRECTIVES..." -ForegroundColor Cyan
Write-Host "──────────────────────────────────────────────────────" -ForegroundColor DarkCyan
Write-Host "Canonical Sources:" -ForegroundColor DarkGray
Write-Host "  • AGENTS: $canonicalAgents (Universal Standard)" -ForegroundColor DarkCyan
Write-Host "  • CLAUDE: $canonicalClaude (Claude Code only)" -ForegroundColor DarkCyan
Write-Host ""

# Clean up redundant legacy files (instructions.md, .goosehints, .goose, and old CLAUDE copies)
$legacyFilesToRemove = @(
    "$env:USERPROFILE\CLAUDE.md",
    "$env:USERPROFILE\.agents\CLAUDE.md",
    "$env:USERPROFILE\.config\agents\CLAUDE.md",
    "$env:USERPROFILE\.codex\CLAUDE.md",
    "$env:USERPROFILE\.codex\instructions.md",
    "$env:USERPROFILE\.pi\CLAUDE.md",
    "$env:USERPROFILE\.config\claude\CLAUDE.md",
    "$env:USERPROFILE\.goosehints",
    "$env:USERPROFILE\.goose\AGENTS.md",
    "$env:USERPROFILE\.config\goose\AGENTS.md"
)
foreach ($file in $legacyFilesToRemove) {
    if (Test-Path $file) {
        Remove-Item $file -Force -ErrorAction SilentlyContinue
    }
}
if (Test-Path "$env:USERPROFILE\.goose") {
    # Remove directory if empty
    if ((Get-ChildItem "$env:USERPROFILE\.goose" -ErrorAction SilentlyContinue).Count -eq 0) {
        Remove-Item "$env:USERPROFILE\.goose" -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# Helper to create NTFS HardLink (or Copy fallback)
function Link-Directive {
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$HarnessName
    )

    if ((Resolve-Path $SourcePath -ErrorAction SilentlyContinue).Path -eq (Resolve-Path $TargetPath -ErrorAction SilentlyContinue).Path) {
        Write-Host "  ⭐ [$HarnessName] (Canonical) " -NoNewline -ForegroundColor Cyan
        Write-Host "$TargetPath" -ForegroundColor White
        return
    }

    $parentDir = Split-Path $TargetPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    if (Test-Path $TargetPath) {
        Remove-Item $TargetPath -Force -ErrorAction SilentlyContinue
    }

    try {
        New-Item -ItemType HardLink -Path $TargetPath -Target $SourcePath -Force -ErrorAction Stop | Out-Null
        Write-Host "  🔗 [$HarnessName] " -NoNewline -ForegroundColor Green
        Write-Host "$TargetPath" -ForegroundColor White
    } catch {
        Copy-Item $SourcePath $TargetPath -Force
        Write-Host "  📋 [$HarnessName] (Copy) " -NoNewline -ForegroundColor Yellow
        Write-Host "$TargetPath" -ForegroundColor White
    }
}

# ------------------------------------------------------------------------------
# ESSENTIAL HARNESS DIRECTIVE LINKS
# ------------------------------------------------------------------------------

# 1. Global User Root (Generic fallback for any tool scanning ~)
Link-Directive $canonicalAgents "$env:USERPROFILE\AGENTS.md" "User Root"

# 2. Claude Code (Strictly isolated ~/.claude)
Link-Directive $canonicalAgents "$env:USERPROFILE\.claude\AGENTS.md" "Claude Code"

# 3. OpenAI Codex CLI (Standard ~/.codex/AGENTS.md)
Link-Directive $canonicalAgents "$env:USERPROFILE\.codex\AGENTS.md" "Codex CLI"

# 4. Antigravity & Gemini CLI
Link-Directive $canonicalAgents "$env:USERPROFILE\.gemini\AGENTS.md" "Antigravity/Gemini"
Link-Directive $canonicalAgents "$env:USERPROFILE\.antigravity\AGENTS.md" "Antigravity"

# 5. Pi-agent
Link-Directive $canonicalAgents "$env:USERPROFILE\.pi\AGENTS.md" "Pi-Agent"

# 6. Kilo Code
Link-Directive $canonicalAgents "$env:USERPROFILE\.kilo\AGENTS.md" "Kilo Code"

# 7. OpenCode
Link-Directive $canonicalAgents "$env:USERPROFILE\.opencode\AGENTS.md" "OpenCode"

# 8. Cursor Rules
Link-Directive $canonicalAgents "$env:USERPROFILE\.cursor\rules\AGENTS.md" "Cursor Rules"

Write-Host "`n══════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ STREAMLINED HARNESS DIRECTIVES LINKED!" -ForegroundColor Green
Write-Host "   CLAUDE.md is isolated exclusively to ~/.claude/CLAUDE.md" -ForegroundColor DarkGray
Write-Host "   AGENTS.md is synced in real-time across active harnesses" -ForegroundColor DarkGray
Write-Host "══════════════════════════════════════════════════════`n" -ForegroundColor Green
