# Master Idempotent Installer for Windows Agentic Dev Dotfiles
# Usage: pwsh .\scripts\install.ps1

Write-Host "`n🚀 DEPLOYING AGENTIC DEV ENVIRONMENT (WINDOWS 11)..." -ForegroundColor Cyan
Write-Host "──────────────────────────────────────────────────────" -ForegroundColor DarkCyan

$scriptDir = $PSScriptRoot

# 1. Herdr Configuration
Write-Host "`n[1/5] Configuring Herdr Multiplexer..." -ForegroundColor Yellow
& "$scriptDir\setup-herdr.ps1"

# 2. Windows Terminal Configuration
Write-Host "`n[2/5] Configuring Windows Terminal..." -ForegroundColor Yellow
& "$scriptDir\setup-terminal.ps1"

# 3. PowerShell Profile & Modules
Write-Host "`n[3/5] Configuring PowerShell 7 Environment..." -ForegroundColor Yellow
& "$scriptDir\setup-profile.ps1"

# 4. Git Settings & Worktrees
Write-Host "`n[4/5] Configuring Git & Worktree Defaults..." -ForegroundColor Yellow
& "$scriptDir\setup-git.ps1"

# 5. Starship Prompt Config
Write-Host "`n[5/5] Deploying Starship Prompt..." -ForegroundColor Yellow
& "$scriptDir\setup-starship.ps1"

Write-Host "`n══════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "🎉 ENVIRONMENT SETUP COMPLETE!" -ForegroundColor Green
Write-Host "   - Open Windows Terminal and select 'Herdr (Agent Multiplexer)' or run 'h'" -ForegroundColor White
Write-Host "   - Run 'test-env.ps1' to verify tool dependencies." -ForegroundColor DarkGray
Write-Host "══════════════════════════════════════════════════════`n" -ForegroundColor Green
