;PushMonitOff.ahk
; Press Shift-F1 to turn the monitor off
;Skrommel @ 2008

#SingleInstance,Force
#NoEnv

applicationname=PushMonitOff

active=0
Gosub,INIREAD
Gosub,TRAYMENU
Return


MONITOFF:
SendMessage,0x112,0xF170,2,,Program Manager
Return


MODIFIERDOWN:
Hotkey,*%button%,BUTTON,On
Return


MODIFIERUP:
If active=1
  Gosub,MONITOFF
active=0
Hotkey,*%button%,BUTTON,Off
Return


BUTTON:
active=1
Return


EXIT:
ExitApp


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
`;[Settings]
`;button=F1`tHotkey
`;modifier=Shift`t+=Shift ^=Ctrl !=Alt #=Win`tHotkey to turn off the screen

[Settings]
button=F1
modifier=Shift
)
FileAppend,%ini%,%applicationname%.ini
}
IniRead,button,%applicationname%.ini,Settings,button
IniRead,modifier,%applicationname%.ini,Settings,modifier
If button=ERROR
  button=F1
If modifier=ERROR
  modifier=Shift
Hotkey,~%modifier%,MODIFIERDOWN
Hotkey,~%modifier% Up,MODIFIERUP
Return


SETTINGS:
Gui,Destroy
FileRead,ini,%applicationname%.ini
Gui,Font,Courier New
Gui,Add,Edit,Vnewini -Wrap W400,%ini%
Gui,Font
Gui,Add,Button,GSETTINGSOK Default W75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Gui,Show,,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
FileDelete,%applicationname%.ini
FileAppend,%newini%,%applicationname%.ini
Gosub,INIREAD
Return


GuiEscape:
GuiClose:
SETTINGSCANCEL:
Gui,Destroy
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add
Menu,Tray,Add,&Settings...,SETTINGS
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
Gui,99:Add,Text,y+10,Press Shift-F1 to turn the monitor off
Gui,99:Add,Text,y+5,- Change settings using Settings in the Tray menu

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
