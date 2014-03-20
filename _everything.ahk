;copy path from everything
#IfWinActive ahk_class EVERYTHING
	+C::
		ControlGetText, text,msctls_statusbar321, ahk_class EVERYTHING
		Clipboard=%text%
	Return
#IfWinActive