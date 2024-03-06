@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

::Press F1 after 5sec of delay to boot directly into game
CALL pressF1.bat 5000

SET DOLPHIN=dolphin\Dolphin.exe
START /WAIT %DOLPHIN% -b -e "F-Zero GX (Europe) (En,Fr,De,Es,It).iso"


