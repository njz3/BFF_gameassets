:: Hyperspin
XCOPY /Y /I C:\Racecab\Hyperspin\Databases\1P\1P%RES_EXT%.xml C:\Racecab\Hyperspin\Databases\1P\1P.xml
XCOPY /Y /I C:\Racecab\Hyperspin\Databases\MULTI\MULTI%RES_EXT%.xml C:\Racecab\Hyperspin\Databases\MULTI\MULTI.xml

:: MAME
XCOPY /Y /I %EMULATORS_DIR%\Mame\mame%RES_EXT%.ini %EMULATORS_DIR%\Mame\mame.ini
:: MAME LINK
XCOPY /Y /I "%EMULATORS_DIR%\Mame LINK\mame%RES_EXT%.ini" "%EMULATORS_DIR%\Mame LINK\mame.ini"

:: Flycast
XCOPY /Y /I %EMULATORS_DIR%\Flycast\flycast_options%RES_EXT%.bat %EMULATORS_DIR%\Flycast\flycast_options.bat
:: Flycast LINK
XCOPY /Y /I "%EMULATORS_DIR%\Flycast LINK\flycast_options%RES_EXT%.bat" "%EMULATORS_DIR%\Flycast LINK\flycast_options.bat"

:: model 2
XCOPY /Y /I "%EMULATORS_DIR%\Model2 v1.1a\Emulator%RES_EXT%.ini" "%EMULATORS_DIR%\Model2 v1.1a\Emulator.ini"
XCOPY /Y /I "%EMULATORS_DIR%\Model2 v1.1a LINK\Emulator%RES_EXT%.ini" "%EMULATORS_DIR%\Model2 v1.1a LINK\Emulator.ini"
:: model 2 LINK
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Model2 v1.1a\scripts%RES_EXT%" "%EMULATORS_DIR%\Model2 v1.1a\scripts"
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Model2 v1.1a LINK\scripts%RES_EXT%" "%EMULATORS_DIR%\Model2 v1.1a LINK\scripts"

:: Supermodel
XCOPY /Y /I %EMULATORS_DIR%\Supermodel\supermodel_video_options%RES_EXT%.bat %EMULATORS_DIR%\Supermodel\supermodel_video_options.bat
:: Supermodel LINK
XCOPY /Y /I "%EMULATORS_DIR%\Supermodel LINK\supermodel_video_options%RES_EXT%.bat" "%EMULATORS_DIR%\Supermodel LINK\supermodel_video_options.bat"

:: Dolphin NGC
XCOPY /Y /I %EMULATORS_DIR%\Dolphin\dolphin\User\Config\GFX%RES_EXT%.ini %EMULATORS_DIR%\Dolphin\dolphin\User\Config\GFX.ini

:: Dolphin Triforce
XCOPY /Y /I %EMULATORS_DIR%\Triforce\dolphin_tri_FZero\User\Config\GFX%RES_EXT%.ini %EMULATORS_DIR%\Triforce\dolphin_tri_FZero\User\Config\GFX.ini
XCOPY /Y /I %EMULATORS_DIR%\Triforce\dolphin_tri_MKAGP\User\Config\GFX%RES_EXT%.ini %EMULATORS_DIR%\Triforce\dolphin_tri_MKAGP\User\Config\GFX.ini

:: Teknoparrot OR2SPDX
XCOPY /Y /I %EMULATORS_DIR%\TeknoParrot\UserProfiles\or2spdlx%RES_EXT%.xml %EMULATORS_DIR%\TeknoParrot\UserProfiles\or2spdlx.xml
