;PlainPaste.ahk
; Press Ctrl-V once to paste regularly, or twice fast to paste as text.
; Also Control Ctrl-C and Ctrl-X.
;Skrommel @2006

#SingleInstance,Force
SetBatchLines,-1
StringTrimRight,applicationname,A_ScriptName,4
Gosub,TRAYMENU
Gosub,INI
pastecounter=0
copycounter=0
cutcounter=0
Return

PASTEONCE:
pastecounter+=1
SetTimer,PASTETWICE,%delay%
Return

PASTETWICE:
SetTimer,PASTETWICE,Off
wholeclipboard:=ClipboardAll
If pastecounter>1
  Clipboard=%Clipboard%
pastecounter=0
Send,^v
Clipboard:=wholeclipboard
Return


COPYONCE:
copycounter+=1
SetTimer,COPYTWICE,%delay%
Return

COPYTWICE:
SetTimer,COPYTWICE,Off
Send,^c
If copycounter>1
  Clipboard=%Clipboard%
copycounter=0
Return

CUTONCE:
cutcounter+=1
SetTimer,CUTTWICE,%delay%
Return

CUTTWICE:
SetTimer,CUTTWICE,Off
Send,^x
If cutcounter>1
  Clipboard=%Clipboard%
cutcounter=0
Return


INI:
IfNotExist,%applicationname%.ini
{
  ini=`;%applicationname%.ini
  ini=%ini%`n[Settings]
  ini=%ini%`nplainpaste=1
  ini=%ini%`nplaincopy=0
  ini=%ini%`nplaincut=0
  ini=%ini%`ndelay=333
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
IniRead,plainpaste,%applicationname%.ini,Settings,plainpaste
IniRead,plaincopy,%applicationname%.ini,Settings,plaincopy
IniRead,plaincut,%applicationname%.ini,Settings,plaincut
IniRead,delay,%applicationname%.ini,Settings,delay
If plainpaste=1
  Hotkey,$^v,PASTEONCE,On
If plaincopy=1
  Hotkey,$^c,COPYONCE,On
If plaincut=1
  Hotkey,$^x,CUTONCE,On
Return


SETTINGS:
Gui,Destroy
Gui,Add,GroupBox,xm w250 h80,&Hotkeys
Gui,Add,CheckBox,xm+10 yp+20 Checked%plainpaste% Vsplainpaste,Plain &Paste (Ctrl-V)
Gui,Add,CheckBox,xm+10 yp+20 Checked%plaincopy% Vsplaincopy,Plain &Copy (Ctrl-C)
Gui,Add,CheckBox,xm+10 yp+20 Checked%plaincut% Vsplaincut,Plain C&ut (Ctrl-X)
Gui,Add,GroupBox,xm y+20 w250 h50,&Delay between double key presses (default=333)
Gui,Add,Edit,xm+10 yp+20 w230 r1 vsdelay,%delay%
Gui,Add,Button,xm y+20 w75 GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,w270,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
If plainpaste=1
  Hotkey,$^v,PASTEONCE,Off
If plaincopy=1
  Hotkey,$^c,COPYONCE,Off
If plaincut=1
  Hotkey,$^x,CUTONCE,Off
plainpaste:=splainpaste
plaincopy:=splaincopy
plaincut:=splaincut
If sdelay<>
  delay:=sdelay
IniWrite,%plainpaste%,%applicationname%.ini,Settings,plainpaste
IniWrite,%plaincopy%,%applicationname%.ini,Settings,plaincopy
IniWrite,%plaincut%,%applicationname%.ini,Settings,plaincut
IniWrite,%delay%,%applicationname%.ini,Settings,delay
Gosub,SETTINGSCANCEL
Return

SETTINGSCANCEL:
Gui,Destroy
If plainpaste=1
  Hotkey,$^v,PASTEONCE,On
If plaincopy=1
  Hotkey,$^c,COPYONCE,On
If plaincut=1
  Hotkey,$^x,CUTONCE,On
Return


TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,Se&ttings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Press Ctrl-V once to paste regularly, or twice fast to paste as text.
Gui,99:Add,Text,y+5,- Also control Ctrl-C and Ctrl-X.
Gui,99:Add,Text,y+5,- Change the settings by choosing Settings in the Tray menu.

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