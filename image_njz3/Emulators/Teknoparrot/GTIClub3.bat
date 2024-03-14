@ECHO On
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set CAB_ID=_single

set GAME=GtiClub3.xml

::Copy config

::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
