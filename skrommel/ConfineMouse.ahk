;ConfineMouse.ahk
; Confine the mouse to one monitor
;Save to ConfineMouse.ahk and install AutoHotkey from www.autohotkey.com
;Skrommel @2006

#SingleInstance,Force
CoordMode,Mouse,Screen

applicationname=ConfineMouse

Gosub,INIREAD
Gosub,TRAYMENU

Hotkey,%disable%,SWAP

If startdisabled=1
  Gosub,SWAP

SysGet,monitor,Monitor,%activemonitor%
Loop
{
  Sleep,100
  MouseGetPos,x,y
  If (x<monitorLeft)
    MouseMove,%monitorLeft%,%y%,0
  If (x>monitorRight)
    MouseMove,%monitorRight%,%y%,0
  If (y<monitorTop)
    MouseMove,%x%,%monitorTop%,0
  If (y>monitorBottom)
    MouseMove,%x%,%monitorBottom%,0
}


INIREAD:
IfNotExist,%applicationname%.ini
{
  activemonitor=1
  startdisabled=0
  disable=^D
  Gosub,INIWRITE
}
IniRead,activemonitor,%applicationname%.ini,Settings,activemonitor
IniRead,startdisabled,%applicationname%.ini,Settings,startdisabled
IniRead,disable,%applicationname%.ini,Settings,disable
Return

INIWRITE:
IniWrite,%activemonitor%,%applicationname%.ini,Settings,activemonitor
IniWrite,%startdisabled%,%applicationname%.ini,Settings,startdisabled
IniWrite,%disable%,%applicationname%.ini,Settings,disable
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,SWAP
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,SWAP
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Check,&Enabled
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return

SWAP:
Menu,Tray,ToggleCheck,&Enabled
Pause,Toggle
Return

SETTINGS:
HotKey,%disable%,Off
Gui,Destroy
SysGet,monitorcount,MonitorCount
Gui,Add,GroupBox,xm ym w220 h12,Monitor
Loop,%monitorcount%
{
  checked=
  If (A_Index=activemonitor)
    checked=Checked
  Gui,Add,Radio,xm+10 y+10 %checked% vvmonitor%A_Index%,Monitor &%A_Index%
}
Gui,Add,GroupBox,xm y+20 w220 h12,Startup
Gui,Add,Checkbox,xp+10 yp+20 Checked%startdisabled% Vvstartdisabled,&Start disabled

Gui,Add,GroupBox,xm y+20 w220 h12,Hotkey to &Disable confinement
Gui,Add,Hotkey,xp+10 yp+20 w200 vvdisable
StringReplace,current,disable,+,Shift +%A_Space%
StringReplace,current,current,^,Ctrl +%A_Space%
StringReplace,current,current,!,Alt +%A_Space%
Gui,Add,Text,xm+20 y+5,Current hotkey: %current%

Gui,Add,Button,xm y+20 w75 GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
startdisabled:=vstartdisabled
If vdisable<>
{
  disable:=vdisable
  HotKey,%disable%,SWAP
  HotKey,%disable%,On
}
SysGet,monitorcount,MonitorCount
Loop,%monitorcount%
  If vmonitor%A_Index%=1
    activemonitor:=A_Index
Gosub,INIWRITE
SysGet,monitor,Monitor,%activemonitor%
Return

SETTINGSCANCEL:
HotKey,%disable%,SWAP
HotKey,%disable%,On
Gui,Destroy
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Confine the mouse to one monitor.
Gui,99:Add,Text,y+10,- Press Ctrl-D to Disable, or doubleclick the tray icon to Toggle. 
Gui,99:Add,Text,y+10,- Change the settings using Settings in the tray menu.

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


EXIT:
ExitApp
