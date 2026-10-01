@echo off
setlocal EnableDelayedExpansion

echo ========================================================
echo   Windows Restricted Workstation Dotfiles Setup
echo ========================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "WINDOWS_DIR=%SCRIPT_DIR%.."
set "CONFIG_DIR=%USERPROFILE%\.config"
set "CLINK_DIR=%LOCALAPPDATA%\clink"

:: 1. Deploy Starship Configuration (Catppuccin-Powerline Latte)
echo [1/4] Deploying Starship configuration...
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
copy /Y "%WINDOWS_DIR%\.config\starship\starship-catppuccin-latte.toml" "%CONFIG_DIR%\starship.toml" >nul
echo       Installed: %CONFIG_DIR%\starship.toml

:: 2. Deploy Clink Scripts and Settings
echo [2/4] Deploying Clink integration for cmd.exe...
if not exist "%CLINK_DIR%" mkdir "%CLINK_DIR%"
copy /Y "%WINDOWS_DIR%\.config\clink\starship.lua" "%CLINK_DIR%\starship.lua" >nul
copy /Y "%WINDOWS_DIR%\.config\clink\clink_settings" "%CLINK_DIR%\clink_settings" >nul
echo       Installed: %CLINK_DIR%\starship.lua
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
echo [3/4] Deploying Git Bash configuration (.bashrc, .inputrc)...
copy /Y "%WINDOWS_DIR%\terminal\.bashrc" "%USERPROFILE%\.bashrc" >nul
copy /Y "%WINDOWS_DIR%\terminal\.inputrc" "%USERPROFILE%\.inputrc" >nul
echo       Installed: %USERPROFILE%\.bashrc
echo       Installed: %USERPROFILE%\.inputrc

:: 4. Verify Starship Binary
echo [4/4] Verifying Starship binary...
where starship >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo       Starship binary verified in PATH.
) else (
    echo       [WARN] starship.exe not found in PATH. Ensure ~/.local/bin is in your user PATH.
)

echo.
echo ========================================================
echo   Setup Complete!
echo   Open a new cmd.exe or Git Bash terminal to test.
echo ========================================================
