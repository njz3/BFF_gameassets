@ECHO OFF
CONSOLESTATE /Min

ping -n 5 127.0.0.1 >nul
cd C:\Racecab\AttractPlus
start C:\Racecab\AttractPlus\attractplus.exe
