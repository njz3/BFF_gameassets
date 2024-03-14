@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=vformula

:: Lunch emulator
mame.exe %GAME% 

