# Work / Office PowerShell Profile
# Compatible with Windows PowerShell 5.1 (CLM) and PowerShell 7+ (pwsh)

# 1. Ensure ~/.local/bin is in PATH for user-space tools (starship, uv, nvim)
$localBin = Join-Path $env:USERPROFILE '.local\bin'
if ($env:PATH -notlike "*$localBin*") {
    $env:PATH = "$localBin;$env:PATH"
}

# 2. Configure Starship Environment
$env:STARSHIP_CONFIG = Join-Path $env:USERPROFILE '.config\starship.toml'
$env:STARSHIP_SHELL = "powershell"
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# 3. Starship Prompt Function (ConstrainedLanguageMode compatible)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    function global:prompt {
        $origExit = $LASTEXITCODE
        $jobs = @(Get-Job -State Running -ErrorAction SilentlyContinue).Count
        $w = if ($Host.UI.RawUI) { $Host.UI.RawUI.WindowSize.Width } else { 80 }
        $arguments = @(
            "prompt",
            "--path=$PWD",
            "--terminal-width=$w",
            "--jobs=$jobs",
            "--status=$origExit"
        )
        $promptText = & starship @arguments
        if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
            try {
                Set-PSReadLineOption -ExtraPromptLineCount ($promptText.Split("`n").Length - 1) -ErrorAction SilentlyContinue
            } catch {}
        }
        $global:LASTEXITCODE = $origExit
        $promptText
    }
}

# 4. Predictive IntelliSense & Next-Word Completion (PSReadLine)
if (Get-Module -ListAvailable PSReadLine) {
    try {
        Import-Module PSReadLine -MinimumVersion 2.2.0 -ErrorAction SilentlyContinue

        # Source predictions from command history and completion plugins
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue

        # Inline ghost text (fish-style)
        Set-PSReadLineOption -PredictionViewStyle InlineView -ErrorAction SilentlyContinue

        # Muted prediction color matching prompt duration style
        Set-PSReadLineOption -Colors @{ InlinePrediction = "`e[38;2;110;106;134m" } -ErrorAction SilentlyContinue

        # Next-word completion: Tab accepts one word of the suggestion
        Set-PSReadLineKeyHandler -Key Tab -Function AcceptNextSuggestionWord -ErrorAction SilentlyContinue

        # Ctrl+RightArrow also accepts one word
        Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function AcceptNextSuggestionWord -ErrorAction SilentlyContinue

        # F2 switches between InlineView and ListView
        Set-PSReadLineKeyHandler -Key F2 -Function SwitchPredictionView -ErrorAction SilentlyContinue
    } catch {}
}
