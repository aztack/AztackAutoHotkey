#r::
Run C:\windows\syswow64\rundll32.exe shell32.dll`,#61
return

ResList=
WinPosArray0=0
return

/* #d::
 * IfNotInString, ResList, |Desktop|
 * 	{
 * 	; Show Desktop
 * 	StoreAllWindowsInOrder("Desktop")
 * 	WinMinimizeAll
 * 	}
 * Else
 * 	{
 * 	; Restore Previous Windows
 * 	StoreAllWindowsInOrder("DesktopUpdate")
 * 	WinMinimizeAllUndo	
 * 	RestoreAllWindowsInOrder("Desktop")
 * 	RestoreAllWindowsInOrder("DesktopUpdate")
 * 	}
 * return
 */



StoreAllWindowsInOrder(Resolution)
{
	Global

	local WinIDlist
	local WinPosList
	local WinOrder
	local thisID
	local IsMaximized
	local OnTopStyle

	
	SetBatchLines -1  ; Makes searching occur at maximum speed. 
	SetWinDelay, 0	  ; No movement or resize is done, so this should not cause any issues
	Critical
	
	WinIDlist=
	WinPosList=
	WinOrder=1
	
	; Get all visible Windows
	WinGet, WinIDlist, list, ,, Program Manager
	Loop, %WinIDlist%
	{
		thisID := WinIDlist%A_Index%
		
		; Don't store the ID's of already minimized Windows
		WinGet, IsMaximized, MinMax, ahk_id %thisID%
		If IsMaximized=-1
			continue
		
		WinGet, OnTopStyle, ExStyle, ahk_id %thisID%
		OnTopStyle&=0x8  ; 0x8 is WS_EX_TOPMOST.

		WinPosList=%WinPosList%%WinOrder%%A_TAB%%thisID%%A_TAB%%OnTopStyle%`n
		WinOrder+=1
	}
	
	WinPosArray%Resolution%:=WinPosList
	ResList=%ResList%|%Resolution%|
	
	; SetWinDelay is back to normal when returning from this function
	; SetBatchLines is back to normal when returning from this function
	; Critical is Off when returning from this function
}



RestoreAllWindowsInOrder(Resolution)
{
	Global

	local WinPosList
	local Field0					
	local Field1			;Field1=WinOrder		
	local Field2			;Field2=thisID		
	local Field4			;Field3=OnTopStyle		
	
	IfNotInString, ResList, |%Resolution%|
		return

	
	SetBatchLines -1  ; Makes searching occur at maximum speed. 
	SetWinDelay, 0	  ; No movement or resize is done so this should not cause any issues
	Critical

	; WinPosArray is sorted from Top to Bottom so we need to reverse that order
	Sort, WinPosArray%Resolution%, N R
	WinPosList:=WinPosArray%Resolution%
	Loop, parse, WinPosList, `n, `r
	{
	StringSplit, Field, A_LoopField, %A_TAB%
	
	; It turned out that using SetWindowPos with the "HWND_NOTOPMOST" Option is causing the least side effects. 
	; Going the other way and setting the Windows to the Bottom of the stack did result in unwanted behavior of the windows:
	; After restoring the z-Order, you could no longer bring a Window in front of another by just clicking somewhere inside 
	; that window. It was necessary to click on the Window Title bar to bring it in front of other windows.
	; It also works more reliable than DllCall("SetForegroundWindow", "UInt", hWnd)
	
	; http://msdn.microsoft.com/en-us/library/ms633545(v=vs.85).aspx?ppud=4
	; Places the window above all non-topmost windows (that is, behind all topmost windows). This flag has no effect if the window is already a non-topmost window.
	DllCall("SetWindowPos", "uint", Field2, "uint", "-2" , "int", "0", "int", "0", "int", "0", "int", "0"  , "uint", "19") ; 19 = NOSIZE | NOMOVE | NOACTIVATE ( 0x1 | 0x2 | 0x10 )

	; Restore the AlwaysOnTop setting
	If Field3 	; On TopSyle = AlwaysOnTop
		WinSet, AlwaysOnTop, On, ahk_id %Field2%
	
	; Opera did always end up in front of other windows, even so those were originaly above Opera and restored correctly until Opera did rise in front of them.
	; Regardless if SetWindowPos did activate the Window or not. But a WinActivate following SetWindowPos did solve that issue. 
	; Since the IDs of Windows that are originally minimized are not in the List, every Window can be activated
	WinActivate, ahk_id %Field2%
	}
	; SetWinDelay is back to normal when returning from this function
	; SetBatchLines is back to normal when returning from this function
	; Critical is Off when returning from this function
	
	; Clear the now unused global variables
	WinPosArray%Resolution%=
	; Rearm the Toggle function
	StringReplace, ResList, ResList, |%Resolution%|
}

