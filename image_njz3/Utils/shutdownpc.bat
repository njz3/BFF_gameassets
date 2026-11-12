@ECHO OFF
CONSOLESTATE /Min

killProcess.vbs "BackForceFeeder.exe"
CALL killAttractModePlus.bat
shutdown /s /t 1
