;BlockInput.ahk
; Temporarily block all input by pressing a hotkey
; To run, save to BlockInput.ahk and install AutoHotkey from www.autohotkey.com
;Skrommel @2006

#SingleInstance,Force

applicationname=BlockInput

Gosub,INI
Gosub,TRAYMENU
Return

HOTKEY:
Loop
{
  GetKeyState,shift,Shift,P
  GetKeyState,ctrl,Ctrl,P
  GetKeyState,alt,Alt,P
  If (shift="U" And ctrl="U" And alt="U")  
    Break
}

BlockInput,On
counter:=delay
Loop,%delay%
{
  ToolTip,BlockInput resumes in %counter% seconds
  counter-=1
  Sleep,1000
}
ToolTip
BlockInput,Off
Return

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


SETTINGS:
HotKey,%hotkey%,Off
Gui,Destroy
Gui,Add,GroupBox,xm ym w400 h70,&Hotkey
Gui,Add,Hotkey,xp+10 yp+20 w380 vshotkey
StringReplace,current,hotkey,+,Shift +%A_Space%
StringReplace,current,current,^,Ctrl +%A_Space%
StringReplace,current,current,!,Alt +%A_Space%
Gui,Add,Text,,Current hotkey: %current%
Gui,Add,GroupBox,xm y+20 w400 h50,&Delay
Gui,Add,Edit,xp+10 yp+20 w380 vsdelay,%delay%
Gui,Add,Button,xm y+10 w75 GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
If shotkey<>
{
  hotkey:=shotkey
  HotKey,%hotkey%,HOTKEY
}
HotKey,%hotkey%,On
If sdelay<>
  delay:=sdelay
IniWrite,%hotkey%,%applicationname%.ini,Settings,hotkey
IniWrite,%delay%,%applicationname%.ini,Settings,delay
Return

SETTINGSCANCEL:
HotKey,%hotkey%,HOTKEY
HotKey,%hotkey%,On
Gui,Destroy
Return


INI:
IfNotExist,%applicationname%.ini
{
  IniWrite,^Q,%applicationname%.ini,Settings,hotkey
  IniWrite,5,%applicationname%.ini,Settings,delay
}
IniRead,hotkey,%applicationname%.ini,Settings,hotkey
IniRead,delay,%applicationname%.ini,Settings,delay
HotKey,%hotkey%,HOTKEY
HotKey,%hotkey%,On
Return



ABOUT:
Gui,Destroy
Gui,Margin,20,20
Gui,Add,Picture,xm Icon1,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,Font
Gui,Add,Text,y+10,- Press Ctrl+Q to temporarily block all input.
Gui,Add,Text,y+10,- To change the settings, choose Settings in the tray menu.

Gui,Add,Picture,xm y+20 Icon2,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,y+10,For more tools, information and donations, please visit 
Gui,Font,CBlue Underline
Gui,Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font

Gui,Add,Picture,xm y+20 Icon7,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,DonationCoder
Gui,Font
Gui,Add,Text,y+10,Please support the contributors at
Gui,Font,CBlue Underline
Gui,Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
Gui,Font

Gui,Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,AutoHotkey
Gui,Font
Gui,Add,Text,y+10,This tool was made using the powerful
Gui,Font,CBlue Underline
Gui,Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,Font

Gui,Add,Button,GABOUTOK Defaultw75,&OK

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

