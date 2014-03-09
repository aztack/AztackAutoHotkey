;IdleRun.ahk
;  Run a program when the CPU is idle
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

applicationname=IdleRun


Gosub,INIREAD
Gosub,TRAYMENU
VarSetCapacity(IdleTicks,8,0)
Gui,+Owner -AlwaysOnTop -Disabled +SysMenu +Caption +Border +ToolWindow
Gui,Add,Edit,vchars
Gui,Add,Button,default,Quit
Gui,Show,,%applicationname%!
Gui,Hide
numberofprocessors:=NUMBEROFPROCESSORS()
Gosub,SETAFFINITY
SetTimer,CHECKCPULOAD,%checkinterval%
Return 


CHECKCPULOAD: 
load:=GETCPULOAD(numberofprocessors)
icon:=load/100*9
Menu,Tray,Tip,%load% `%
IfExist,%icon%.ico
  Menu,Tray,Icon,%icon%.ico
If load>%cputhreshold%
If A_TimeIdlePhysical>=%idleduration%
{
  If program<>
    Run,%program%
  If message<>
    MsgBox,0,%applicationname%,%message%
  If exit=1
    Goto,EXIT
}
Return 


SETAFFINITY:  ;Run the script on one processor ;Values stolen from _dave_ at http://www.overcards.com/wiki/moin.cgi/ResizeableTables
Process,Exist
pid:=ErrorLevel  ; sets ErrorLevel to the PID of this running script
hProcess:=DllCall("OpenProcess","UInt",0x1F0FFF,"Int",false,"UInt",pid)
cpu=1
DllCall("SetProcessAffinityMask","UInt",hProcess,"UInt",cpu)
DllCall("CloseHandle","UInt",hProcess)
Return


NUMBEROFPROCESSORS() ;stolen from Larry at http://www.autoitscript.com/forum/index.php?showtopic=26129
{
  VarSetCapacity(systeminfo,36)
  ;systeminfo("short;short;dword;int;int;int;dword;dword;dword;short;short")
  DllCall("GetSystemInfo","UInt",&systeminfo)
  numberofprocessors:=NumGet(systeminfo,20) ;2+2+4+4+4+4
  If numberofprocessors<1
    numberofprocessors=1
  Return,%numberofprocessors%
}


GETCPULOAD(numberofprocessors) ;originally made by shimanov
{ 
  Global
  idletime0=%idletime%    ; Save previous values 
  tick0=%tick% 
  DllCall("Kernel32.dll\GetSystemTimes","Uint",&idleticks,"Uint",0,"Uint",0) 
  idletime:=*(&idleticks)
  Loop,7                  ; Ticks when Windows was idle 
    idletime+=*(&idleticks+A_Index)<<(8*A_Index) 
  tick:=A_TickCount       ; Ticks all together 
  load:=100-0.01*(idletime-idletime0)/numberofprocessors/(tick-tick0)
  Return,load 
} 


SETTINGS:
Run,%applicationname%.ini
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  IniWrite,winver.exe,%applicationname%.ini,Action,program
  IniWrite,CPU is idle!,%applicationname%.ini,Action,message
}
IniRead,program,%applicationname%.ini,Action,program
IniRead,message,%applicationname%.ini,Action,message
IniRead,exit,%applicationname%.ini,Action,exit
IniRead,cputhreshold,%applicationname%.ini,Settings,cputhreshold
IniRead,checkinterval,%applicationname%.ini,Settings,checkinterval
IniRead,idleduration,%applicationname%.ini,Settings,idleduration

If (program="Error")
  program=
If (message="Error")
  message=
If (cputhreshold="" Or cputhreshold="Error")
  cputhreshold=5
If (checkinterval="" Or checkinterval="Error")
  checkinterval=1
If (exit="" Or exit="Error")
  exit=1
If (idleduration="" Or idleduration="Error")
  idleduration=60

IniWrite,%program%,%applicationname%.ini,Action,program
IniWrite,%message%,%applicationname%.ini,Action,message
IniWrite,%exit%,%applicationname%.ini,Action,exit
IniWrite,%cputhreshold%,%applicationname%.ini,Settings,cputhreshold
IniWrite,%checkinterval%,%applicationname%.ini,Settings,checkinterval
IniWrite,%idleduration%,%applicationname%.ini,Settings,idleduration

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
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Run a program when the CPU is idle
Gui,99:Add,Text,y+10,- Run a program or show a message
Gui,99:Add,Text,y+10,- Shows CPU usage in the tray
Gui,99:Add,Text,y+10,- Change settings using Settings in the tray menu

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
  If ctrl in Static10,Static14,Static18
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp
