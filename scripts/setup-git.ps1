# Git Config and Global Ignore Deployer
param(
    [switch]$Force
)

$sourceGitConfig = Join-Path $PSScriptRoot "..\.config\git\.gitconfig"
$sourceGitIgnore = Join-Path $PSScriptRoot "..\.config\git\.gitignore_global"

$userConfigGit = "$env:USERPROFILE\.config\git"
if (-not (Test-Path $userConfigGit)) {
    New-Item -ItemType Directory -Path $userConfigGit -Force | Out-Null
}

Copy-Item $sourceGitIgnore "$userConfigGit\.gitignore_global" -Force
Write-Host "✅ Global gitignore deployed to: $userConfigGit\.gitignore_global" -ForegroundColor Green

# Configure git global excludesfile and longpaths
git config --global core.excludesfile "$env:USERPROFILE\.config\git\.gitignore_global"
git config --global core.longpaths true
git config --global core.autocrlf input
git config --global pull.rebase true
git config --global init.defaultBranch main

# Set helpful aliases
git config --global alias.st "status -sb"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.wt "worktree"
git config --global alias.wtl "worktree list"
git config --global alias.wta "worktree add"
git config --global alias.wtr "worktree remove"

Write-Host "✅ Git global settings and worktree aliases configured!" -ForegroundColor Green
