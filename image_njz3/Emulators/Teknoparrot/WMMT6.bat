@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=WMMT6.xml

::Start game
Elevate -wait TeknoParrotUi.exe "--profile=%GAME% --startMinimized"
