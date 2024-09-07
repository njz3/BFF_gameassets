SET EMULATORS_DIR=C:\Racecab\Emulators
SET RES_EXT=_2560x1440

SetResolution.exe -w 2560 -h 1440 -noprompt

:: VR on MAME enable 16:9
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame\nvram\vr_16_9" "%EMULATORS_DIR%\Mame\nvram\vr"

CALL SetVideoCommon.bat

