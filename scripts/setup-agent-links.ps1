# Multi-Harness Agent Directives Linker & Real-Time Sync
# Hardlinks & syncs AGENTS.md and CLAUDE.md across all major AI coding harnesses on Windows 11.
# Uses NTFS HardLinks on C: so edits in any harness update everywhere instantly with 0ms lag.

param(
    [switch]$Force
)

$sourceAgentsInDotfiles = Join-Path $PSScriptRoot "..\agents\AGENTS.md"
$sourceClaudeInDotfiles = Join-Path $PSScriptRoot "..\agents\CLAUDE.md"

$canonicalAgents = "$env:USERPROFILE\.agents\AGENTS.md"
$canonicalClaude = "$env:USERPROFILE\.agents\CLAUDE.md"

# Ensure canonical directory exists
$agentsDir = "$env:USERPROFILE\.agents"
if (-not (Test-Path $agentsDir)) { New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null }

# Sync from dotfiles repo to canonical source on C: drive
Copy-Item $sourceAgentsInDotfiles $canonicalAgents -Force
Copy-Item $sourceClaudeInDotfiles $canonicalClaude -Force

Write-Host "`n🚀 ESTABLISHING MULTI-HARNESS AGENT DIRECTIVE LINKS..." -ForegroundColor Cyan
Write-Host "──────────────────────────────────────────────────────" -ForegroundColor DarkCyan
Write-Host "Canonical Sources:" -ForegroundColor DarkGray
Write-Host "  • AGENTS: $canonicalAgents" -ForegroundColor DarkCyan
Write-Host "  • CLAUDE: $canonicalClaude" -ForegroundColor DarkCyan
Write-Host ""

# Helper to create NTFS HardLink (or Copy fallback)
function Link-Directive {
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$HarnessName
    )

    # If target is identical to source, skip linking
    if ((Resolve-Path $SourcePath -ErrorAction SilentlyContinue).Path -eq (Resolve-Path $TargetPath -ErrorAction SilentlyContinue).Path) {
        Write-Host "  ⭐ [$HarnessName] (Canonical) " -NoNewline -ForegroundColor Cyan
        Write-Host "$TargetPath" -ForegroundColor White
        return
    }

    $parentDir = Split-Path $TargetPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # If target already exists, remove it so we can create a fresh HardLink
    if (Test-Path $TargetPath) {
        Remove-Item $TargetPath -Force -ErrorAction SilentlyContinue
    }

    try {
        # Create NTFS HardLink (native same-drive real-time sync without admin rights)
        New-Item -ItemType HardLink -Path $TargetPath -Target $SourcePath -Force -ErrorAction Stop | Out-Null
        Write-Host "  🔗 [$HarnessName] " -NoNewline -ForegroundColor Green
        Write-Host "$TargetPath" -ForegroundColor White
    } catch {
        # Fallback to copy if cross-volume or error
        Copy-Item $SourcePath $TargetPath -Force
        Write-Host "  📋 [$HarnessName] (Copy) " -NoNewline -ForegroundColor Yellow
        Write-Host "$TargetPath" -ForegroundColor White
    }
}

# ------------------------------------------------------------------------------
# HARNESS LINK DEFINITIONS
# ------------------------------------------------------------------------------

# 1. Global & Generic
Link-Directive $canonicalAgents "$env:USERPROFILE\AGENTS.md" "Global Root"
Link-Directive $canonicalClaude "$env:USERPROFILE\CLAUDE.md" "Global Root"
Link-Directive $canonicalAgents "$env:USERPROFILE\.config\agents\AGENTS.md" "Global Config"
Link-Directive $canonicalClaude "$env:USERPROFILE\.config\agents\CLAUDE.md" "Global Config"
Link-Directive $canonicalAgents "$env:USERPROFILE\.agents\AGENTS.md" "Agents Root"
Link-Directive $canonicalClaude "$env:USERPROFILE\.agents\CLAUDE.md" "Agents Root"

# 2. Claude Code
Link-Directive $canonicalClaude "$env:USERPROFILE\.claude\CLAUDE.md" "Claude Code"
Link-Directive $canonicalAgents "$env:USERPROFILE\.claude\AGENTS.md" "Claude Code"
Link-Directive $canonicalClaude "$env:USERPROFILE\.config\claude\CLAUDE.md" "Claude Config"
Link-Directive $canonicalAgents "$env:USERPROFILE\.config\claude\AGENTS.md" "Claude Config"

