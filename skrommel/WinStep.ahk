;WinStep.ahk
; Step through groups of windows using hotkeys
;Skrommel @ 2005

#SingleInstance,Force
SetTitleMatchMode,2

applicationname=WinStep

Gosub,READINI
Gosub,TRAYMENU

Loop
{
  Sleep,100
  GetKeyState,shift,LShift,P
  GetKeyState,ctrl,LCtrl,P
  GetKeyState,alt,LAlt,P
  GetKeyState,win,LWin,P
  shifts=%shift%%ctrl%%alt%%win%
  keys=
  Loop,10
  {
    key:=A_Index-1
    GetKeyState,state,%key%,P
    keys=%keys%%state%
  }
  StringGetPos,key,keys,D
  state=%shifts%%key%
  StringLen,length,state 
  If length=5
  If shifts=%add%
  {
    WinGet,%add%%key%,ID,A
    window:=%add%%key%
    WinGetTitle,title,ahk_id %window%
    SoundPlay,%addsound%
    GroupAdd,group%key%,ahk_id %window%
    TOOLTIP("Added to Group" key ": " title)
  }
  Else
  If shifts=%show%
  {
    SoundPlay,%showsound%
    GroupActivate,group%key% 
    TOOLTIP("Activating Group" key)
  }
}  


TOOLTIP(tooltip,timeout=3000)
{
  ToolTip,%tooltip%
  Sleep,1000
  SetTimer,TOOLTIPOFF,%timeout%
  Return
}


TOOLTIPOFF:
SetTimer,TOOLTIPOFF,Off
ToolTip
Return


TRAYMENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,Exit
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


SETTINGS:
Gosub,READINI
RunWait,%applicationname%.ini
Gosub,READINI
Return


EXIT:
ExitApp


READINI:
IfNotExist,%applicationname%.ini
{
ini=`;[Settings]
ini=%ini%`n`;addsound=C:\Windows\Media\notify.wav  `;Sound to play when adding a window to a group
ini=%ini%`n`;showsound=C:\Windows\Media\ding.wav   `;Sound to play when showing a window
ini=%ini%`n`;addshift=0                            `;0=No 1=Yes  Use shift in show Hotkey?
ini=%ini%`n`;addctrl=1                             `;                ctrl
ini=%ini%`n`;addalt=0                              `;                alt
ini=%ini%`n`;addwin=0                              `;                win
ini=%ini%`n`;showshift=0                           `;0=No 1=Yes  Use shift in show Hotkey?
ini=%ini%`n`;showctrl=0                            `;                ctrl
ini=%ini%`n`;showalt=1                             `;                alt
ini=%ini%`n`;showwin=0                             `;                win
ini=%ini%`n
ini=%ini%`n[Settings]
ini=%ini%`naddsound=C:\Windows\Media\notify.wav
ini=%ini%`nshowsound=C:\Windows\Media\ding.wav
ini=%ini%`naddshift=0
ini=%ini%`naddctrl=1
ini=%ini%`naddalt=0
ini=%ini%`naddwin=0
ini=%ini%`nshowshift=0
ini=%ini%`nshowctrl=0
ini=%ini%`nshowalt=1
ini=%ini%`nshowwin=0
FileAppend,%ini%,%applicationname%.ini
ini=
}
IniRead,addsound,%applicationname%.ini,Settings,addsound
IniRead,showsound,%applicationname%.ini,Settings,C:\Windows\Media\tada.wav

IniRead,addshift,%applicationname%.ini,Settings,addshift
IniRead,addctrl,%applicationname%.ini,Settings,addctrl
IniRead,addalt,%applicationname%.ini,Settings,addalt
IniRead,addwin,%applicationname%.ini,Settings,addwin
IniRead,showshift,%applicationname%.ini,Settings,showshift
IniRead,showctrl,%applicationname%.ini,Settings,showctrl
IniRead,showalt,%applicationname%.ini,Settings,showalt
IniRead,showwin,%applicationname%.ini,Settings,showwin

If addshift=1
  addshift=D
Else
  addshift=U
If addctrl=1
  addctrl=D
Else
  addctrl=U
If addalt=1
  addalt=D
Else
  addalt=U
If addwin=1
  addwin=D
Else
  addwin=U

If showshift=1
  showshift=D
Else
  showshift=U
If showctrl=1
  showctrl=D
Else
  showctrl=U
If showalt=1
  showalt=D
Else
  showalt=U
If showwin=1
  showwin=D
Else
  showwin=U

add=%addshift%%addctrl%%addalt%%addwin%
show=%showshift%%showctrl%%showalt%%showwin%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,- Step through groups of windows using hotkeys
Gui,99:Add,Text,y+0,Ctrl-0: add a window to a Group0
Gui,99:Add,Text,y+0,Ctrl-1: add a window to a Group1
Gui,99:Add,Text,y+0,  ... :   ...
Gui,99:Add,Text,y+0,Alt-0 : show the next window of Group0
Gui,99:Add,Text,y+0,Alt-1 : show the next window of Group1
Gui,99:Add,Text,y+0,  ... :   ...
Gui,99:Add,Text,y+10,- To change hotkeys and sounds, choose Settings in the tray menu

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
  If ctrl in Static14,Static18,Static22
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return
