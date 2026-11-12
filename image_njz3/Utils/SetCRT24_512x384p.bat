SET EMULATORS_DIR=C:\Racecab\Emulators
SET RES_EXT=_512x384

SetResolution.exe -w 512 -h 384 -noprompt

:: VR on MAME enable 4:3
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame\nvram\vr_4_3" "%EMULATORS_DIR%\Mame\nvram\vr"
:: Same format for the link cabinet, from its own variants (Mame LINK\nvram\vr_*,
:: laid by Build-Config from nvram_link_cabN): they keep its link number
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame LINK\nvram\vr_4_3" "%EMULATORS_DIR%\Mame LINK\nvram\vr"

CALL SetVideoCommon.bat

