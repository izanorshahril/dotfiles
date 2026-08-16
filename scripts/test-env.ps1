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
Test-Component "Starship Prompt" { (Get-Command starship -ErrorAction SilentlyContinue) -ne $null } "Optional: winget install Starship.Starship"
Test-Component "Fast Directory Jump (zoxide)" { (Get-Command zoxide -ErrorAction SilentlyContinue) -ne $null } "Optional: winget install ajeetdsouza.zoxide"

# Config checks
Write-Host "`n📁 CHECKING ACTIVE CONFIGURATION FILES:" -ForegroundColor Cyan
Test-Component "Herdr Config Deployed" { Test-Path "$env:APPDATA\herdr\config.toml" } "Run .\scripts\setup-herdr.ps1"
Test-Component "PowerShell Profile Active" { Test-Path $PROFILE } "Run .\scripts\setup-profile.ps1"
Test-Component "Global Git Ignore Configured" { (git config --global core.excludesfile) -ne $null } "Run .\scripts\setup-git.ps1"

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host "Diagnostic completed. Total checks: $($results.Count)" -ForegroundColor DarkGray
