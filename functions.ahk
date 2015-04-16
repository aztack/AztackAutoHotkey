ActiveOrRun(clazz,p)
{
	if(WinExist(clazz)) {
		WinActivate
	} else {
		Run %p%
	}
	WinActivate
}

AutoRun(exename,p)
{
	Process, Exist, %name%.exe
	{
		If ! errorLevel
		{
			IfExist, %p%
				Run %p%
		}
	}
}

Kill(exename)
{
	process=%exename%
	Process, Exist, %process%
	if	pid :=	ErrorLevel
	{
		Loop 
		{
			WinClose, ahk_pid %pid%, , 5	; will wait 5 sec for window to close
			if	ErrorLevel	; if it doesn't close
				Process, Close, %pid%	; force it 
			Process, Exist, %process%
		} Until !pid :=	ErrorLevel
	}
}
