;Auto-Genreated at 2014-03-20 16:16:29 +0800
#Include paths.ahk
#Include functions.ahk
#Include autorun.ahk

;-----
;Menus
;-----
menus := {}

;QuickMenu
menus["QuickMenu"] := ["-----","e:\ebook","-----","D:\Program Files\bcompare\BCompare.exe","C:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe","C:\Program Files (x86)\Just Great Software\RegexBuddy3\RegexBuddy.exe","C:\Program Files (x86)\PicPick\picpick.exe","D:\prog\sqliteadmin\sqliteadmin.exe","C:\Program Files\China Mobile\Fetion\Fetion.exe","C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe","D:\Program Files\Firefox26\App\Firefox\firefox.exe","C:\Program Files\The KMPlayer\KMPlayer.exe"]
						Menu, QuickMenu, Add,,,
										Menu, QuickMenu, Add, ebook, TheMenuHandler
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
			

;Test
menus["Test"] := ["http://wwh.lianmeng.360.cn/index","http://wwh.lianmeng.360.cn:8000","http://lianmeng.360.cn/index","http://lianmeng.360.cn:8000","E:\doc\closesource\qh\signuphao360_fillform.au3"]
						Menu, Test, Add, 开发：联盟web-front, TheMenuHandler
										Menu, Test, Add, 开发：联盟web-admin, TheMenuHandler
										Menu, Test, Add, 测试：联盟web-front, TheMenuHandler
										Menu, Test, Add, 测试：联盟web-admin, TheMenuHandler
										Menu, Test, Add, 填写直客注册表格, TheMenuHandler
					


;-----------
; other ahks
;-----------

#Include appdir.ahk
#Include system.ahk
#Include _console.ahk
#Include _chrome.ahk
#Include _everything.ahk

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
