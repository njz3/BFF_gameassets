@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=..\SupermodelRoms\lemans24.zip
CALL supermodel_options.bat
:: emulated FFB, link to right nvram for model 3 driveboard
del /F /Q "NVRAM\lemans24.nv"
mklink /H "NVRAM\lemans24.nv" "NVRAM\lemans24_m3db.nv"

:: Lunch emulator
supermodel.exe %GAME% %SUPERMODEL_OPTIONS%
