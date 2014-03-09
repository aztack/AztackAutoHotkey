;ProcessGuard.ahk
; Add alarms and actions to process values like memory usage, cpu usage and more
;Skrommel @ 2008

#SingleInstance,Force
DetectHiddenWindows,On
DetectHiddenText,On
SetTitleMatchMode,Slow
CoordMode,ToolTip,Screen

applicationname=ProcessGuard

RegRead,oldusrcolumnsettings,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,UsrColumnSettings
RegRead,oldpreferences,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,Preferences

OnExit,EXIT

Gosub,READINI
Gosub,TRAYMENU
taskmanid=
Gosub,TASKMAN

Loop
{
  IfWinNotExist,ahk_id %taskmanid%
    Gosub,TASKMAN
  WinSetTitle,ahk_id %taskmanid%,,%applicationname%
  Sleep,500
  ControlGet,rows,List,,SysListView321,ahk_id %taskmanid%
  StringReplace,rows,rows,%A_Space%kB,,ALL
  StringReplace,rows,rows, kB,,ALL
  StringReplace,rows,rows,%A_Space%,,All
  StringReplace,rows,rows, ,,All
  Loop,Parse,rows,`n
  {
    row=%A_LoopField%
    StringSplit,column,row,%A_Tab%
    Loop,%alarmcount%
    {
      processname:=alarm%A_Index%_2
      pid:=alarm%A_Index%_3
      If processname=*
      If column2=0
        Continue
      If processname<>*
      If processname<>%column1%
      If pid<>%column2%
        Continue
      columntowatch:=alarm%A_Index%_1
      value:=column%columntowatch%
      compare:=alarm%A_Index%_4
      limit:=alarm%A_Index%_5
      If compare=`<
      If value>=%limit%
      {
        starttime_%A_Index%_%column2%=
        Continue
      }
      If compare=`=
      If value<>%limit%
      {
        starttime_%A_Index%_%column2%=
        Continue
      }
      If compare=`>
      If value<=%limit%
      {
        starttime_%A_Index%_%column2%=
        Continue
      }
      If starttime_%A_Index%_%column2%=
        starttime_%A_Index%_%column2%:=A_Now
      time:=alarm%A_Index%_6
      start:=starttime_%A_Index%_%column2%       
      elapsed:=A_Now
      EnvSub,elapsed,%start%,Seconds
      If elapsed<%time%
        Continue
      starttime_%A_Index%_%column2%=
      message:=alarm%A_Index%_7
      If message<>
      {
        ToolTip,%message%,0,0
        SetTimer,TOOLTIP,5000
      }
      action:=alarm%A_Index%_8
      If action<>
      {
        confirm:=alarm%A_Index%_10
        msg=%message%`n`nExecute %action%: %column1%?
        run:=alarm%A_Index%_9
        If run<>
          msg=%msg%`n`nRun %run%?
        If confirm=1
        {
          MsgBox,4,%applicationname%,%msg%
          IfMsgBox,No
            Continue
        }
        If run<>
          Run,%run%
        If action=Close
        {
          Process,Close,%column2%
          Continue
        }
        priority=LBNAHR
        IfInString,priority,%action%
        {
          Process,Priority,%column2%,%action% 
          Continue
        }
        If action=Hide
        {
          WinHide,ahk_pid %column2%
          Continue
        }
        If action=Show
        {
          WinShow,ahk_pid %column2%
          Continue
        }
        If action=Min
        {
          WinMinimize,ahk_pid %column2%
          Continue
        }
        If action=Max
        {
          WinMaximize,ahk_pid %column2%
          Continue
        }
        If action=Shutdown
        {
          Shutdown, 1
          Continue
        }
        If action=ForceShutdown
        {
          Shutdown, 5
          Continue
        }
        If action=Reboot
        {
          Shutdown, 2
          Continue
        }
        If action=ForceReboot
        {
          Shutdown, 6
          Continue
        }
        If action=Logoff
        {
          Shutdown, 0
          Continue
        }
        If action=ForceLogoff
        {
          Shutdown, 4
          Continue
        }
        If action=Hibernate
        {
          DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
          Continue
        }
        If action=Suspend
        {
          DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
          Continue
        }
      }
    }
  }
}
Return

TASKMAN:
;RegRead,oldusrcolumnsettings,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,UsrColumnSettings
;RegRead,oldpreferences,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,Preferences

usrcolumnsettings=1C0C0000340400000000000078000000010000001D0C0000350400000100000023000000010000001E0C0000360400000
usrcolumnsettings=%usrcolumnsettings%00000005D000000010000001F0C000039040000000000006400000001000000200C00003704000
usrcolumnsettings=%usrcolumnsettings%0000000007800000001000000

preferences=9C020000D00700000200000001000000010000000A0000000A000000AA030000EF0200000100000000000000020000000300000
preferences=%preferences%004000000FFFFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000
preferences=%preferences%000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
preferences=%preferences%0000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
preferences=%preferences%FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000010000000200000003000000FFFFFFFFFFFFFFFFFFFFFFF
preferences=%preferences%FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
preferences=%preferences%FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000000
preferences=%preferences%000000100000000000000010000000000000000000000010000000200000003000000040000000500000006000
preferences=%preferences%0000700000008000000090000000A0000000B0000000C0000000D0000000E0000000F000000100000001100000
preferences=%preferences%012000000130000001400000015000000160000001700000018000000FFFFFFFF6B000000320000006B0000004
preferences=%preferences%6000000230000004600000046000000640000004600000046000000460000004600000046000000460000003C0
preferences=%preferences%000003C0000003C0000003C0000003C0000004600000046000000460000004600000046000000460000006B000
preferences=%preferences%000000000000100000002000000030000000400000005000000060000000700000008000000090000000A00000
preferences=%preferences%00B0000000C0000000D0000000E0000000F0000001000000011000000120000001300000014000000150000001
preferences=%preferences%60000001700000018000000FFFFFFFF42000000000000000000000001000000

RegWrite,REG_BINARY,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,UsrColumnSettings,%usrcolumnsettings%
RegWrite,REG_BINARY,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,Preferences,%preferences%

IfWinNotExist,ahk_id %taskmanid%
{
Run,taskmgr.exe,,Hide UseErrorLevel,taskmanpid 
  Process,Wait,%taskmanpid%,5 
  If ErrorLevel=0 
  { 
    MsgBox,0,Error,Unable to run TaskManager! 
    Goto,EXIT 
  } 
  WinWait,ahk_pid %taskmanpid%,,5 
  If ErrorLevel=1 
  { 
    MsgBox,0,Error,Unable to locate TaskManager! 
    Goto,EXIT 
  } 
  WinGet,taskmanid,ID,ahk_pid %taskmanpid% 
  Control,Disable,,SysTabControl321,ahk_id %taskmanid%
  WinSetTitle,ahk_id %taskmanid%,,%applicationname%
}

;  Run,taskmgr.exe,,Hide UseErrorLevel,taskmanpid
;  Process,Wait,%taskmanpid%,5
;  If ErrorLevel=0
;  {
;    MsgBox,0,%applicationname%,Unable to run TaskManager!
;    Goto,EXIT
;  }
;  WinWait,ahk_class #32770,CPU,5
;  If ErrorLevel=1
;  {
;    MsgBox,0,%applicationname%,Unable to locate TaskManager!
;    Goto,EXIT
;  }
;  WinGet,taskmanid,ID,ahk_class #32770,CPU
;  Control,Disable,,SysTabControl321,ahk_id %taskmanid%
;  WinSetTitle,ahk_id %taskmanid%,,%applicationname%
;}
;RegWrite,REG_BINARY,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,UsrColumnSettings,%oldusrcolumnsettings%
;RegWrite,REG_BINARY,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,Preferences,%oldpreferences%
Return