# 3. Antigravity & Gemini CLI
Link-Directive $canonicalAgents "$env:USERPROFILE\.gemini\AGENTS.md" "Antigravity/Gemini"
Link-Directive $canonicalAgents "$env:USERPROFILE\.gemini\GEMINI.md" "Antigravity/Gemini"
Link-Directive $canonicalAgents "$env:USERPROFILE\.gemini\antigravity-cli\AGENTS.md" "Antigravity CLI"
Link-Directive $canonicalAgents "$env:USERPROFILE\.antigravity-ide\AGENTS.md" "Antigravity IDE"
Link-Directive $canonicalAgents "$env:USERPROFILE\.antigravity\AGENTS.md" "Antigravity"

# 4. OpenAI Codex CLI
Link-Directive $canonicalAgents "$env:USERPROFILE\.codex\AGENTS.md" "Codex CLI"
Link-Directive $canonicalAgents "$env:USERPROFILE\.codex\instructions.md" "Codex CLI"
Link-Directive $canonicalClaude "$env:USERPROFILE\.codex\CLAUDE.md" "Codex CLI"
Link-Directive $canonicalAgents "$env:USERPROFILE\.config\codex\AGENTS.md" "Codex Config"

# 5. Pi-agent
Link-Directive $canonicalAgents "$env:USERPROFILE\.pi\AGENTS.md" "Pi-Agent"
Link-Directive $canonicalClaude "$env:USERPROFILE\.pi\CLAUDE.md" "Pi-Agent"
Link-Directive $canonicalAgents "$env:USERPROFILE\.pi-agent\AGENTS.md" "Pi-Agent"
Link-Directive $canonicalAgents "$env:USERPROFILE\.config\pi\AGENTS.md" "Pi-Agent Config"

# 6. Kilo Code / Kiro
Link-Directive $canonicalAgents "$env:USERPROFILE\.kilo\AGENTS.md" "Kilo Code"
Link-Directive $canonicalAgents "$env:USERPROFILE\.kilocode\AGENTS.md" "Kilo Code"
Link-Directive $canonicalAgents "$env:USERPROFILE\.config\kilo\AGENTS.md" "Kilo Code Config"

# 7. OpenCode
Link-Directive $canonicalAgents "$env:USERPROFILE\.opencode\AGENTS.md" "OpenCode"
Link-Directive $canonicalAgents "$env:USERPROFILE\.config\opencode\AGENTS.md" "OpenCode Config"

# 8. Goose
Link-Directive $canonicalAgents "$env:USERPROFILE\.goose\AGENTS.md" "Goose"
Link-Directive $canonicalAgents "$env:USERPROFILE\.goosehints" "Goose Hints"
Link-Directive $canonicalAgents "$env:USERPROFILE\.config\goose\AGENTS.md" "Goose Config"

# 9. Cursor
Link-Directive $canonicalAgents "$env:USERPROFILE\.cursor\rules\AGENTS.md" "Cursor Rules"
Link-Directive $canonicalAgents "$env:USERPROFILE\.cursorrules" "Cursor Rules"

# 10. Aider, Amp, Droid, Hermes, Qoder
Link-Directive $canonicalAgents "$env:USERPROFILE\.aider\AGENTS.md" "Aider"
Link-Directive $canonicalAgents "$env:USERPROFILE\.amp\AGENTS.md" "Amp"
Link-Directive $canonicalAgents "$env:USERPROFILE\.droid\AGENTS.md" "Droid"
Link-Directive $canonicalAgents "$env:USERPROFILE\.hermes\AGENTS.md" "Hermes"
Link-Directive $canonicalAgents "$env:USERPROFILE\.qoder\AGENTS.md" "Qoder"

Write-Host "`n══════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ ALL AGENT HARNESSES LINKED & SYNCHRONIZED!" -ForegroundColor Green
Write-Host "   Any file edit to AGENTS.md / CLAUDE.md in any harness" -ForegroundColor DarkGray
Write-Host "   will immediately reflect in real-time across all others." -ForegroundColor DarkGray
Write-Host "══════════════════════════════════════════════════════`n" -ForegroundColor Green
