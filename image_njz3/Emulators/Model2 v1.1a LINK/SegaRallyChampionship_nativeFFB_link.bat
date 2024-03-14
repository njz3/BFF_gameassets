@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set MODEL2=emulator_multicpu.exe
set ROM=srallyc

:: lunch m2lagfix
start m2lagfix /B /MIN
ping -n 3 127.0.0.1 >nul

:: Lunch emulator
%MODEL2% %ROM%

CALL killm2lagfix.bat
