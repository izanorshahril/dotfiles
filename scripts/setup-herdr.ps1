# Herdr Configuration Installer & Reloader for Windows
param(
    [switch]$Force
)

$sourceConfig = Join-Path $PSScriptRoot "..\.config\herdr\config.toml"
$targetDir = "$env:APPDATA\herdr"
$targetConfig = Join-Path $targetDir "config.toml"

if (-not (Test-Path $sourceConfig)) {
    Write-Error "Source configuration file not found at $sourceConfig."
    exit 1
}

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

if ((Test-Path $targetConfig) -and (-not $Force)) {
    $backupPath = "$targetConfig.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item $targetConfig $backupPath
    Write-Host "📦 Existing Herdr config backed up to: $backupPath" -ForegroundColor DarkGray
}

Copy-Item $sourceConfig $targetConfig -Force
Write-Host "✅ Herdr config deployed to: $targetConfig" -ForegroundColor Green

# Test if server is running, then reload
try {
    $null = herdr server reload-config 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🔄 Active Herdr server configuration reloaded!" -ForegroundColor Cyan
    }
} catch {
    # Server not active, config will load on next launch
}