READINI:
IfNotExist,%applicationname%.ini
{
ini=
ini=%ini%`n7,Notepad.exe,,>,1000,10,Memory usage above limit!,Close,Calc.exe,1
ini=%ini%`n5,*,,>,90,10,Processor usage above limit!,L,,1
ini=%ini%`n
ini=%ini%`n;%applicationname%.ini
ini=%ini%`n;
ini=%ini%`n;Syntax:
ini=%ini%`n;
ini=%ini%`n;Column,Processname,PID,<=>,Limit,Time,Message,Action,Run,Confirm
ini=%ini%`n;
ini=%ini%`n; Column is the column in TaskManager to watch. The one on the far left is no. 1. 
ini=%ini%`n;  1-25 
ini=%ini%`n; Processname is the name of the process to watch. Must be exactly as listed in TaskManager.
ini=%ini%`n;  * means any process
ini=%ini%`n; PID is the id of the process to watch. Must be exactly as listed in TaskManager.
ini=%ini%`n; <=> determines how to use the Limit
ini=%ini%`n;  < checks for a value less than the Limit
ini=%ini%`n;  = checks for a value equal to the Limit
ini=%ini%`n;  > checks for a value greater than the Limit
ini=%ini%`n; Limit is the allowed value. The alarm is triggered if the value refered to in Column is <=> than this value.
ini=%ini%`n;  Write the value without spaces and kB.
ini=%ini%`n; Time is the time in seconds a value must be <=> than the Limit to trigger an alarm. 
ini=%ini%`n; Message is the message to show when the alarm is triggered.
ini=%ini%`n; Action is the action to perform when the alarm is triggered. 
ini=%ini%`n;  Close kills the process
ini=%ini%`n;  L changes the priority of the process to Low 
ini=%ini%`n;  B changes the priority of the process to BelowNormal 
ini=%ini%`n;  N changes the priority of the process to Normal
ini=%ini%`n;  A changes the priority of the process to AboveNormal
ini=%ini%`n;  H changes the priority of the process to High
ini=%ini%`n;  R changes the priority of the process to Realtime
ini=%ini%`n;  Hide hides the process window
ini=%ini%`n;  Show shows the process window
ini=%ini%`n;  Min minimizes the process window
ini=%ini%`n;  Max maximizes the process window
ini=%ini%`n;  Shutdown shuts down windows
ini=%ini%`n;  ForceShutdown forces a shutdown
ini=%ini%`n;  Reboot reboots Windows
ini=%ini%`n;  ForceReboot forces a reboot
ini=%ini%`n;  Logoff logs off windows
ini=%ini%`n;  ForceLogoff forces a logoff
ini=%ini%`n;  Suspend suspends Windows
ini=%ini%`n;  Hibernate hibernates Windows
ini=%ini%`n; Run is the program to run when the alarm is triggered.
ini=%ini%`n;  Example:Notepad.exe c:\boot.ini   Commas are not allowed in the command line.
ini=%ini%`n; Confirm prompts before performing the Action
ini=%ini%`n;  0,1 0=No 1=Yes
ini=%ini%`n;
ini=%ini%`n;Examples:
ini=%ini%`n;
ini=%ini%`n;7,Notepad.exe,,>,1000,10,Memory usage above limit!,Close,Calc.exe,1
ini=%ini%`n;  Asks to close Notepad.exe and run Calc.exe if the value in column 7 (memory) is
ini=%ini%`n;  above 1000 kB for 10 seconds.
ini=%ini%`n;5,*,,>,90,10,Processor usage above limit!,L,,0
ini=%ini%`n;  Automatically lowers the priority of * (any process) to L (low) 
ini=%ini%`n;   if the value in column 5 (CPU) is above 90 `% for 10 secs.
FileAppend,%ini%,%applicationname%.ini
}
linecounter=0
alarmcount=0
Loop
{
  linecounter+=1
  FileReadLine,line,%applicationname%.ini,%linecounter%
  If ErrorLevel<>0
    Break
  StringLeft,char,line,1
  If char=`;
    Continue
  IfNotInString,line,`,
    Continue
  alarmcount+=1
  StringSplit,alarm%alarmcount%_,line,`,
}
Return

SETTINGS:
WinShow,,ahk_id %taskmanid%
WinMaximize,ahk_id %taskmanid%
Gosub,READINI
Run,%applicationname%.ini
Return

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&Edit alarms...,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&Enable,ON
Menu,Tray,Add,&Disable,OFF
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return 

TOGGLE:
Suspend,Toggle
Return

ON:
Suspend,Off
Return

OFF:
Suspend,On
Return

TOOLTIP:
SetTimer,TOOLTIP,Off
ToolTip,
Return

EXIT:
;RegRead,oldusrcolumnsettings,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,UsrColumnSettings
;RegRead,oldpreferences,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,Preferences
;FileAppend,%oldusrcolumnsettings%,usr.txt
;FileAppend,%oldpreferences%,pref.txt
WinClose,ahk_id %taskmanid%
RegWrite,REG_BINARY,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,UsrColumnSettings,%oldusrcolumnsettings%
RegWrite,REG_BINARY,HKEY_CURRENT_USER,Software\Microsoft\Windows NT\CurrentVersion\TaskManager,Preferences,%oldpreferences%
ExitApp

ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Add alarms and actions to process values.
Gui,99:Add,Text,y+5,- Watch memory usage, cpu usage and more
Gui,99:Add,Text,y+5,- Add alarms by selecting Settings in the Tray menu

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
