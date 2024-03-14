' Kill process by its name, as first argument to the script
' ex:  killProcess.vbs mame.exe
Option Explicit
Dim objWMIService, objProcess, colProcess
Dim strComputer, strProcessKill
' see https://stackoverflow.com/questions/52231543/how-to-close-terminate-kill-an-instance-of-a-application-with-vbs
if WScript.Arguments.Count = 0 then
    WScript.Echo "Missing parameters"
	WScript.Quit 1
end if
strProcessKill = Wscript.Arguments.Item(0)
strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colProcess = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '" & strProcessKill & "'")
For Each objProcess in colProcess
objProcess.Terminate
Next