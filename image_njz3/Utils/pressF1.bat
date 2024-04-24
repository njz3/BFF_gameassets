@ECHO OFF
CONSOLESTATE /Min

::First BATCH argument is time delay before key will be pressed.
::It is passed to the ahk script.
START autohotkey.exe C:\Racecab\Utils\pressF1.ahk %1

