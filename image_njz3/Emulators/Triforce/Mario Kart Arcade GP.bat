@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

SET DOLPHIN=dolphin_tri_MKAGP\Dolphin.exe
START /WAIT %DOLPHIN% -b -e "Mario Kart Arcade GP (USA).iso"

