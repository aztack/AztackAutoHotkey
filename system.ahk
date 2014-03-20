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
	fullFileName := Clipboard
	SplitPath, fullFileName, , dir, , ,
	if FileExist(dir)
		Run, cmd /k cd /d "%dir%"
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
	Clip0 = %ClipBoardAll%
	text = %ClipBoard%

	;filters
	s := "\s*报错"
	text := RegExReplace(text, s, "")
	s := "\s*跟读"
	text := RegExReplace(text, s, "")
	s := "\s*口语练习"
	text := RegExReplace(text, s, "")

	ClipBoard = %text% ; Convert to text
	Send ^v ; For best compatibility: SendPlay
	Sleep 50 ; Don't change clipboard while it is pasted! (Sleep > 0)
	ClipBoard = %Clip0% ; Restore original ClipBoard
	VarSetCapacity(Clip0, 0) ; Free memory
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

;reset hosts
#F6::
	WinActivate ahk_class PX_WINDOW_CLASS
	old = %Clipboard%
	Clipboard =
	(
127.0.0.1 localhost
10.16.15.199 wwh.lianmeng.360.cn
10.108.214.50 lianmeng.360.cn
10.108.214.50 admin.lianmeng.360.cn
10.16.15.199 docs.lianmeng.360.cn
10.16.15.169 crm.360.cn
#回归机器
#10.121.215.80 admin.lianmeng.360.cn
#10.108.212.42 lianmeng.360.cn
	)
	Send, ^{End}^v^s^w
	Sleep 50
	ClipBoard = %old%
	VarSetCapacity(old, 0)
return