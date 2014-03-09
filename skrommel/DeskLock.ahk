;DeskLock.ahk
; Prevents the moving of desktop icons.
;Skrommel @2006

#SingleInstance,Force
#NoEnv
CoordMode,Mouse,Screen

applicationname=DeskLock

Gosub,INIREAD
Gosub,TRAYMENU

Hotkey,%disable%,SWAP,UseErrorLevel

If startdisabled=1
  Gosub,SWAP

If nomove=1
  Hotkey,~LButton,LBUTTON,On UseErrorLevel

If showinfo=1
  SetTimer,SHOWINFO,100

If norbutton=1
Loop
{
  Sleep,10
  MouseGetPos,,,winid
  WinGetClass,class,ahk_id %winid%
  If class In %classes%
    Hotkey,RButton,RBUTTON,On UseErrorLevel
  Else
    Hotkey,RButton,Off,UseErrorLevel
}
Return


RBUTTON:
Return


LBUTTON:
Loop
{
  x2:=x1
  y2:=y1
  Sleep,0
  MouseGetPos,x2,y2,winid
  WinGetClass,class,ahk_id %winid%
  If class Not In %classes%
    Return

  If class In %classes%
  If (x2<>x1 Or y2<>y1)
  {
    Click,Up,%x1%,%y1%
    MouseMove,%x2%,%y2%
    Return
  }
  GetKeyState,state,LButton,P
  If state=U
    Return
}
Return


SHOWINFO:
MouseGetPos,,,winid
WinGetClass,class,ahk_id %winid%
ToolTip,%class%
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  nomove=1
  norbutton=1
  classes=Progman
  showinfo=0
  startdisabled=0
  disable=^!D
  Gosub,INIWRITE
}
IniRead,nomove,%applicationname%.ini,Settings,nomove
IniRead,norbutton,%applicationname%.ini,Settings,norbutton
IniRead,classes,%applicationname%.ini,Settings,classes
IniRead,showinfo,%applicationname%.ini,Settings,showinfo
IniRead,startdisabled,%applicationname%.ini,Settings,startdisabled
IniRead,disable,%applicationname%.ini,Settings,disable
Return

INIWRITE:
IniWrite,%nomove%,%applicationname%.ini,Settings,nomove
IniWrite,%norbutton%,%applicationname%.ini,Settings,norbutton
IniWrite,%classes%,%applicationname%.ini,Settings,classes
IniWrite,%showinfo%,%applicationname%.ini,Settings,showinfo
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
Suspend,Toggle
Return


EXIT:
ExitApp


SETTINGS:
HotKey,%disable%,Off,UseErrorLevel
Gui,Destroy
Gui,Add,GroupBox,xm y+10 w220 h95,Settings
Gui,Add,Checkbox,xm+10 yp+20 Checked%nomove% Vvnomove,&Lock icons
Gui,Add,Checkbox,xm+10 y+5 Checked%norbutton% Vvnorbutton,Disable &right mouse button
Gui,Add,Checkbox,xm+10 y+5 Checked%startdisabled% Vvstartdisabled,Start &disabled
Gui,Add,Checkbox,xm+10 y+5 Checked%showinfo% Vvshowinfo,&Show class

Gui,Add,GroupBox,xm y+20 w220 h70,Hotkey to &disable DeskLock
Gui,Add,Hotkey,xm+10 yp+20 w200 vvdisable
StringReplace,current,disable,+,Shift +%A_Space%
StringReplace,current,current,^,Ctrl +%A_Space%
StringReplace,current,current,!,Alt +%A_Space%
Gui,Add,Text,xm+10 y+5,Current hotkey: %current%

Gui,Add,GroupBox,xm y+20 w220 h105,&Classes to lock
Gui,Add,Edit,xm+10 yp+20 h60 w200 Vvclasses,%classes%
Gui,Add,Text,xm+10 y+5,Format: Class1,Class2,Class3

Gui,Add,Button,xm y+20 w75 Default GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
nomove:=vnomove
norbutton:=vnorbutton
If classes<>
  classes:=vclasses
showinfo:=vshowinfo
startdisabled:=vstartdisabled
If vdisable<>
  disable:=vdisable
Gosub,INIWRITE
Reload
Return

SETTINGSCANCEL:
Gui,Destroy
HotKey,%disable%,SWAP,On UseErrorLevel
Return


ABOUT:
Gui,Destroy
Gui,Add,Picture,Icon1,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,Font
Gui,Add,Text,xm,Prevents the moving of desktop icons.
Gui,Add,Text,xm,- DoubleClick the tray icon to Disable/Enable.
Gui,Add,Text,xm,- Change the settings using Settings in the tray menu.
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm Icon2,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,xm,For more tools, information and donations, visit
Gui,Font,CBlue Underline
Gui,Add,Text,xm G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm Icon5,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,DonationCoder
Gui,Font
Gui,Add,Text,xm,Please support the DonationCoder community
Gui,Font,CBlue Underline
Gui,Add,Text,xm GDONATIONCODER,www.DonationCoder.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm Icon6,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,AutoHotkey
Gui,Font
Gui,Add,Text,xm,This program was made using AutoHotkey
Gui,Font,CBlue Underline
Gui,Add,Text,xm GAUTOHOTKEY,www.AutoHotkey.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Button,GABOUTOK Default w75,&OK
Gui,Show,,%applicationname% About

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
Gui,Destroy
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static10,Static15,Static20
    DllCall("SetCursor","UInt",hCurs)
  Return
}