;hotkeys for openning drive with win+number
;#1:: Run c:
;#2:: Run d:
;#3:: Run e:
;#4:: Run f:
;#5:: Run g:
;#6:: Run h:

#F10::
Run lib\toggleTaskbarShowHide.au3
return

#F11::
Run lib\closeWindowUnderCursor.au3
return

;
;reload this script
;
#F12::
	Reload
return

;vpn on
^!F12::
 Run, vpnon.bat
return

^!+F12::
 Run, vpnoff.bat
return

;toggle proxy
;^!F12::
;setproxy()
;return

;^!+F12::
;if ( regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1 ) 
;{
;	TrayTip,,你在墙外, 2, 17
;}
;else
;{
;	TrayTip,,你在墙内, 2, 17
;}
;return


setproxy(state = "Toggle", which = 0){
if (which = 0) {
	proxy := "http=10.16.13.18:8080;https=10.16.13.18:8080;socks=10.16.13.18:8080"
} else {
	proxy := "http=127.0.0.1:1080;https=127.0.0.1:1080;socks=127.0.0.1:1080"
}
if (state ="ON" or state = 1)
regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
  else if (state="OFF" or state = 0)
    regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
  else if (state = "TOGGLE")
  {
      if ( regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1 ) 
	  {
		TrayTip,,你在墙内, 2, 17
        regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
	  } else if (regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0 ) 
	  {
		TrayTip,,你在墙外, 2, 17
        regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
		regwrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer, %proxy%
	  }
  }
  dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
  dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
  Return
}

RegRead(RootKey, SubKey, ValueName = "") {
   RegRead, v, %RootKey%, %SubKey%, %ValueName%
   Return, v
}

;~#LButton::
; setproxy()
;Return

;
;run path/url on clipboard
;
!h::
	try
	{
		Run open %clipboard%
	}catch e{
	}
return

;quick press ESC close window
escPressCount := 0
~ESC::
GetKeyState, state, LButton
If (A_TimeSincePriorHotkey < 300 and state = "D") {
	escPressCount := 1 + escPressCount
	if (escPressCount = 1) {
		WinClose A
		escPressCount := 0
	}
} else {
	escPressCount := 0
}
Return

;open path in clipboard with cmd.exe
!+h::
	s := Clipboard
	if(FileExist(s))
	{
		Run, cmd /k cd /d "%s%"
	} else {
		SplitPath, s, filename, dir, extension, noext, drv
		IfExist %dir%
			Run, cmd /k cd /d "%dir%"
	}
return


;mouse wheel change volume when taskbar is active
#IfWinActive,ahk_class Shell_TrayWnd
	~WheelUp::Send, {Volume_Up}
	~WheelDown::Send, {Volume_Down}
	~MButton::Send, {Volume_Mute}
#IfWinActive

;hotkeys for manipulating window
^!e:: WinMinimize, A
^!q:: WinClose, A

^!r::
	WinGet MX, MinMax, A
	If MX
	WinRestore A
	Else WinMaximize A
return

!l::
	WinGetPos,X,Y,,,A
	X:= X+50
	WinMove,A,,%X%,%Y%
return

!j::
	WinGetPos,X,Y,,,A
	X:= X-50
	WinMove,A,,%X%,%Y%
return

!i::
	WinGetPos,X,Y,,,A
	Y:= Y-50
	WinMove,A,,%X%,%Y%
return

!k::
	WinGetPos,X,Y,,,A
	Y:= Y+50
	WinMove,A,,%X%,%Y%
return

!+l::
	WinGetPos,X,Y,W,H,A
	W := W + 50
	WinMove,A,,%X%,%Y%,%W%,%H%
return

!+j::
	WinGetPos,X,Y,W,H,A
	W := W - 50
	WinMove,A,,%X%,%Y%,%W%,%H%
return

!+i::
	WinGetPos,X,Y,W,H,A
	H := H - 50
	WinMove,A,,%X%,%Y%,%W%,%H%
return

!+k::
	WinGetPos,X,Y,W,H,A
	H := H + 50
	WinMove,A,,%X%,%Y%,%W%,%H%
return

;kill active 
#q::
	WinGetActiveTitle, Title
	WinGet, PID, PID, %Title%
	MsgBox, 0x104, Close? ,Ternimate %Title%?
	IfMsgBox, No
	    return
	Process, Close, %PID%
return

MoveWindowToMonitor(Index, n, m, factorX, factorY,factorW = 1,factorH = 1){
	SysGet, mon,MonitorWorkArea, %Index%
	Width  := (monRight  - monLeft) / n
	Height := (monBottom - monTop)  / m
	X := monLeft + Width  * factorX
	Y := monTop  + Height * factorY
	W := Width * factorW
	H := Height * factorH
	WinMove, A, , %X%, %Y%, %W%, %H%
}

;monitor1
#Numpad7::
	MoveWindowToMonitor(1,3,3,0,0)
return

#Numpad8::
	MoveWindowToMonitor(1,3,3,1,0)
return

#Numpad9::
	MoveWindowToMonitor(1,3,3,2,0)
return

#Numpad4::
	MoveWindowToMonitor(1,3,3,0,1)
return

#Numpad5::
	MoveWindowToMonitor(1,3,3,1,1)
return

#Numpad6::
	MoveWindowToMonitor(1,3,3,2,1)
return

#Numpad1::
	MoveWindowToMonitor(1,3,3,0,2)
return

#Numpad2::
	MoveWindowToMonitor(1,3,3,1,2)
return

#Numpad3::
	MoveWindowToMonitor(1,3,3,2,2)
return

;monitor2
^#Numpad7::
	MoveWindowToMonitor(2,3,3,0,0)
return

^#Numpad8::
	MoveWindowToMonitor(2,3,3,1,0)
return

^#Numpad9::
	MoveWindowToMonitor(2,3,3,2,0)
return

^#Numpad4::
	MoveWindowToMonitor(2,3,3,0,1)
return

^#Numpad5::
	MoveWindowToMonitor(2,3,3,1,1)
return

^#Numpad6::
	MoveWindowToMonitor(2,3,3,2,1)
return

^#Numpad1::
	MoveWindowToMonitor(2,3,3,0,2)
return

^#Numpad2::
	MoveWindowToMonitor(2,3,3,1,2)
return

^#Numpad3::
	MoveWindowToMonitor(2,3,3,2,2)
return

^+1::
	MoveWindowToMonitor(2,3,1,0,0)
return

^+2::
	MoveWindowToMonitor(2,3,1,1,0)
return

^+3::
	MoveWindowToMonitor(2,3,1,2,0)
return

^+4::
	MoveWindowToMonitor(2,3,1,1,0,2,1)
return

;
^+7::
	MoveWindowToMonitor(2,1,3,0,1,1,2)
return

^+8::
	MoveWindowToMonitor(2,1,3,0,0)
return

^+9::
	MoveWindowToMonitor(2,1,3,0,1)
return

^+0::
	MoveWindowToMonitor(2,1,3,0,2)
return


^#Up::MouseMove,0,-10,0,R
^#Down::MouseMove,0,10,0,R
^#Left::MouseMove,-10,0,0,R
^#Right::MouseMove,10,0,0,R
^+#Up::MouseMove,0,-100,0,R
^+#Down::MouseMove,0,100,0,R
^+#Left::MouseMove,-100,0,0,R
^+#Right::MouseMove,100,0,0,R



;Convert whatever's on the clipboard to plain text (no formatting) and then pastes.
#v::
	old = %ClipBoardAll%
	text = %ClipBoard%

	;filters
	s := "\s*报错"
	text := RegExReplace(text, s, "")
	s := "\s*跟读"
	text := RegExReplace(text, s, "")
	s := "\s*口语练习"
	text := RegExReplace(text, s, "")
	s := "\s*全球发音"
	text := RegExReplace(text, s, "")

	ClipBoard = %text% ; Convert to text
	Send ^v ; For best compatibility: SendPlay
	Sleep 50 ; Don't change clipboard while it is pasted! (Sleep > 0)
	ClipBoard = %old% ; Restore original ClipBoard
	VarSetCapacity(old, 0) ; Free memory
Return

#F4::
	WinGetClass, class, A
	GetKeyState, state, LButton
	title := Clipboard
	if(class = "Chrome_WidgetWin_1") {
		send,{F6}
		Send,^c
		ClipWait,0.2
		PageURL := Clipboard
		if(state = "D"){
			a = [%title%](%PageURL%)
		} else {
			a = %title%`r`n%PageURL%
		}
		Clipboard = %a%
	}
return


#Enter::
	MouseGetPos, x, y
	MouseClick, left, x, y
return
 
; Win+F12 - Sleep
#+F12::
    ; Sleep/Suspend:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; Hibernate:
    ;DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
Return
 
; Win+Shift+F12 - Lock and sleep
;#+F12::
    ; Lock:
    ;Run rundll32.exe user32.dll`,LockWorkStation
    ;Sleep 1000
    ; Sleep/Suspend:
    ;DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; Hibernate:
    ;DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
;Return

SetTimer, KillGWX, 10000
return

KillGWX:
run, taskkill /f /im gwx.exe,,Hide
run, taskkill /f /im kkv.exe,,Hide
run, taskkill /f /im SogouCloud.exe,,Hide
return
