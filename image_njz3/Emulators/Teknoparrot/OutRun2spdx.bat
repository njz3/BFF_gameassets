@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set CAB_ID=_single

set GAME=or2spdlx.xml

:: link to right config for link mode
set CFG_SRC=%APPDATA%\Teknoparrot\SBMB_e2prom%CAB_ID%.bin
set CFG_DST=%APPDATA%\Teknoparrot\SBMB_e2prom.bin
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
