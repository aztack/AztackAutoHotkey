;TaskLog.ahk
; Logs the time spent on different tasks.
;Skrommel @2005

#SingleInstance,Force
#Persistent

applicationname=TaskLog

START:
OnExit,ONEXIT
Gosub,INIREAD
Gosub,MENU
Gosub,CHANGEICON
start=%A_Now%
If showreminder=1
{
  Gosub,REMINDER
  SetTimer,REMINDER,% remindertime*60000,On
}
Return


MENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Default,%applicationname%
Menu,Tray,Add
Loop,Parse,tasks,`,
{
  Menu,Tray,Add,%A_LoopField%,MENUCLICK
}
Menu,Tray,Check,%task%
Menu,Tray,Add
Menu,Tray,Add,Show &log...,SHOWLOG
Menu,Tray,Add,Sort lo&g...,SORTLOG
Menu,Tray,Add
Menu,Tray,Add,&Settings...,SETTINGS 
Menu,Tray,Add,&About...,About 
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname% 
Return 


CHANGEICON:
If changeicon=1
{
  StringSplit,icons_,icons,`,
  iconcount:=lasttask*2-1
  iconpath:=icons_%iconcount%
  iconcount+=1
  iconpos:=icons_%iconcount%
  IfExist,%iconpath%
    Menu,Tray,Icon,%iconpath%,%iconpos%
}
Return


SHOWLOG:
Run,%applicationname%.csv
Return


SORTLOG:
FileRead,log,%applicationname%.csv
FileDelete,SortedLog.csv
Sort,log
FileAppend,%log%,SortedLog.csv
Run,SortedLog.csv
log=
Return


HOTKEY:
Loop,Parse,taskhotkeys,`,
{
  lasttask=%A_Index%
  If A_LoopField=%A_ThisHotkey%
  {
    Loop,Parse,tasks,`,
    {
      If A_Index=%lasttask%
      {
        nexttask=%A_LoopField%
        Break
      }
    }
    Gosub,TASK
    Break
  }
}
Return


MENUCLICK:
lasttask:=A_ThisMenuItemPos-2
Loop,Parse,tasks,`,
{
  If A_Index=%lasttask%
  {
    nexttask=%A_LoopField%
    Break
  }
}
;If nexttask<>%task%
Gosub,TASK
Return


TASK:
SetTimer,REMINDER,Off
stop=%A_Now%
duration=%stop%
EnvSub,duration,%start%,Minutes

If showdescription=0
{
  description=
  prevdescription=
  Goto,TASKOK
}

Gui,Destroy
Gui,+ToolWindow +AlwaysOnTop
StringReplace,text,prevdescriptiontext,<task>,%task%,All
StringReplace,text,text,<duration>,%duration%,All
Gui,Add,Text,,%text%
Gui,Add,Edit,vprevdescription w200 r1,%description%
If shownextdescription=1
{
  StringReplace,text,nextdescriptiontext,<task>,%nexttask%,All
  Gui,Add,Text,,%text%
  Gui,Add,Edit,vdescription w200 r1,%description%
}
Gui,Add,Button,x+10 yp Default gTASKOK,OK
Gui,Show,AutoSize Center,%applicationname% Description
Return


TASKOK:
Gui,Submit
FormatTime,startstring,%start%,%timestring%
FormatTime,stopstring,%stop%,%timestring%
text=%task%`,%startstring%`,%stopstring%`,%duration%`,%prevdescription%`n
FileAppend,%text%,%applicationname%.csv
Menu,Tray,UnCheck,%task%
Menu,Tray,Check,%nexttask%
Gosub,CHANGEICON
task=%nexttask%
start=%stop%
If description=
  description=%prevdescription%
IniWrite,%lasttask%,%applicationname%.ini,Settings,lasttask
IniWrite,%description%,%applicationname%.ini,Settings,lastdescription
SetTimer,REMINDER,% remindertime*60000,On
Menu,Tray,Tip,%task%
Return


