:: Lance un jeu Windows par windowsloader EN LINK, a la convention de l image.
::
:: Seuls les jeux dont windowsloader porte le link sont ici. Le titre de
:: console reste [nom], comme en solo : BFF garde le meme profil.
::
:: L identite de la cabine vient de Utils\set_cab_id.bat (_link_cab1 ou
:: _link_cab2), jamais de l adresse IP du PC ; ses adresses viennent de
:: Utils\set_cab_network<CAB_ID>.bat (LOCALIP, NEXTIP), comme pour MAME et
:: linuxloader.
::
:: Mario Kart Arcade GP DX (1.18 et 1.10) : [Game.mkdx] LINK = les adresses
:: des cabines, la cabine 1 en premier, la meme liste partout ; CABINET = le
:: numero de cette cabine. Le PCB-ID du jeu (menu de test) doit etre different
:: sur chaque borne : deux bornes au meme PCB-ID donnent E24-03.
::
:: Les autres jeux : [Game.<nom court>] LINK seulement, windowsloader en tire
:: le numero de la cabine (windowsloader 20261031-4 ; chacun a fait une course
:: a deux sur racecab1 et racecab2 le 31/10/2026). Les reglages du menu de test
:: sont dans le dossier d ecriture, un par variante : ceux du link ne touchent
:: pas le solo.
:: - GTI Club : CABINET ID du menu de test (NETWORK OPTIONS), different sur
::   chaque borne.
:: - Valve Limit R : un calibrage des pedales au premier lancement (menu de
::   test, levier de vitesses pour se deplacer, Start pour choisir).
:: - Wacky Races, D1GP, Valve Limit R, Chase H.Q. 2 : DirectPlay de Windows
::   doit etre actif.
:: - Chase H.Q. 2 : un etalonnage volant et pedales au premier lancement
::   (menu de test, Nitro pour descendre, Start pour choisir).
:: - Sonic & Sega All-Stars Racing : CABINET ID = 1 ou 2 (GAME ASSIGNMENTS de
::   gametest.exe), 1 en solo.
:: - Sega Racing Classic : cabine 1 START UP MODE = MAIN, TOTAL NODES = 2 ;
::   cabine 2 START UP MODE = SUB, CAR NUMBER = 2 (GAME ASSIGNMENTS de
::   d1a.exe -t ; le 1 est celui de la MAIN).
::
:: Appel : %~nx0 <nom>   par exemple MKDX118
@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

set ROM=%~1
if "%ROM%"=="" (
    echo Usage : %~nx0 ^<nom du jeu^>
    exit /b 1
)
TITLE [%ROM%]
CD /d "%~dp0"

set GAME=
set GARGS=
set NUMERO=
if /I "%ROM%"=="MKDX118"                 set "GAME=C:\Racecab\Games\Mario Kart Arcade GP DX V1.18 - Namco ES3\MK_AGP3_FINAL.exe"
if /I "%ROM%"=="MKDX118"                 set "NUMERO=1"
if /I "%ROM%"=="MKDX"                    set "GAME=C:\Racecab\Games\Mario Kart Arcade GP DX (V1.10 - Mod FR 1h) - Namco ES3\MK_AGP3_FINAL.exe"
if /I "%ROM%"=="MKDX"                    set "NUMERO=1"
if /I "%ROM%"=="SSASR"                   set "GAME=C:\Racecab\Games\Sonic & Sega All Stars Racing - SEGA Ringwide\game.exe"
if /I "%ROM%"=="SRC"                     set "GAME=C:\Sega Racing Classic\d1a.exe"
:: Sega Rally 3 : une borne choisit Quick Race, l autre appuie sur Start
:: pendant son decompte de 15 s. Les editions speciales ne marchent qu en
:: link : elles passent ici, et non plus par TeknoParrot (03/11/2026).
if /I "%ROM%"=="SR3"                     set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - Original\Rally\Rally.exe"
if /I "%ROM%"=="SR3AlpineEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - AlpineEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3ArticEdition"         set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - ArticEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3CanyonEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - CanyonEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3MasterEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - MasterEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3SafariEdition"        set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - SafariEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3TropicalEdition"      set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - TropicalEdition\Rally\Rally.exe"
if /I "%ROM%"=="SR3TropicalEdition478"   set "GAME=C:\Racecab\Games\Sega Rally 3 - SEGA Europa R - TropicalEdition478\Rally\Rally.exe"
if /I "%ROM%"=="Daytona3"                set "GAME=C:\Racecab\Games\Daytona Championship USA\Sega\Daytona\Daytona.exe"
:: Daytona 3 NSE : course a deux verifiee le 31/10/2026, comme Daytona 3
if /I "%ROM%"=="Daytona3NSE"             set "GAME=C:\Racecab\Games\Daytona Championship USA New Season Edition\Sega\Daytona\Daytona.exe"
:: Wangan Midnight 5, 5 DX+ et 6 : windowsloader 20261102-1 et plus ; rien a regler au
:: menu de test (PCB ID et numero de cle donnes par borne). Le defi se fait en
:: jeu : une borne accepte le VS (ecran a l inscription, ou Interruption en
:: course), l autre repond YES a "Challenge other racers?" apres la boite
if /I "%ROM%"=="WMMT5"                   set "GAME=C:\Racecab\Games\Wangan Midnight Maximum Tune 5 - Namco ES3X\wmn5r.exe"
if /I "%ROM%"=="WMMT5DXPlus"             set "GAME=C:\Racecab\Games\Wangan Midnight Maximum Tune 5DX+\wmn5r.exe"
if /I "%ROM%"=="WMMT6"                   set "GAME=C:\Racecab\Games\Wangan Midnight Maximum Tune 6 - Namco ES3B\wmn6r.exe"
if /I "%ROM%"=="FR"                      set "GAME=C:\Racecab\Games\Ford Racing Full Blown - SEGA Arcade PC Based\FordRacing\fordracing.exe"
if /I "%ROM%"=="GRID"                    set "GAME=C:\Sega\Grid\GRID.exe"
if /I "%ROM%"=="Showdown"                set "GAME=C:\Racecab\Games\Showdown  - SEGA Arcade PC Based\Showdown\Showdown.exe"
if /I "%ROM%"=="GtiClub3"                set "GAME=C:\Racecab\Games\GTI Club Super Mini Fiesta - Konami PC Based\gti3.exe"
if /I "%ROM%"=="WastelandRacers"         set "GAME=C:\Racecab\Games\Wasteland Racers 2071 - Trio Tech PC Based\Arcade.exe"
if /I "%ROM%"=="BattleGear4Tuned"        set "GAME=C:\Racecab\Games\Battle Gear 4 Tuned 2.8 - Taito Type X +\game.exe"
if /I "%ROM%"=="BattleGear4Tuned"        set "GARGS=_MTS_FULL_SCREEN_"
if /I "%ROM%"=="BattleGear4"             set "GAME=C:\Racecab\Games\Battle Gear 4 - Taito Type X+\game.exe"
if /I "%ROM%"=="BattleGear4"             set "GARGS=_MTS_FULL_SCREEN_"
if /I "%ROM%"=="D1GP"                    set "GAME=C:\Racecab\Games\D1GP Arcade - Taito Type X2\game.exe"
if /I "%ROM%"=="WackyRaces"              set "GAME=C:\Racecab\Games\Wacky Races - Taito Type X 2\Launcher.exe"
if /I "%ROM%"=="VirtuaRLimit"            set "GAME=C:\Racecab\Games\Valve Limit R - Taito Type X\launcher.exe"
:: Chase H.Q. 2 : windowsloader 20261101-1 et plus ; la cabine 1 heberge,
:: la lancer la premiere (environ 20 s avant l autre)
if /I "%ROM%"=="ChaseHQ2"                set "GAME=C:\Racecab\Games\Chase H.Q. 2 - Taito Type X 2\game.exe"
:: K.O. Drive : windowsloader 20261101-2 et plus ; rien a regler au menu de
:: test, la cabine 1 mene la course. Pare-feu actif : laisser entrer UDP 11882
if /I "%ROM%"=="KODrive"                 set "GAME=C:\Racecab\Games\K.O. Drive  - SEGA Ringwide\exe\M-DriveR_RingWide.exe"
:: Storm Racer G : windowsloader 20261101-3 et plus ; les bornes se trouvent
:: par multicast (234.7.7.7:5002), course commune verifiee le 01/11/2026
if /I "%ROM%"=="SRG"                     set "GAME=C:\Racecab\Games\Storm Racer G - SEGA Arcade PC Based\bin\racing.exe"
:: Storm Rider : windowsloader 20261101-5 et plus ; la premiere moto qui lance
:: une course la sert, l autre la rejoint (course a deux verifiee le 01/11/2026)
if /I "%ROM%"=="StormRider"              set "GAME=C:\Racecab\Games\Storm Rider V1.2.6 - WAHLAP PC Based\Ntfs\all_test\game\Gold\motobike.exe"
:: Crazy Ride : windowsloader 20261101-6 et plus ; Start deux fois, puis
:: l ecran "Searching for other players" reunit les bornes (Linking succeed)
if /I "%ROM%"=="CrazyRide"               set "GAME=C:\Racecab\Games\Crazy Ride (V1.9.0) - UNIS PC Based\Crazy Ride\SysStart\Game\CrazyCab\CrazyTaxiGame\Binaries\Win64\CrazyTaxiGame-Win64-Shipping.exe"
if not defined GAME (
    echo Jeu sans link connu : "%ROM%"
    exit /b 2
)
if not exist "%GAME%" (
    echo Programme introuvable : "%GAME%"
    exit /b 3
)

