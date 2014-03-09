;DimScreen.ahk
; Dim the screen via the tray icon
;Skrommel @2007

#SingleInstance,Force
#NoEnv
SetWinDelay,0

applicationname=DimScreen

Gosub,INIREAD
Gosub,MENU
Gosub,GUI

LOOP:
WinGet,id,Id,A
WinSet,AlwaysOnTop,On,ahk_id %guiid%
WinWaitNotActive,ahk_id %id%
IfWinNotExist,ahk_id %guiid%
  Gosub,GUI
Goto,LOOP


CHANGE:
Menu,Tray,UnCheck,% "&" dimming*10 "%"
If A_ThisMenuItem<>
  dimming:=A_ThisMenuItemPos-3
Menu,Tray,Check,% "&" dimming*10 "%"
WinSet,Transparent,% dimming*255/10,ahk_id %guiid%
Return


DECREASE:
Menu,Tray,UnCheck,% "&" dimming*10 "%"
dimming-=1
If dimming<0
  dimming=0
Menu,Tray,Check,% "&" dimming*10 "%"
WinSet,Transparent,% dimming*255/10,ahk_id %guiid%
Return


GUI:
Gui,+ToolWindow -Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop 
Gui,Color,000000
Gui,Show,% "X0 Y0 W" . A_ScreenWidth "H" . A_ScreenHeight,%applicationname% Screen
Gui,+LastFound
WinGet,guiid,Id,A
Gosub,CHANGE
Return


MENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Default,%applicationname%
Menu,Tray,Add,
Loop,10
  Menu,Tray,Add,% "&" A_Index*10-10 "%",CHANGE
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,&Exit,EXIT
Menu,Tray,Tip,%applicationname%
Return


INCREASE:
Menu,Tray,UnCheck,% "&" dimming*10 "%"
dimming+=1
If dimming>9
  dimming=9
Menu,Tray,Check,% "&" dimming*10 "%"
WinSet,Transparent,% dimming*255/10,ahk_id %guiid%
Return


SETTINGS:
Hotkey,%hotkey1%,Off
Hotkey,%hotkey2%,Off
Gui,2:Destroy
Gui,2:Add,GroupBox,xm y+20 w175,&Startup dimming (0-90 `%)
Gui,2:Add,Edit,xp+10 yp+20 w155 vvdimming,% dimming*10
Gui,2:Add,GroupBox,xm y+20 w175 h70,&Increase dimming hotkey
Gui,2:Add,Hotkey,xp+10 yp+20 w155 vvhotkey1,% hotkey1
Gui,2:Add,Text,,Current: %hotkey1%
Gui,2:Add,GroupBox,xm y+20 w175 h70,&Decrease dimming hotkey
Gui,2:Add,Hotkey,xp+10 yp+20 w155 vvhotkey2,% hotkey2
Gui,2:Add,Text,,Current: %hotkey2%
Gui,2:Add,Button,xm y+20 w75 Default gSETTINGSOK,&OK
Gui,2:Add,Button,x+5 yp w75 gSETTINGSCANCEL,&CANCEL
Gui,2:Show,,%applicationname% Settings
Return


SETTINGSOK:
Gui,2:Submit
vdimming:=Floor(vdimming/10)
If (vdimming>=0 And vdimming<=9)
{
  IniWrite,%vdimming%,%applicationname%.ini,Settings,dimming
}
If vhotkey1<>
{
  hotkey1:=vhotkey1
  IniWrite,%hotkey1%,%applicationname%.ini,Settings,hotkey1
}
If vhotkey2<>
{
  hotkey2:=vhotkey2
  IniWrite,%hotkey2%,%applicationname%.ini,Settings,hotkey2
}

SETTINGSCANCEL:
Gui,2:Destroy
Hotkey,%hotkey1%,INCREASE
Hotkey,%hotkey2%,DECREASE
Return


INIREAD:
IniRead,dimming,%applicationname%.ini,Settings,dimming
If dimming=Error
  dimming=5
IniRead,hotkey1,%applicationname%.ini,Settings,hotkey1
If hotkey1=Error
  hotkey1=^+
IniRead,hotkey2,%applicationname%.ini,Settings,hotkey2
If hotkey2=Error
  hotkey2=^-
Hotkey,%hotkey1%,INCREASE
Hotkey,%hotkey2%,DECREASE
Return


ABOUT:
Gui,2:Destroy
Gui,2:Margin,20,20
Gui,2:Add,Picture,xm Icon1,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,%applicationname% v1.1
Gui,2:Font
Gui,2:Add,Text,y+10,Dim the whole screen.
Gui,2:Add,Text,xp y+5,- Change the brightness by selecting a `% in the tray menu.
Gui,2:Add,Text,xp y+5,- Or use the hotkeys Ctrl++ and Ctrl+-.
Gui,2:Add,Text,xp y+5,- Change hotkeys using Settings in the tray menu.
Gui,2:Add,Text,xp y+5,- Doesn't work properly with video windows.

Gui,2:Add,Picture,xm y+20 Icon2,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,2:Font
Gui,2:Add,Text,y+10,For more tools, information and donations, please visit 
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,2:Font

Gui,2:Add,Picture,xm y+20 Icon7,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,DonationCoder
Gui,2:Font
Gui,2:Add,Text,y+10,Please support the contributors at
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
Gui,2:Font

Gui,2:Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,AutoHotkey
Gui,2:Font
Gui,2:Add,Text,y+10,This tool was made using the powerful
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,2:Font

Gui,2:Show,,%applicationname% - About

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
Gui,2:Destroy
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static11,Static15,Static19
    DllCall("SetCursor","UInt",hCurs)
  Return
}


EXIT:
ExitApp