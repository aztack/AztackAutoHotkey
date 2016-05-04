;chrome
!2::
	GetKeyState, state, LButton
	exclude := ""
	if(state = "D") {
		WinGet, this_id, ID,Developer Tools,
		WinActivate ahk_id %this_id%
	} else {
		WinGet, id, list,ahk_class Chrome_WidgetWin_1,, Developer Tools
		Loop, %id%
		{
			this_id := id%A_Index%
			WinActivate ahk_id %this_id%
			;WinGetTitle, title, ahk_id %this_id%
			;MsgBox %title%
			return
		}
		Run chrome
	}
return

#IfWinActive ahk_class Chrome_WidgetWin_1
	;命令行操作
	~Shift & WheelUp::
	SendEvent {Up}
	return
	
	~Shift & WheelDown::
	SendEvent {Down}
	return
	
	~Shift & MButton::
	SendInput clear(){Enter}
	return
	
	;调试操作
	~Alt & WheelDown::
	GetKeyState, state, Shift
	if(state = "D"){
		SendEvent {F11}
	} else {
		SendEvent {F10}
	}
	return
	
	~Alt & WheelUp::
	SendEvent {Shift down}{F11}{Shift up}
	return
	
	~Alt & MButton::
	SendEvent {F8}
	return

	~Alt & RButton::
	SendEvent {F12}
	return
	
	~!+l::
	  SendEvent {Ctrl down}l{Ctrl up}
	  Sleep 50
	  SendEvent {Ctrl down}c{Ctrl up}
	  text = %ClipBoard%
	  StringReplace, text, text, localhost, %A_IPAddress1%
	  ClipBoard = %text%
	return
	
#IfWinActive