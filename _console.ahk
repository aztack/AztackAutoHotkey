#IfWinActive ahk_class ConsoleWindowClass
	^v::
	SendInput %clipboard%
	return
	
	~LControl & WheelUp::
	SendEvent {Up}
	return
	
	~LControl & WheelDown::
	SendEvent {Down}
	return
	
	~LControl & LButton::
	SendEvent {Enter}
	return
	
	~LControl & MButton::
	SendInput cls{Enter}
	return
#IfWinActive