@echo off
setlocal

echo ========================================
echo          CRYPTOGRAPHY TOOL
echo             INSTALLER
echo ========================================
echo.

set "INSTALL_PATH=%~dp0"

echo Installing CryptoTool...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$path = [Environment]::GetEnvironmentVariable('Path','User'); $install = '%INSTALL_PATH%'.TrimEnd('\'); if (($path -split ';') -notcontains $install) { [Environment]::SetEnvironmentVariable('Path', (($path + ';' + $install).Trim(';')), 'User'); Write-Host '[+] CryptoTool added to User PATH.' } else { Write-Host '[+] CryptoTool already exists in User PATH.' }"

echo.
echo ========================================
echo       INSTALLATION COMPLETE
echo ========================================
echo.
echo Please open a NEW CMD or PowerShell window.
echo.
echo Then simply type:
echo.
echo     CryptoTool
echo.
pause