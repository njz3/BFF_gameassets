@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
:: set the title to match the name of the game
TITLE [%ROM%]

:: CAB_ID
CALL set_cab_id.bat
:: Network: LOCALPORT NEXTPORT LOCALIP NEXTIP
CALL set_cab_network%CAB_ID%.bat

:: Change current directory to the folder that contains this file
CD /d "%~dp0"

:: lunch m2lagfix
start m2lagfix /B /MIN
ping -n 3 127.0.0.1 >nul

set MODEL2=emulator_multicpu.exe

:: Lunch emulator
%MODEL2% %ROM%

CALL killm2lagfix.bat

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
