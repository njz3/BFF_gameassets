@ECHO OFF
CONSOLESTATE /Min

::First BATCH argument is name of window title to close
::It is passed to the ahk script.
START autohotkey.exe C:\Racecab\Utils\closeWindow.ahk %1
