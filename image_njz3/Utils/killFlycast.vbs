Option Explicit
Dim objWMIService, objProcess, colProcess
Dim strComputer, strProcessKill
strComputer = "."
strProcessKill = "flycast.exe"
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colProcess = objWMIService.ExecQuery _
("Select * from Win32_Process Where Name = '" & strProcessKill & "'")
For Each objProcess in colProcess
objProcess.Terminate
Next