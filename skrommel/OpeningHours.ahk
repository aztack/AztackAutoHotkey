;OpeningHours.ahk
; Runs a program when inside a certain time interval, and closes it when outside
;Skrommel @2006

#SingleInstance,off
#Persistent,On

applicationname=OpeningHours

Gosub,TRAYMENU

If 0=0
{
  Gosub,ABOUT
  Return
}

start=0000
end=2400
checkdelay=1000
run=1
close=1
kill=1
killdelay=5000
hide=0

commandline=
Loop,%0%
{
  parameter:=%A_Index%
  If A_Index=1
    program=%parameter%
  Else
  If (parameter="close=0")
    close=0
  Else
  If (parameter="kill=0")
    kill=0
  Else
  If (parameter="run=0")
    run=0
  Else
  If (parameter="hide=1")
    Menu,Tray,NoIcon
  Else
  If InStr(parameter,"start=")
    StringTrimLeft,start,parameter,6
  Else
  If InStr(parameter,"end=")
    StringTrimLeft,end,parameter,4
  Else
  If InStr(parameter,"checkdelay=")
    StringTrimLeft,checkdelay,parameter,11
  Else
  If InStr(parameter,"killdelay=")
    StringTrimLeft,killdelay,parameter,10
  commandline:=commandline parameter " "
}
Gosub,TRAYMENU

SetTimer,CHECK,%checkdelay%
Return


CHECK:
SetTimer,CHECK,Off
pid=0
WinGet,ids,List,,,Program Manager
Loop,%ids%
{
  Sleep,0
  StringTrimRight,id,ids%A_Index%,0
  WinGet,pid,PID,ahk_id %id%
  path:=GetModuleFileNameEx(pid) 
  IfInString,path,%program%
    Break
  Else
    pid=0
}

StringMid,now,A_Now,9,4
If (now>=start And now<end)
{
  If (pid=0 And run=1)
    Run,%program%  
}
Else
{
  If pid<>0
  {
    If (close=1 Or kill=1)
      WinClose,ahk_pid %pid%
    If kill=1
    {
      Sleep,%killdelay%
      WinKill,ahk_pid %pid%
    }
  }
}
SetTimer,CHECK,%checkdelay%,On
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,SWAP
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,SWAP
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Check,&Enabled
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname% %commandline%
Return


SWAP:
Menu,Tray,ToggleCheck,&Enabled
Suspend,Toggle
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Runs a program when inside a certain time interval, and closes it when outside.
Gui,99:Add,Text,y+10,- Command line:
Gui,99:Add,Text,y+5,OpeningHours.exe <part of program path> start=<start time HHMM> end=<end time HHMM> 
Gui,99:Add,Text,y+5,%A_Space%%A_Space%%A_Space%[ checkdelay=<time between checks in ms> run=<0=Don't run, 1=Run> close=<0=Don't close, 1=Close> 
Gui,99:Add,Text,y+5,%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%kill=<0=Don't kill, 1=Kill> killdelay=<time to wait before killing a task in ms> hide=<1=Hide from the tray, 0=Show in the tray> ]
Gui,99:Add,Text,y+10,- Example:
Gui,99:Add,Text,y+5,OpeningHours.exe \Notepad.exe start=1200 end=2400 checkdelay=1000 run=1 close=1 kill=1 killdelay=5000 hide=0 

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


GuiClose:
If 0=0
  ExitApp
Return


GetModuleFileNameEx( p_pid ) ;by shimanov at http://www.autohotkey.com/forum/topic4182.html
{ 
   if A_OSVersion in WIN_95,WIN_98,WIN_ME 
   { 
;      MsgBox, This Windows version (%A_OSVersion%) is not supported. 
      return 
   } 

   /* 
      #define PROCESS_VM_READ           (0x0010) 
      #define PROCESS_QUERY_INFORMATION (0x0400) 
   */ 
   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid ) 
   if ( ErrorLevel or h_process = 0 ) 
   { 
;      MsgBox, [OpenProcess] failed 
      return 
   } 
    
   name_size = 255 
   VarSetCapacity( name, name_size ) 
    
   result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size ) 
   if ( ErrorLevel or result = 0 ) 
;      MsgBox, [GetModuleFileNameExA] failed 
    
   DllCall( "CloseHandle", h_process ) 
    
   return, name 
}