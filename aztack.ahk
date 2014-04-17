;Auto-Genreated at 2014-04-17 17:13:42 +0800
#Include paths.ahk
#Include functions.ahk
#Include autorun.ahk

;-----
;Menus
;-----
menus := {}
;QuickMenu
menus["QuickMenu"] := ["f:\dl","e:\ebook","-----","D:\Program Files\bcompare\BCompare.exe","C:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe","C:\Program Files (x86)\Just Great Software\RegexBuddy3\RegexBuddy.exe","C:\Program Files (x86)\PicPick\picpick.exe","D:\prog\sqliteadmin\sqliteadmin.exe","C:\Program Files\China Mobile\Fetion\Fetion.exe","C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe","D:\Program Files\Firefox26\App\Firefox\firefox.exe","C:\Program Files\The KMPlayer\KMPlayer.exe","C:\Program Files (x86)\Astrill\astrill.exe","D:\Program Files\PhotoshopCS5\Photoshop (64 Bit)\Photoshop.exe","D:\prog\SQLite Expert Professiona.exe","D:prog\LINQPad4.31\LINQPad.exe"]
	Menu, QuickMenu, Add, download, TheMenuHandler
	Menu, QuickMenu, Icon,download, Shell32.dll, 4
	Menu, QuickMenu, Add, ebook, TheMenuHandler
	Menu, QuickMenu, Icon,ebook, Shell32.dll, 4
	Menu, QuickMenu, Add,,,
	Menu, QuickMenu, Add, BCompare, TheMenuHandler
	Menu, QuickMenu, Icon,BCompare, D:\Program Files\bcompare\BCompare.exe
	Menu, QuickMenu, Add, 有道云笔记 (&B), TheMenuHandler
	Menu, QuickMenu, Icon,有道云笔记 (&B), C:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe
	Menu, QuickMenu, Add, RegexBuddy, TheMenuHandler
	Menu, QuickMenu, Icon,RegexBuddy, C:\Program Files (x86)\Just Great Software\RegexBuddy3\RegexBuddy.exe
	Menu, QuickMenu, Add, PicPick, TheMenuHandler
	Menu, QuickMenu, Icon,PicPick, C:\Program Files (x86)\PicPick\picpick.exe
	Menu, QuickMenu, Add, SQLiteAdmin, TheMenuHandler
	Menu, QuickMenu, Icon,SQLiteAdmin, D:\prog\sqliteadmin\sqliteadmin.exe
	Menu, QuickMenu, Add, 飞信, TheMenuHandler
	Menu, QuickMenu, Icon,飞信, C:\Program Files\China Mobile\Fetion\Fetion.exe
	Menu, QuickMenu, Add, Filezilla, TheMenuHandler
	Menu, QuickMenu, Icon,Filezilla, C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe
	Menu, QuickMenu, Add, Firefox, TheMenuHandler
	Menu, QuickMenu, Icon,Firefox, D:\Program Files\Firefox26\App\Firefox\firefox.exe
	Menu, QuickMenu, Add, KMPlayer, TheMenuHandler
	Menu, QuickMenu, Icon,KMPlayer, C:\Program Files\The KMPlayer\KMPlayer.exe
	Menu, QuickMenu, Add, Astrill, TheMenuHandler
	Menu, QuickMenu, Icon,Astrill, C:\Program Files (x86)\Astrill\astrill.exe
	Menu, QuickMenu, Add, Photoshop, TheMenuHandler
	Menu, QuickMenu, Icon,Photoshop, D:\Program Files\PhotoshopCS5\Photoshop (64 Bit)\Photoshop.exe
	Menu, QuickMenu, Add, SQLite Expert, TheMenuHandler
	Menu, QuickMenu, Icon,SQLite Expert, D:\prog\SQLite Expert Professiona.exe
	Menu, QuickMenu, Add, LINQPad, TheMenuHandler
	Menu, QuickMenu, Icon,LINQPad, D:prog\LINQPad4.31\LINQPad.exe
;SublimeProject
menus["SublimeProject"] := ["D:\prog\sublime-projects\web-cp.sublime-project","E:\doc\closesource\qh\union.sublime-project","E:\doc\GitHub\rails-dev-box\sites\blog.aztack.com.sublime-project","E:\doc\GitHub\aztec-alpha\aztec-alpha.sublime-project"]
	Menu, SublimeProject, Add, Web-CP, TheMenuHandler
	Menu, SublimeProject, Add, Union, TheMenuHandler
	Menu, SublimeProject, Add, Blog, TheMenuHandler
	Menu, SublimeProject, Add, Aztec-Alpha, TheMenuHandler
;Test
menus["Test"] := ["http://wwh.lianmeng.360.cn/index","http://wwh.lianmeng.360.cn:8000","http://lianmeng.360.cn/index","http://lianmeng.360.cn:8000","----","E:\doc\closesource\qh\unionad\web-cp","http://cp.lianmeng.360.cn","E:\doc\closesource\qh\signuphao360_fillform.au3"]
	Menu, Test, Add, 开发：联盟web-front, TheMenuHandler
	Menu, Test, Icon,开发：联盟web-front, Shell32.dll, 14
	Menu, Test, Add, 开发：联盟web-admin, TheMenuHandler
	Menu, Test, Icon,开发：联盟web-admin, Shell32.dll, 14
	Menu, Test, Add, 测试：联盟web-front, TheMenuHandler
	Menu, Test, Icon,测试：联盟web-front, Shell32.dll, 14
	Menu, Test, Add, 测试：联盟web-admin, TheMenuHandler
	Menu, Test, Icon,测试：联盟web-admin, Shell32.dll, 14
	Menu, Test, Add,,,
	Menu, Test, Add, CP, TheMenuHandler
	Menu, Test, Icon,CP, Shell32.dll, 4
	Menu, Test, Add, CP网站, TheMenuHandler
	Menu, Test, Icon,CP网站, Shell32.dll, 14
	Menu, Test, Add, 填写直客注册表格, TheMenuHandler
	Menu, Test, Icon,填写直客注册表格, lib\au3.ico

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
