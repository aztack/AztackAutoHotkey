;RandomScreenSaver
; Change screensaver every x minutes
;Skrommel @2006

#SingleInstance,Force
#NoTrayIcon 
OnExit,EXIT
Gosub,INIREAD

StringLeft,param,1,2
If (param="" Or param="/c") 
  Goto,SETTINGS
If (param="/p")
  ExitApp

SetTimer,IDLE,1000
Gosub,GUI
count=1


RUN:
savers=
Loop,%A_WinDir%\*.scr
  IfNotInString,ignored,%A_LoopFileName%
    savers=%savers%%A_LoopFileName%`n
Loop,%A_WinDir%\System32\*.scr
  IfNotInString,ignored,%A_LoopFileName%
    savers=%savers%%A_LoopFileName%`n
Sort,savers,U
StringSplit,savers_,savers,`n
savers_0-=1
If random=1
  Random,count,1,%savers_0%
screensaver:=savers_%count%
count+=1
If screensaver=RandomScreenSaver.scr
  Goto,RUN
If count>%savers_0%
  count=1
Run,%screensaver% /s


CHANGE:
sleep:=(hours*3600+minutes*60+seconds)*1000
Sleep,%sleep%
Process,Close,%screensaver%
Process,Close,SCRNSAVE.EXE
WinSet,Top,,ahk_id %runid%
Goto,RUN
Return


CONFIGURE:
Run,rundll32.exe desk.cpl`,InstallScreenSaver `%l
ExitApp


ENABLE:
RegWrite,REG_SZ,HKEY_USERS,.DEFAULT\Control Panel\Desktop,ScreenSaveActive,1
Return


DISABLE:
RegWrite,REG_SZ,HKEY_USERS,.DEFAULT\Control Panel\Desktop,ScreenSaveActive,0
Return


ACTIVE:
RegRead,active,HKEY_USERS,.DEFAULT\Control Panel\Desktop,ScreenSaveActive
If active=1
  Menu,Tray,Check,Enabled
Else
  Menu,Tray,UnCheck,Enabled
Return 


SETTINGS:
ohours:=hours
ominutes:=minutes
oseconds:=seconds
If random=random
checkedrandom=Checked
If alpha=1
checkedalpha=Checked

ohidedesktop:=hidedesktop

Gui,Destroy
Gui,Add,Tab,W330 H300 xm,Options|ScreenSavers|About

Gui,Tab,1
Gui,Add,GroupBox,w310 h110 xm+10 y+10,&Time to wait before changing ScreenSaver
Gui,Add,Edit,Vohours w100 xm+20 yp+20
Gui,Add,UpDown,Range0-23,%hours%
Gui,Add,Text,x+20 yp+3,Hours
Gui,Add,Edit,Vominutes w100 xm+20 y+10
Gui,Add,UpDown,Range0-59,%minutes%
Gui,Add,Text,x+20 yp+3,Minutes
Gui,Add,Edit,Voseconds w100 xm+20 y+10
Gui,Add,UpDown,Range0-59,%seconds%
Gui,Add,Text,x+20 yp+3,Seconds

Gui,Add,GroupBox,w310 h50 xm+10 y+35,&Running order
Gui,Add,Radio,xm+20 yp+20 Checked%random% vorandom,Random
Gui,Add,Radio,x+50 yp Checked%alpha% voalpha,Alphabetical

Gui,Add,GroupBox,w310 h50 xm+10 y+30,&Hide the desktop
Gui,Add,CheckBox,xm+20 yp+20 Checked%hidedesktop% vohidedesktop,Hide the desktop

Gui,Tab,2
Gui,Add,GroupBox,w310 h260 xm+10 y+10,&ScreenSavers to ignore
Gui,Add,ListView,xm+20 yp+20 r12 w280 Checked AutoHdr,Ignore|ScreenSaver|Path
Loop,%A_WinDir%\*.scr
{
  IfInString,ignored,%A_LoopFileName%
    LV_Add("Check","",A_LoopFileName,A_LoopFileDir)
  Else
    LV_Add("","",A_LoopFileName,A_LoopFileDir)
}
Loop,%A_WinDir%\System32\*.scr
{
  IfInString,ignored,%A_LoopFileName%
    LV_Add("Check","",A_LoopFileName,A_LoopFileDir)
  Else
    LV_Add("","",A_LoopFileName,A_LoopFileDir)
}
LV_ModifyCol(2,"Sort")
LV_ModifyCol(2)
LV_ModifyCol(3)

Gui,Tab,3
Gui,Add,Picture,xm+20 ym+30 Icon1,RandomScreenSaver.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,RandomScreenSaver v1.2
Gui,Font
Gui,Add,Text,xm+20 yp+30,Changes screensaver every x minutes.
Gui,Add,Text,,- Change running time and order.
Gui,Add,Text,,- Select screensavers to ignore.
Gui,Add,Text,,`t
Gui,Add,Picture,Icon5,RandomScreenSaver.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,xm+20 yp+30,For more information, tools and donations, visit
Gui,Font,CBlue Underline
Gui,Add,Text,GWWW,http://www.1hoursoftware.com
Gui,Font
Gui,Add,Text,

