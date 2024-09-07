@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

:: Set CAB_ID
CALL set_cab_id.bat

set GAME=hummerextreme.xml

:: link to right config for link mode
set CFG_SRC=%APPDATA%\Teknoparrot\SBST_sram%CAB_ID%.bin
set CFG_DST=%APPDATA%\Teknoparrot\SBST_sram.bin
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
