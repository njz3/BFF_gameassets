SET EMULATORS_DIR=C:\Racecab\Emulators
SET RES_EXT=_3840x2160

SetResolution.exe -w 3840 -h 2160 -noprompt

:: VR on MAME enable 16:9
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame\nvram\vr_16_9" "%EMULATORS_DIR%\Mame\nvram\vr"
:: Same format for the link cabinet, from its own variants (Mame LINK\nvram\vr_*,
:: laid by Build-Config from nvram_link_cabN): they keep its link number
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame LINK\nvram\vr_16_9" "%EMULATORS_DIR%\Mame LINK\nvram\vr"

CALL SetVideoCommon.bat

