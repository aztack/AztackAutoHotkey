#IfWinActive ahk_class Xshell4:MainWnd
	^v::SendInput %clipboard%
	
	~Shift & BackSpace::
	SendInput cd ..{Enter}
	return
	
	!Home::
	SendInput cd ~{Enter}
	return
	
	~Shift & AppsKey::
	SendInput ls{Enter}
	return
	
	~Alt & AppsKey::
	SendInput ll{Enter}
	return
	
	~Alt & Left::
	SendInput {Ctrl down}c{Ctrl up}
	SendInput cd -{Enter}
	return

#IfWinActive