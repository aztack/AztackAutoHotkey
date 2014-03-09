;ShiftOff.ahk
; Turns off CapsLock when Shift is pressed together with A-Z or other user defined keys.
; Also makes CapsLock work like Shift when pressed togheter with A-Z or other user defined keys.
;Skrommel @2006

#SingleInstance,Force
#Persistent
SetBatchLines,-1
SendMode,Input
SetKeyDelay,0

applicationname=ShiftOff
Gosub,TRAYMENU
Gosub,INI
Return


DOWN:
SetCapsLockState,Off
StringReplace,hotkey,A_ThisHotkey,% "CapsLock & ",+
StringReplace,hotkey,hotkey,+,
Send,%hotkey%
Return


UP:
IfInString,A_ThisHotkey,CapsLock &
  SetCapsLockState,On
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
Gui,Destroy
Gui,Add,GroupBox,w400 h70,&Keys
Gui,Add,Button,y+10 w75 GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Add,Edit,xm+10 ym+30 w380 vskeys,%keys%
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
keys:=skeys
IniWrite,%keys%,%applicationname%.ini,Settings,keys
Return

SETTINGSCANCEL:
Gui,Destroy
Return


INI:
IfNotExist,%applicationname%.ini
  IniWrite,ABCDEFGHIJKLMNOPQRSTUVWXYZ∆ÿ≈,%applicationname%.ini,Settings,keys
IniRead,keys,%applicationname%.ini,Settings,keys
If keys=ERROR
  keys=ABCDEFGHIJKLMNOPQRSTUVWXYZ
Loop,Parse,keys
{
  Hotkey,+%A_LoopField%,DOWN
  Hotkey,+%A_LoopField% Up,UP
  Hotkey,CapsLock & %A_LoopField%,DOWN
  Hotkey,CapsLOck & %A_LoopField% Up,UP
}
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Turns off CapsLock when Shift is pressed together 
Gui,99:Add,Text,xp+10 y+0,with A-Z or other user defined keys.
Gui,99:Add,Text,xp-10 y+0,- Also makes CapsLock work like Shift when pressed togheter 
Gui,99:Add,Text,xp y+0,with A-Z or other user defined keys.
Gui,99:Add,Text,xp y+5,- To change the keys, choose Settings in the tray menu.

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
  If ctrl in Static11,Static15,Static19
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp