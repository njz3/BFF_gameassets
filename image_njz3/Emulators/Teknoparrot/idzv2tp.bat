@ECHO OFF

:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=IDZv2TP.xml
::Start game
ELEVATE.exe "TeknoParrotUi.exe" "--profile=%GAME% --startMinimized"