Gui,Tab,
Gui,Add,Button,GSETTINGSOK Default xm+20 y+30 w75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Gui,Show,,RandomScreenSaver Settings
Return


SETTINGSOK:
ignored=
row=0
Loop
{
  row:=LV_GetNext(row,"Checked")
  If row=0
    Break
  LV_GetText(text,row,2)
  ignored=%ignored%%text%|
}
Gui,Submit

hours:=ohours
minutes:=ominutes
seconds:=oseconds
random:=orandom
alpha:=oalpha
hidedesktop:=ohidedesktop
Gosub,INIWRITE
Gosub,SETTINGSCANCEL
Return


SETTINGSCANCEL:
Gui,Destroy
EXITAPP


WWW:
Run,http://www.1hoursoftware.com,,UseErrorLevel
Return


INIREAD:
IfNotExist,RandomScreenSaver.ini
{
  hours:=0
  minutes:=0
  seconds:=10
  random:=1
  alpha:=0
  hidedesktop:=1
  ignored=
  Gosub,INIWRITE
}
Else
{
  IniRead,hours,RandomScreenSaver.ini,Settings,hours
  IniRead,minutes,RandomScreenSaver.ini,Settings,minutes
  IniRead,seconds,RandomScreenSaver.ini,Settings,seconds
  IniRead,random,RandomScreenSaver.ini,Settings,random
  IniRead,alpha,RandomScreenSaver.ini,Settings,alpha
  IniRead,hidedesktop,RandomScreenSaver.ini,Settings,hidedesktop
  IniRead,ignored,RandomScreenSaver.ini,Settings,ignored
}
Return


INIWRITE:
IniWrite,%hours%,RandomScreenSaver.ini,Settings,hours
IniWrite,%minutes%,RandomScreenSaver.ini,Settings,minutes
IniWrite,%seconds%,RandomScreenSaver.ini,Settings,seconds
IniWrite,%random%,RandomScreenSaver.ini,Settings,random
IniWrite,%alpha%,RandomScreenSaver.ini,Settings,alpha
IniWrite,%hidedesktop%,RandomScreenSaver.ini,Settings,hidedesktop
IniWrite,%ignored%,RandomScreenSaver.ini,Settings,ignored
Return


INSTALL:
RegWrite,REG_SZ,HKEY_USERS,.DEFAULT\Control Panel\Desktop,ScrnSave.Exe,RandomScreenSaver.scr
Return


IDLE:
idle=%A_TimeIdlePhysical%
If idle<20
{
  SetTimer,IDLE,Off
  Process,Close,%screensaver%
  Process,Close,SCRNSAVE.EXE
  ExitApp
}
Return


GUI:
If hidedesktop=0
  Return
hidden=0
IfWinExist,ahk_class Shell_TrayWnd
{
  hidden=1
  WinHide,ahk_class Shell_TrayWnd
}
Gui,+AlwaysOnTop -Border
Gui,Color,000000
Gui,Show,x-3 y-3 w%A_ScreenWidth% h%A_ScreenHeight%,RandomScreenSaver
Gui,+LastFound
WinGet,guiid,Id,A
Return

EXIT:
If hidedesktop<>0
If hidden=1
  WinShow,ahk_class Shell_TrayWnd
ExitApp
Return
