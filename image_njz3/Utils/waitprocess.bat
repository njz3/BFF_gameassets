@echo off
set "processName=%~1"

if "%processName%"=="" (
    echo Usage: %0 nom_du_processus.exe
    exit /b 1
)

:: Attente de la fin
:loop
tasklist /FI "IMAGENAME eq %processName%" 2>NUL | find /I /N "%processName%">NUL
if "%ERRORLEVEL%"=="0" (
    timeout /t 2 /nobreak >nul
    goto loop
)

:: Le processus %processName% est termine.
