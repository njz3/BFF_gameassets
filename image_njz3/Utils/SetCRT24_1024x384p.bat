SET EMULATORS_DIR=C:\Racecab\Emulators
SET RES_EXT=_1024x384

SetResolution.exe -w 1024 -h 384 -noprompt

:: VR on MAME enable 4:3
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame\nvram\vr_4_3" "%EMULATORS_DIR%\Mame\nvram\vr"

CALL SetVideoCommon.bat

