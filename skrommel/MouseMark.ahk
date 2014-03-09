;MouseMark.ahk
; Press Ctrl+M to locate the mouse.
;Skrommel @ 2006

#SingleInstance,Force 
SetWinDelay,0 
DetectHiddenWindows,On
CoordMode,Mouse,Screen 

applicationname=MouseMark

Gosub,INI
Gosub,TRAYMENU
Return


DOWN:
down=1
Loop,2 
{ 
  MouseGetPos,x,y 
  size:=size%A_Index%
  width:=size%A_Index%*1.4
  height:=size%A_Index%*1.4
  color:=color%A_Index%
  boldness:=boldness%A_Index%
  Gui,%A_Index%:Destroy
  Gui,%A_Index%:+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow 
  Gui,%A_Index%:Margin,0,0 
  Gui,%A_Index%:Color,123456
  Gui,%A_Index%:Font,C%color% S%size% W%boldness%,Wingdings
  Gui,%A_Index%:Add,Text,,±
  Gui,%A_Index%:Show,X-%width% Y-%height% W%width% H%height% NoActivate,%applicationname%%A_Index%
  WinSet,TransColor,123456,%applicationname%%A_Index%
}
Loop
{
  Loop,2
  {
    MouseGetPos,x,y 
    WinMove,%applicationname%%A_Index%,,% x-size%A_Index%/1.7,% y-size%A_Index%/1.4
    WinShow,%applicationname%%A_Index%
    Sleep,%delay%
    WinHide,%applicationname%%A_Index%
    Sleep,%delay% 
    If down=0
      Return
  }
}
Return


UP:
down=0
Loop,2 
{ 
  Gui,%A_Index%:Destroy
}
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
HotKey,%hotkey% Up,Off
Gui,Destroy
Gui,Add,GroupBox,xm ym w400 h70,&Hotkey
Gui,Add,Hotkey,xp+10 yp+20 w380 vshotkey
StringReplace,current,hotkey,+,Shift +%A_Space%
StringReplace,current,current,^,Ctrl +%A_Space%
StringReplace,current,current,!,Alt +%A_Space%
Gui,Add,Text,,Current hotkey: %current%
Gui,Add,GroupBox,xm y+20 w400 h50,&Delay
Gui,Add,Edit,xp+10 yp+20 w380 vsdelay,%delay%
Gui,Add,GroupBox,xm y+20 w400 h110,Mark &1
Gui,Add,Text,xp+10 yp+20,&Size1:
Gui,Add,Edit,xm+100 yp w290 vssize1,%size1%
Gui,Add,Text,xm+10 y+10,Colo&r1:
Gui,Add,Edit,xm+100 yp w290 vscolor1,%color1%
Gui,Add,Text,xm+10 y+10,&Boldness1:
Gui,Add,Edit,xm+100 yp w290 vsboldness1,%boldness1%
Gui,Add,GroupBox,xm y+20 w400 h110,Mark &2
Gui,Add,Text,xp+10 yp+20,S&ize2:
Gui,Add,Edit,xm+100 yp w290 vssize2,%size2%
Gui,Add,Text,xm+10 y+10,Co&lor2:
Gui,Add,Edit,xm+100 yp w290 vscolor2,%color2%
Gui,Add,Text,xm+10 y+10,Bol&dness2:
Gui,Add,Edit,xm+100 yp w290 vsboldness2,%boldness2%
Gui,Add,Button,xm y+10 w75 GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
If shotkey<>
{
  hotkey:=shotkey
  HotKey,%hotkey%,DOWN
  HotKey,%hotkey% Up,UP
}
HotKey,%hotkey%,On
HotKey,%hotkey% Up,On
If sdelay<>
  delay:=sdelay
If ssize1<>
  size1:=ssize1
If ssize2<>
  size2:=ssize2
If scolor1<>
  color1:=scolor1
If scolor2<>
  color2:=scolor2
If sboldness1<>
  boldness1:=sboldness1
If sboldness2<>
  boldness2:=sboldness2
IniWrite,%hotkey%,%applicationname%.ini,Settings,hotkey
IniWrite,%delay%,%applicationname%.ini,Settings,delay
IniWrite,%size1%,%applicationname%.ini,Settings,size1
IniWrite,%size2%,%applicationname%.ini,Settings,size2
IniWrite,%color1%,%applicationname%.ini,Settings,color1
IniWrite,%color2%,%applicationname%.ini,Settings,color2
IniWrite,%boldness1%,%applicationname%.ini,Settings,boldness1
IniWrite,%boldness2%,%applicationname%.ini,Settings,boldness2
Return

SETTINGSCANCEL:
HotKey,%hotkey%,DOWN,On
HotKey,%hotkey% Up,UP,On
HotKey,%hotkey%,On
HotKey,%hotkey% Up,On
Gui,Destroy
Return


INI:
IfNotExist,%applicationname%.ini
{
  IniWrite,^M,%applicationname%.ini,Settings,hotkey
  IniWrite,200,%applicationname%.ini,Settings,delay
  IniWrite,100,%applicationname%.ini,Settings,size1
  IniWrite,300,%applicationname%.ini,Settings,size2
  IniWrite,FF0000,%applicationname%.ini,Settings,color1
  IniWrite,0000FF,%applicationname%.ini,Settings,color2
  IniWrite,1,%applicationname%.ini,Settings,boldness1
  IniWrite,2,%applicationname%.ini,Settings,boldness2
}
IniRead,hotkey,%applicationname%.ini,Settings,hotkey
IniRead,delay,%applicationname%.ini,Settings,delay
IniRead,size1,%applicationname%.ini,Settings,size1
IniRead,size2,%applicationname%.ini,Settings,size2
IniRead,color1,%applicationname%.ini,Settings,color1
IniRead,color2,%applicationname%.ini,Settings,color2
IniRead,boldness1,%applicationname%.ini,Settings,boldness1
IniRead,boldness2,%applicationname%.ini,Settings,boldness2
HotKey,%hotkey%,DOWN
HotKey,%hotkey% Up,UP
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Press Ctrl+M to locate the mouse.
Gui,99:Add,Text,y+10,- To change the settings, choose Settings in the tray menu.

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