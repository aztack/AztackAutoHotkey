get_path_in_sublime_title()
{
	WinGetTitle, title
	apath := RegExReplace(title, "^(.*) \(.*\) - Sublime Text \(UNREGISTERED\)$","$1")
	SplitPath, apath, filename, dir,,
	return dir
}
#IfWinActive ahk_class PX_WINDOW_CLASS
	~^!c::
	dir := get_path_in_sublime_title()
	Run, cmd /k cd /d "%dir%"
	return
	
	#e::
	dir := get_path_in_sublime_title()
	Run,"%dir%"
	return
	
	~^s::
		GetKeyState, lstate, LButton
		GetKeyState, rstate, RButton
		if(lstate == "D"){
			WinGet, original, ID, A
			WinActivate, ahk_class Chrome_WidgetWin_1
			WinWaitActive, ahk_class Chrome_WidgetWin_1
			Send ^{F5}
			WinActivate, ahk_id %original%
		}
		
		if (rstate == "D") {
			WinGet, original, ID, A
			WinActivate, ahk_class Chrome_WidgetWin_1
			WinWaitActive, ahk_class Chrome_WidgetWin_1
			Send ^{F5}
		}
	return
#IfWinActive
