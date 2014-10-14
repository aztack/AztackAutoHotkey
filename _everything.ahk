;copy path from everything
#IfWinActive ahk_class EVERYTHING
	+!C::
		ControlGetText, text,msctls_statusbar321, ahk_class EVERYTHING
		Clipboard=%text%
	Return

	+!v::
		ControlGetText, text,msctls_statusbar321, ahk_class EVERYTHING
		SplitPath, text, filename, dir, extension, noext, drv
		IfExist %dir%
			Run "%dir%"
	Return

	+!r::
		ControlGetText, text,msctls_statusbar321, ahk_class EVERYTHING
		SplitPath, text, filename, dir, extension, noext, drv
		IfExist %dir%
			Run, cmd /k cd /d "%dir%"
	Return

#IfWinActive