:: Identite et adresses de la cabine
CALL "..\..\Utils\set_cab_id.bat"
if /I "%CAB_ID%"=="_single" (
    echo Cette borne n a pas de place en link : Utils\set_cab_id.bat dit _single
    exit /b 4
)
if not exist "..\..\Utils\set_cab_network%CAB_ID%.bat" (
    echo Adresses absentes : Utils\set_cab_network%CAB_ID%.bat
    exit /b 5
)
CALL "..\..\Utils\set_cab_network%CAB_ID%.bat"
:: Deux bornes : la cabine 1 est celle de _link_cab1, l autre est la suivante
if /I "%CAB_ID%"=="_link_cab1" (set "IP1=%LOCALIP%" & set "IP2=%NEXTIP%" & set "NUM=1") else (set "IP1=%NEXTIP%" & set "IP2=%LOCALIP%" & set "NUM=2")

:: Reglages du jeu lance ([Game.<nom court>] par --set Game.CLE=VALEUR) ;
:: CABINET seulement pour les jeux qui le lisent (NUMERO)
set RESEAU=--set "Game.LINK=%IP1%,%IP2%"
if defined NUMERO set RESEAU=%RESEAU% --set Game.CABINET=%NUM%

:: Dossier d ecriture (bornes sous UWF) : Saves\windowsloader<CAB_ID>. Ce que
:: le jeu ecrit va dans <ce dossier>\<jeu>, le dossier du jeu n est que lu
set VARIANTE=%CAB_ID:~1%
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=--write-dir "%WRITEDIR_ROOT%\windowsloader_%VARIANTE%"

windowsloader.exe %ECRITURE% %RESEAU% "%GAME%" %GARGS%

EXIT

:aide
:: Sans argument : la syntaxe et les noms de jeu possibles, par
:: Utils\AideLanceur.ps1 (chemin normalise : les dossiers Demul ont des [ ])
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
:: Lance par un double-clic : garder la fenetre ouverte
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
