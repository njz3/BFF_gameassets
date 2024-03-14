@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set MODEL2=emulator_multicpu.exe
set ROM=stcc
:: Lunch emulator
%MODEL2% %ROM%

