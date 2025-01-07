@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

:: Set CAB_ID
CALL set_cab_id.bat

set GAME=WMMT5DXPlus.xml

:: link to right config
set GAME_PATH="C:\Racecab\Games\Wangan Midnight Maximum Tune 5DX+"
set CFG_SRC=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT5DXPlus%CAB_ID%.xml
set CFG_DST=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT5DXPlus.xml
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
