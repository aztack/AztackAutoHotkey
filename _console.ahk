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
	
	~Ctrl & b::
	SendInput {Enter}
	return

	!+/::
	SendInput git status{Enter}
	return
	
	!+.::
	SendInput git branch{ENTER}
	return
	
	^!/::
	SendInput dir{ENTER}
	return
#IfWinActive

#IfWinActive ahk_class VirtualConsoleClass
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
	
	~Ctrl & b::
	SendInput {Enter}
	return

	!+/::
	SendInput git status{Enter}
	return
	
	!+.::
	SendInput git branch{ENTER}
	return
	
	^!/::
	SendInput dir{ENTER}
	return
#IfWinActive