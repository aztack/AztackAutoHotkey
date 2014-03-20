!1:: Run %SublimeText%
!+s:: Run %XShell%
!+o:: Run %Outlook%
!+l:: Run %Lingoes%
!+b:: Run %EditPlus%
!+t:: Run %Thunder%
!+q:: Run %QQ%

!b:: Run Notepad
!r:: Run Cmd
!t:: Run Taskmgr
!3:: Run Mspaint
!5:: Run Calc

!c:: Run e:\doc
!z:: Run d:\program files
!x:: Run e:\doc\github

;edit specific files
#F8:: Run %SublimeText% "C:\Windows\System32\drivers\etc\hosts"
#F7:: Edit %A_ScriptFullPath%

#IfWinActive ahk_class MSPaintApp
	Esc::Send !{F4}
#IfWinActive

#IfWinActive ahk_class Notepad
	Esc::Send !{F4}
#IfWinActive

