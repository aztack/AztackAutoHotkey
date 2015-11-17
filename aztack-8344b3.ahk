;Auto-Genreated at 2015-11-17 17:25:35 +0800
#Include paths-8344b3.ahk
#Include functions.ahk
#Include autorun.ahk

;-----
;Menus
;-----
menus := {}
;QuickMenu
menus["QuickMenu"] := ["f:\dl","e:\ebook","-----","D:\Program Files (x86)\Beyond Compare 3\BCompare.exe","D:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe","C:\Users\Administrator\AppData\Local\Youdao\Dict\Application\YodaoDict.exe","D:\prog\RegexBuddy 3\RegexBuddy.exe","D:\Program Files (x86)\PicPick\picpick.exe","C:\Program Files (x86)\China Mobile\Fetion\Fetion.exe","D:\Program Files (x86)\FileZilla FTP Client\filezilla.exe","C:\Program Files (x86)\Mozilla Firefox\firefox.exe","C:\Program Files (x86)\The KMPlayer\KMPlayer.exe","C:\Program Files (x86)\Astrill\astrill.exe","D:\Program Files\Adobe\Adobe Photoshop CS5\Photoshop.exe","D:\Program Files (x86)\FastStone Image Viewer\FSViewer.exe","D:\prog\LINQPad\LINQPad.exe","D:\Program Files\MobipocketReader6.2\MobipocketReader_6.2.exe","D:\Program Files\Source Insight 3\Insight3.exe","D:\Program Files\todolist\ToDoList.exe","D:\prog\Fiddler2\Fiddler.exe"]
	Menu, QuickMenu, Add, download, TheMenuHandler
	Menu, QuickMenu, Icon,download, Shell32.dll, 4
	Menu, QuickMenu, Add, ebook, TheMenuHandler
	Menu, QuickMenu, Icon,ebook, Shell32.dll, 4
	Menu, QuickMenu, Add,,,
	Menu, QuickMenu, Add, BCompare, TheMenuHandler
	Menu, QuickMenu, Icon,BCompare, D:\Program Files (x86)\Beyond Compare 3\BCompare.exe
	Menu, QuickMenu, Add, 有道云笔记, TheMenuHandler
	Menu, QuickMenu, Icon,有道云笔记, D:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe
	Menu, QuickMenu, Add, 有道词典, TheMenuHandler
	Menu, QuickMenu, Icon,有道词典, C:\Users\Administrator\AppData\Local\Youdao\Dict\Application\YodaoDict.exe
	Menu, QuickMenu, Add, RegexBuddy, TheMenuHandler
	Menu, QuickMenu, Icon,RegexBuddy, D:\prog\RegexBuddy 3\RegexBuddy.exe
	Menu, QuickMenu, Add, PicPick, TheMenuHandler
	Menu, QuickMenu, Icon,PicPick, D:\Program Files (x86)\PicPick\picpick.exe
	Menu, QuickMenu, Add, Fetion, TheMenuHandler
	Menu, QuickMenu, Icon,Fetion, C:\Program Files (x86)\China Mobile\Fetion\Fetion.exe
	Menu, QuickMenu, Add, Filezilla, TheMenuHandler
	Menu, QuickMenu, Icon,Filezilla, D:\Program Files (x86)\FileZilla FTP Client\filezilla.exe
	Menu, QuickMenu, Add, Firefox, TheMenuHandler
	Menu, QuickMenu, Icon,Firefox, C:\Program Files (x86)\Mozilla Firefox\firefox.exe
	Menu, QuickMenu, Add, KMPlayer, TheMenuHandler
	Menu, QuickMenu, Icon,KMPlayer, C:\Program Files (x86)\The KMPlayer\KMPlayer.exe
	Menu, QuickMenu, Add, Astrill, TheMenuHandler
	Menu, QuickMenu, Icon,Astrill, C:\Program Files (x86)\Astrill\astrill.exe
	Menu, QuickMenu, Add, Photoshop, TheMenuHandler
	Menu, QuickMenu, Icon,Photoshop, D:\Program Files\Adobe\Adobe Photoshop CS5\Photoshop.exe
	Menu, QuickMenu, Add, FSViewer, TheMenuHandler
	Menu, QuickMenu, Icon,FSViewer, D:\Program Files (x86)\FastStone Image Viewer\FSViewer.exe
	Menu, QuickMenu, Add, LINQPad, TheMenuHandler
	Menu, QuickMenu, Icon,LINQPad, D:\prog\LINQPad\LINQPad.exe
	Menu, QuickMenu, Add, MobiReader, TheMenuHandler
	Menu, QuickMenu, Icon,MobiReader, D:\Program Files\MobipocketReader6.2\MobipocketReader_6.2.exe
	Menu, QuickMenu, Add, Source Insight, TheMenuHandler
	Menu, QuickMenu, Icon,Source Insight, D:\Program Files\Source Insight 3\Insight3.exe
	Menu, QuickMenu, Add, ToDoList, TheMenuHandler
	Menu, QuickMenu, Icon,ToDoList, D:\Program Files\todolist\ToDoList.exe
	Menu, QuickMenu, Add, Fiddler, TheMenuHandler
	Menu, QuickMenu, Icon,Fiddler, D:\prog\Fiddler2\Fiddler.exe
;SublimeProject
menus["SublimeProject"] := ["D:\prog\sublime-projects\web-cp.sublime-project","E:\doc\closesource\qh\union.sublime-project","E:\doc\GitHub\rails-dev-box\sites\blog.aztack.com.sublime-project","E:\doc\GitHub\aztec-alpha\aztec-alpha.sublime-project"]
	Menu, SublimeProject, Add, Web-CP, TheMenuHandler
	Menu, SublimeProject, Add, Union, TheMenuHandler
	Menu, SublimeProject, Add, Blog, TheMenuHandler
	Menu, SublimeProject, Add, Aztec-Alpha, TheMenuHandler
;Test
menus["Test"] := ["http://wap.tmall.imxiaomai.com/page/newv4/index.html"]
	Menu, Test, Add, 开发：小麦商城测试环境, TheMenuHandler
	Menu, Test, Icon,开发：小麦商城测试环境, Shell32.dll, 14

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
