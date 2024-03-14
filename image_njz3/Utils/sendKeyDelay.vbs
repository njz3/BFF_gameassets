' Send a key press as first argument to the script, using a delay in ms as second argument
' ex send Alt+F4 after 500ms:  sendKey.vbs "%{F4}" 500
' ex send F1 after 4000ms:  sendKey.vbs "{F1}" 4000
Option Explicit
Dim delay, dkey, WshShell
if WScript.Arguments.Count < 2 then
    WScript.Echo "Missing parameters"
	WScript.Quit 1
end if
dkey = Wscript.Arguments.Item(0)
delay = Wscript.Arguments.Item(1)
Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep delay
WshShell.SendKeys dkey
