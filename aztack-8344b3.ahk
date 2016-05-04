;Auto-Genreated at 2016-05-01 20:56:33 +0800
#Include paths-8344b3.ahk
#Include functions.ahk
#Include autorun.ahk

;-----
;Menus
;-----
menus := {}
;QuickMenu
menus["QuickMenu"] := ["f:\dl","e:\ebook","d:\prog","d:\vm\projects","-----","D:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe","C:\Users\Administrator\AppData\Local\Youdao\Dict\Application\YodaoDict.exe","D:\Program Files (x86)\PicPick\picpick.exe","D:\Program Files (x86)\FileZilla FTP Client\filezilla.exe","C:\Program Files (x86)\Mozilla Firefox\firefox.exe","C:\Program Files (x86)\The KMPlayer\KMPlayer.exe","D:\Program Files (x86)\Tencent\QQPlayer\QQPlayer.exe","C:\Program Files (x86)\Astrill\astrill.exe","D:\Program Files\Photoshop2015\PhotoshopPortable.exe","D:\Program Files (x86)\FastStone Image Viewer\FSViewer.exe","D:\Program Files\MobipocketReader6.2\MobipocketReader_6.2.exe","D:\Program Files (x86)\Beyond Compare 3\BCompare.exe","D:\prog\RegexBuddy 3\RegexBuddy.exe","D:\Program Files\gizmo\prog\SQLite Expert Professiona.exe","D:\prog\LINQPad\LINQPad.exe","D:\Program Files\Source Insight 3\Insight3.exe","D:\Program Files\todolist\ToDoList.exe","D:\prog\Fiddler2\Fiddler.exe","D:\Program Files\SwitchHosts\SwitchHosts.exe","D:\Program Files\Navicat Premium\navicat.exe","D:\Program Files\cmder\Cmder.exe"]
	Menu, QuickMenu, Add, download, TheMenuHandler
	Menu, QuickMenu, Icon,download, Shell32.dll, 4
	Menu, QuickMenu, Add, ebook, TheMenuHandler
	Menu, QuickMenu, Icon,ebook, Shell32.dll, 4
	Menu, QuickMenu, Add, prog, TheMenuHandler
	Menu, QuickMenu, Icon,prog, Shell32.dll, 4
	Menu, QuickMenu, Add, vm\projects, TheMenuHandler
	Menu, QuickMenu, Icon,vm\projects, Shell32.dll, 4
	Menu, QuickMenu, Add,,,
	Menu, QuickMenu, Add, 有道云笔记, TheMenuHandler
	Menu, QuickMenu, Icon,有道云笔记, D:\Program Files (x86)\Youdao\YoudaoNote\RunYNote.exe
	Menu, QuickMenu, Add, 有道词典, TheMenuHandler
	Menu, QuickMenu, Icon,有道词典, C:\Users\Administrator\AppData\Local\Youdao\Dict\Application\YodaoDict.exe
	Menu, QuickMenu, Add, PicPick, TheMenuHandler
	Menu, QuickMenu, Icon,PicPick, D:\Program Files (x86)\PicPick\picpick.exe
	Menu, QuickMenu, Add, Filezilla, TheMenuHandler
	Menu, QuickMenu, Icon,Filezilla, D:\Program Files (x86)\FileZilla FTP Client\filezilla.exe
	Menu, QuickMenu, Add, Firefox, TheMenuHandler
	Menu, QuickMenu, Icon,Firefox, C:\Program Files (x86)\Mozilla Firefox\firefox.exe
	Menu, QuickMenu, Add, KMPlayer, TheMenuHandler
	Menu, QuickMenu, Icon,KMPlayer, C:\Program Files (x86)\The KMPlayer\KMPlayer.exe
	Menu, QuickMenu, Add, QQPlayer, TheMenuHandler
	Menu, QuickMenu, Icon,QQPlayer, D:\Program Files (x86)\Tencent\QQPlayer\QQPlayer.exe
	Menu, QuickMenu, Add, Astrill, TheMenuHandler
	Menu, QuickMenu, Icon,Astrill, C:\Program Files (x86)\Astrill\astrill.exe
	Menu, QuickMenu, Add, Photoshop, TheMenuHandler
	Menu, QuickMenu, Icon,Photoshop, D:\Program Files\Photoshop2015\PhotoshopPortable.exe
	Menu, QuickMenu, Add, FSViewer, TheMenuHandler
	Menu, QuickMenu, Icon,FSViewer, D:\Program Files (x86)\FastStone Image Viewer\FSViewer.exe
	Menu, QuickMenu, Add, MobiReader, TheMenuHandler
	Menu, QuickMenu, Icon,MobiReader, D:\Program Files\MobipocketReader6.2\MobipocketReader_6.2.exe
	Menu, QuickMenu, Add, BCompare, TheMenuHandler
	Menu, QuickMenu, Icon,BCompare, D:\Program Files (x86)\Beyond Compare 3\BCompare.exe
	Menu, QuickMenu, Add, RegexBuddy, TheMenuHandler
	Menu, QuickMenu, Icon,RegexBuddy, D:\prog\RegexBuddy 3\RegexBuddy.exe
	Menu, QuickMenu, Add, SQLite Expert, TheMenuHandler
	Menu, QuickMenu, Icon,SQLite Expert, D:\Program Files\gizmo\prog\SQLite Expert Professiona.exe
	Menu, QuickMenu, Add, LINQPad, TheMenuHandler
	Menu, QuickMenu, Icon,LINQPad, D:\prog\LINQPad\LINQPad.exe
	Menu, QuickMenu, Add, Source Insight, TheMenuHandler
	Menu, QuickMenu, Icon,Source Insight, D:\Program Files\Source Insight 3\Insight3.exe
	Menu, QuickMenu, Add, ToDoList, TheMenuHandler
	Menu, QuickMenu, Icon,ToDoList, D:\Program Files\todolist\ToDoList.exe
	Menu, QuickMenu, Add, Fiddler, TheMenuHandler
	Menu, QuickMenu, Icon,Fiddler, D:\prog\Fiddler2\Fiddler.exe
	Menu, QuickMenu, Add, SiwtchHosts, TheMenuHandler
	Menu, QuickMenu, Icon,SiwtchHosts, D:\Program Files\SwitchHosts\SwitchHosts.exe
	Menu, QuickMenu, Add, Navicat Premium, TheMenuHandler
	Menu, QuickMenu, Icon,Navicat Premium, D:\Program Files\Navicat Premium\navicat.exe
	Menu, QuickMenu, Add, Cmder, TheMenuHandler
	Menu, QuickMenu, Icon,Cmder, D:\Program Files\cmder\Cmder.exe
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
