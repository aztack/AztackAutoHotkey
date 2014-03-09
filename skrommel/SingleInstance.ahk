;SingleInstance.ahk
; Only allow one instance of a program to run
;Skrommel @ 2006

#SingleInstance,Force
SetBatchLines,-1

applicationname=SingleInstance

Gosub,INIREAD
Gosub,TRAYMENU

enabled=1
Gosub,START
Goto,LOOP

START:
oldpids=
WinGet,ids_,List,,,Program Manager
Loop,%ids_%
{  
  Sleep,0
  StringTrimRight,id,ids_%A_Index%,0
  WinGet,pid,Pid,Ahk_Id %id%
  IfNotInString,oldpids,%pid%
    oldpids=%oldpids%%pid%\
}
Return


LOOP:
If enabled=0
{
  Sleep,1000
  Goto,LOOP
}
programs=
newpids=
pids=
WinGet,ids_,List,,,Program Manager
Loop,%ids_%
{  
  Sleep,%pause%
  StringTrimRight,id,ids_%A_Index%,0
  WinGet,pid,Pid,Ahk_Id %id%
  IfInString,oldpids,%pid%
  {
    IfNotInString,pids,%pid%
    {
      pids=%pids%%pid%\
      WinGet,program,ProcessName,Ahk_Pid %pid%
      program=\%program%
      IfNotInString,programs,%program%
        programs=%programs%%program%
    }
  }
  Else
  IfNotInString,newpids,%pid%
    newpids=%newpids%%pid%\
}
StringTrimRight,newpids,newpids,1
StringTrimRight,oldpids,pids,1

Loop,Parse,newpids,\
{
  Sleep,%pause%
  pid=%A_LoopField%
  WinGet,program,ProcessName,Ahk_Pid %pid%
  program=\%program%
  IfInString,programs,%program%
  {
    IfInString,closeprograms,%program%
      WinClose,Ahk_Pid %pid%
  }
  Else
  {
    programs=%programs%%program%
    oldpids=%oldpids%%pid%\
  }
}
Goto,LOOP


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=[Settings]
  ini=%ini%`ncloseprograms=\calc.exe
  ini=%ini%`npause=1
  ini=%ini%`ndetecthidden=0
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
IniRead,closeprograms,%applicationname%.ini,Settings,closeprograms
IniRead,pause,%applicationname%.ini,Settings,pause
IniRead,detecthidden,%applicationname%.ini,Settings,detecthidden
If detecthidden=1
  DetectHiddenWindows,On
Else
  DetectHiddenWindows,Off  
closeprograms=\%closeprograms%
StringReplace,closeprograms,closeprograms,`,,\,All
StringReplace,closeprograms,closeprograms,`n,\,All
Loop
{
  StringReplace,closeprograms,closeprograms,\%A_Space%,\,All
  IfNotInString,closeprograms,\%A_Space%
    Break
}
Loop
{
  StringReplace,closeprograms,closeprograms,\\,\,All
  IfNotInString,closeprograms,\\
    Break
}
Return


TRAYMENU:
Menu,Tray,Click,1 
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,DOUBLECLICK
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,TOGGLE
Menu,Tray,Add,Se&ttings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Check,&Enabled
Menu,Tray,Tip,%applicationname%
Return


SINGLECLICK:
Pause,Off
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
Gosub,SETTINGS
Return


TOGGLE:
If enabled=1
{
  enabled=0
  Menu,Tray,UnCheck,&Enabled
  Menu,Tray,Icon,%applicationname%.exe,4,1
}
Else
{
  enabled=1
  Menu,Tray,Check,&Enabled
  Menu,Tray,Icon,%applicationname%.exe,1,1
  Gosub,START
}
Return


SETTINGS:
Gosub,INIREAD
StringTrimLeft,scloseprograms,closeprograms,1
StringReplace,scloseprograms,scloseprograms,\,`n,All
Gui,Destroy
Gui,+Resize
Gui,Add,Edit,xm r9 w200 vocloseprograms,%scloseprograms%
Gui,Add,CheckBox,Checked%detecthidden% Vodetecthidden xm y+10,Detect hidden programs (slow)
Gui,Add,Text,xm y+10,&Response time (0=fast 10=slow)
Gui,Add,Edit,Vopause w100 xm y+5
Gui,Add,UpDown,Range0-10,%pause%
Gui,Add,Button,GSETTINGSOK Default xm y+15 w75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Gui,Show,,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
closeprograms=\%ocloseprograms%
StringReplace,closeprograms,closeprograms,`,,\,All
StringReplace,closeprograms,closeprograms,`n,\,All
Loop
{
  StringReplace,closeprograms,closeprograms,\%A_Space%,\,All
  IfNotInString,closeprograms,\%A_Space%
    Break
}
Loop
{
  StringReplace,closeprograms,closeprograms,\\,\,All
  IfNotInString,closeprograms,\\
    Break
}
pause=%opause%
detecthidden=%odetecthidden%
IniWrite,%closeprograms%,%applicationname%.ini,Settings,closeprograms
IniWrite,%pause%,%applicationname%.ini,Settings,pause
IniWrite,%detecthidden%,%applicationname%.ini,Settings,detecthidden
If detecthidden=1
  DetectHiddenWindows,On
Else
  DetectHiddenWindows,Off  
Gosub,SETTINGSCANCEL
Reload
Return


SETTINGSCANCEL:
Gui,Destroy
Return


GuiSize:
If A_EventInfo=1
  Return
GuiControl,Move,paths, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 50)
Return


EXIT:
ExitApp


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Only allow one instance of a program to run
Gui,99:Add,Text,y+5,- User defined programs
Gui,99:Add,Text,y+5,- Change the settings by choosing Settings in the Tray menu

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
