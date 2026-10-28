' Activate (focus) an application.
' see https://solmu.org/pub/help/sendkeys.txt
Set WshShell = CreateObject("WScript.Shell")
WshShell.AppActivate Wscript.Arguments(0) 
