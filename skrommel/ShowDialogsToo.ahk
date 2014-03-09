;ShowDialogsToo.ahk
; Shows dialog boxes on the task bar
;Skrommel @2005

#SingleInstance,Force
SetWinDelay,0

applicationname=ShowDialogsToo

WinGet,parent,ID,ahk_class ExploreWClass
Gosub,READINI
Gosub,TRAYMENU

Loop
{
  Gosub,CHANGEDINI
  Sleep,1000
  WinGet,id,ID,A
  WinGetTitle,title,ahk_id %id%
  WinGetClass,class,ahk_id %id%
  match=0
  Loop,%title_0%
  {
    line:=title_%A_Index%
    StringLen,length,line
    StringLeft,text,title,%length%
    If text=%line%
    {
      match=1
      Break
    }
  }
  Loop,%class_0%
  {
    line:=class_%A_Index%
    If class=%line%
    {
      match=1
      Break
    }
  } 
  If match=1
    Continue

  WinGet,exstyle,ExStyle,ahk_id %id%
  If(exstyle & 0x40000)
    Continue
  WinSet,ExStyle,+0x40000,ahk_id %id%
  DetectHiddenWindows,On
  WinHide,ahk_id %id%
  WinShow,ahk_id %id%
  DetectHiddenWindows,Off
}

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,TOGGLE
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,TOGGLE
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,ToggleCheck,&Enabled
Menu,Tray,Tip,%applicationname%
Return

TOGGLE:
Menu,Tray,ToggleCheck,&Enabled
Pause,Toggle
Return

SETTINGS:
Gosub,READINI
Run,%applicationname%.ini
Return

EXIT:
ExitApp

READINI:
IfNotExist,%applicationname%.ini
{
ini=`;%applicationname%.ini
ini=%ini%`n`;List the title of the windows to exclude. 
ini=%ini%`n`;Use ahk_class followed by the classname to exclude a class.
ini=%ini%`n`;
ini=%ini%`n`;Examples:
ini=%ini%`n`;Start-menu                 Excludes the windows with the title beginning with Start-menu 
ini=%ini%`n`;ahk_class DV2ControlHost   Excludes the windows of the class DV2ControlHost
ini=%ini%`n
ini=%ini%`nStart-menu
ini=%ini%`nahk_class DV2ControlHost
FileAppend,%ini%,%applicationname%.ini
ini=
}
titles=
classes=
Loop,Read,%applicationname%.ini
{
  StringTrimRight,line,A_LoopReadLine,0
  If line=
    Continue
  StringLeft,char,line,1
  If char=`;
    Continue
  StringLeft,chars,line,9
  If chars=ahk_class
  {
    StringTrimLeft,line,line,10
    classes=%classes%%line%`n
  }
  else
    titles=%titles%%line%`n
}
char=
chars=
line=
StringSplit,title_,titles,`n
title_0-=1
titles=
StringSplit,class_,classes,`n
class_0-=1
classes=
Return

CHANGEDINI:
FileGetAttrib,attrib,%applicationname%.ini
IfInString,attrib,A
{
  Gosub,READINI
  FileSetAttrib,-A,%applicationname%.ini
}
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Show dialog boxes on the task bar.
Gui,99:Add,Text,y+5,- To exclude windows, choose Settings in the menu of the Tray Icon.

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
