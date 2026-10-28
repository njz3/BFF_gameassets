@ECHO OFF
CONSOLESTATE /Min

killProcess.vbs "BackForceFeeder.exe"
CALL killHyperspin.bat
shutdown /r /t 1
