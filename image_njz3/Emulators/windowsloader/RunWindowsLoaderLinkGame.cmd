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
if /I "%ROM%"=="MKDX118"                 set "GAME=C:\Racecab\Games\Mario Kart Arcade GP DX V1.18 - Namco ES3\MK_AGP3_FINAL.exe"
if /I "%ROM%"=="MKDX"                    set "GAME=C:\Racecab\Games\Mario Kart Arcade GP DX (V1.10 - Mod FR 1h) - Namco ES3\MK_AGP3_FINAL.exe"
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

:: Reglages du jeu lance ([Game.<nom court>] par --set Game.CLE=VALEUR)
set RESEAU=--set "Game.LINK=%IP1%,%IP2%" --set Game.CABINET=%NUM%

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
