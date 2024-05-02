@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

:: Set CAB_ID
CALL set_cab_id.bat

set GAME=or2spdlx.xml

::Copy config
set CFG_SRC=%APPDATA%\Teknoparrot\SBMB_e2prom%CAB_ID%.bin
set CFG_DST=%APPDATA%\Teknoparrot\SBMB_e2prom.bin
XCOPY /Y /C %CFG_SRC% %CFG_DST%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
