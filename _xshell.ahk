#IfWinActive ahk_class Xshell4:MainWnd
	^v::SendInput %clipboard%
#IfWinActive