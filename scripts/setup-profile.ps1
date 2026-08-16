# PowerShell Profile & Module Installer
param(
    [switch]$Force
)

$sourceProfile = Join-Path $PSScriptRoot "..\powershell\Microsoft.PowerShell_profile.ps1"
$sourceModules = Join-Path $PSScriptRoot "..\powershell\modules"

$profileTarget = $PROFILE
$profileDir = Split-Path $profileTarget -Parent

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Deploy modules to user's config directory as well
$userConfigModules = "$env:USERPROFILE\.config\powershell\modules"
if (-not (Test-Path $userConfigModules)) {
    New-Item -ItemType Directory -Path $userConfigModules -Force | Out-Null
}
Copy-Item "$sourceModules\*" $userConfigModules -Recurse -Force
Write-Host "✅ PowerShell modules copied to: $userConfigModules" -ForegroundColor Green

# Backup existing profile if present
if ((Test-Path $profileTarget) -and (-not $Force)) {
    $backupProfile = "$profileTarget.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item $profileTarget $backupProfile
    Write-Host "📦 Existing profile backed up to: $backupProfile" -ForegroundColor DarkGray
}

Copy-Item $sourceProfile $profileTarget -Force
Write-Host "✅ PowerShell profile deployed to: $profileTarget" -ForegroundColor Green
