@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
:: set the title to match the name of the game
TITLE [%ROM%]

:: Change current directory to the folder that contains this file
CD /d "%~dp0"

set GAME=../SupermodelRoms/%ROM%.zip
:: Lunch emulator
:: Every option is in Config\Supermodel.ini (Build-Config template)
:: Dossier d ecriture (bornes sous UWF) : Saves\supermodel_single, que
:: Supermodel amorce lui-meme au premier lancement depuis Config et NVRAM en place
set VARIANTE=single
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=-write-dir="%WRITEDIR_ROOT%\supermodel_%VARIANTE%"
supermodel.exe %ECRITURE% %GAME%

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
