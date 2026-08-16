<#
.SYNOPSIS
    Herdr CLI Workflow and Agent Orchestration Helpers for PowerShell 7.
    Ported from Kun Chen's AXI / L8 Principal Multiplexer patterns.
#>

function Start-HerdrSession {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]$SessionName
    )
    if ($SessionName) {
        herdr --session $SessionName
    } else {
        herdr
    }
}

function Get-HerdrStatus {
    [CmdletBinding()]
    param()
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor DarkCyan
    Write-Host "  HERDR AGENT MULTIPLEXER STATUS                   " -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor DarkCyan
    
    try {
        herdr status
    } catch {
        Write-Warning "Herdr server is not currently running. Launch with 'herdr' or 'h'."
    }
}

function Get-HerdrAgents {
    [CmdletBinding()]
    param()
    try {
        herdr agent list
    } catch {
        Write-Warning "Failed to query Herdr agents. Ensure Herdr is running."
    }
}

function Get-HerdrWorkspaces {
    [CmdletBinding()]
    param()
    try {
        herdr workspace list
    } catch {
        Write-Warning "Failed to query Herdr workspaces. Ensure Herdr is running."
    }
}

function Split-HerdrPane {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [ValidateSet('right', 'down')]
        [string]$Direction = 'right',

        [Parameter(Position=1)]
        [string]$Cwd = $PWD.Path,

        [switch]$Focus
    )
    $args = @("pane", "split", "--current", "--direction", $Direction, "--cwd", $Cwd)
    if (-not $Focus) {
        $args += "--no-focus"
    }
    herdr @args
}

function Start-HerdrAgent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Name,

        [Parameter(Position=1)]
        [string]$Kind = "codex",

        [Parameter(Position=2)]
        [ValidateSet('right', 'down', 'current')]
        [string]$Placement = 'right',

        [Parameter(Position=3)]
        [string]$Cwd = $PWD.Path,

        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$AgentArgs
    )

    Write-Host "`n🚀 Launching Agent [$Name] (Kind: $Kind) in Herdr..." -ForegroundColor Cyan

    if ($Placement -ne 'current') {
        # Split pane first
        $splitResult = herdr pane split --current --direction $Placement --cwd $Cwd --no-focus 2>&1
        $paneId = $null
        try {
            $parsed = $splitResult | ConvertFrom-Json
            $paneId = $parsed.result.pane.pane_id
        } catch {
            Write-Warning "Could not parse new pane ID automatically. Check herdr UI."
        }

        if ($paneId) {
            Write-Host "   Created pane: $paneId" -ForegroundColor DarkGray
            $startArgs = @("agent", "start", $Name, "--kind", $Kind, "--pane", $paneId)
            if ($AgentArgs -and $AgentArgs.Count -gt 0) {
                $startArgs += "--"
                $startArgs += $AgentArgs
            }
            herdr @startArgs
        }
    } else {
        $startArgs = @("agent", "start", $Name, "--kind", $Kind, "--current")
        if ($AgentArgs -and $AgentArgs.Count -gt 0) {
            $startArgs += "--"
            $startArgs += $AgentArgs
        }
        herdr @startArgs
    }
}

function Send-HerdrPrompt {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Agent,

        [Parameter(Mandatory=$true, Position=1)]
        [string]$Prompt,

        [switch]$Wait,

        [int]$TimeoutMs = 120000
    )
    $args = @("agent", "prompt", $Agent, $Prompt, "--timeout", "$TimeoutMs")
    if ($Wait) {
        $args += "--wait"
    }
    herdr @args
}

function Sync-AgentDirectives {
    [CmdletBinding()]
    param()
    $setupScript = "D:\dev\dotfiles\scripts\setup-agent-links.ps1"
    if (Test-Path $setupScript) {
        & $setupScript
    } else {
        Write-Warning "Setup script not found at $setupScript."
    }
}

# Short aliases matching Kun Chen's muscle-memory shortcuts
Set-Alias -Name h -Value Start-HerdrSession -ErrorAction SilentlyContinue
Set-Alias -Name hs -Value Get-HerdrStatus -ErrorAction SilentlyContinue
Set-Alias -Name hla -Value Get-HerdrAgents -ErrorAction SilentlyContinue
Set-Alias -Name hlw -Value Get-HerdrWorkspaces -ErrorAction SilentlyContinue
Set-Alias -Name hsplit -Value Split-HerdrPane -ErrorAction SilentlyContinue
Set-Alias -Name hstart -Value Start-HerdrAgent -ErrorAction SilentlyContinue
Set-Alias -Name hprompt -Value Send-HerdrPrompt -ErrorAction SilentlyContinue
Set-Alias -Name sync-agents -Value Sync-AgentDirectives -ErrorAction SilentlyContinue

Export-ModuleMember -Function Start-HerdrSession, Get-HerdrStatus, Get-HerdrAgents, Get-HerdrWorkspaces, Split-HerdrPane, Start-HerdrAgent, Send-HerdrPrompt, Sync-AgentDirectives -Alias h, hs, hla, hlw, hsplit, hstart, hprompt, sync-agents

