@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=..\Mame\roms\initdv2e.zip
CALL flycast_options.bat
:: Lunch emulator
flycast.exe %GAME% %FLYCAST_OPTIONS%
