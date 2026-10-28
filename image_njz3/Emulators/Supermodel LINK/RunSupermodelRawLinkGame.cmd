:: Lance un jeu Supermodel EN LINK et en mode BRUT (raw).
::
:: La SEULE difference avec RunSupermodelLinkGame.cmd est le titre de la
:: fenetre : [romset_raw] au lieu de [romset]. BFF lit ce nom entre crochets
:: pour choisir son profil, et le suffixe lui permet d'en avoir un distinct
:: qui utilise les octets bruts de la drive board plutot que les effets
:: DirectInput. Les options passees a l'emulateur sont celles du link.
::
:: Appel : RunSupermodelRawLinkGame.cmd <romset>      par exemple lemans24
@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
:: set the title to match the name of the game, with the _raw suffix for BFF
TITLE [%ROM%_raw]

:: Change current directory to the folder that contains this file
CD /d "%~dp0"

set GAME=../SupermodelRoms/%ROM%.zip
:: Lunch emulator
:: Every option is in Config\Supermodel.ini (Build-Config template)
:: Dossier d ecriture (bornes sous UWF) : Saves\supermodel<CAB_ID>, que
:: Supermodel amorce lui-meme au premier lancement depuis Config et NVRAM en
:: place (ceux de la cabine de cette machine, poses par Build-Config)
CALL "..\..\Utils\set_cab_id.bat"
set VARIANTE=%CAB_ID:~1%
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
