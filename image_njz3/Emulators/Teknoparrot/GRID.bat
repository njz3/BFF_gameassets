@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

:: Set CAB_ID
set CAB_ID=_single

set GAME=GRID.xml

:: link to right config
set GAME_PATH="C:\Sega"
set CFG_SRC=%GAME_PATH%\shell\Game%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\shell\Game.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%
set CFG_SRC=%GAME_PATH%\ShellData\ShellData%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\ShellData\ShellData.ini
del /F /Q %CFG_DST%
mklink /H %CFG_DST% %CFG_SRC%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
