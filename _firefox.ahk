#IfWinActive ahk_class MozillaWindowClass
	~Alt & RButton::
	SendEvent {F12}
	return
#IfWinActive