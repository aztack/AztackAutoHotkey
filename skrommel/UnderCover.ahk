#SingleInstance,Force
SetBatchLines,-1
DetectHiddenWindows,On
SetWinDelay,0
SetControlDelay,0

applicationname=UnderCover

OnExit,EXIT
Gosub,INIREAD
Gosub,TRAYMENU

shift=0
mouse=0
Loop
{
  Sleep,10

  oldactiveid:=activeid
  activeid:=WinExist("A")
  WinGetClass,class,ahk_id %activeid%
  StringReplace,shortclass,class,%A_Space%,,All
  StringReplace,shortclass,shortclass,% Chr(255),,All
  StringReplace,shortclass,shortclass,:,,All
  StringReplace,shortclass,shortclass,-,,All
  If (activeid<>oldactiveid)
  IfInString,classes,%shortclass%
    Gosub,KEYUP

  GetKeyState,key,%userkey%,P
  GetKeyState,button,%userbutton%,P
  If (key="D" And shift=0)
  {
    shift=1
    Gosub,KEYDOWN
  }
  If (key="U" And shift=1)
  {
    shift=0
    Gosub,KEYUP
  }
  If (button="D" And shift=1 and mouse=0)
  {
    mouse=1
    Gosub,BUTTON
  }
  If (button="U" And shift=1 and mouse=1)
  {
    mouse=0
  }
}
Return


KEYDOWN:
winid:=WinExist("A")
WinGetClass,class,ahk_id %winid%
StringReplace,shortclass,class,%A_Space%,,All
StringReplace,shortclass,shortclass,% Chr(255),,All
StringReplace,shortclass,shortclass,:,,All
StringReplace,shortclass,shortclass,-,,All
If shortclass<>
Loop,Parse,%shortclass%,`,
{
  If A_LoopField<>
  {
    Control,Show,,%A_LoopField%,ahk_id %winid%
  }
}
Return


KEYUP:
winid:=WinExist("A")
WinGetClass,class,ahk_id %winid%
StringReplace,shortclass,class,%A_Space%,,All
StringReplace,shortclass,shortclass,% Chr(255),,All
StringReplace,shortclass,shortclass,:,,All
StringReplace,shortclass,shortclass,-,,All
If shortclass<>
Loop,Parse,%shortclass%,`,
{
  If A_LoopField<>
  {
    Control,Hide,,%A_LoopField%,ahk_id %winid%
  }
}
Return


BUTTON:
MouseGetPos,mx,my,winid,ctrl
WinGetClass,class,ahk_id %winid%
StringReplace,shortclass,class,%A_Space%,,All
StringReplace,shortclass,shortclass,% Chr(255),,All
StringReplace,shortclass,shortclass,:,,All
StringReplace,shortclass,shortclass,-,,All
If %shortclass%=
{
  IfNotInString,classes,%shortclass%`,
    classes=%classes%%shortclass%,
}
IfNotInString,%shortclass%,%ctrl%`,
{
  %shortclass%:=%shortclass% ctrl ","
  Control,Hide,,%ctrl%,ahk_id %winid%
}
Else
{
  StringReplace,%shortclass%,%shortclass%,%ctrl%`,,,All
  Control,Show,,%ctrl%,ahk_id %winid%
}
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  IniWrite,Ctrl,%applicationname%.ini,Settings,userkey
  IniWrite,RButton,%applicationname%.ini,Settings,userbutton
}

IniRead,userkey,%applicationname%.ini,Settings,userkey
If (userkey="ERROR" Or userkey="")
  userkey=Ctrl
IniRead,userbutton,%applicationname%.ini,Settings,userbutton
If (userbutton="ERROR" Or userbutton="")
  userbutton=RButton
IniRead,classes,%applicationname%.ini,Settings,classes
If (classes="ERROR" Or classes="")
{
  classes=
  Return
}
Loop,Parse,classes,`,
{
  If A_LoopField<>
  {
    shortclass:=A_LoopField
    ctrls:=%shortclass%
    IniRead,%shortclass%,%applicationname%.ini,%shortclass%,controls
    If %shortclass%=ERROR
      %shortclass%=
  }
}
Return


EXIT:
INIWRITE:
IniWrite,%userkey%,%applicationname%.ini,Settings,userkey
IniWrite,%userbutton%,%applicationname%.ini,Settings,userbutton
IniWrite,%classes%,%applicationname%.ini,Settings,classes
Loop,Parse,classes,`,
{
  shortclass:=A_LoopField
  If shortclass<>
  {
    ctrls:=%shortclass%
    IniWrite,%ctrls%,%applicationname%.ini,%shortclass%,controls
  }
}
ExitApp


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


SETTINGS:
Run,%applicationname%.ini
Return


ABOUT:
Gui,Destroy
Gui,Add,Picture,Icon1,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,Font
Gui,Add,Text,xm,Automatically hide a window's buttons and other controls.
Gui,Add,Text,xm,- Ctrl-Rightclick to hide a control
Gui,Add,Text,xm,- Change settings using Settings in the tray menu
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm Icon5,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,xm,For more tools, information and donations, visit
Gui,Font,CBlue Underline
Gui,Add,Text,xm G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm Icon7,%applicationname%.exe
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
  MouseGetPos,,,winid,ctrl
  If ctrl in Static10,Static15,Static20
    DllCall("SetCursor","UInt",hCurs)
}
