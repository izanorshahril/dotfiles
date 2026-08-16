# Starship Config Deployer
param(
    [switch]$Force
)

$sourceStarship = Join-Path $PSScriptRoot "..\.config\starship\starship.toml"
$targetDir = "$env:USERPROFILE\.config"
$targetFile = Join-Path $targetDir "starship.toml"

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Copy-Item $sourceStarship $targetFile -Force
Write-Host "✅ Starship config deployed to: $targetFile" -ForegroundColor Green

if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    Write-Host "ℹ️ Starship is not currently in PATH. You can install it anytime via winget: 'winget install Starship.Starship'" -ForegroundColor DarkCyan
}
