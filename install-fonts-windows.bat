@echo off
echo Installing MesloLGS NF fonts for Windows Terminal...
echo.
echo This script will download and install the required fonts.
echo You may need to run this as Administrator.
echo.
pause

PowerShell -ExecutionPolicy Bypass -File "%~dp0install-fonts-windows.ps1"

echo.
echo Installation complete! Please restart Windows Terminal.
pause