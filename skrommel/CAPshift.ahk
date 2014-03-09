;CAPshift.ahk
;Slows down and extends the CapsLock key. 
; Also slows down F1, Insert, NumLock and ScrollLock
;
;Hold for 0.5 sec to toggle caps lock on or off.
;Hold for 1 sec to show a menu that converts selected text to 
; UPPER CASE, lower case, Title Case or iNVERT cASE.
;
;If the keyboard is idle for 120 seconds, CapsLock is turned off.
;
;Skrommel @2005

#NoEnv
#SingleInstance,Force
AutoTrim,Off 
StringCaseSense,On
SetBatchLines,-1
SetWinDelay,0

applicationname=CAPshift

Gosub,READINI
Gosub,TRAYMENU

WinGet,oldid,ID,A

SetTimer,ACTIVEWIN,500

time:=A_TickCount
Loop
{
  Input,key,L1 T1 V,{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
  If (ErrorLevel<>"Timeout")
    time:=A_TickCount
  If (A_TickCount-time>=capslockidle*1000)
  {
    If capslockidle>0
    If (GetKeyState("CapsLock","T"))
      SetCapsLockState,Off
    time:=A_TickCount
  }
}
Return


ACTIVEWIN:
WinGet,id,ID,A
WinGetClass,class,ahk_id %id%
If id=
  id=%oldid%
If class=Shell_TrayWnd
  id=%oldid%
If id=AutoHotkey
  id=%oldid%
oldid=%id%
Return


DELAY:
Gosub,TRAYTIP
hotkey=%A_ThisHotkey%
IfInString,hotkey,$
  StringTrimLeft,hotkey,hotkey,1
If hotkey=CapsLock
  Gosub,CAPSLOCK
Else
  Gosub,THEREST
Return


THEREST:
counter=500
Loop,5
{
  If showstatus=1
    ToolTip,%hotkey% in %counter% ms
  Sleep,100
  counter-=100
  GetKeyState,state,%hotkey%,P
  If state=U
    Break
}
If showstatus=1
  ToolTip,
If counter=0
If hotkey=F1
  Send,{%hotkey%}
Else
{
  GetKeyState,state,%hotkey%,T
  If state=U
  {
    If hotkey=NumLock
      SetNumLockState,On
    If hotkey=ScrollLock
      SetScrollLockState,On
    If hotkey=Insert
      Send,{%hotkey%}
    If showstatus=1
      ToolTip,%hotkey% On
  }
  Else
  {
    If hotkey=NumLock
      SetNumLockState,Off
    If hotkey=ScrollLock
      SetScrollLockState,Off
    If hotkey=Insert
      Send,{%hotkey%}
    If showstatus=1
      ToolTip,%hotkey% Off
  }
  SetTimer,TOOLTIPOFF,On
}
KeyWait,%hotkey%
Return


CAPSLOCK:
counter=1000
Loop,10
{
  If showstatus=1
    ToolTip,%hotkey% in %counter% ms
  Sleep,100
  counter-=100
  If counter=500
    SoundPlay,%SYSTEMROOT%\Media\ding.wav
  GetKeyState,state,%hotkey%,P
  If state=U
    Break
}
If showstatus=1
  ToolTip,
If counter=0
  Gosub,MENU
Else
If counter<600
{
  GetKeyState,state,%hotkey%,T
  If state=D
    Gosub,OFF
  Else
    Gosub,ON
}
Return


TRAYTIP:
status=
key=Insert
Gosub,GETSTATE
key=CapsLock
Gosub,GETSTATE
key=NumLock
Gosub,GETSTATE
key=ScrollLock
Gosub,GETSTATE
If showstatus=1
  TrayTip,Status,%status%,10
Return


GETSTATE:
GetKeyState,state,%key%,T
If state=D
  status=%status%%key%`n
Return


MENU:
Menu,convert,Add
Menu,convert,Delete
Menu,convert,Add,CAPshift,TOGGLE
Menu,convert,Add,
Menu,Convert,Add,CapsLock &On,On
Menu,Convert,Add,&CapsLock Off,Off
Menu,convert,Add,
Menu,convert,Add,&UPPER CASE,UPPER
Menu,convert,Add,&lower case,LOWER
Menu,convert,Add,&Title Case,TITLE
Menu,convert,Add,&iNVERT cASE,INVERT
Menu,convert,Add,&RaNDoM CaSE,RANDOM
Menu,convert,Add,Replace user &chars,REPLACE
Menu,convert,Add,
Menu,convert,Add,&Settings...,SETTINGS
Menu,convert,Add,&About...,ABOUT
Menu,convert,Add,E&xit,EXIT
Menu,convert,Default,CapShift
Menu,convert,Show
Return


TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,CAPshift,TOGGLE
Menu,Tray,Add,
Menu,Tray,Add,CapsLock &On,On
Menu,Tray,Add,&CapsLock Off,Off
Menu,Tray,Add,
Menu,Tray,Add,&UPPER CASE,UPPER
Menu,Tray,Add,&lower case,LOWER
Menu,Tray,Add,&Title Case,TITLE
Menu,Tray,Add,&iNVERT cASE,INVERT
Menu,Tray,Add,&RaNDoM CaSE,RANDOM
Menu,Tray,Add,Replace user &chars,REPLACE
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,CapShift
Menu,Tray,Tip,%applicationname%
Return 


TOOLTIPON:
Return


TOOLTIPOFF:
If showstatus=1
  ToolTip,
SetTimer,TOOLTIPOFF,Off
Gosub,TRAYTIP
Return


ON:
SetCapsLockState,On
If showstatus=1
  ToolTip,CapsLock On
SetTimer,TOOLTIPOFF,On
Return


OFF:
SetCapsLockState,Off
If showstatus=1
  ToolTip,CapsLock Off
SetTimer,TOOLTIPOFF,On
Return


TOGGLE:
GetKeyState,state,CapsLock,T
If state=D
{
  SetCapsLockState,Off
  If showstatus=1
    ToolTip,CapsLock Off
}
Else
{
  SetCapsLockState,On
  If showstatus=1
    ToolTip,CapsLock On
}
SetTimer,TOOLTIPOFF,On
Return


CUT:
oldclipboard:=ClipboardAll
WinActivate,ahk_id %id%
WinWaitActive,ahk_id %id%,,1
WinGetClass,class,ahk_id %id%
If class In Progman,WorkerW,Explorer,CabinetWClass
  Send,{F2}
Sleep,500
Send,^c
ClipWait,1
string=%clipboard%
Return


PASTE:
WinActivate,ahk_id %id%
WinWaitActive,ahk_id %id%,,1
If class In Progman,WorkerW,Explorer,CabinetWClass
  Send,{F2}
clipboard=%string%
Send,^v
Clipboard:=oldclipboard
oldclipboard=
Return


UPPER:
Gosub,CUT
StringUpper,string,string
Gosub,PASTE
If showstatus=1
  ToolTip,Selection converted to UPPER CASE
SetTimer,TOOLTIPOFF,On
Return


LOWER:
Gosub,CUT
StringLower,string,string
Gosub,PASTE
If showstatus=1
  ToolTip,Selection converted to lower case
SetTimer,TOOLTIPOFF,On
Return


TITLE:
Gosub,CUT
StringLower,string,string,T
Gosub,PASTE
If showstatus=1
  ToolTip,Selection converted to Title Case
SetTimer,TOOLTIPOFF,On
Return


INVERT:
Gosub,CUT
StringLen,length,string
Loop,%length%
{
  StringLeft,char,string,1
  If char Is Upper
    StringLower,char,char
  Else
  If char Is Lower
    StringUpper,char,char
  StringTrimLeft,string,string,1
  string=%string%%char%
}
If showstatus=1
  ToolTip,Selection converted to iNVERTED cASE
SetTimer,TOOLTIPOFF,On
Gosub,PASTE
Return


RANDOM:
Gosub,CUT
StringLen,length,string
Loop,%length%
{
  StringLeft,char,string,1
  Random,random,1,2
  If random=1
    StringLower,char,char
  Else
    StringUpper,char,char
  StringTrimLeft,string,string,1
  string=%string%%char%
}
If showstatus=1
  ToolTip,Selection converted to RaNDoM CaSE
SetTimer,TOOLTIPOFF,On
Gosub,PASTE
Return


REPLACE:
AutoTrim,Off 
StringCaseSense,On
Gosub,CUT
Loop,%swapcount%
{
  from:=swap_%A_Index%_1
  to:=swap_%A_Index%_2
  StringReplace,string,string,%A_Space%,.space.,All
  StringReplace,string,string,%A_Tab%,.tab.,All
  StringReplace,string,string,`r,.return.,All
  StringReplace,string,string,`n,.newline.,All
  StringReplace,string,string,`,,.comma.,All
  StringReplace,string,string,`;,.semicolon.,All
  StringReplace,string,string,%from%,%to%,All
  StringReplace,string,string,.space.,%A_Space%,All
  StringReplace,string,string,.tab.,%A_Tab%,All
  StringReplace,string,string,.return.,`r,All
  StringReplace,string,string,.newline.,`n,All
  StringReplace,string,string,.comma.,`,,All
  StringReplace,string,string,.semicolon.,`;,All
}
If showstatus=1
  ToolTip,Selection's User chars replaced
SetTimer,TOOLTIPOFF,On
Gosub,PASTE
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.7
Gui,99:Font
Gui,99:Add,Text,y+10,CAPshift slows down and extends the CapsLock key.
Gui,99:Add,Text,y+5,It also slows down F1, Insert, NumLock and ScrollLock.
Gui,99:Add,Text,y+10,- Hold down CapsLock for .5 sec to toggle CapsLock on or off.
Gui,99:Add,Text,y+10,- Hold for 1 sec to show a menu that converts selected text to 
Gui,99:Add,Text,y+5,UPPER CASE, lower case, Title Case, iNVERT cASE, RaNDoM CaSE  
Gui,99:Add,Text,y+5,or to Replace user defined chars as defined in CAPshift.ini.
Gui,99:Add,Text,y+10,- If the keyboard is idle for 120 seconds, CapsLock is turned off.

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
  If ctrl in Static13,Static17,Static21
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return

EXIT:
ExitApp



SETTINGS:
Gosub,READINI
Run,CAPshift.ini
Return


READINI:
IfNotExist,CAPshift.ini
{
  inifile=;CAPshift.ini
  inifile=%inifile%`n`;[Settings]
  inifile=%inifile%`n`;capslockidle=120    `;0-999  0=Off  Seconds to wait before turning off CapsLock when the keyboard is idle
  inifile=%inifile%`n`;showstatus=1        `;0,1    0=Hide  1=Show  Hide or show the status windows
  inifile=%inifile%`n`;delaycapslock=1     `;0,1    0=Ignore CapsLock  1=Delay F1
  inifile=%inifile%`n`;delayf1=1           `;0,1    0=Ignore F1  1=Delay F1
  inifile=%inifile%`n`;delayinsert=1
  inifile=%inifile%`n`;delayscrolllock=1
  inifile=%inifile%`n`;delaynumlock=1
  inifile=%inifile%`n`;
  inifile=%inifile%`n`;ae=æ                `;Chars to replace=Chars to replace with
  inifile=%inifile%`n`;oe=ø                `;Special characters:
  inifile=%inifile%`n`;aa=å                `;  .space. .tab. .return. .newline. .comma. .semicolon.
  inifile=%inifile%`n`;AE=Æ
  inifile=%inifile%`n`;OE=Ø
  inifile=%inifile%`n`;AA=Å
  inifile=%inifile%`n`;AA=Å
  inifile=%inifile%`n`;.return..newline..return..newline.=  ;Removes empty lines 
  inifile=%inifile%`n
  inifile=%inifile%`n[Settings]
  inifile=%inifile%`ncapslockidle=120
  inifile=%inifile%`nshowstatus=1
  inifile=%inifile%`ndelaycapslock=1
  inifile=%inifile%`ndelayf1=1
  inifile=%inifile%`ndelayinsert=1
  inifile=%inifile%`ndelayscrolllock=1
  inifile=%inifile%`ndelaynumlock=1
  inifile=%inifile%`n
  inifile=%inifile%`nae=æ
  inifile=%inifile%`noe=ø
  inifile=%inifile%`naa=å
  inifile=%inifile%`nAE=Æ
  inifile=%inifile%`nOE=Ø
  inifile=%inifile%`nAA=Å
  FileAppend,%inifile%,CAPshift.ini
  inifile=
}
IniRead,capslockidle,CAPshift.ini,Settings,capslockidle
IniRead,showstatus,CAPshift.ini,Settings,showstatus
IniRead,delaycapslock,CAPshift.ini,Settings,delaycapslock
IniRead,delayf1,CAPshift.ini,Settings,delayf1
IniRead,delayinsert,CAPshift.ini,Settings,delayinsert
IniRead,delayscrolllock,CAPshift.ini,Settings,delayscrolllock
IniRead,delaynumlock,CAPshift.ini,Settings,delaynumlock

If delaycapslock=1
  Hotkey,$CapsLock,DELAY
If delayf1=1
  Hotkey,$F1,DELAY
If delayinsert=1
  Hotkey,$Insert,DELAY
If delaynumlock=1
  Hotkey,$NumLock,DELAY
If delayscrolllock=1
  Hotkey,$ScrollLock,DELAY

swapcount=0
Loop,Read,CAPshift.ini
{
  StringLeft,char,A_LoopReadLine,1
  If char=`;
    Continue
  IfInString,A_LoopReadLine,[Settings]
    Continue
  If A_LoopReadLine Contains capslockidle=,showstatus=,delaycapslock=,delayf1=,delayinsert=,delayscrolllock=,delaynumlock=
    Continue
  IfNotInString,A_LoopReadLine,=
    Continue
  swapcount+=1
  StringSplit,swap_%swapcount%_,A_LoopReadLine,=
}
Return
