;Desktop.ahk
; Give the desktop it's own taskbar button
;Skrommel @ 2008

#SingleInstance,Force

applicationname=Desktop

RegRead,desktopname,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Desktop
StringSplit,desktoparray,desktopname,`\
desktopname=desktoparray%desktoparray0%
desktopname:=%desktopname%

Gui,Show,NoActivate,%desktopname%!
Menu,Tray,NoStandard
Menu,Tray,Add,%desktopname%!,DESKTOP
Menu,Tray,Add
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%desktopname%!
Menu,Tray,Tip,%applicationname%!

oldclass=
desktop=0
Loop
{
  WinGetClass,class,A
  Sleep,100
  IfWinActive,%desktopname%!
  {
    WinSet,Bottom,,%desktopname%!
    If desktop=0
    {
      WinMinimizeAll
      desktop=1
    }
    Else
    {
      If oldclass=Progman
        WinMinimizeAllUndo
      If oldclass=WorkerW
        WinMinimizeAllUndo
      If oldclass=Shell_TrayWnd
        WinMinimizeAllUndo
      desktop=0
    }
  }
  oldclass=%class%
}

DESKTOP:
WinActivate,%desktopname%!
Return

ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname%! v1.1
Gui,99:Font
Gui,99:Add,Text,y+10,Give the desktop it's own taskbar button
Gui,99:Add,Text,y+10,- Click it, drag files to it or Alt-Tab to it to show the desktop.

Gui,99:Add,Picture,xm y+20 Icon5,%applicationname%.exe
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

99GuiClose:
  Gui,99:Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static8,Static12,Static16
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp
