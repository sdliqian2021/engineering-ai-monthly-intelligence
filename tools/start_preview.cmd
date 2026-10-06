@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start_preview.ps1" %*
set "preview_exit=%errorlevel%"
if not "%preview_exit%"=="0" pause
exit /b %preview_exit%
