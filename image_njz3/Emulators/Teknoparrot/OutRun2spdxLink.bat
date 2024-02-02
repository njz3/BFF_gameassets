@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=or2spdlx.xml
::Copy EPROM for link cab mode
set EPROM_SRC=%APPDATA%\Teknoparrot\SBMB_e2prom_link.bin
set EPROM_DST=%APPDATA%\Teknoparrot\SBMB_e2prom.bin
XCOPY /Y /C %EPROM_SRC% %EPROM_DST%
::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
