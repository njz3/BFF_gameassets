@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=..\Supermodel\ROMs\lemans24.zip
CALL supermodel_options.bat
:: Lunch emulator
supermodel.exe %GAME% %SUPERMODEL_OPTIONS%
