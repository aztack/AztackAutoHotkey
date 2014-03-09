;ClickToDesktop.ahk
; Click on the desktop to hide all windows, 
; or click at the top of the screen.
; Click again to unhide.
;Skrommel @ 2008

#SingleInstance,Force
#NoEnv
SendMode,Input
SetWorkingDir,%A_ScriptDir%
SetWinDelay,0
CoordMode,Mouse,Screen

applicationname=ClickToDesktop
Gosub,MENU
WinMinimizeAllUndo
hidden=0
Return


~LButton::
MouseGetPos,mx,my,mwin,mctrl
WinGetClass,class,ahk_id %mwin%
Return


~LButton Up::
If (my=0 And mx>A_ScreenWidth/4 And mx<A_ScreenWidth/4+A_ScreenWidth/2)
If hidden=0
{
  WinMinimizeAll
  hidden=1
  Return
}
Else
{
  WinMinimizeAllUndo
  hidden=0
  Return
}
If mctrl Not In SysListView321
  Return
If class Not In Progman,WorkerW
{
  If hidden=1
  {
    WinMinimizeAllUndo
    hidden=0
  }
  Return
}

WinWaitActive,ahk_id %mwin%
ControlGet,selected,List,Count Selected,%mctrl%,ahk_id %mwin%
If hidden=1
{
  If selected>0
    Return
  WinMinimizeAllUndo
  hidden=0
}
Else
{
  WinMinimizeAll
  hidden=1
}
Return


MENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname%
Menu,Tray,Default,%applicationname%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,- Click on the desktop to hide all windows,
Gui,99:Add,Text,xp+5 y+5,or click at the middle part of the top of the screen.
Gui,99:Add,Text,xp-5 y+10,- Click again to unhide.

Gui,99:Add,Picture,xm y+20 Icon2,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,99:Font
Gui,99:Add,Text,y+10,For more tools, information and donations, please visit 
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon7,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,DonationCoder
Gui,99:Font
Gui,99:Add,Text,y+10,Please support the contributors at
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,AutoHotkey
Gui,99:Font
Gui,99:Add,Text,y+10,This tool was made using the powerful
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,99:Font

Gui,99:Show,,%applicationname% About
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

1HOURSOFTWARE:
  Run,http://www.1hoursoftware.com,,UseErrorLevel
Return

DONATIONCODER:
  Run,http://www.donationcoder.com,,UseErrorLevel
Return

AUTOHOTKEY:
  Run,http://www.autohotkey.com,,UseErrorLevel
Return

ABOUTOK:
  Gui,99:Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static9,Static13,Static17
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp



