SET EMULATORS_DIR=C:\Racecab\Emulators
SET RES_EXT=_1920x1080

SetResolution.exe -w 1920 -h 1080 -noprompt

:: VR on MAME enable 16:9
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame\nvram\vr_16_9" "%EMULATORS_DIR%\Mame\nvram\vr"
:: Same format for the link cabinet, from its own variants (Mame LINK\nvram\vr_*,
:: laid by Build-Config from nvram_link_cabN): they keep its link number
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame LINK\nvram\vr_16_9" "%EMULATORS_DIR%\Mame LINK\nvram\vr"
:: VR on Keisho, the same format: the pair in saves\vr_16_9 onto saves\vr.* (the link folder's are its own cabinet's)
XCOPY /H /C /Y "%EMULATORS_DIR%\Keisho\saves\vr_16_9\*" "%EMULATORS_DIR%\Keisho\saves\"
XCOPY /H /C /Y "%EMULATORS_DIR%\Keisho LINK\saves\vr_16_9\*" "%EMULATORS_DIR%\Keisho LINK\saves\"

CALL SetVideoCommon.bat

