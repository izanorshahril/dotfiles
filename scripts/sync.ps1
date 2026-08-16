# Bi-directional Sync Helper: Captures live configs back into dotfiles repository
param(
    [ValidateSet('pull-to-repo', 'push-to-system')]
    [string]$Direction = 'pull-to-repo'
)

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

if ($Direction -eq 'push-to-system') {
    & "$PSScriptRoot\install.ps1"
    return
}

Write-Host "🔄 Syncing live system configurations into Dotfiles repository ($repoRoot)..." -ForegroundColor Cyan

# 1. Herdr Config
$herdrLive = "$env:APPDATA\herdr\config.toml"
if (Test-Path $herdrLive) {
    Copy-Item $herdrLive "$repoRoot\.config\herdr\config.toml" -Force
    Write-Host "  ✅ Synced Herdr config" -ForegroundColor Green
}

# 2. PowerShell Profile
if (Test-Path $PROFILE) {
    Copy-Item $PROFILE "$repoRoot\powershell\Microsoft.PowerShell_profile.ps1" -Force
    Write-Host "  ✅ Synced PowerShell profile" -ForegroundColor Green
}

# 3. Starship Config
$starshipLive = "$env:USERPROFILE\.config\starship.toml"
if (Test-Path $starshipLive) {
    Copy-Item $starshipLive "$repoRoot\.config\starship\starship.toml" -Force
    Write-Host "  ✅ Synced Starship config" -ForegroundColor Green
}

Write-Host "`n✨ Dotfiles repo is up to date with live system configs!" -ForegroundColor Green
