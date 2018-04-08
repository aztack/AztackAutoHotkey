;Auto-Genreated at 2018-04-01 18:28:55 +0800
#Include gpd-pocket.ahk
#Include paths-c5d8a3.ahk
#Include functions.ahk
#Include autorun.ahk
;-----
;Menus
;-----
menus := {}
;QuickMenu
menus["QuickMenu"] := ["f:\dl","e:\ebook","d:\prog","d:\vm\projects","-----","C:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe","C:\app\PicPickPortable\picpick.exe","C:\Program Files (x86)\Fiddler2\Fiddler.exe"]
	Menu, QuickMenu, Add, download, TheMenuHandler
	Menu, QuickMenu, Add, ebook, TheMenuHandler
	Menu, QuickMenu, Add, prog, TheMenuHandler
	Menu, QuickMenu, Add, vm\projects, TheMenuHandler
	Menu, QuickMenu, Add,,,
	Menu, QuickMenu, Add, 有道云笔记, TheMenuHandler
	Menu, QuickMenu, Icon,有道云笔记, C:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe
	Menu, QuickMenu, Add, PicPick, TheMenuHandler
	Menu, QuickMenu, Icon,PicPick, C:\app\PicPickPortable\picpick.exe
	Menu, QuickMenu, Add, Fiddler, TheMenuHandler
	Menu, QuickMenu, Icon,Fiddler, C:\Program Files (x86)\Fiddler2\Fiddler.exe
;SublimeProject
menus["SublimeProject"] := ["D:\prog\sublime-projects\web-cp.sublime-project","E:\doc\closesource\qh\union.sublime-project","E:\doc\GitHub\rails-dev-box\sites\blog.aztack.com.sublime-project","E:\doc\GitHub\aztec-alpha\aztec-alpha.sublime-project"]
	Menu, SublimeProject, Add, Web-CP, TheMenuHandler
	Menu, SublimeProject, Add, Union, TheMenuHandler
	Menu, SublimeProject, Add, Blog, TheMenuHandler
	Menu, SublimeProject, Add, Aztec-Alpha, TheMenuHandler
;Test
menus["Test"] := ["http://wap.tmall.imxiaomai.com/page/newv4/index.html","E:/doc/info/xiaomai/gitlabauth.au3","E:/doc/info/xiaomai/loginTest.au3","E:/doc/info/xiaomai/pushorigin.au3","E:/doc/info/xiaomai/pullorigin.au3"]
	Menu, Test, Add, 开发：小麦商城测试环境, TheMenuHandler
	Menu, Test, Icon,开发：小麦商城测试环境, Shell32.dll, 14
	Menu, Test, Add, Gitlab Auth, TheMenuHandler
	Menu, Test, Icon,Gitlab Auth, lib\au3.ico
	Menu, Test, Add, login Test Server, TheMenuHandler
	Menu, Test, Icon,login Test Server, lib\au3.ico
	Menu, Test, Add, Push Origin Master, TheMenuHandler
	Menu, Test, Icon,Push Origin Master, lib\au3.ico
	Menu, Test, Add, Pull Origin Master, TheMenuHandler
	Menu, Test, Icon,Pull Origin Master, lib\au3.ico

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
#Include _firefox.ahk
#Include _everything.ahk
#Include _explorer.ahk
#Include _xshell.ahk
#Include _sublime.ahk
#Include _vscode.ahk
#Include _cmder.ahk
#Include hotstrings.ahk

;hotkeys for menus
!d:: Menu,QuickMenu,Show
!Numpad1:: Menu,SublimeProject,Show
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
