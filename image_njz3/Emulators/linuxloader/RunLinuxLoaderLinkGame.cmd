:: Lance un jeu Linux par linuxloader EN LINK, a la convention de l image.
::
:: Seuls les jeux qui ont un vrai mode reseau sont ici. Le titre de console
:: reste [nom], comme en solo : BFF garde le meme profil.
::
:: L identite de la cabine vient de Utils\set_cab_id.bat (_link_cab1 ou
:: _link_cab2), jamais de l adresse IP du PC ; ses adresses viennent de
:: Utils\set_cab_network<CAB_ID>.bat (LOCALIP, NEXTIP), comme pour MAME.
::
:: Le reglage du link propre a chaque jeu (numero de cabine ou de siege,
:: maitre ou esclave) est dans ses NVRAM, sous
::   <WRITEDIR_ROOT>\linuxloader<CAB_ID>\<jeu>\
:: posees depuis un modele capture au menu de service, comme pour Supermodel
:: et sm2-emu. Le solo garde les siennes dans linuxloader_single.
::
:: Appel : %~nx0 <nom> [test]   par exemple or2spdlx
::   test : demarre le jeu dans son menu de test, avec les reglages link de la
::   borne, pour y regler le numero de cabine ou de siege.
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

set JEUX=C:\Racecab\Games
set GAME=
if /I "%ROM%"=="DeadHeat"         set "GAME=%JEUX%\Dead Heat - Namco ES1\a.elf"
if /I "%ROM%"=="DeadHeatRiders"   set "GAME=%JEUX%\Dead Heat Riders - Namco N2\a.elf"
if /I "%ROM%"=="GaelcoTR"         set "GAME=%JEUX%\Gaelco Championship Tuning Race - Gaelco PC Based\home\joc2001\joc2004\salidas\car"
if /I "%ROM%"=="HummerXT"         set "GAME=%JEUX%\Hummer Extreme - SEGA Lindbergh\disk0\hummer_Master.elf"
if /I "%ROM%"=="ID4Exp"           set "GAME=%JEUX%\Initial D 4 Export (Fr Traduction) - SEGA Lindbergh\id4.elf"
:: Pas d Initial D 4 japonais : son link passe par un routeur et un DHCP
:: (192.168.37.254) que le chargeur ne remplace pas, meme sous Linux.
if /I "%ROM%"=="ID5"              set "GAME=%JEUX%\Initial D 5 Export - SEGA Lindbergh\id5.exe"
if /I "%ROM%"=="MaxHeat3D"        set "GAME=%JEUX%\Maximum Heat 3D - Namco ES1\a.elf"
:: Nirin : duel, une borne repond YES a Accept challengers? et court, l autre
:: repond YES a Challenge rivals? (link verifie le 01/11/2026)
if /I "%ROM%"=="Nirin"            set "GAME=%JEUX%\Nirin - Namco ES1\exec\a.elf"
if /I "%ROM%"=="or2spdlx"         set "GAME=%JEUX%\Outrun 2 SP SDX - SEGA Lindbergh\disk0\Jennifer\Jennifer"
if /I "%ROM%"=="RingRiders"       set "GAME=%JEUX%\Ring Riders - Gaelco PC Based\home\joc2001\joc2003\salidas\gameport"
if /I "%ROM%"=="RTuned"           set "GAME=%JEUX%\R-Tuned Ultimate Street Racing - SEGA Lindbergh\dsr_HD_FFB"
if /I "%ROM%"=="segartv"          set "GAME=%JEUX%\Sega Race TV - SEGA Lindbergh\drive.elf"
if /I "%ROM%"=="TokyoCop"         set "GAME=%JEUX%\Tokyo Cop - Gaelko PC Based\home\joc2001\joc2001\salidas\gameport"
if /I "%ROM%"=="WMMT3"            set "GAME=%JEUX%\Wangan Midnight Maximum Tune 3 (Export) - Namco N2\main"
:: Maximum Tune 3DX+ : linuxloader 20261101 et plus (cle HASP) ; reglage de
:: la borne dans tmp\data\etc\testmode.lua (pas tmp\data comme Maximum Tune 3).
:: Duel : une borne choisit Accepting VS et court, l autre repond YES a
:: Buy in race and challenge.
if /I "%ROM%"=="WMMT3DXP"         set "GAME=%JEUX%\Wangan Midnight Maximum Tune 3DX+ (Japan) - Namco N2\main"
if not defined GAME (
    echo Jeu sans link connu : "%ROM%"
    exit /b 2
)
if not exist "%GAME%" (
    echo Binaire introuvable : "%GAME%"
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
if /I "%CAB_ID%"=="_link_cab1" (set "IP1=%LOCALIP%" & set "IP2=%NEXTIP%") else (set "IP1=%NEXTIP%" & set "IP2=%LOCALIP%")

:: Reseau des jeux (linuxloader 20261026 et plus). Le chargeur donne au jeu
:: l adresse de la borne quand une de ses cles est une adresse de ce PC :
::   OutRun 2       OR2_IPADDRESS = cette borne (le jeu deduit l autre de
::                  son LINK ID : LINK ID 1 = .4, LINK ID 2 = .5)
::   Hummer         IP_CAB1..4 = la liste des cabines, la meme partout ;
::                  3 et 4 sur des adresses libres (le defaut .4/.5 tombe
::                  sur les bornes)
::   Sega Race TV   SRTV_IPADDRESS = cette borne
::   Initial D 4/5  ID_IP_SEAT_1/2 = les deux sieges, les memes partout
::   Namco (Dead Heat, Dead Heat Riders, Max Heat 3D, Maximum Tune 3),
::   Gaelco (Tuning Race, Ring Riders, Tokyo Cop) et R-Tuned : ces memes
::   cles, le chargeur traduit leurs adresses vers celles des bornes (link
::   verifie avec exactement cette ligne, 31/10/2026)
:: Le numero de cabine ou de siege est dans la NVRAM du jeu (menu de test) :
:: testmode_game_options.bin (Namco ES1/N2), testmode\testmode_game.lua
:: (Nirin : PCB_ID, IS_BATTLE), tmp\data\testmode.lua (Maximum Tune 3),
:: switch.bin (Gaelco), sram.bin (R-Tuned), poses par borne dans
:: saves_link_cabN.
set RESEAU=--set Network.ENABLE_NETWORK_PATCHES=true
set RESEAU=%RESEAU% --set Network.OR2_IPADDRESS=%LOCALIP% --set Network.OR2_NETMASK=255.255.255.0
set RESEAU=%RESEAU% --set Network.SRTV_IPADDRESS=%LOCALIP%
set RESEAU=%RESEAU% --set Network.ID_IP_SEAT_1=%IP1% --set Network.ID_IP_SEAT_2=%IP2%
set RESEAU=%RESEAU% --set Network.IP_CAB1=%IP1% --set Network.IP_CAB2=%IP2%
set RESEAU=%RESEAU% --set Network.IP_CAB3=192.168.1.250 --set Network.IP_CAB4=192.168.1.251

:: Dossier d ecriture : une variante par cabine
set VARIANTE=%CAB_ID:~1%
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
:: Pas de recopie ici : au premier lancement d un jeu, linuxloader (3.0.13 et
:: plus) amorce lui-meme son dossier d ecriture depuis saves\<jeu>, le modele
:: de la cabine pose par Build-Config (FOLDER de targets.csv), puis depuis le
:: dossier du jeu pour le reste. Un fichier deja present n est jamais remplace.
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=--write-dir "%WRITEDIR_ROOT%\linuxloader_%VARIANTE%" --seed-dir saves

set MODE=
if /I "%~2"=="test" set MODE=--test
linuxloader.exe "%GAME%" %ECRITURE% %RESEAU% %MODE%

EXIT

:aide
:: Sans argument : la syntaxe et les noms de jeu possibles, par
:: Utils\AideLanceur.ps1 (chemin normalise : les dossiers Demul ont des [ ])
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
:: Lance par un double-clic : garder la fenetre ouverte
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
