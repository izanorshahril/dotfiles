# Environment Diagnostics & Verification Script
# Usage: pwsh .\scripts\test-env.ps1

Write-Host "`n🔍 RUNNING AGENTIC DEV ENVIRONMENT DIAGNOSTICS..." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor DarkCyan

$results = [System.Collections.Generic.List[PSCustomObject]]::new()

function Test-Component {
    param([string]$Name, [scriptblock]$TestBlock, [string]$Recommendation)
    try {
        $passed = & $TestBlock
        if ($passed) {
            Write-Host "  ✅ $Name" -ForegroundColor Green
            $results.Add([PSCustomObject]@{ Component = $Name; Status = "OK"; Note = "" })
        } else {
            Write-Host "  ⚠️ $Name (Not found / Inactive)" -ForegroundColor Yellow
            $results.Add([PSCustomObject]@{ Component = $Name; Status = "WARN"; Note = $Recommendation })
        }
    } catch {
        Write-Host "  ❌ $Name (Error: $_)" -ForegroundColor Red
        $results.Add([PSCustomObject]@{ Component = $Name; Status = "FAIL"; Note = "$_" })
    }
}

Test-Component "PowerShell 7 (pwsh)" { $PSVersionTable.PSVersion.Major -ge 7 } "Install PowerShell 7 via winget: winget install Microsoft.PowerShell"
Test-Component "Herdr CLI (herdr.exe)" { (Get-Command herdr -ErrorAction SilentlyContinue) -ne $null } "Download Herdr from https://herdr.dev"
Test-Component "Windows Terminal (wt.exe)" { (Get-Command wt -ErrorAction SilentlyContinue) -ne $null } "Install Windows Terminal from Microsoft Store or winget"
Test-Component "Git & Worktree Support" { (Get-Command git -ErrorAction SilentlyContinue) -ne $null } "Install Git: winget install Git.Git"
Test-Component "Python Fast Tooling (uv)" { (Get-Command uv -ErrorAction SilentlyContinue) -ne $null } "Install uv: winget install astral-sh.uv"
Test-Component "JavaScript Runtime (bun)" { (Get-Command bun -ErrorAction SilentlyContinue) -ne $null } "Install bun: powershell -c 'irm bun.sh/install.ps1 | iex'"

# Kun Chen AXI & Worktree Ecosystem
Write-Host "`n🛠️ CHECKING AXI & ORCHESTRATION COMPANIONS:" -ForegroundColor Cyan
Test-Component "Treehouse Worktree Pool (treehouse.exe)" { (Get-Command treehouse -ErrorAction SilentlyContinue) -ne $null } "Install Treehouse from https://github.com/kunchenguid/treehouse"
Test-Component "No-Mistakes Pre-Push Gate (no-mistakes.exe)" { (Get-Command no-mistakes -ErrorAction SilentlyContinue) -ne $null } "Install No-Mistakes from https://github.com/kunchenguid/no-mistakes"
Test-Component "Tasks-AXI Queue CLI (tasks-axi)" { (Get-Command tasks-axi -ErrorAction SilentlyContinue) -ne $null } "Install tasks-axi: bun add -g tasks-axi"
Test-Component "Quota-AXI Token Tracker (quota-axi)" { (Get-Command quota-axi -ErrorAction SilentlyContinue) -ne $null } "Install quota-axi: bun add -g quota-axi"
Test-Component "Lavish-AXI Visualizer (lavish-axi)" { (Get-Command lavish-axi -ErrorAction SilentlyContinue) -ne $null } "Install lavish-axi: bun add -g lavish-axi"

# Config checks
Write-Host "`n📁 CHECKING ACTIVE CONFIGURATION FILES:" -ForegroundColor Cyan
Test-Component "Herdr Config Deployed" { Test-Path "$env:APPDATA\herdr\config.toml" } "Run .\scripts\setup-herdr.ps1"
Test-Component "PowerShell Profile Active" { Test-Path $PROFILE } "Run .\scripts\setup-profile.ps1"
Test-Component "Global Git Ignore Configured" { (git config --global core.excludesfile) -ne $null } "Run .\scripts\setup-git.ps1"
Test-Component "Canonical AGENTS.md Directives" { Test-Path "$env:USERPROFILE\.agents\AGENTS.md" } "Run .\scripts\setup-agent-links.ps1"

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host "Diagnostic completed. Total checks: $($results.Count)" -ForegroundColor DarkGray
