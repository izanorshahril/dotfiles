# Windows Restricted Workstation Setup

Configuration and scripts for corporate/enterprise Windows laptops operating under application control, proxy, and user-space constraints without WSL.

## Why This Setup Exists

Enterprise Windows laptops often enforce security policies that break traditional developer shell setups:

1. **PowerShell Constrained Language Mode (CLM)**:
   WDAC and AppLocker lock PowerShell into `ConstrainedLanguage` mode.
   This disables arbitrary `.NET` reflection, script blocks in `Invoke-Expression`, and dynamic modules needed by Starship's default PowerShell initialization.
2. **OneDrive Profile Redirection**:
   PowerShell profiles stored in cloud-synced folders (`OneDrive - <Org>\Documents\PowerShell`) are subject to `RemoteSigned` policy blocks on untrusted or unsigned scripts.
3. **Console Code Page Mismatch**:
   Windows console host defaults to OEM Code Page 437, turning UTF-8 Nerd Font glyphs into corrupted characters (`≤░ì▓ ΓÇª\viberaven on ∩Éÿ main`).
4. **Git Bash Fork Overhead**:
   POSIX emulation layers like MSYS2 intercept keystrokes with significant subshell latency on Windows, especially when scanned by corporate endpoint detection (EDR).

## Architecture

```text
Windows Terminal (Default Profile: Command Prompt)
        |
        +-> cmd.exe + Clink (Portable C++)
        |     |
        |     +-> Starship (Catppuccin-Powerline Latte)
        |     +-> Inline ghost-text suggestions (Ctrl+Right next word)
        |     +-> Native Win32 execution (0 ms typing latency)
        |
        +-> Git Bash (Native GNU Readline ~/.inputrc)
              |
              +-> Starship prompt
              +-> Shell script / Makefile compatibility
```

## Directory Structure

```text
windows/
├── .config/
│   ├── starship/
│   │   └── starship-catppuccin-latte.toml   # Catppuccin-Powerline Latte preset with Windows glyph spacing
│   └── clink/
│       ├── starship.lua                      # Clink Lua prompt filter for Starship
│       └── clink_settings                   # Inline autosuggestions (True) and clean logo (none)
├── terminal/
│   ├── settings.json                         # Windows Terminal reference profiles & defaults
│   ├── .inputrc                              # GNU Readline history search & word navigation
│   └── .bashrc                               # Clean Git Bash profile with Starship
├── scripts/
│   └── setup-windows.cmd                     # Automated installer for cmd + Clink + Starship
└── README.md
```

## Installation

Run the automated setup from Command Prompt:

```cmd
cd windows\scripts
setup-windows.cmd
```

### Toolchain Prerequisites (User-space)

All binaries are installed in user space without requiring administrator rights:

1. **Starship**:
   Placed in `%USERPROFILE%\.local\bin\starship.exe` via portable MSI extraction or WinGet download.
2. **Clink**:
   Portable zip extracted to `%LOCALAPPDATA%\Programs\clink`.
   Added to user `PATH` and hooked via `clink autorun install`.
3. **Neovim**:
   Portable zip/MSI extracted to `%LOCALAPPDATA%\Programs\Neovim\bin`.
   Configured at `%LOCALAPPDATA%\nvim\init.lua`.
4. **Font**:
   FiraCode Nerd Font installed in `%LOCALAPPDATA%\Microsoft\Windows\Fonts` and selected as default face in Windows Terminal.

## Keybindings and Workflow

### Command Prompt (`cmd.exe` + Clink)

- **`Right Arrow`**: Accept full ghost-text suggestion.
- **`Ctrl+Right`**: Accept next word of suggestion.
- **`Ctrl+R`**: Interactive history search.
- **`Tab`**: Context-sensitive completion.

### Git Bash

- **`Up` / `Down`**: History prefix search (matches commands starting with typed text).
- **`Ctrl+Right` / `Ctrl+Left`**: Fast word navigation.
- **`Ctrl+Backspace` / `Ctrl+Delete`**: Fast word deletion.

## Reverting or Uninstalling

To detach Clink from `cmd.exe` and return to standard command prompt:

```cmd
clink autorun uninstall
```
