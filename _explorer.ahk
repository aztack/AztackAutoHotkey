;copy path from explorer
#IfWinActive ahk_class CabinetWClass
	^!c::
		dir := Explorer_GetPath()
		Run, cmd /k cd /d "%dir%"
	Return
	
	;copy path of selected 
	#c::
		Clipboard := Explorer_GetSelected()
	Return
	
	~Alt & WheelUp::
	SendInput {Alt down}{Up} {Alt up}
	return
	
	~Alt & WheelDown::
	SendInput {Alt down}{Left} {Alt up}
	return
#IfWinActive