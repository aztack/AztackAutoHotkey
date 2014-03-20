SetTimer CloseAnnoyingDialog, On

CloseAnnoyingDialog:
	IfWinExist, Sublime Text ahk_class #32770
		WinClose

	IfWinExist, This is an unregistered copy ahk_class #32770
		WinClose
Return
