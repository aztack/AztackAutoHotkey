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
	SendInput {Ctrl down}c{Ctrl up}cls{Enter}
	return
	
	~Ctrl & L::
	SendInput {Ctrl down}c{Ctrl up}cls{Enter}
	return
	
	~Shift & BackSpace::
	SendInput cd ..{Enter}
	return
	
	#1::
	SendInput c:{Enter}
	return
	
	#2::
	SendInput d:{Enter}
	return
	
	#3::
	SendInput e:{Enter}
	return
	
	#4::
	SendInput f:{Enter}
	return
	
	#e::
	SendInput start .{Enter}
	return
	
	~Shift & AppsKey::
	SendInput dir{Enter}
	return

	~Ctrl & w::
	WinClose A 
	return
	
#IfWinActive