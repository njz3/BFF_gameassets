@ECHO OFF
CONSOLESTATE /Min

killProcess.vbs "BackForceFeeder.exe"
CALL killAttractModePlus.bat
shutdown /r /t 1
