@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

SET DOLPHIN=dolphin_tri_FZero\Dolphin.exe
START /WAIT %DOLPHIN% -b -e "F-Zero AX (Rev E).iso"


