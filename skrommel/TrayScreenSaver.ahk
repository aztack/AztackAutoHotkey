;TrayScreenSaver.ahk
; Control the screensaver from the tray
;Skrommel @ 2006

#SingleInstance,Force
#Persistent

applicationname=TrayScreenSaver

Gosub,TRAYMENU
Gosub,ACTIVE
Return


TRAYMENU:
savers=
Loop,%A_WinDir%\*.scr
  savers=%savers%%A_LoopFileName%`n
Loop,%A_WinDir%\System32\*.scr
  savers=%savers%%A_LoopFileName%`n
StringSplit,savers_,savers,`n
savers_0-=1

Menu,Tray,Click,1 
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,DOUBLECLICK
Menu,Tray,Add,

Loop,%savers_0%
{
  screensaver:=savers_%A_Index%
  Menu,Tray,Add,%screensaver%,SELECT
}

Menu,Tray,Add,
Menu,Tray,Add,&Run,RUN
Menu,Tray,Add,&Enabled,TOGGLE
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Check,&Enabled
Menu,Tray,Tip,%applicationname%
Return


SELECT:
Run,%A_ThisMenuItem% /s
Return


SINGLECLICK:
SetTimer,SINGLECLICK,Off 
clicks=
Gosub,TOGGLE
Return 


DOUBLECLICK: 
If clicks= 
{ 
  SetTimer,SINGLECLICK,500
  clicks=1 
  Return 
} 
SetTimer,SINGLECLICK,Off 
clicks= 
Gosub,RUN
Return


TOGGLE:
RegRead,active,HKEY_CURRENT_USER,Control Panel\Desktop,ScreenSaveActive
If active=1
  active=0
Else
  active=1
RegWrite,Reg_SZ,HKEY_CURRENT_USER,Control Panel\Desktop,ScreenSaveActive,%active%
Gosub,ACTIVE
Return


ACTIVE:
RegRead,active,HKEY_CURRENT_USER,Control Panel\Desktop,ScreenSaveActive
If active=1
{
  Menu,Tray,Icon,%applicationname%.exe,1,1
  Menu,Tray,Check,&Enabled
}
Else
{
  Menu,Tray,Icon,%applicationname%.exe,4,4
  Menu,Tray,UnCheck,&Enabled
}
Return


RUN:
RegRead,screensaver,HKEY_CURRENT_USER,Control Panel\Desktop,ScrnSave.Exe
IfInString,screensaver,.scr
  Run,%screensaver% /s
Else
  Gosub,SETTINGS
Return


SETTINGS:
RegRead,screensaver,HKEY_CURRENT_USER,Control Panel\Desktop,ScrnSave.Exe
Run,rundll32.exe desk.cpl`,InstallScreenSaver %screensaver%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Control the screensaver from the tray
Gui,99:Add,Text,y+5,- Singleclick to enable or disable the screensaver
Gui,99:Add,Text,y+5,- Doubleclick the tray icon to run the default screensaver
Gui,99:Add,Text,y+5,- Run any screensaver from the tray menu
Gui,99:Add,Text,y+5,- Change settings using Settings in the tray menu

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
  If ctrl in Static10,Static14,Static18
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp
