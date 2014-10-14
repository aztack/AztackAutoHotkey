;Auto-Genreated at 2014-04-19 08:00:39 +0800
#Include paths.ahk
#Include functions.ahk
#Include autorun.ahk

;-----
;Menus
;-----
menus := {}
;QuickMenu
menus["QuickMenu"] := ["f:\dl","e:\ebook","D:\Program Files\bcompare\BCompare.exe"]
	Menu, QuickMenu, Add, download, TheMenuHandler
	Menu, QuickMenu, Icon,download, Shell32.dll, 4
	Menu, QuickMenu, Add, ebook, TheMenuHandler
	Menu, QuickMenu, Icon,ebook, Shell32.dll, 4
	Menu, QuickMenu, Add, BCompare, TheMenuHandler
	Menu, QuickMenu, Icon,BCompare, D:\Program Files\bcompare\BCompare.exe
;Test
menus["Test"] := ["http://wwh.lianmeng.360.cn/index","http://wwh.lianmeng.360.cn:8000","http://lianmeng.360.cn/index","http://lianmeng.360.cn:8000"]
	Menu, Test, Add, 开发：联盟web-front, TheMenuHandler
	Menu, Test, Icon,开发：联盟web-front, Shell32.dll, 14
	Menu, Test, Add, 开发：联盟web-admin, TheMenuHandler
	Menu, Test, Icon,开发：联盟web-admin, Shell32.dll, 14
	Menu, Test, Add, 测试：联盟web-front, TheMenuHandler
	Menu, Test, Icon,测试：联盟web-front, Shell32.dll, 14
	Menu, Test, Add, 测试：联盟web-admin, TheMenuHandler
	Menu, Test, Icon,测试：联盟web-admin, Shell32.dll, 14

;-----------
; timers
;-----------

SetTimer sublime_timer_ahk, On

;-----------
; other ahks
;-----------

#Include appdir.ahk
#Include system.ahk
#Include _console.ahk
#Include _chrome.ahk
#Include _everything.ahk
#Include _explorer.ahk
#Include _xshell.ahk
#Include _sublime.ahk


;hotkeys for menus
!d:: Menu,QuickMenu,Show
!Numpad0:: Menu,Test,Show

;---------------------
;The Only Menu Handler
;---------------------

TheMenuHandler:
	items := menus[A_ThisMenu]
	p := items[A_ThisMenuItemPos]
	if(p<> "")
		Run, %p%
	if(InStr(p,"http:") = 1) {
		WinWait,ahk_class Chrome_WidgetWin_1
		WinActive("ahk_class Chrome_WidgetWin_1")
		Send, ^l{End}
	}
return

;---------------
; Timer handlers
;---------------
sublime_timer_ahk:
IfWinExist, Sublime Text ahk_class #32770
	WinClose

IfWinExist, This is an unregistered copy ahk_class #32770
	WinClose
return
