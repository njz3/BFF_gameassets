@ECHO ON

:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set CAB_ID=_single

set GAME=WMMT5.xml

::Copy config
set GAME_PATH="C:\Racecab\Games\Wangan Midnight Maximum Tune 5 - Namco ES3X"
set CFG_SRC=%GAME_PATH%\Fsetting.lua%CAB_ID%.gz
set CFG_DST=%GAME_PATH%\Fsetting.lua.gz
XCOPY /Y /C %CFG_SRC% %CFG_DST%
set CFG_SRC=%GAME_PATH%\Gsetting.lua%CAB_ID%.gz
set CFG_DST=%GAME_PATH%\Gsetting.lua.gz
XCOPY /Y /C %CFG_SRC% %CFG_DST%
set CFG_SRC=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT5%CAB_ID%.xml
set CFG_DST=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT5.xml
XCOPY /Y /C %CFG_SRC% %CFG_DST%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
