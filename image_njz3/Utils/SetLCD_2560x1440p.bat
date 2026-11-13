SET EMULATORS_DIR=C:\Racecab\Emulators
SET RES_EXT=_2560x1440

SetResolution.exe -w 2560 -h 1440 -noprompt

:: VR on MAME enable 16:9
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame\nvram\vr_16_9" "%EMULATORS_DIR%\Mame\nvram\vr"
:: Same format for the link cabinet, from its own variants (Mame LINK\nvram\vr_*,
:: laid by Build-Config from nvram_link_cabN): they keep its link number
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Mame LINK\nvram\vr_16_9" "%EMULATORS_DIR%\Mame LINK\nvram\vr"
:: VR on sm2-emu, the same format: the pair in saves\vr_16_9 onto saves\vr.* (the link folder's are its own cabinet's)
XCOPY /H /C /Y "%EMULATORS_DIR%\sm2-emu\saves\vr_16_9\*" "%EMULATORS_DIR%\sm2-emu\saves\"
XCOPY /H /C /Y "%EMULATORS_DIR%\sm2-emu LINK\saves\vr_16_9\*" "%EMULATORS_DIR%\sm2-emu LINK\saves\"

CALL SetVideoCommon.bat

