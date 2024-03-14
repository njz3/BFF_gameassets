' Send a key press as first argument to the script
' ex send Alt+F4:  sendKey.vbs "%{F4}"
' ex send F1:  sendKey.vbs "{F1}"
Option Explicit
Dim dkey, WshShell
if WScript.Arguments.Count < 1 then
    WScript.Echo "Missing parameters"
	WScript.Quit 1
end if
dkey = Wscript.Arguments.Item(0)
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.SendKeys dkey
