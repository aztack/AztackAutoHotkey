;SingleApp.ahk
; Only allow one application to be active
;Skrommel @ 2005

#SingleInstance,Force
DetectHiddenWindows,On
SetWinDelay,0

applicationname=SingleApp

OnExit,EXIT
Gosub,READINI
Gosub,TRAYMENU

gui=
;Gui,-Border -Caption -SysMenu +OwnDialogs +ToolWindow +0x02000000 ; WS_CLIPCHILDREN
;Gui,Show,X0 Y0 W%A_ScreenWidth% H%A_ScreenHeight%,%applicationname%
;Gui,+LastFound,
;WinGet,gui,Id,A

Loop
{
;  WinActivate,ahk_id %gui%
If gui<>
{
  WinActivate,ahk_id %gui%
  Continue
}
  WinActivate,ahk_pid %pid%
  WinWaitNotActive,ahk_pid %pid%
;  IfWinNotActive,ahk_id %gui%
;    WinActivate,ahk_pid %pid%
  IfWinNotExist,ahk_pid %pid%
  {
;    WinActivate,ahk_id %gui%
    BlockInput,On
    Run,%command%,,Max,pid
    WinWait,ahk_pid %pid%
    WinActivate,ahk_pid %pid%
    WinGet,id,Id,ahk_pid %pid%
;    DllCall("SetParent",UInt,id,UInt,gui) 
    BlockInput,Off
  }
  IfWinExist,ahk_class #32770,CPU
    WinClose,ahk_class #32770,CPU
}


READINI:
IfNotExist,%applicationname%.ini
{
  ini=;[Settings]
  ini=%ini%`n`;command=C:\Windows\Notepad.exe  `;Command to run when active window is closed
  ini=%ini%`n
  ini=%ini%`n[Settings]
  ini=%ini%`ncommand=Notepad.exe
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
IniRead,command,%applicationname%.ini,Settings,command
Return


TRAYMENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,PASSWORD
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,PASSWORD
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


TOOLTIP(tooltip)
{
  ToolTip,%tooltip%
  SetTimer,TOOLTIPOFF,10000
  Return
}


TOOLTIPOFF:
SetTimer,TOOLTIPOFF,Off
ToolTip,
Return


PASSWORD:
Gui,2:Destroy
Gui,2:Add,Text,,Password?
Gui,2:Add,Edit,w180 Vinput Password
Gui,2:Add,Button,w75 Default GOK,&OK
Gui,2:Show,w200 h100,Password
oldgui:=gui
Gui,2:+LastFound,
WinGet,gui,Id,A
Return


OK:
Gui,2:Submit
If input<>SingleApp
{
  gui:=oldgui
  Return
}
Gosub,EXIT
Return


EXIT:
ExitApp


F12::ExitApp


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Only allow one application to be active
Gui,99:Add,Text,y+5,- Autmatically restart the application when the watched window is closed
Gui,99:Add,Text,y+5,- Password protected

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
  If ctrl in Static9,Static13,Static17
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return

