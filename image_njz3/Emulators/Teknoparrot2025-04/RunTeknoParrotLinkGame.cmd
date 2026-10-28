@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

:: One launcher for every TeknoParrot game of this folder, in place of
:: one .bat a game. 11 games here, of which 11 need something of
:: their own: they have a :prep_ label below, and that is the whole
:: difference between them and the rest.
::
:: Attract-Mode calls it either with the entry's name, as the
:: TeknoParrot<version> emulator does, or with its AltRomname, as
:: TeknoParrotCmd<version> does - and an AltRomname still carries the
:: .bat extension of the file this script replaces. %~n1 takes the name
:: without extension, so both forms arrive here the same.

set ROM=%~n1
if "%ROM%"=="" ( echo Usage: %~n0 ^<game^> & exit /b 1 )

:: The title BFF reads. Between brackets, and nothing else, so that
:: [id5] can never be taken for the [id58] of another game.
TITLE [%ROM%]

CD /d "%~dp0"

:: Link: the cabinet says which configuration it takes
CALL set_cab_id.bat
CALL :lier_appdata

:: The profile, and the preparation a few games need. A game with no
:: :prep_ label simply has none - 2>NUL swallows the "label not found".
set GAME=%ROM%.xml
set LAUNCH=
CALL :prep_%ROM% 2>NUL

if not defined LAUNCH set LAUNCH=TeknoParrotUi.exe --profile=%GAME% --startMinimized
%LAUNCH%

:: After the game, for the few that need it
CALL :post_%ROM% 2>NUL

EXIT


:: --------------------------------------------------------------------
:: Bascule des NVRAM de %APPDATA%\TeknoParrot sur le mode courant
:: --------------------------------------------------------------------
:: TeknoParrot ecrit l'eprom et la sram de chaque jeu dans son dossier
:: utilisateur, toujours au meme nom : il ne sait pas distinguer le solo du
:: link. On fait donc pointer le nom qu'il lit sur la variante du mode
:: courant, par un lien dur - le jeu ecrit alors directement dans la bonne
:: variante, sans recopie a la sortie.
::
:: Generique : tout fichier *_e2prom.bin ou *_sram.bin est traite, sans
:: table de correspondance entre les jeux et leurs codes SB**.
::
:: La variante est amorcee depuis le fichier vivant si elle n'existe pas
:: encore, et un echec de mklink laisse une copie : jamais de fichier perdu.
:lier_appdata
set "TPDATA=%APPDATA%\TeknoParrot"
if not exist "%TPDATA%" goto :eof
for /f "delims=" %%f in ('dir /b "%TPDATA%\*_e2prom.bin" "%TPDATA%\*_sram.bin" 2^>nul') do (
    call :lier_un "%TPDATA%\%%f" "%TPDATA%\%%~nf%CAB_ID%%%~xf"
)
goto :eof

:lier_un
if not exist %2 copy /Y %1 %2 >nul
del /F /Q %1 >nul 2>&1
mklink /H %1 %2 >nul 2>&1
if not exist %1 copy /Y %2 %1 >nul
goto :eof

:: --------------------------------------------------------------------
:: One block a game, copied from its link .bat
:: --------------------------------------------------------------------

:prep_Daytona3USANSE_link
set GAME=Daytona3NSE.xml
set GAME_PATH="C:\Racecab\Games\Daytona Championship USA New Season Edition\Sega"
set CFG_SRC=%GAME_PATH%\GameData\config%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\GameData\config.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\shell\Game%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\shell\Game.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\ShellData\ShellData%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\ShellData\ShellData.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
goto :eof

:prep_Daytona3USA_link
set GAME=Daytona3.xml
set GAME_PATH="C:\Racecab\Games\Daytona Championship USA\Sega"
set CFG_SRC=%GAME_PATH%\GameData\config%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\GameData\config.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\shell\Game%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\shell\Game.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\ShellData\ShellData%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\ShellData\ShellData.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
goto :eof

:prep_GRID_link
set GAME=GRID.xml
set GAME_PATH="C:\Sega"
set CFG_SRC=%GAME_PATH%\shell\Game%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\shell\Game.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\ShellData\ShellData%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\ShellData\ShellData.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
goto :eof

:prep_HummerExtreme_link
set GAME=hummerextreme.xml
goto :eof

:prep_MKDX_link
set GAME=MKDX.xml
:: Le serveur du jeu, puis RETOUR : sans cela le lancement se ferait
:: depuis Serveur_MKDX, ou TeknoParrotUi.exe n'est pas.
CD ..\Serveur_MKDX
CALL startServerMKDX.bat
CD /d "%~dp0"
goto :eof

:post_MKDX_link
CD ..\Serveur_MKDX
CALL killServerMKDX.bat
goto :eof

:prep_OutRun2spdx_link
set GAME=or2spdlx.xml
goto :eof

:prep_WMMT3_link
set GAME=WMMT3.xml
set CFG_SRC=%~dp0UserProfiles\WMMT3%CAB_ID%.xml
set CFG_DST=%~dp0UserProfiles\WMMT3.xml
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
goto :eof

:prep_WMMT5DX_link
set GAME=WMMT5DXPlus.xml
set GAME_PATH="C:\Racecab\Games\Wangan Midnight Maximum Tune 5DX+"
set CFG_SRC=%~dp0UserProfiles\WMMT5DXPlus%CAB_ID%.xml
set CFG_DST=%~dp0UserProfiles\WMMT5DXPlus.xml
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
goto :eof

:prep_WMMT5_link
set GAME=WMMT5.xml
set GAME_PATH="C:\Racecab\Games\Wangan Midnight Maximum Tune 5 - Namco ES3X"
set CFG_SRC=%GAME_PATH%\Fsetting.lua%CAB_ID%.gz
set CFG_DST=%GAME_PATH%\Fsetting.lua.gz
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\Gsetting.lua%CAB_ID%.gz
set CFG_DST=%GAME_PATH%\Gsetting.lua.gz
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%~dp0UserProfiles\WMMT5%CAB_ID%.xml
set CFG_DST=%~dp0UserProfiles\WMMT5.xml
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
goto :eof

:prep_WMMT6_link
set GAME=WMMT6.xml
set GAME_PATH=%~dp0..\..\Games\Wangan Midnight Maximum Tune 6 - Namco ES3B
set CFG_SRC="%GAME_PATH%\TP\setting.lua%CAB_ID%.gz"
set CFG_DST="%GAME_PATH%\TP\setting.lua.gz"
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%~dp0UserProfiles\WMMT6%CAB_ID%.xml
set CFG_DST=%~dp0UserProfiles\WMMT6.xml
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
goto :eof

:prep_or2spdlx_link
set GAME=or2spdlx.xml
:: Le profil porte l'adresse de CETTE cabine : on fait pointer le nom
:: que TeknoParrot lit sur la variante du mode courant.
set CFG_SRC=%~dp0UserProfiles\or2spdlx%CAB_ID%.xml
set CFG_DST=%~dp0UserProfiles\or2spdlx.xml
if not exist %CFG_SRC% copy /Y %CFG_DST% %CFG_SRC% >nul
del /F /Q %CFG_DST% >nul 2>&1
mklink /H %CFG_DST% %CFG_SRC% >nul 2>&1
if not exist %CFG_DST% copy /Y %CFG_SRC% %CFG_DST% >nul
goto :eof

:aide
:: Sans argument : la syntaxe et les noms de jeu possibles, par
:: Utils\AideLanceur.ps1 (chemin normalise : les dossiers Demul ont des [ ])
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
:: Lance par un double-clic : garder la fenetre ouverte
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
