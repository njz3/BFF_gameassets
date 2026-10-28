:: Lance un jeu Windows par windowsloader, a la convention de l image.
::
:: windowsloader prend le CHEMIN COMPLET du programme du jeu, suivi des
:: arguments propres au jeu : la traduction se fait ici, un jeu par ligne.
:: Toujours windowsloader.exe, meme pour un jeu 64 bits : il passe la main
:: a windowsloader64.exe tout seul.
::
:: Pas de --fullscreen : le jeu tourne en fenetre SANS BORDURE, reglee par
:: DISPLAY_MODE = BORDERLESS dans windowsloader.ini, a cote du lanceur.
::
:: Les noms sont ceux de TeknoParrot quand le jeu y existe aussi, pour que
:: BFF retrouve le meme profil de retour de force quel que soit le lanceur.
::
:: Dossier d ecriture (bornes sous UWF) : Saves\windowsloader_single. Ce que
:: le jeu ecrit va dans <ce dossier>\<jeu>, le dossier du jeu n est que lu.
::
:: Appel : %~nx0 <nom>   par exemple SR3
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
TITLE [%ROM%]

:: Change current directory to the folder that contains this file
CD /d "%~dp0"

set GAME=
set GARGS=
if /I "%ROM%"=="SR3"                     set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - Original\Rally\Rally.exe"
if /I "%ROM%"=="SR3StandardEdition"      set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - StandardEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3AlpineEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - AlpineEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3ArticEdition"         set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - ArticEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3CanyonEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - CanyonEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3MasterEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - MasterEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3SafariEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - SafariEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3TropicalEdition"      set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - TropicalEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3TropicalEdition478"   set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - TropicalEdition478\Rally\Rally.exe"
if /I "%ROM%"=="Daytona3"                set "GAME=C:\Racecab\Games\Daytona Championship USA\Sega\Daytona\Daytona.exe"
if /I "%ROM%"=="Daytona3NSE"             set "GAME=C:\Racecab\Games\Daytona Championship USA New Season Edition\Sega\Daytona\Daytona.exe"
if /I "%ROM%"=="FR"                      set "GAME=C:\Racecab\Games\Ford Racing Full Blown - SEGA Arcade PC Based\FordRacing\fordracing.exe"
if /I "%ROM%"=="ID6"                     set "GAME=C:\Racecab\Games\Initial D 6 AA - SEGA Ringedge\id6_dump_.exe"
if /I "%ROM%"=="ID7"                     set "GAME=C:\Racecab\Games\Initial D 7 AAX - SEGA Ringedge\InitialD7_GLW_RE_SBYD_dumped_.exe"
if /I "%ROM%"=="ID8"                     set "GAME=C:\Racecab\Games\Initial D 8 Infinity - SEGA Ringedge\InitialD8_GLW_RE_SBZZ_redumped_.exe"
if /I "%ROM%"=="GRID"                    set "GAME=C:\Sega\Grid\GRID.exe"
if /I "%ROM%"=="SRC"                     set "GAME=C:\Sega Racing Classic\d1a.exe"
if /I "%ROM%"=="Showdown"                set "GAME=C:\Racecab\Games\Showdown  - SEGA Arcade PC Based\Showdown\Showdown.exe"
if /I "%ROM%"=="KODrive"                 set "GAME=C:\Racecab\Games\K.O. Drive  - SEGA Ringwide\exe\M-DriveR_RingWide.exe"
if /I "%ROM%"=="SSASR"                   set "GAME=C:\Racecab\Games\Sonic & Sega All Stars Racing - SEGA Ringwide\game.exe"
if /I "%ROM%"=="BattleGear4Tuned"        set "GAME=C:\Racecab\Games\Battle Gear 4 Tuned 2.8 - Taito Type X +\game.exe"
if /I "%ROM%"=="BattleGear4Tuned"        set "GARGS=_MTS_FULL_SCREEN_"
if /I "%ROM%"=="BattleGear4Pro"          set "GAME=C:\Racecab\Games\Battle Gear 4 Tuned 2.8 Professional Edition - Taito Type X +\game.exe"
if /I "%ROM%"=="BattleGear4Pro"          set "GARGS=_MTS_FULL_SCREEN_"
if /I "%ROM%"=="BattleGear4"             set "GAME=C:\Racecab\Games\Battle Gear 4 - Taito Type X+\game.exe"
if /I "%ROM%"=="BattleGear4"             set "GARGS=_MTS_FULL_SCREEN_"
if /I "%ROM%"=="ChaseHQ2"                set "GAME=C:\Racecab\Games\Chase H.Q. 2 - Taito Type X 2\game.exe"
if /I "%ROM%"=="GtiClub3"                set "GAME=C:\Racecab\Games\GTI Club Super Mini Fiesta - Konami PC Based\gti3.exe"
if /I "%ROM%"=="WastelandRacers"         set "GAME=C:\Racecab\Games\Wasteland Racers 2071 - Trio Tech PC Based\Arcade.exe"
if /I "%ROM%"=="MKDX118"                 set "GAME=C:\Racecab\Games\Mario Kart Arcade GP DX V1.18 - Namco ES3\MK_AGP3_FINAL.exe"
if /I "%ROM%"=="MKDX"                    set "GAME=C:\Racecab\Games\Mario Kart Arcade GP DX (V1.10 - Mod FR 1h) - Namco ES3\MK_AGP3_FINAL.exe"
if /I "%ROM%"=="D1GP"                    set "GAME=C:\Racecab\Games\D1GP Arcade - Taito Type X2\game.exe"
if /I "%ROM%"=="LGS"                     set "GAME=C:\Racecab\Games\Let's Go Safari - SEGA Ringwide\GameSampR_RingWide.exe"
if /I "%ROM%"=="SRG"                     set "GAME=C:\Racecab\Games\Storm Racer G - SEGA Arcade PC Based\bin\racing.exe"
if /I "%ROM%"=="WackyRaces"              set "GAME=C:\Racecab\Games\Wacky Races - Taito Type X 2\Launcher.exe"
if /I "%ROM%"=="VirtuaRLimit"            set "GAME=C:\Racecab\Games\Valve Limit R - Taito Type X\launcher.exe"
if /I "%ROM%"=="CrazyRide"               set "GAME=C:\Racecab\Games\Crazy Ride (V1.9.0) - UNIS PC Based\Crazy Ride\SysStart\Game\CrazyCab\CrazyTaxiGame\Binaries\Win64\CrazyTaxiGame-Win64-Shipping.exe"
if /I "%ROM%"=="WMMT5"                   set "GAME=C:\Racecab\Games\Wangan Midnight Maximum Tune 5 - Namco ES3X\wmn5r.exe"
if /I "%ROM%"=="WMMT5DXPlus"             set "GAME=C:\Racecab\Games\Wangan Midnight Maximum Tune 5DX+\wmn5r.exe"
if /I "%ROM%"=="SWDC"                    set "GAME=C:\Racecab\Games\Sega World Drivers Championship - SEGA ALLS\App\Todoroki\WindowsNoEditor\Todoroki\Binaries\Win64\Todoroki-Win64-Shipping.exe"
:: SWDC : -windowed, sans quoi la fenetre reste reduite ; amdaemon.exe est lance par windowsloader
if /I "%ROM%"=="SWDC"                    set "GARGS=-windowed"
:: Initial D Zero : le programme du jeu, pas start.bat ; amdaemon.exe et ServerBoxD8_Nu_x64.exe sont lances par windowsloader
if /I "%ROM%"=="IDZTP"                   set "GAME=C:\Racecab\Games\Initial D Arcade Stage Zero v1.31 - SEGA NU\app\package\InitialD0_DX11_Nu.exe"
if /I "%ROM%"=="IDZv2TP"                 set "GAME=C:\Racecab\Games\Initial D Arcade Stage Zero v2.30 - SEGA NU\InitialD0_DX11_Nu.exe"
if /I "%ROM%"=="FrenzyExpress"           set "GAME=C:\Racecab\Games\Frenzy Express - Uniana PC Based\xwin.exe"
if /I "%ROM%"=="StormRider"              set "GAME=C:\Racecab\Games\Storm Rider V1.2.6 - WAHLAP PC Based\Ntfs\all_test\game\Gold\motobike.exe"
if /I "%ROM%"=="WMMT6"                   set "GAME=C:\Racecab\Games\Wangan Midnight Maximum Tune 6 - Namco ES3B\wmn6r.exe"

if not defined GAME (
    echo Jeu inconnu : "%ROM%"
    exit /b 2
)
if not exist "%GAME%" (
    echo Programme introuvable : "%GAME%"
    exit /b 3
)

:: Lunch emulator
:: Affichage selon la resolution : DISPLAY_MODE de windowsloader.ini (gabarit de Build-Config, colonne MODE_FENETRE).
:: Les options de windowsloader passent AVANT le chemin du jeu.
set VARIANTE=single
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=--write-dir "%WRITEDIR_ROOT%\windowsloader_%VARIANTE%"
windowsloader.exe %ECRITURE% "%GAME%" %GARGS%

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
