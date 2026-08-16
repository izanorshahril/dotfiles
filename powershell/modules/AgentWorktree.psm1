<#
.SYNOPSIS
    Git Worktree Isolation Tools for Multi-Agent Workflows (Treehouse Pattern).
    Ported from Kun Chen's Principal Engineer Agentic Dev Workflow.
#>

function New-AgentWorktree {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Branch,

        [Parameter(Position=1)]
        [string]$Base = "main",

        [Parameter(Position=2)]
        [string]$DestinationPath,

        [switch]$OpenHerdrTab
    )

    # Verify inside git repo
    $isGit = git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Current directory is not inside a git repository."
        return
    }

    $repoRoot = (git rev-parse --show-toplevel).Trim()
    $repoName = Split-Path $repoRoot -Leaf

    if (-not $DestinationPath) {
        # Place worktree as sibling directory: ../<repo>-<branch> or in .worktrees/<branch>
        $parentDir = Split-Path $repoRoot -Parent
        $DestinationPath = Join-Path $parentDir "$repoName-$Branch"
    }

    Write-Host "`n🌿 Creating isolated Worktree for Agent Task..." -ForegroundColor Cyan
    Write-Host "   Repo:   $repoName" -ForegroundColor DarkGray
    Write-Host "   Branch: $Branch (based on $Base)" -ForegroundColor DarkGray
    Write-Host "   Path:   $DestinationPath" -ForegroundColor DarkGray

    # Create git worktree
    git worktree add -b $Branch $DestinationPath $Base

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Worktree successfully created at: $DestinationPath" -ForegroundColor Green
        
        # If Herdr is running and user requested Herdr tab, create a new tab in Herdr
        if ($OpenHerdrTab -or ($env:HERDR_WORKSPACE_ID -ne $null)) {
            Write-Host "📟 Opening new tab in Herdr workspace..." -ForegroundColor Cyan
            try {
                herdr tab create --cwd $DestinationPath --title "wt:$Branch" 2>$null
            } catch {
                # Ignore if herdr is not in current context
            }
        }

        # Offer to jump
        Write-Host "👉 Run: cd '$DestinationPath'`n" -ForegroundColor Yellow
    } else {
        Write-Error "Failed to create worktree."
    }
}

function Get-AgentWorktrees {
    [CmdletBinding()]
    param()

    Write-Host "🌿 ACTIVE GIT WORKTREES:" -ForegroundColor Cyan
    git worktree list
}

function Remove-AgentWorktree {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$PathOrBranch,

        [switch]$Force,

        [switch]$DeleteBranch
    )

    $args = @("worktree", "remove")
    if ($Force) {
        $args += "--force"
    }
    $args += $PathOrBranch

    git @args

    if ($LASTEXITCODE -eq 0) {
        Write-Host "🗑️ Worktree removed: $PathOrBranch" -ForegroundColor Green
        if ($DeleteBranch) {
            git branch -D $PathOrBranch
        }
    }
}

function Sync-AgentWorktrees {
    [CmdletBinding()]
    param()

    Write-Host "🔄 Pruning stale worktrees..." -ForegroundColor Cyan
    git worktree prune -v
}

# Aliases
Set-Alias -Name gwt -Value New-AgentWorktree -ErrorAction SilentlyContinue
Set-Alias -Name gwtl -Value Get-AgentWorktrees -ErrorAction SilentlyContinue
Set-Alias -Name gwtrm -Value Remove-AgentWorktree -ErrorAction SilentlyContinue
Set-Alias -Name gwtprune -Value Sync-AgentWorktrees -ErrorAction SilentlyContinue

Export-ModuleMember -Function New-AgentWorktree, Get-AgentWorktrees, Remove-AgentWorktree, Sync-AgentWorktrees -Alias gwt, gwtl, gwtrm, gwtprune
