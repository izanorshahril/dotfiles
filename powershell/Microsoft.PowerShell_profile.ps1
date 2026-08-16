# ==============================================================================
# PowerShell 7 Profile - Windows Agentic Engineering Environment
# Ported from Kun Chen's L8 Principal Dev Setup for Windows 11
# ==============================================================================

# Ensure UTF-8 output encoding for proper Nerd Font and Unicode rendering
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# ------------------------------------------------------------------------------
# 1. PSReadLine Predictive IntelliSense Configuration
# ------------------------------------------------------------------------------
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine

    try {
        # Enable Predictive IntelliSense based on command history and plugins
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
        
        # Inline auto-suggestions (Tab or RightArrow to complete, Ctrl+RightArrow for word)
        Set-PSReadLineOption -PredictionViewStyle InlineView -ErrorAction SilentlyContinue

        # Rosé Pine Moon muted tone for suggestions (#6e6a86)
        Set-PSReadLineOption -Colors @{
            InlinePrediction = '#6e6a86'
        } -ErrorAction SilentlyContinue

        # Smart Tab: Accept inline prediction if present; otherwise fallback to normal tab completion
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
            param($key, $arg)
            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            $prevLine = $line
            $prevCursor = $cursor

            # Try accepting the predictive suggestion
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)

            # If nothing changed, fallback to standard Tab completion
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            if ($line -eq $prevLine -and $cursor -eq $prevCursor) {
                [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext($key, $arg)
            }
        } -ErrorAction SilentlyContinue
    } catch {
        # Silent fallback for non-interactive hosts
    }
}

# ------------------------------------------------------------------------------
# 2. Load Custom Dotfiles Modules
# ------------------------------------------------------------------------------
$modulePaths = @(
    "$PSScriptRoot\modules",
    "D:\dev\dotfiles\powershell\modules",
    "$env:USERPROFILE\.config\powershell\modules"
)

foreach ($path in $modulePaths) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path -Filter "*.psm1" -ErrorAction SilentlyContinue | ForEach-Object {
            Import-Module $_.FullName -Force -Global -DisableNameChecking
        }
        break
    }
}

# ------------------------------------------------------------------------------
# 3. Prompt Configuration (Starship or Minimal Native Fallback)
# ------------------------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
} else {
    # Lightweight, fast fallback prompt with git branch awareness
    function global:prompt {
        $cwd = (Get-Location).Path.Replace($env:USERPROFILE, "~")
        $gitBranch = ""
        try {
            $branch = (git branch --show-current 2>$null)
            if ($branch) {
                $gitBranch = "  $branch"
            }
        } catch {}

        Write-Host "`n$cwd" -ForegroundColor Magenta -NoNewline
        if ($gitBranch) {
            Write-Host $gitBranch -ForegroundColor DarkCyan -NoNewline
        }
        Write-Host ""
        return "$([char]0x276F) "
    }
}

# ------------------------------------------------------------------------------
# 4. Agentic & Developer Aliases
# ------------------------------------------------------------------------------
# Git Shortcuts
Set-Alias -Name g -Value git -ErrorAction SilentlyContinue
function gst { git status -sb }
function gco { git checkout @args }
function gbr { git branch @args }
function gdiff { git diff @args }
function glog { git log --oneline --graph -n 15 }

# Modern File Listing
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls { eza --icons --group-directories-first @args }
    function ll { eza -la --icons --group-directories-first @args }
    function lt { eza --tree --level=2 --icons @args }
} elseif (Get-Command lsd -ErrorAction SilentlyContinue) {
    function ls { lsd --icon=auto @args }
    function ll { lsd -la --icon=auto @args }
}

# Fast Jump
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (&zoxide init powershell)
}

# Quick dev navigation
function cddev { Set-Location "D:\dev" }
function cddot { Set-Location "D:\dev\dotfiles" }
