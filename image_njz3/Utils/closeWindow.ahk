#NoTrayIcon
SetTitleMatchMode 2
SetTitleMatchMode "Slow"
DetectHiddenWindows true

; First argument is windows title
; %A_Args[1]%
if (A_Args.Length == 1)
{
	if WinExist(A_Args[1]) 
	{
		WinKill A_Args[1], , 5
	}
}

