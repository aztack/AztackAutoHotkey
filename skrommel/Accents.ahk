#Persistent
#SingleInstance,Force
#NoEnv
SendMode,Input
SetKeyDelay,-1
SetBatchLines,-1

applicationname=Accents
Gosub,INIREAD
Gosub,TRAYMENU
Loop,Parse,hotkeys,`,
  Hotkey,%A_LoopField%,ACCENT,On
Return


ACCENT:
hotkey:=A_ThisHotkey
Loop,Parse,hotkeys,`,
  Hotkey,%A_LoopField%,ACCENT,Off

StringRight,key,hotkey,1
StringLower,key,key

GetKeyState,caps,CapsLock,T

IfInString,hotkey,+
If caps=D
  caps=U
Else
  caps=D

string=
counter=1
Loop,
{
  ascii:=Asc(key)
  char:=%ascii%%counter%
  string=%string%%char%
  If %ascii%%A_Index%=
    Break
  counter+=1
}
counter=1

If caps=D
  StringUpper,string,string

Loop
{
  If A_Index=3
  {  
    counter=1
    char:=%ascii%%counter%
    If caps=D
      StringUpper,char,char
    Else
      StringLower,char,char
    Send,{BackSpace 2}%char%
  }
  Else
  If A_Index>3
  {
    char:=%ascii%%counter%
    If caps=D
      StringUpper,char,char
    Else
      StringLower,char,char
    Send,{BackSpace %length%}%char%
  }
  Else
  {
    If caps=D
      StringUpper,key,key
    Else
      StringLower,key,key
    Send,%key%
  }

  IfInString,hotkey,+
    Send,{Shift Down}
  Else
    Send,{Shift Up}

  Input,input,T1 L1,{BackSpace}{Left}{Right}{Up}{Down}{Shift},%char%
  If ErrorLevel=Timeout
  {
    ToolTip,
    Break
  }
  IfInString,ErrorLevel,EndKey:
  {
    StringTrimLeft,endkey,ErrorLevel,7
    endkey={%endkey%}
    Send,%endkey%
    ToolTip,
    Break
  }
  If (input<>key)
  {
;    If caps=D
;      StringUpper,input,input
;    Else
;      StringLower,input,input
    Send,%input%
    ToolTip,
    Break
  }

  StringLen,length,char

  StringLeft,char,string,% length
  StringTrimLeft,string,string,% length
  string=%string%%char%
  ToolTip,%string%,% A_CaretX,% A_CaretY-20 ;%counter%`n%key%`n%char%`n%caps%
  counter+=1
  If %ascii%%counter%=
    counter=1
}
Loop,Parse,hotkeys,`,
  Hotkey,%A_LoopField%,ACCENT,On
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
[Settings]
delay=1

[1]
key=a
1=å
2=ä
3=â
4=à
5=á
6={Alt Down}{NumPad1}{NumPad2}{NumPad3}{Alt Up}

[2]
key=e
1=æ
2=ë
3=ê
4=è
5=é
6=e

[3]
key=i
1=ï
2=î
3=ì
4=í
5=i

[4]
key=o
1=ø
2=ö
3=ô
4=ò
5=ó
6=o

[5]
key=u
1=ü
2=û
3=ù
4=ú
5=u

[6]
key=y
1=ÿ
2=ý
3=y

)
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
hotkeys=
IniRead,delay,%applicationname%.ini,Settings,delay
Loop
{
  section:=A_Index
  IniRead,key,%applicationname%.ini,%section%,key
  If key=ERROR
    Break
  hotkeys=%hotkeys%%key%,+%key%,
  Loop
  {
    ascii:=Asc(key)
    IniRead,%ascii%%A_Index%,%applicationname%.ini,%section%,%A_Index%
    If %ascii%%A_Index%=ERROR
    {
      %ascii%%A_Index%=
      Break
    }
  }
}
StringTrimRight,hotkeys,hotkeys,1
Return


SETTINGS:
Run,%applicationname%.ini
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
Gui,99:Add,Text,y+10,- Press a key three times or more to apply accents
Gui,99:Add,Text,y+10,- Change accents using Settings in the tray menu
Gui,99:Add,Text,y+10,- Doesn't work properly with shifted keys while CapsLock is on

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
