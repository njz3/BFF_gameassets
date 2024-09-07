@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

:: Set CAB_ID
CALL set_cab_id.bat

set GAME=WMMT5.xml

:: link to right config
set GAME_PATH="C:\Racecab\Games\Wangan Midnight Maximum Tune 5 - Namco ES3X"
set CFG_SRC=%GAME_PATH%\Fsetting.lua%CAB_ID%.gz
set CFG_DST=%GAME_PATH%\Fsetting.lua.gz
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\Gsetting.lua%CAB_ID%.gz
set CFG_DST=%GAME_PATH%\Gsetting.lua.gz
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT5%CAB_ID%.xml
set CFG_DST=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT5.xml
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
