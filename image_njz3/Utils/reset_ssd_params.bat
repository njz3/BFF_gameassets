@ECHO ON
killProcess.vbs "BackForceFeeder.exe"
CALL killHyperspin.bat

DEL C:\Racecab\Utils\Assistant_BFF\calibration_done
DEL C:\Racecab\Utils\Assistant_BFF\calibration_done.flag
DEL C:\Users\Racecab\Documents\BackForceFeeder\*.dat

