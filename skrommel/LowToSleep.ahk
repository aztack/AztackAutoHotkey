;LowToSleep.ahk
;  Stop a PC from falling asleep until the CPU is inactive
;Skrommel@2006

FileInstall,0.ico,0.ico
FileInstall,1.ico,1.ico
FileInstall,2.ico,2.ico
FileInstall,3.ico,3.ico
FileInstall,4.ico,4.ico
FileInstall,5.ico,5.ico
FileInstall,6.ico,6.ico
FileInstall,7.ico,7.ico
FileInstall,8.ico,8.ico
FileInstall,9.ico,9.ico

#SingleInstance,Force
#Persistent 
#NoEnv
SetBatchLines,-1 
SendMode,Input
SetFormat,Float,0 

applicationname=LowToSleep

Gosub,INIREAD
Gosub,TRAYMENU
Gui,+Owner +AlwaysOnTop +ToolWindow
Gui,Add,Edit,vchars
Gui,Show,,% applicationname "!"
Gui,+LastFound
WinGet,guiid,Id,A
Gui,Hide
Gosub,INITGETCPULOAD
SetTimer,CHECKCPULOAD,%checkinterval%,On
Return 


CHECKCPULOAD: 
SetTimer,CHECKCPULOAD,%checkinterval%,Off
Gosub,GETCPULOAD
icon:=load/100*9 ".ico"
IfExist,%icon%
  Menu,Tray,Icon,%icon%
Menu,Tray,Tip,% load " %"
If (A_TimeIdlePhysical>idleduration)
If (load>cputhreshold)
{
  Sleep,1000
  Gosub,GETCPULOAD
  If (load>cputhreshold)
    Gosub,MAKENOISE
}
SetTimer,CHECKCPULOAD,%checkinterval%,On
Return 


INITGETCPULOAD:
EnvGet,numberofprocessors,NUMBER_OF_PROCESSORS 
If numberofprocessors<1
  numberofprocessors=1
VarSetCapacity(idletime,8,0)
VarSetCapacity(dummy1,8,0)
VarSetCapacity(dummy2,8,0)
Return


GETCPULOAD:  ;originally made by shimanov, optimized by f0dder
idletime0:=idletime
tick0:=tick 
tick:=A_TickCount
DllCall("Kernel32.dll\GetSystemTimes","*UInt64",idletime,"*Uint64",dummy1,"*Uint64",dummy2) 
load:=100-0.01*(idletime-idletime0)/numberofprocessors/(tick-tick0)
Return


MAKENOISE:
If keyboard<>0
{
  chars=
  GuiControl,,chars
  Random,char,65,90   ;97,122
  Transform,char,CHR,%char%
  ControlSend,Edit1,{Blind}%char%,ahk_id %guiid%
}
If mouse<>0
{
  MouseMove,1,1,0,R
  MouseMove,-1,-1,0,R
}
Return


SETTINGS:
Run,%applicationname%.ini
Return


INIREAD:
IniRead,cputhreshold,%applicationname%.ini,Settings,cputhreshold
IniRead,checkinterval,%applicationname%.ini,Settings,checkinterval
IniRead,idleduration,%applicationname%.ini,Settings,idleduration
IniRead,mouse,%applicationname%.ini,Settings,mouse
IniRead,keyboard,%applicationname%.ini,Settings,keyboard

If (cputhreshold="" Or cputhreshold="Error")
{
  cputhreshold=10
  IniWrite,%cputhreshold%,%applicationname%.ini,Settings,cputhreshold
}
If (checkinterval="" Or checkinterval="Error")
{
  checkinterval=1
  IniWrite,%checkinterval%,%applicationname%.ini,Settings,checkinterval
}
If (idleduration="" Or idleduration="Error")
{
  idleduration=30
  IniWrite,%idleduration%,%applicationname%.ini,Settings,idleduration
}
If (mouse="" Or mouse="Error")
{
  mouse=1
  IniWrite,%mouse%,%applicationname%.ini,Settings,mouse
}
If (keyboard="" Or keyboard="Error")
{
  keyboard=1
  IniWrite,%keyboard%,%applicationname%.ini,Settings,keyboard
}

checkinterval*=1000
idleduration*=1000
Return


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


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.6
Gui,99:Font
Gui,99:Add,Text,y+10,Stop a PC from falling asleep until the CPU is inactive.
Gui,99:Add,Text,y+10,- Change settings using Settings in the tray menu
Gui,99:Add,Text,y+10,- Shows CPU usage in the tray

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

