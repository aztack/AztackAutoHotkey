;hotkeys for openning drive with win+number
#1:: Run c:
#2:: Run d:
#3:: Run e:
#4:: Run f:

#F10::
Run lib\toggleTaskbarShowHide.au3
return

;
;reload this script
;
#F12::
	Reload
return

;toggle proxy
^!F12::
setproxy()
return

^!+F12::
if ( regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1 ) 
{
	TrayTip,,你在墙外, 2, 17
}
else
{
	TrayTip,,你在墙内, 2, 17
}
return


setproxy(state = "Toggle"){

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
		regwrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer,http=10.16.13.18:8080;https=10.16.13.18:8080;socks=10.16.13.18:8080
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

#IfWinActive ahk_class Chrome_WidgetWin_1
~#LButton::
 setproxy()
Return
#IfWinActive

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

;kill active 
#q::
	WinGetActiveTitle, Title
	WinGet, PID, PID, %Title%
	MsgBox, 0x104, Close? ,Ternimate %Title%?
	IfMsgBox, No
	    return
	Process, Close, %PID%
return

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