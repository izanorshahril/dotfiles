# Windows Terminal Configuration Injector & Updater
# Safely updates Windows Terminal settings.json without clobbering existing profiles

param(
    [switch]$DryRun
)

$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-not (Test-Path $settingsPath)) {
    $settingsPath = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
}

if (-not (Test-Path $settingsPath)) {
    Write-Error "Windows Terminal settings.json not found at $settingsPath."
    exit 1
}

Write-Host "⚙️ Updating Windows Terminal settings at: $settingsPath" -ForegroundColor Cyan

# Backup existing settings
$backupPath = "$settingsPath.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
Copy-Item $settingsPath $backupPath
Write-Host "📦 Backup created at: $backupPath" -ForegroundColor DarkGray

$json = Get-Content $settingsPath -Raw | ConvertFrom-Json

# 1. Ensure Rosé Pine Moon Scheme exists
$schemePath = Join-Path $PSScriptRoot "..\windows-terminal\schemes\rose-pine-moon.json"
if (Test-Path $schemePath) {
    $rosePineScheme = Get-Content $schemePath -Raw | ConvertFrom-Json
    $existingSchemes = @($json.schemes)
    $foundSchemeIndex = -1
    for ($i = 0; $i -lt $existingSchemes.Count; $i++) {
        if ($existingSchemes[$i].name -eq "Rosé Pine Moon") {
            $foundSchemeIndex = $i
            break
        }
    }

    if ($foundSchemeIndex -ge 0) {
        $existingSchemes[$foundSchemeIndex] = $rosePineScheme
    } else {
        $existingSchemes += $rosePineScheme
    }
    $json.schemes = $existingSchemes
    Write-Host "✅ Injected/Updated 'Rosé Pine Moon' color scheme." -ForegroundColor Green
}

# 2. Ensure Herdr Profile exists in profiles.list
$herdrGuid = "{e8b4e7c3-7b3f-4e6a-8b1a-5c2d9e1f0a1b}"
$profilesList = @($json.profiles.list)
$herdrProfile = $profilesList | Where-Object { $_.guid -eq $herdrGuid -or $_.name -eq "Herdr (Agent Multiplexer)" }

if (-not $herdrProfile) {
    $newHerdr = [PSCustomObject]@{
        guid = $herdrGuid
        name = "Herdr (Agent Multiplexer)"
        commandline = "herdr.exe"
        startingDirectory = "D:\dev"
        colorScheme = "Rosé Pine Moon"
        hidden = $false
        font = [PSCustomObject]@{
            face = "Cascadia Code"
            size = 11.0
        }
    }
    $json.profiles.list = $profilesList + $newHerdr
    Write-Host "✅ Added 'Herdr (Agent Multiplexer)' profile to Windows Terminal." -ForegroundColor Green
} else {
    Write-Host "ℹ️ 'Herdr (Agent Multiplexer)' profile already present." -ForegroundColor DarkCyan
}

# 3. Update defaults aesthetic
if ($json.profiles.defaults) {
    $json.profiles.defaults.colorScheme = "Rosé Pine Moon"
}

if (-not $DryRun) {
    $json | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding UTF8
    Write-Host "🎉 Windows Terminal configuration successfully updated!`n" -ForegroundColor Green
} else {
    Write-Host "ℹ️ Dry-run mode: no changes written to disk." -ForegroundColor Yellow
}
