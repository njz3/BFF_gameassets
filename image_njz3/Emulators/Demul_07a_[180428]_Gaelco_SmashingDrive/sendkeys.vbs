' Script to send a key to an application.
' see https://solmu.org/pub/help/sendkeys.txt

' https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/8c6yea83(v=vs.84)?redirectedfrom=MSDN
Set WshShell = CreateObject("WScript.Shell")
WshShell.SendKeys Wscript.Arguments(0) 
