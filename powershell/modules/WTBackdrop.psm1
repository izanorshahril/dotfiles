<#
.SYNOPSIS
    Dynamic Backdrop & Transparency Toggler for Windows Terminal.
#>

function Set-WTBackdrop {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [ValidateSet('acrylic', 'mica', 'none', 'solid', 'toggle', '')]
        [string]$Mode = 'toggle',

        [Parameter(Position=1)]
        [int]$Opacity = 0
    )

    $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (-not (Test-Path $settingsPath)) {
        $settingsPath = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
    }
    if (-not (Test-Path $settingsPath)) {
        Write-Warning "Windows Terminal settings.json not found."
        return
    }

    try {
        $json = Get-Content $settingsPath -Raw | ConvertFrom-Json
    } catch {
        Write-Error "Failed to read Windows Terminal settings.json: $_"
        return
    }

    $currentAcrylic = $json.profiles.defaults.useAcrylic
    $currentMica = ($json.theme -eq 'Rosé Pine Moon Mica')

    $targetMode = $Mode.ToLower()
    if ($targetMode -in @('toggle', '')) {
        if ($currentAcrylic) {
            $targetMode = 'mica'
        } elseif ($currentMica) {
            $targetMode = 'none'
        } else {
            $targetMode = 'acrylic'
        }
    }

    $micaTheme = @{
        name = "Rosé Pine Moon Mica"
        window = @{
            applicationTheme = "dark"
            useMica = $true
        }
        tabRow = @{
            background = "#00000000"
            unfocusedBackground = "#00000000"
        }
        tab = @{
            background = "#2a283e80"
            unfocusedBackground = "#00000000"
        }
    }

    switch ($targetMode) {
        'acrylic' {
            $json.theme = "dark"
            $json.useAcrylicInTabRow = $true
            $json.profiles.defaults.useAcrylic = $true
            if ($Opacity -gt 0) {
                $json.profiles.defaults.opacity = $Opacity
            } elseif ($json.profiles.defaults.opacity -eq 100) {
                $json.profiles.defaults.opacity = 85
            }
            $json.themes = @()
            $json | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
            Write-Host "`n✨ [Windows Terminal] Backdrop: " -NoNewline -ForegroundColor Cyan
            Write-Host "ACRYLIC (Frosted Glass)" -ForegroundColor Green
            Write-Host "   Opacity: $($json.profiles.defaults.opacity)%`n" -ForegroundColor DarkGray
        }
        'mica' {
            $json.theme = "Rosé Pine Moon Mica"
            $json.useAcrylicInTabRow = $false
            $json.profiles.defaults.useAcrylic = $false
            if ($Opacity -gt 0) {
                $json.profiles.defaults.opacity = $Opacity
            } elseif ($json.profiles.defaults.opacity -eq 100) {
                $json.profiles.defaults.opacity = 85
            }
            $json.themes = @($micaTheme)
            $json | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
            Write-Host "`n✨ [Windows Terminal] Backdrop: " -NoNewline -ForegroundColor Cyan
            Write-Host "MICA (Windows 11 Tint)" -ForegroundColor Magenta
            Write-Host "   Opacity: $($json.profiles.defaults.opacity)%" -ForegroundColor DarkGray
            Write-Host "   ℹ️ Note: If the top titlebar doesn't update immediately, restart Windows Terminal.`n" -ForegroundColor Yellow
        }
        { $_ -in @('none', 'solid') } {
            $json.theme = "dark"
            $json.useAcrylicInTabRow = $false
            $json.profiles.defaults.useAcrylic = $false
            $json.profiles.defaults.opacity = 100
            $json.themes = @()
            $json | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
            Write-Host "`n✨ [Windows Terminal] Backdrop: " -NoNewline -ForegroundColor Cyan
            Write-Host "NONE / SOLID (Opaque 100%)" -ForegroundColor White
            Write-Host "   Opacity: 100% (No GPU blur overhead)`n" -ForegroundColor DarkGray
        }
    }
}

Set-Alias -Name backdrop -Value Set-WTBackdrop -ErrorAction SilentlyContinue
Set-Alias -Name tb -Value Set-WTBackdrop -ErrorAction SilentlyContinue

Export-ModuleMember -Function Set-WTBackdrop -Alias backdrop, tb
