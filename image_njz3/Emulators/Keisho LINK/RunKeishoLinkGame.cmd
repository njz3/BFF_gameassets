@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
:: set the title to match the name of the game
TITLE [%ROM%]-Keisho

:: Change current directory to the folder that contains this file
CD /d "%~dp0"

set MODEL2=keisho.exe

:: Lunch emulator
:: Dossier d ecriture (bornes sous UWF) : Saves\keisho<CAB_ID>, que Keisho
:: amorce lui-meme au premier lancement depuis keisho.ini et saves en place
:: (ceux de la cabine de cette machine, poses par Build-Config)
CALL "..\..\Utils\set_cab_id.bat"
set VARIANTE=%CAB_ID:~1%
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=--write-dir "%WRITEDIR_ROOT%\keisho_%VARIANTE%"
%MODEL2% %ECRITURE% --game %ROM%

:: leave caller
EXIT

:aide
:: Sans argument : la syntaxe et les noms de jeu possibles, par
:: Utils\AideLanceur.ps1 (chemin normalise : les dossiers Demul ont des [ ])
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
:: Lance par un double-clic : garder la fenetre ouverte
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
