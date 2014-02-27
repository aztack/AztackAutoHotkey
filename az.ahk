#Persistent
#SingleInstance force
chromeIndex := 0
escPressCount := 0
Process, Exist, CLCL.exe ; check to see if AutoHotkey.exe is running
{
	If ! errorLevel
	{
		Run D:\Program Files\CLCL1.1.2\CLCL.exe
	}
}

Process, Exist, ToDoList.exe ; check to see if AutoHotkey.exe is running
{
	If ! errorLevel
	{
		Run D:\Program Files\ToDoList\ToDoList.exe
	}
}

;make a popup menu to open urls/apps
Menu , m , Add ,  &1 http://wwh.lianmeng.360.cn, MenuHandler
Menu , m , Add ,  &2 http://wwh.lianmeng.360.cn:8000, MenuHandler
Menu , m , Add ,  &3 http://lianmeng.360.cn, MenuHandler
Menu , m , Add ,  &4 http://lianmeng.360.cn:8000, MenuHandler
Menu , m , Add ,,,
Menu , m , Add ,  &BCompare,BCompare,D:\Program Files\bcompare\BCompare.exe
Menu , m , Icon ,  &BCompare,D:\Program Files\bcompare\BCompare.exe

SetTimer CloseAnnoyingDialog, On

;====================================================================

;quick press ESC close window
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

;reload this script
#F12::
	Reload
return

;open path/url in clipboard
!h::
	try
	{
		Run open %clipboard%
	}catch e{

	}
return

;open path in clipboard with cmd.exe
!+h::
	fullFileName := Clipboard
	SplitPath, fullFileName, , dir, , ,
	if FileExist(dir)
		Run, cmd /k cd /d "%dir%"
return

;hotkeys for openning drive with win+number
#1:: Run c:
#2:: Run d:
#3:: Run e:
#4:: Run f:

;hotkeys for openning applications
!+s:: Run "C:\Program Files (x86)\NetSarang\Xshell 4\Xshell.exe"
!+o:: Run "C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE"
!+l:: Run "C:\Users\wangweihua.CORP\AppData\Local\Lingoes\Translator\lingoes-cn\Lingoes.exe"
!+b:: Run "C:\Program Files (x86)\EditPlus 3\editplus.exe"
!+t:: Run "C:\Program Files (x86)\Thunder Network\Thunder\Program\Thunder.exe"
!+q:: Run "C:\Program Files (x86)\Tencent\QQ\Bin\QQ.exe"
#b:: Run "D:\Program Files (x86)\Sublime Text 3\sublime_text.exe"
!b:: Run Notepad
!r:: Run cmd
!t:: Run taskmgr
!3:: Run mspaint
!5:: Run calc

!c:: Run E:\doc\closesource\qh\
#F8:: Run "D:\Program Files (x86)\Sublime Text 3\sublime_text.exe" "C:\Windows\System32\drivers\etc\hosts"
#F7:: Edit %A_ScriptFullPath%
#F6::
	old = %Clipboard%
	Clipboard = 
	(
10.16.15.199 wwh.lianmeng.360.cn
10.108.214.50 lianmeng.360.cn
10.16.15.199 docs.lianmeng.360.cn
10.16.15.169 crm.360.cn
	)
	Send, ^v
	Sleep 50
	ClipBoard = %old%
	VarSetCapacity(old, 0)
return

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

;在命令行窗口启用快捷键粘贴
#IfWinActive ahk_class ConsoleWindowClass
	^v::SendInput %clipboard%
#IfWinActive

#F10::
	VarSetCapacity( APPBARDATA, A_PtrSize=4 ? 36:48, 0 )
	NumPut(DllCall("Shell32\SHAppBarMessage", "UInt", 4 ; ABM_GETSTATE
                                           , "Ptr", &APPBARDATA
                                           , "Int")
 ? 2:1, APPBARDATA, A_PtrSize=4 ? 32:40) ; 2 - ABS_ALWAYSONTOP, 1 - ABS_AUTOHIDE
 , DllCall("Shell32\SHAppBarMessage", "UInt", 10 ; ABM_SETSTATE
                                    , "Ptr", &APPBARDATA)
return

;popup menu
MenuHandler:
	ary := StrSplit(A_ThisMenuItem, " ")
	url := ary[2]
	Run %url%
return

!D::Menu , m , Show

!1::
	GetKeyState, state, LButton
	if(state = "D" and WinExist("ahk_class PX_WINDOW_CLASS")) {
		WinActivate
	}
return

ListVars
;quick switch to some window
!2::
GetKeyState, state, LButton
if(state = "D") {
	WinGet WindowList , List , ahk_class Chrome_WidgetWin_1
	max := WindowList
	if (WinExist("ahk_class Chrome_WidgetWin_1")){
		chromeIndex := chromeIndex + 1
		
		if(chromeIndex >= max) {
			chromeIndex := 0
		}
		WinID := WindowList%chromeIndex%

		WinActivate ahk_id %WinID%
		
	} else {
		Run chrome
	}
} else {
	if(WinExist("ahk_class Chrome_WidgetWin_1")) {
		GetKeyState, state, RButton
		if(state = "D"){
			Run chrome
		} else {
			WinActivate
		}
	} else {
		Run chrome
	}
	WinActivate
}
return

!0::
if WinExist("ahk_class PX_WINDOW_CLASS")
	WinActivate
return


!7::
if WinExist("ahk_class CabinetWClass")
	WinActivate
return


;mouse wheel change volume when taskbar is active
#IfWinActive,ahk_class Shell_TrayWnd
	~WheelUp::Send, {Volume_Up}
	~WheelDown::Send, {Volume_Down}
	~MButton::Send, {Volume_Mute}
	Up::Send, {Volume_Up}
	Down::Send, {Volume_Down}
	Right::Send, {Volume_Mute}
	Left::Send, {Volume_Mute}
	k::Send, {Volume_Up}
	j::Send, {Volume_Down}; Generated using SmartGUI Creator for SciTE
Gui, Show, w479 h377, Untitled GUI
return

GuiClose:
ExitApp
	l::Send, {Volume_Mute}
	h::Send, {Volume_Mute}
#IfWinActive

#IfWinActive ahk_class MSPaintApp
	Esc::Send !{F4}
#IfWinActive

#IfWinActive ahk_class Notepad
	Esc::Send !{F4}
#IfWinActive


;copy path from everything
#IfWinActive ahk_class EVERYTHING
	+C::
		ControlGetText, text,msctls_statusbar321, ahk_class EVERYTHING
		Clipboard=%text%
	Return
#IfWinActive

CloseAnnoyingDialog:
	IfWinExist, Sublime Text ahk_class #32770
		WinClose
	
	IfWinExist, This is an unregistered copy ahk_class #32770
		WinClose
Return

BCompare:
Run "D:\Program Files\bcompare\BCompare.exe"
return

::afunc::
code := "function(){}"
SendRaw %code%
SendInput {Left 1}
return

::func::
code := "function (){}"
SendRaw %code%
SendInput {Left 4}
return

::forin::
code = 
(
for(`;i < len`; ++i){
`t
}
)
SendRaw %code%
SendInput {Left 1}
return