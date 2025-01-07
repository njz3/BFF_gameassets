@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

:: Set CAB_ID
CALL set_cab_id.bat

set GAME=WMMT3.xml

:: link to right config
set CFG_SRC=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT3%CAB_ID%.xml
set CFG_DST=C:\Racecab\Emulators\TeknoParrot\UserProfiles\WMMT3.xml
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
