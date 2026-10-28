:: Lance un jeu Linux par linuxloader, a la convention de l image.
:: Variante BRUTE : le seul ecart avec RunLinuxLoaderGame.cmd est le
:: titre, [%ROM%_raw], qui designe a BFF son profil brut. Les options
:: sont les memes dans les deux modes (voir [Outputs] de linuxloader.ini).
::
:: linuxloader prend le CHEMIN du binaire en argument, pas un nom de set :
:: la traduction se fait ici, un jeu par ligne. Tous les chemins pointent
:: dans C:\Racecab\Games, a cote des autres emulateurs.
::
:: Les noms sont ceux de TeknoParrot quand le jeu y existe aussi, pour que
:: BFF retrouve le meme profil de retour de force quel que soit le lanceur.
:: Un alias court est accepte en plus (la casse est ignoree).
::
:: Appel : %~nx0 <nom>   par exemple DeadHeat
@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
if "%ROM%"=="" (
    echo Usage : %~nx0 ^<nom du jeu^>
    exit /b 1
)
:: set the title to match the name of the game
TITLE [%ROM%_raw]

:: Change current directory to the folder that contains this file
CD /d "%~dp0"

set JEUX=C:\Racecab\Games
set GAME=
if /I "%ROM%"=="DeadHeat"         set "GAME=%JEUX%\Dead Heat - Namco ES1\a.elf"
if /I "%ROM%"=="DeadHeatRiders"   set "GAME=%JEUX%\Dead Heat Riders - Namco N2\a.elf"
if /I "%ROM%"=="dhriders"         set "GAME=%JEUX%\Dead Heat Riders - Namco N2\a.elf"
if /I "%ROM%"=="GaelcoTR"         set "GAME=%JEUX%\Gaelco Championship Tuning Race - Gaelco PC Based\home\joc2001\joc2004\salidas\car"
if /I "%ROM%"=="HummerXT"         set "GAME=%JEUX%\Hummer Extreme - SEGA Lindbergh\disk0\hummer_Master.elf"
if /I "%ROM%"=="ID4Exp"           set "GAME=%JEUX%\Initial D 4 Export (Fr Traduction) - SEGA Lindbergh\id4.elf"
if /I "%ROM%"=="ID4Jap"           set "GAME=%JEUX%\Initial D 4 - SEGA Lindbergh\id4.elf"
if /I "%ROM%"=="ID5"              set "GAME=%JEUX%\Initial D 5 Export - SEGA Lindbergh\id5.exe"
if /I "%ROM%"=="MaxHeat3D"        set "GAME=%JEUX%\Maximum Heat 3D - Namco ES1\a.elf"
if /I "%ROM%"=="Nirin"            set "GAME=%JEUX%\Nirin - Namco ES1\exec\a.elf"
if /I "%ROM%"=="or2spdlx"         set "GAME=%JEUX%\Outrun 2 SP SDX - SEGA Lindbergh\disk0\Jennifer\Jennifer"
if /I "%ROM%"=="or2spsdx"         set "GAME=%JEUX%\Outrun 2 SP SDX - SEGA Lindbergh\disk0\Jennifer\Jennifer"
if /I "%ROM%"=="RingRiders"       set "GAME=%JEUX%\Ring Riders - Gaelco PC Based\home\joc2001\joc2003\salidas\gameport"
if /I "%ROM%"=="RTuned"           set "GAME=%JEUX%\R-Tuned Ultimate Street Racing - SEGA Lindbergh\dsr_HD_FFB"
if /I "%ROM%"=="segartv"          set "GAME=%JEUX%\Sega Race TV - SEGA Lindbergh\drive.elf"
if /I "%ROM%"=="racetv"           set "GAME=%JEUX%\Sega Race TV - SEGA Lindbergh\drive.elf"
if /I "%ROM%"=="TokyoCop"         set "GAME=%JEUX%\Tokyo Cop - Gaelko PC Based\home\joc2001\joc2001\salidas\gameport"
if /I "%ROM%"=="WMMT3"            set "GAME=%JEUX%\Wangan Midnight Maximum Tune 3 (Export) - Namco N2\main"
if /I "%ROM%"=="WMMT3DXP"         set "GAME=%JEUX%\Wangan Midnight Maximum Tune 3DX+ (Japan) - Namco N2\main"

if not defined GAME (
    echo Jeu inconnu : "%ROM%"
    exit /b 2
)
if not exist "%GAME%" (
    echo Binaire introuvable : "%GAME%"
    exit /b 3
)

:: Dossier d ecriture unique (bornes sous UWF). Vide par defaut : chaque
:: jeu ecrit alors a cote de son binaire, comportement d origine.
:: Un WRITEDIR_ROOT deja pose dans l environnement a la main sur le
:: reglage de Utils\set_writedir.bat, pratique pour un essai.
:: Le suffixe suit la convention de l image : <emulateur>_<variante>.
set VARIANTE=single
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=--write-dir "%WRITEDIR_ROOT%\linuxloader_%VARIANTE%"

:: Lunch emulator
:: Affichage selon la resolution : DISPLAY_MODE de linuxloader.ini (gabarit de Build-Config, colonne MODE_FENETRE).
linuxloader.exe "%GAME%" %ECRITURE%

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
