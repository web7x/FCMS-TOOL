@echo off
title DAW - FCMS 2.0 Installer & Downloader
color 0B

:: 1. Run as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] ERROR: Please Right-click > Run as Administrator
    pause
    exit
)

:: --- Configuration ---
set "EXT_ID=jjfddbepomohcefimfgajfldihaldcmj"
set "XML_URL=https://raw.githubusercontent.com/web7x/FCMS-TOOL/refs/heads/main/update.xml"
set "CRX_URL=https://raw.githubusercontent.com/web7x/FCMS-TOOL/main/fcms_tool.crx"
set "DESKTOP_PATH=%USERPROFILE%\Desktop\fcms_tool.crx"

echo ====================================================
echo           DAW - FCMS 2.0 UNIVERSAL DEPLOYER
echo ====================================================
echo.

:: 2. Download a copy to the Desktop
echo [+] Downloading a copy to your Desktop...
powershell -Command "Invoke-WebRequest -Uri '%CRX_URL%' -OutFile '%DESKTOP_PATH%'"
if exist "%DESKTOP_PATH%" (
    echo [OK] File saved to Desktop: fcms_tool.crx
) else (
    echo [!] Warning: Could not download copy to Desktop.
)

:: 3. Registering as an External Extension
echo [+] Registering Extension in Registry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Google\Chrome\Extensions\%EXT_ID%" /v "update_url" /t REG_SZ /d "%XML_URL%" /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge\Extensions\%EXT_ID%" /v "update_url" /t REG_SZ /d "%XML_URL%" /f >nul

:: 4. Adding to Allowlist (To reduce security warnings)
echo [+] Trusting Extension (Allowlist)...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist" /v "1" /t REG_SZ /d "%EXT_ID%" /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallAllowlist" /v "1" /t REG_SZ /d "%EXT_ID%" /f >nul

:: 5. Enable DevMode
reg add "HKEY_CURRENT_USER\Software\Google\Chrome\DeveloperMode" /v "1" /t REG_DWORD /d 1 /f >nul

:: 6. Refresh Browsers
echo [+] Restarting Browsers...
taskkill /F /IM chrome.exe /T >nul 2>&1
taskkill /F /IM msedge.exe /T >nul 2>&1

echo.
echo ====================================================
echo [SUCCESS] FCMS TOOL is Installed AND Saved to Desktop.
echo.
echo You can now find 'fcms_tool.crx' on your desktop.
echo ====================================================
pause