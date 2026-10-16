# Work / Office Profile

Windows enterprise workstation profile tailored for corporate laptops operating under application whitelisting (WDAC/AppLocker), PowerShell Constrained Language Mode (CLM), proxy restrictions, and user-space constraints without WSL.

## Overview

This profile packages the cmd, Clink, Starship, PowerShell, and Windows Terminal customizations for the enterprise workspace:

```text
Windows Terminal (Default Profile: Command Prompt)
        |
        +-> cmd.exe + Clink (Portable C++)
        |     |
        |     +-> Starship (Gruvbox Dark Powerline)
        |     +-> Async prompt rendering (clink.promptcoroutine)
        |     +-> Tab: Clink dropdown list or next-word suggestion fallback
        |     +-> Native Win32 execution (0 ms typing latency)
        |
        +-> PowerShell 5.1 & PowerShell 7 (pwsh)
        |     |
        |     +-> PSReadLine Predictive IntelliSense (InlineView, muted ghost text)
        |     +-> Tab & Ctrl+Right: AcceptNextSuggestionWord
        |     +-> F2: SwitchPredictionView (Inline / List)
        |     +-> Starship custom prompt compatible with ConstrainedLanguageMode
        |
        +-> Git Bash
              |
              +-> Starship prompt
              +-> GNU Readline ~/.inputrc with Clink-aware backspace handling
              +-> ~/.bash_profile for login shells
```

## Directory Structure

```text
profiles/work/
├── .config/
│   ├── clink/
│   │   ├── clink_settings             # Autosuggest enable & dropdown candidate default
│   │   ├── starship.lua               # Async prompt coroutine & directory caching filter
│   │   └── tab_suggest.lua            # Hybrid Tab completion (dropdown or next-word ghost text)
│   └── starship/
│       └── starship-gruvbox-dark.toml # Gruvbox Dark powerline theme with glyph spacing
├── bin/
│   ├── clink.cmd                      # Portable shim calling %LOCALAPPDATA%\Programs\clink
│   └── nvim.cmd                       # Portable shim calling %LOCALAPPDATA%\Programs\Neovim
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1 # PSReadLine + CLM Starship for PS 5.1 and PS 7
├── scripts/
│   └── setup-work.cmd                 # Automated one-click installer for Work profile
├── terminal/
│   ├── .bash_profile                  # Login shell profile sourcing .bashrc
│   ├── .bashrc                        # Starship init & clean shell aliases
│   ├── .inputrc                       # UTF-8 Readline navigation + Clink \C-h backspace fix
│   └── settings.json                  # Windows Terminal profiles, keybindings, and Shift+Enter action
└── README.md
```

## Privacy & Sanitization

All files in this profile are strictly sanitized:
- No hardcoded corporate usernames or email addresses.
- Dynamic path resolution via `%USERPROFILE%`, `%LOCALAPPDATA%`, and `$env:USERPROFILE`.
- Handles corporate OneDrive folder redirection automatically (`OneDrive*\Documents\...`).
- Safe to commit to public or personal dotfiles repositories.

## Quick Installation

Run the setup script from Command Prompt:

```cmd
cd profiles\work\scripts
setup-work.cmd
```

To update Windows Terminal settings:
Copy `profiles\work\terminal\settings.json` into `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.
