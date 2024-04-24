@ECHO OFF
CONSOLESTATE /Min

killProcess.vbs "BackForceFeeder.exe"
CALL killHyperspin.bat
shutdown /s /t 1
