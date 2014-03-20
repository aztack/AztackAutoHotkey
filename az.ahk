#Include paths.ahk
#Include functions.ahk
#Include autorun.ahk
#Include menus.ahk
!D::Menu, m, Show
MenuHandler:
	MsgBox A_ThisMenu
	p := MenuItemPaths[A_ThisMenuItemPos]
	if(p<> "")
		Run, %p%
	if(InStr(p,"http:") = 1) {
		WinWait,ahk_class Chrome_WidgetWin_1
		WinActive("ahk_class Chrome_WidgetWin_1")
		Send, ^l{End}
	}
return

#Include appdir.ahk
#Include system.ahk
#Include _console.ahk
#Include _chrome.ahk
#Include _xshell.ahk
#Include _sublimetext.ahk