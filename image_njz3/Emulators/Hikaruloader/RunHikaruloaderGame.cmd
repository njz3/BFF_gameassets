:: Lance un jeu Hikaru par hikaruloader (njz3), en solo, a la convention de l image.
::
:: Remplace Demul pour Sega Nascar et Star Wars Racer Arcade (03/11/2026).
:: hikaruloader prend le nom de set MAME (-r) et cherche les zip dans
:: Emulators\MameRoms (le jeu, et hikaru.zip pour le BIOS).
::
:: Reglages : hikaruloader.ini a cote de ce lanceur, produit par Build-Config
:: (gabarit hikaruloader.ini.template : sans bordure, etire en
:: super-resolution, region EXPORT, NO_LINK), et controls.ini (vJoy). Le retour
:: de force est le natif : DirectInput vers vJoy, relaye par BFF.
::
:: Dossier d ecriture (bornes sous UWF) : Saves\hikaruloader_single. Au premier
:: lancement, hikaruloader y recopie hikaruloader.ini et controls.ini, puis il
:: n utilise plus que cette copie (Build-Config l efface quand elle n est plus
:: a jour). NVRAM d un jeu : <dossier>\<jeu>\nvram\<jeu>.nvram.
::
:: Quitter : Echap (ou F9). Le titre de la fenetre porte [<set>], que les
:: profils BFF HL-Nascar et HL-StarWarsRacers reconnaissent.
::
:: Appel : %~nx0 <set>   sgnascar ou swracer
@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

set ROM=%~1
TITLE [%ROM%]-Hikaruloader
CD /d "%~dp0"

if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=--write-dir "%WRITEDIR_ROOT%\hikaruloader_single"

hikaruloader.exe -R "C:\Racecab\Emulators\MameRoms" -r %ROM% %ECRITURE%

EXIT

:aide
:: Sans argument : la syntaxe, par Utils\AideLanceur.ps1
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
