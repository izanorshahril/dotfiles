# WSL2 Agentic Dotfiles

Reusable shell, Git, Neovim, Starship, and agent directives for an Ubuntu WSL2 development environment.

The Windows host is intentionally kept thin:

```text
Windows Terminal
        |
        v
WSL2 Ubuntu -> bash -> Starship -> Herdr / Pi / agents
        |
        +-> Git, jq, gh, uv, Bun, Neovim, AXI tools
```

Keep active repositories inside the WSL filesystem, such as `~/src`, instead of `/mnt/c` or `/mnt/d`.
This avoids cross-filesystem path, permissions, file-watch, and process-tree problems.

## Layout

```text
dotfiles/
├── .config/
│   ├── git/
│   ├── nvim/
│   └── starship/
├── agents/
│   ├── AGENTS.md
│   ├── CLAUDE.md
│   └── skills-audit.md
├── scripts/
│   ├── install-wsl.sh
│   ├── setup-agent-links.sh
│   ├── setup-git.sh
│   ├── setup-shell.sh
│   └── test-env.sh
└── README.md
```

## Install in WSL2

Run these commands inside Ubuntu WSL2:

```bash
cd /mnt/d/Dev/dotfiles
chmod +x scripts/*.sh
./scripts/install-wsl.sh
```

For best repository performance, clone application repositories into `~/src`.
The dotfiles repository may remain on the Windows drive while it is being migrated.

The installer configures Git, global agent directives, bash, Starship, Neovim, and the WSL package prerequisites.
It installs `jq` because Firstmate and the AXI tools use it for structured automation output.
It installs `mise` only as a runtime manager, not as a wrapper around agent processes.

## Agent tools

Install Herdr, Pi, Treehouse, and the selected agent CLIs inside WSL2 after the base setup.
Use each project's current Linux installation instructions rather than Windows binaries.
Launch agents directly from the WSL shell so their paths, process ancestry, sockets, and workspaces share one Linux environment.

The AXI tools remain useful for Windows automation and are also supported inside WSL2:

- `gh-axi` for GitHub operations.
- `chrome-devtools-axi` for browser automation.
- `lavish-axi` for visual review artifacts.
- `quota-axi` for quota evidence.
- `tasks-axi` for backlog operations.
- `no-mistakes` for validation pipelines.

Install these tools in the environment that will execute them.
Do not mix Windows and WSL installations for one agent session.

## Retained tools

Keep Windows Terminal, GitHub CLI, Copilot CLI, Agy CLI, Bun, uv, Starship, and the AXI tools available on Windows when an IDE or automation workflow still uses them.
Keep the native Codex and Claude applications until their WSL replacements are verified.

## Validation

```bash
./scripts/test-env.sh
```

The check distinguishes required WSL tools from optional agent and AXI tools.
