
AnimateWindow(A, "Slide RL BT Activate", 500)



; AHK_L AnimateWindow wrapper 5L by nimda
; returns: nonzero on success, false on failure
; MSDN http://msdn.microsoft.com/en-us/library/ms632669(v=vs.85).aspx

AnimateWindow(HWND, Options, t=200){
o := 0, op := {Activate : 0x00020000, Fade : 0x00080000, Center : 0x00000010, Hide : 0x00010000, LR : 0x00000001, RL : 0x00000002, Slide : 0x00040000, TB : 0x00000004, BT : 0x00000008}
For k in op
If InStr(Options, k, false)
o |= op[k]
return DllCall("AnimateWindow", "UPtr", HWND, "Int", t, "UInt", o)
}