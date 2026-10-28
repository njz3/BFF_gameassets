@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
:: set the title to match the name of the game
TITLE [%ROM%]
set GAME=%ROM%

:: Change current directory to the folder that contains this file
CD /d "%~dp0"
:: Normal command. Never START: the console must live as long as the game,
:: so Attract-Mode keeps waiting on it and BFF keeps the title it reads
:: Dossier d ecriture (bornes sous UWF) : Saves\mame_single. MAME y ecrit tout
:: et lit les fichiers en place tant qu il n en a pas enregistre la
set VARIANTE=single
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=-writedir "%WRITEDIR_ROOT%\mame_%VARIANTE%"
mame.exe %GAME% %ECRITURE%

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
