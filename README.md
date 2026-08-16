# Agentic Dotfiles for Windows 11 (L8 Principal Setup)

Reproducible, agent-native development environment tailored for Windows 11, PowerShell 7, Windows Terminal, and the **Herdr** agent multiplexer.
Ported from Kun Chen's Principal Engineer workflow (`5N-okeDdIuI`, `kPN564Kol14`).

```
dotfiles/
├── .config/
│   ├── git/
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── herdr/
│   │   └── config.toml
│   ├── nvim/
│   │   └── init.lua
│   └── starship/
│       └── starship.toml
├── agents/
│   ├── AGENTS.md
│   └── CLAUDE.md
├── powershell/
│   ├── Microsoft.PowerShell_profile.ps1
│   └── modules/
│       ├── AgentWorktree.psm1
│       ├── HerdrTools.psm1
│       └── WTBackdrop.psm1
├── scripts/
│   ├── install.ps1
│   ├── setup-agent-links.ps1
│   ├── setup-git.ps1
│   ├── setup-herdr.ps1
│   ├── setup-profile.ps1
│   ├── setup-starship.ps1
│   ├── setup-terminal.ps1
│   ├── sync.ps1
│   └── test-env.ps1
└── windows-terminal/
    ├── settings.json
    └── schemes/
        └── rose-pine-moon.json
```

## Architecture & Minimal Directives Topology

```mermaid
flowchart TD
    User([User / Orchestrator]) --> WT[Windows Terminal]
    WT --> Profile[PowerShell 7 + PSReadLine]
    Profile --> HM[Herdr Multiplexer]
    
    subgraph Directives [Standardized Open Directives]
        DotAgents[dotfiles/agents/AGENTS.md]
        CanonAgents[~/.agents/AGENTS.md]
        HomeAgents[~/AGENTS.md]
        ClaudeMD[~/.claude/CLAUDE.md]
        
        DotAgents -->|Sync| CanonAgents
        CanonAgents <-->|NTFS Hardlink| HomeAgents
        DotAgents -->|Sync| ClaudeMD
        
        CanonAgents & HomeAgents -.-> AllHarnesses[All Harnesses: Codex, OpenCode, Pi, Kilo, Antigravity, Cursor, Goose, Aider]
        ClaudeMD -.-> ClaudeCode[Claude Code]
    end

    subgraph HM [Herdr Multiplexer Session]
        Side[Agent Status Sidebar]
        Pane1[Controller Pane]
        Pane2[Agent 1: Codex / Claude]
        Pane3[Agent 2: Test Runner]
    end

    Pane1 -->|gwt new feature-x| WTTree[Git Worktree Isolation]
    Pane2 -->|Works in| WTTree
    Pane1 -->|herdr agent prompt| Pane2
    Side -->|Tracks Lifecycle: working / idle / blocked| User
```

## Installation & Deployment

Run from PowerShell 7:

```powershell
# One-shot idempotent installation
pwsh .\scripts\install.ps1

# Sync live configs into repository
pwsh .\scripts\sync.ps1

# Deploy / Refresh global agent directives
pwsh .\scripts\setup-agent-links.ps1

# Run diagnostic verification
pwsh .\scripts\test-env.ps1
```

## Keybindings & Shortcuts

### Herdr (`ctrl+a` prefix)
| Keybinding | Action |
| :--- | :--- |
| `ctrl+a` + `v` | Split pane vertically |
| `ctrl+a` + `-` | Split pane horizontally |
| `ctrl+a` + `h/j/k/l` | Navigate panes (Vim-style) |
| `ctrl+a` + `z` | Zoom / Fullscreen active pane |
| `ctrl+a` + `b` | Toggle agent sidebar |
| `ctrl+a` + `c` | Create new tab |
| `ctrl+a` + `w` | Workspace picker |
| `ctrl+a` + `Shift+G` | New Git worktree in Herdr |
| `ctrl+a` + `Shift+R` | Reload `config.toml` |
| `ctrl+a` + `q` | Detach session |

### PowerShell & Agent Workflow Commands
| Command | Alias | Description |
| :--- | :--- | :--- |
| `Start-HerdrSession` | `h` | Launch / attach to Herdr |
| `Get-HerdrStatus` | `hs` | Show Herdr client & server status |
| `Get-HerdrAgents` | `hla` | List live agents and their lifecycle state |
| `Start-HerdrAgent` | `hstart` | Split pane & spawn named agent (`hstart reviewer codex`) |
| `Send-HerdrPrompt` | `hprompt` | Submit prompt to named agent (`hprompt reviewer "review diff" -Wait`) |
| `New-AgentWorktree` | `gwt` | Create isolated git worktree branch for agent task |
| `Get-AgentWorktrees` | `gwtl` | List active git worktrees |
| `Remove-AgentWorktree`| `gwtrm` | Safely remove worktree |
| `Sync-AgentDirectives`| `sync-agents` | Re-sync minimalist global directives |
| `Set-WTBackdrop` | `backdrop`, `tb` | Toggle Windows Terminal acrylic / mica / solid backdrop |
