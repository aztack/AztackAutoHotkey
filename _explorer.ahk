;copy path from explorer
#IfWinActive ahk_class CabinetWClass
	^!c::
		dir := Explorer_GetPath()
		Run, cmd /k cd /d "%dir%"
	Return
	
	;copy path of selected 
	^+c::
		Clipboard := Explorer_GetSelected()
	Return
#IfWinActive