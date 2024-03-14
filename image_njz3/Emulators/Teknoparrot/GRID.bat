@ECHO On
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set CAB_ID=_single

set GAME=GRID.xml

::Copy config
set GAME_PATH="C:\Sega"
set CFG_SRC=%GAME_PATH%\shell\Game%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\shell\Game.ini
XCOPY /Y /C %CFG_SRC% %CFG_DST%
set CFG_SRC=%GAME_PATH%\ShellData\ShellData%CAB_ID%.ini
set CFG_DST=%GAME_PATH%\ShellData\ShellData.ini
XCOPY /Y /C %CFG_SRC% %CFG_DST%

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
