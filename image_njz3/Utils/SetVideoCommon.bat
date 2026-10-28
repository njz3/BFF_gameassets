:: RES_EXT is the "Resolution" filename extension, set by caller's, like "_1920x1080"

:: get CAB_ID
:: CAB_ID is the "link" filename extension, set by caller's, like "_single"
CALL set_cab_id.bat

:: Hyperspin
XCOPY /Y /I "C:\Racecab\Hyperspin\Databases\1P\1P%RES_EXT%.xml" "C:\Racecab\Hyperspin\Databases\1P\1P.xml"
XCOPY /Y /I "C:\Racecab\Hyperspin\Databases\MULTI\MULTI%RES_EXT%.xml" "C:\Racecab\Hyperspin\Databases\MULTI\MULTI.xml"

:: MAME : mame.ini par Build-Config (gabarits, voir targets.csv)
:: Virtua Racing : le SetXXX.bat appelant vient de poser la NVRAM au format de
:: l ecran dans Mame\nvram\vr. Avec le dossier d ecriture, MAME lit d abord
:: sa copie de Saves\mame_single\nvram\vr : on l efface, il repart de
:: celle qui vient d etre posee.
CALL set_writedir.bat
if defined WRITEDIR_ROOT if exist "%WRITEDIR_ROOT%\mame_single\nvram\vr\" RMDIR /S /Q "%WRITEDIR_ROOT%\mame_single\nvram\vr"

:: Flycast, Supermodel et sm2-emu passent par la table de cibles :
:: Utils\config\targets.csv dit quel fichier vient de quel gabarit ou de
:: quelle variante, et sous quelle identite de cabine.
:: Build-Config ne touche PAS aux dossiers NVRAM sur un changement de
:: resolution : ils ne sont reposes que lorsque la cabine change.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Racecab\Utils\config\Build-Config.ps1" -Res %RES_EXT%
IF ERRORLEVEL 1 ECHO *** Build-Config a echoue : configuration incomplete ***

:: model 2
XCOPY /Y /I "%EMULATORS_DIR%\Model2 v1.1a\Emulator%RES_EXT%.ini" "%EMULATORS_DIR%\Model2 v1.1a\Emulator.ini"
XCOPY /Y /I "%EMULATORS_DIR%\Model2 v1.1a LINK\Emulator%RES_EXT%.ini" "%EMULATORS_DIR%\Model2 v1.1a LINK\Emulator.ini"
:: model 2 LINK
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Model2 v1.1a\scripts%RES_EXT%" "%EMULATORS_DIR%\Model2 v1.1a\scripts"
XCOPY /E /H /C /Y /I "%EMULATORS_DIR%\Model2 v1.1a LINK\scripts%RES_EXT%" "%EMULATORS_DIR%\Model2 v1.1a LINK\scripts"

:: Dolphin NGC
XCOPY /Y /I "%EMULATORS_DIR%\Dolphin\dolphin\User\Config\GFX%RES_EXT%.ini" "%EMULATORS_DIR%\Dolphin\dolphin\User\Config\GFX.ini"

:: Dolphin Triforce
XCOPY /Y /I "%EMULATORS_DIR%\Triforce\dolphin_tri_FZero\User\Config\GFX%RES_EXT%.ini" "%EMULATORS_DIR%\Triforce\dolphin_tri_FZero\User\Config\GFX.ini"
XCOPY /Y /I "%EMULATORS_DIR%\Triforce\dolphin_tri_MKAGP\User\Config\GFX%RES_EXT%.ini" "%EMULATORS_DIR%\Triforce\dolphin_tri_MKAGP\User\Config\GFX.ini"

:: La resolution des profils TeknoParrot est posee par Build-Config
:: (type XML, table valeurs\teknoparrot.csv) : les noms de champs varient
:: d un jeu a l autre, et les anciennes lignes XCOPY visaient un dossier
:: TeknoParrot qui n existe plus depuis que les installations sont versionnees.

:: Le temoin Configured_for*.txt est desormais ecrit par Build-Config.