REMINDER:
Gui,Destroy
stop=%A_Now%
duration=%stop%
EnvSub,duration,%start%,Minutes
StringReplace,text,remindertext,<task>,%task%,All
StringReplace,text,text,<duration>,%duration%,All
Gui,Destroy
Gui,+ToolWindow +AlwaysOnTop
Gui,Add,Text,y+10,%text%
Gui,Add,Button,x+10 yp-5 gREMINDERYES Default,Yes
Gui,Add,Button,x+5 yp gREMINDERNO,No
Gui,Show,AutoSize Center NoActivate,%applicationname% Reminder
;Menu,Tray,Tip,%text% 
Return


REMINDERYES:
Gui,Destroy
Return


REMINDERNO:
SHOWMENU:
Menu,Tray,Show
Return


EXIT:
Goto,OnExit


OnExit:
showdescription=0
nexttask=%task%
description=%prevdescription%
Gosub,TASKOK
ExitApp


GuiClose:
Gosub,SETTINGSCANCEL
Return

 
SETTINGS:
SetTimer,REMINDER,Off
Loop,Parse,taskhotkeys,`,
  Hotkey,%A_LoopField%,HOTKEY,Off
Gui,Destroy
Gui,Margin,30
Gui,Add,Tab,xm-20 w440 h550,Settings|Descriptions|Time formats

Gui,Tab,1
Gui,Add,GroupBox,xm-10 y+20 w420 h80,Task &names
Gui,Add,Edit,xm yp+20 w400 r2 vvtasks,%tasks%
Gui,Add,Text,,Format: taskname1,taskname2,taskname3

Gui,Add,GroupBox,xm-10 y+20 w420 h100,Icons
Gui,Add,CheckBox,xm yp+20 vvchangeicon Checked%changeicon%,Change tray &icon
Gui,Add,Edit,w400 r2 vvicons,%icons%
Gui,Add,Text,,Format: iconpath1,iconnumber1,iconpath2,iconnumber2,

Gui,Add,GroupBox,xm-10 y+20 w420 h150,Hotkeys 
Gui,Add,Text,xm yp+20,Change &task:
Gui,Add,Edit,w400 r2 vvtaskhotkeys,%taskhotkeys%
Gui,Add,Text,,Show &menu
Gui,Add,Edit,w100 vvmenuhotkey,%menuhotkey%
Gui,Add,Text,,Alt=! Ctrl=^ Shift=+

Gui,Add,GroupBox,xm-10 y+20 w420 h125,Dialogs 
Gui,Add,CheckBox,xm yp+20 vvshowreminder Checked%showreminder%,Show &reminder dialog
Gui,Add,Text,,Time to wait between reminders (minutes):
Gui,Add,Edit,w100 vvremindertime,
Gui,Add,UpDown,Range1-9999,%remindertime%
Gui,Add,CheckBox,vvshowdescription Checked%showdescription%,Show task &description dialog
Gui,Add,CheckBox,vvshownextdescription Checked%shownextdescription%,Show &next task description inputbox

Gui,Tab
Gui,Add,Button,y+40 w75 gSETTINGSOK,&OK
Gui,Add,Button,x+5 yp w75 gSETTINGSCANCEL,&Cancel

Gui,Tab,2
Gui,Add,GroupBox,xm-10 y+20 w420 h190,Dialog descriptions 
Gui,Add,Text,xm yp+20,Reminder:
Gui,Add,Edit,w400 vvremindertext,%remindertext%
Gui,Add,Text,,Previous task:
Gui,Add,Edit,w400 vvprevdescriptiontext,%prevdescriptiontext%
Gui,Add,Text,,Next task:
Gui,Add,Edit,w400 vvnextdescriptiontext,%nextdescriptiontext%
Gui,Add,Text,w380,Include the tags <task> to show the name of the task and <duration> to show the duration of the task

Gui,Add,GroupBox,xm-10 y+20 w420 h150,Logfile format
Gui,Add,Text,xm yp+20,Column descriptions: *
Gui,Add,Edit,yp+20 w380 vvheaders,%headers%
Gui,Add,Text,,Time format: *
Gui,Add,Edit,w400 vvtimestring,%timestring%
Gui,Add,Text,w400,* Won't take effect until %applicationname%.csv and SortedLog.csv are deleted, and %applicationname% is restarted.

Gui,Tab,3
Gui,Add,GroupBox,xm-10 y+20 w420 h185,Date Formats (case sensitive)
Gui,Add,Text,xm yp+20 w400,
(
d `t Day of the month without leading zero (1 - 31) 
dd `t Day of the month with leading zero (01 – 31) 
ddd `t Abbreviated name for the day of the week (e.g. Mon) 
dddd `t Full name for the day of the week (e.g. Monday) 
M `t Month without leading zero (1 – 12) 
MM `t Month with leading zero (01 – 12) 
MMM `t Abbreviated month name (e.g. Jan) 
MMMM `t Full month name (e.g. January) 
y `t Year without century, without leading zero (0 – 99) 
yy `t Year without century, with leading zero (00 - 99) 
yyyy `t Year with century. For example: 2005 
gg `t Period/era string (blank if none) 
)
 
Gui,Add,GroupBox,xm-10 y+20 w420 h160,Time Formats (case sensitive)
Gui,Add,Text,xm yp+20 w400,
(
h `t Hours without leading zero; 12-hour format (1 - 12) 
hh `t Hours with leading zero; 12-hour format (01 – 12) 
H `t Hours without leading zero; 24-hour format (0 - 23) 
HH `t Hours with leading zero; 24-hour format (00– 23) 
m `t Minutes without leading zero (0 – 59) 
mm `t Minutes with leading zero (00 – 59) 
s `t Seconds without leading zero (0 – 59) 
ss `t Seconds with leading zero (00 – 59) 
t `t Single character time marker, such as A or P (depends on locale) 
tt `t Multi-character time marker, such as AM or PM (depends on locale) 
) 

Gui,Show,w460,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
restart=1
If tasks=%vtasks%
If icons=%vicons%
If taskhotkeys=%vtaskhotkeys%
If menuhotkey=%vmenuhotkey%
If changeicon=%vchangeicon%
If showreminder=%vshowreminder%
If remindertext=%vremindertext%
If remindertime=%vremindertime%
If showdescription=%vshowdescription1%
If shownextdescription=%vshownextdescription%
If prevdescriptiontext=%vprevdescriptiontext%
If nextdescriptiontext=%vnextdescriptiontext%
If timestring=%vtimestring%
If headers=%vheaders%
  restart=0
If vtasks<>
  tasks:=vtasks
icons:=vicons
taskhotkeys:=vtaskhotkeys
menuhotkey:=vmenuhotkey
changeicon:=vchangeicon
showreminder:=vshowreminder
remindertext:=vremindertext
remindertime:=vremindertime
showdescription:=vshowdescription1
shownextdescription:=vshownextdescription
prevdescriptiontext:=vprevdescriptiontext
nextdescriptiontext:=vnextdescriptiontext
timestring:=vtimestring
headers:=vheaders
Gosub,INIWRITE
Gosub,SETTINGSCANCEL
If restart=1
  Gosub,START
Return


SETTINGSCANCEL:
Gui,Destroy
Loop,Parse,taskhotkeys,`,
  Hotkey,%A_LoopField%,HOTKEY,On
SetTimer,REMINDER,% remindertime*60000,On
Return


INIREAD:
IfNotExist,%applicationname%.ini 
{
  tasks=Pause,Task1,Task2
  icons=%applicationname%.exe,1,%windir%\System32\Calc.exe,1,%windir%\System32\Sol.exe,1
  taskhotkeys=^1,^2,^3
  menuhotkey=^0
  changeicon=1
  showreminder=1
  remindertext=Still working on task <task>, running for <duration> minutes?
  remindertime=1
  showdescription=1
  shownextdescription=1
  prevdescriptiontext=Description for previous task <task> running for <duration> minutes:
  nextdescriptiontext=Description for next task <task>:
  timestring=yyyy.MM.dd HH:mm:ss
  headers=Task,Start,Stop,Duration,Description
  lasttask=1
  lastdescription=
  Gosub,INIWRITE
}
IniRead,tasks,%applicationname%.ini,Settings,tasks
IniRead,taskhotkeys,%applicationname%.ini,Settings,taskhotkeys
IniRead,menuhotkey,%applicationname%.ini,Settings,menuhotkey
IniRead,icons,%applicationname%.ini,Settings,icons
IniRead,showreminder,%applicationname%.ini,Settings,showreminder
IniRead,remindertext,%applicationname%.ini,Settings,remindertext
IniRead,remindertime,%applicationname%.ini,Settings,remindertime
IniRead,showdescription,%applicationname%.ini,Settings,showdescription
IniRead,shownextdescription,%applicationname%.ini,Settings,shownextdescription
IniRead,prevdescriptiontext,%applicationname%.ini,Settings,prevdescriptiontext
IniRead,nextdescriptiontext,%applicationname%.ini,Settings,nextdescriptiontext
IniRead,timestring,%applicationname%.ini,Settings,timestring
IniRead,changeicon,%applicationname%.ini,Settings,changeicon
IniRead,lasttask,%applicationname%.ini,Settings,lasttask
IniRead,description,%applicationname%.ini,Settings,lastdescription
IniRead,headers,%applicationname%.ini,Settings,headers
Loop,Parse,tasks,`,
{
  task=%A_LoopField%
  If A_Index=%lasttask%
    Break
}
Loop,Parse,taskhotkeys,`,
  Hotkey,%A_LoopField%,HOTKEY
Hotkey,%menuhotkey%,SHOWMENU
IfNotExist,%applicationname%.csv
  FileAppend,%A_Space%%headers%`n,%applicationname%.csv
Return


INIWRITE:
IniWrite,%tasks%,%applicationname%.ini,Settings,tasks
IniWrite,%taskhotkeys%,%applicationname%.ini,Settings,taskhotkeys
IniWrite,%menuhotkey%,%applicationname%.ini,Settings,menuhotkey
IniWrite,%icons%,%applicationname%.ini,Settings,icons
IniWrite,%showreminder%,%applicationname%.ini,Settings,showreminder
IniWrite,%remindertext%,%applicationname%.ini,Settings,remindertext
IniWrite,%remindertime%,%applicationname%.ini,Settings,remindertime
IniWrite,%showdescription%,%applicationname%.ini,Settings,showdescription
IniWrite,%shownextdescription%,%applicationname%.ini,Settings,shownextdescription
IniWrite,%prevdescriptiontext%,%applicationname%.ini,Settings,prevdescriptiontext
IniWrite,%nextdescriptiontext%,%applicationname%.ini,Settings,nextdescriptiontext
IniWrite,%timestring%,%applicationname%.ini,Settings,timestring
IniWrite,%changeicon%,%applicationname%.ini,Settings,changeicon
IniWrite,%lasttask%,%applicationname%.ini,Settings,lasttask
IniWrite,%description%,%applicationname%.ini,Settings,lastdescription
IniWrite,%headers%,%applicationname%.ini,Settings,headers
Return


ABOUT:
Gui,Destroy
Gui,Add,Picture,Icon1,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,Font
Gui,Add,Text,xm,Logs the time spent on different tasks.
Gui,Add,Text,xm,- Change task using the tray menu, or press Ctrl-1 through Ctrl-9.
Gui,Add,Text,xm,- To show the menu, press Ctrl-0.
Gui,Add,Text,xm,- To change the settings, choose Settings in the tray menu.
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
DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static11,Static16,Static21
    DllCall("SetCursor","UInt",hCurs)
  Return
}

