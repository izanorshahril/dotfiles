@echo off
setlocal EnableDelayedExpansion

echo ========================================================
echo   Windows Workstation Dotfiles Setup (Work / Office)
echo ========================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "PROFILE_DIR=%SCRIPT_DIR%.."
set "CONFIG_DIR=%USERPROFILE%\.config"
set "CLINK_DIR=%LOCALAPPDATA%\clink"
set "LOCAL_BIN=%USERPROFILE%\.local\bin"
set "WT_PKG_DIR=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

:: 1. Deploy Starship Configuration (Gruvbox Dark preset)
echo [1/6] Deploying Starship Gruvbox Dark configuration...
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
copy /Y "%PROFILE_DIR%\.config\starship\starship-gruvbox-dark.toml" "%CONFIG_DIR%\starship.toml" >nul
echo       Installed: %CONFIG_DIR%\starship.toml

:: 2. Deploy Clink Scripts and Settings (async Starship, tab dropdown, autosuggest)
echo [2/6] Deploying Clink integration for cmd.exe...
if not exist "%CLINK_DIR%" mkdir "%CLINK_DIR%"
copy /Y "%PROFILE_DIR%\.config\clink\starship.lua" "%CLINK_DIR%\starship.lua" >nul
copy /Y "%PROFILE_DIR%\.config\clink\tab_suggest.lua" "%CLINK_DIR%\tab_suggest.lua" >nul
copy /Y "%PROFILE_DIR%\.config\clink\clink_settings" "%CLINK_DIR%\clink_settings" >nul
echo       Installed: %CLINK_DIR%\starship.lua
echo       Installed: %CLINK_DIR%\tab_suggest.lua
echo       Installed: %CLINK_DIR%\clink_settings

:: Register Clink autorun for cmd.exe
where clink >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    call clink autorun install >nul 2>&1
    echo       Registered Clink autorun in cmd.exe.
) else (
    echo       [WARN] clink not found in PATH. Install Clink portably into AppData\Local\Programs\clink.
)

:: 3. Deploy Git Bash Configuration
echo [3/6] Deploying Git Bash configuration (.bashrc, .bash_profile, .inputrc)...
copy /Y "%PROFILE_DIR%\terminal\.bashrc" "%USERPROFILE%\.bashrc" >nul
copy /Y "%PROFILE_DIR%\terminal\.bash_profile" "%USERPROFILE%\.bash_profile" >nul
copy /Y "%PROFILE_DIR%\terminal\.inputrc" "%USERPROFILE%\.inputrc" >nul
echo       Installed: %USERPROFILE%\.bashrc
echo       Installed: %USERPROFILE%\.bash_profile
echo       Installed: %USERPROFILE%\.inputrc

:: 4. Deploy PowerShell Profiles (PSReadLine, Inline suggestions, Starship CLM)
echo [4/6] Deploying PowerShell profiles...
set "PS5_DIR=%USERPROFILE%\Documents\WindowsPowerShell"
set "PS7_DIR=%USERPROFILE%\Documents\PowerShell"
if not exist "%PS5_DIR%" mkdir "%PS5_DIR%"
if not exist "%PS7_DIR%" mkdir "%PS7_DIR%"
copy /Y "%PROFILE_DIR%\powershell\Microsoft.PowerShell_profile.ps1" "%PS5_DIR%\Microsoft.PowerShell_profile.ps1" >nul
copy /Y "%PROFILE_DIR%\powershell\Microsoft.PowerShell_profile.ps1" "%PS7_DIR%\Microsoft.PowerShell_profile.ps1" >nul
echo       Installed: %PS5_DIR%\Microsoft.PowerShell_profile.ps1
echo       Installed: %PS7_DIR%\Microsoft.PowerShell_profile.ps1

:: Check and deploy to any corporate OneDrive redirected Documents folders
for /d %%D in ("%USERPROFILE%\OneDrive*\Documents\WindowsPowerShell") do (
    copy /Y "%PROFILE_DIR%\powershell\Microsoft.PowerShell_profile.ps1" "%%D\Microsoft.PowerShell_profile.ps1" >nul
    echo       Installed: %%D\Microsoft.PowerShell_profile.ps1
)
for /d %%D in ("%USERPROFILE%\OneDrive*\Documents\PowerShell") do (
    copy /Y "%PROFILE_DIR%\powershell\Microsoft.PowerShell_profile.ps1" "%%D\Microsoft.PowerShell_profile.ps1" >nul
    echo       Installed: %%D\Microsoft.PowerShell_profile.ps1
)

:: 5. Deploy User-space Shims (~/.local/bin)
echo [5/6] Deploying user-space shims to ~/.local/bin...
if not exist "%LOCAL_BIN%" mkdir "%LOCAL_BIN%"
if exist "%PROFILE_DIR%\bin\clink.cmd" copy /Y "%PROFILE_DIR%\bin\clink.cmd" "%LOCAL_BIN%\clink.cmd" >nul
if exist "%PROFILE_DIR%\bin\nvim.cmd" copy /Y "%PROFILE_DIR%\bin\nvim.cmd" "%LOCAL_BIN%\nvim.cmd" >nul
echo       Installed shims in: %LOCAL_BIN%

:: 6. Windows Terminal Deployment / Guidance
echo [6/6] Checking Windows Terminal configuration...
if exist "%WT_PKG_DIR%" (
    echo       To update Windows Terminal, copy:
    echo       "%PROFILE_DIR%\terminal\settings.json" to "%WT_PKG_DIR%\settings.json"
)

echo.
echo ========================================================
echo   Work Profile Setup Complete!
echo   Open a new cmd.exe, PowerShell, or Git Bash terminal.
echo ========================================================
