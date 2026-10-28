@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

:: The gaelco games of this Demul build, in place of one .cmd a game.
:: Every one of them ran exactly these lines; only the rom changed, and it
:: came from the file name. It is the argument now.
::
:: Attract-Mode passes the game through RunAltRomname.cfg, which calls
:: this script with the entry name as its argument. %~n1 drops an
:: extension if one is ever given, as the TeknoParrot launcher does.

set ROM=%~n1
if "%ROM%"=="" ( echo Usage: %~n0 ^<game^> & exit /b 1 )

:: The title BFF reads: the rom name between brackets, nothing else
TITLE [%ROM%]

CD /d "%~dp0"

START demul.exe -run=gaelco -rom=%ROM%

:: Demul needs a moment, then the focus, then Alt+Enter for full screen
start /w /B wscript "sleep.vbs" "1000"
start /w /B wscript "activate.vbs" "demul.exe"
start /w /B wscript "sleep.vbs" "5000"
start /w sendkeys.vbs "%%{ENTER}"

:: Blocking: Attract-Mode must wait for the game, and the console must
:: live as long as it so that BFF keeps the title
call waitprocess "demul.exe"

EXIT

:aide
:: Sans argument : la syntaxe et les noms de jeu possibles, par
:: Utils\AideLanceur.ps1 (chemin normalise : les dossiers Demul ont des [ ])
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
:: Lance par un double-clic : garder la fenetre ouverte
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
