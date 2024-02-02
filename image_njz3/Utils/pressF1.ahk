#NoTrayIcon
; First argument is time delay before press is pressed
if (A_Args.Length > 0) {
  Sleep A_Args[1]
}
Send "{F1 down}"
Sleep 200
Send "{F1 up}"

