!1:: Run %SublimeText%
!+s:: Run %XShell%
!+o:: Run %Outlook%
!+b:: Run %EditPlus%
!+t:: Run %Thunder%
!+q:: Run %QQ%

!b:: Run Notepad
!r:: 
	GetKeyState, state, LButton
	if(state = "D"){
		Run Cmd
	} else {
		Run Cmd, %A_Desktop%
	}
return
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


;360yunpan
!+2::
	DetectHiddenWindows Off
	IfWinExist, ahk_class 360WangPanMainDlg
	{
		WinHide, ahk_class 360WangPanMainDlg
		
	} else {
		WinShow, ahk_class 360WangPanMainDlg
		WinActivate, ahk_class 360WangPanMainDlg
	}
	DetectHiddenWindows On
return

;Photoshop
!0::
	WinActivate,ahk_class Photoshop,,,
return

