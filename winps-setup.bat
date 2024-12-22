@echo off
   3   │ @REM echo Running PowerShell command...
   4   │ @REM powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
   5   │
   6   │ echo.
   7   │ echo Calling PowerShell script...
   8   │ powershell -ExecutionPolicy Bypass -File ".\1_winSandbox-init-setup.ps1"
   9   │
  10   │ @REM @echo off
  11   │ @REM Echo Install Powertoys and Terminal
  12   │ @REM REM Powertoys
  13   │ @REM winget install Microsoft.Powertoys
  14   │ @REM if %ERRORLEVEL% EQU 0 Echo Powertoys installed successfully.
  15   │ @REM REM Terminal
  16   │ @REM winget install Microsoft.WindowsTerminal
  17   │ @REM if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
