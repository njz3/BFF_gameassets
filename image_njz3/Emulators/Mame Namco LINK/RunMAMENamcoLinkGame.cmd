@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
:: set the title to match the name of the game
TITLE [%ROM%]
set GAME=%ROM%

:: CAB_ID
CALL set_cab_id.bat
:: Network: LOCALPORT NEXTPORT LOCALIP NEXTIP
CALL set_cab_network%CAB_ID%.bat

:: Change current directory to the folder that contains this file
CD /d "%~dp0"
:: Normal command
:: Never START: the console must live as long as the game, so Attract-Mode
:: keeps waiting on it and BFF keeps the title it reads
mame.exe %GAME% -nvram_directory nvram%CAB_ID% -comm_localport %LOCALPORT% -comm_remoteport %NEXTPORT% -comm_localhost %LOCALIP% -comm_remotehost %NEXTIP%

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
