;StartClock.ahk
; Shows the time on the Start button and date and more in the tray.
;Skrommel 2005

#SingleInstance,Force
#NoEnv
SetBatchLines,-1
AutoTrim,Off
StringCaseSense,On

applicationname=StartClock

Gosub,INIREAD
Gosub,TRAYMENU

START:
ControlMove,Button1,% 0-startoffset,,% startwidth+startoffset,,ahk_class Shell_TrayWnd

Sleep,1000
string:=startformat1
Gosub,EXPAND
ControlSetText,Button1,%timestring%,ahk_class Shell_TrayWnd

Sleep,1000
string:=startformat2
Gosub,EXPAND
ControlSetText,Button1,%timestring%,ahk_class Shell_TrayWnd

If traytip=1
{
  string:=tipformat
  Gosub,EXPAND
  Menu,Tray,Tip,%timestring%
}
Else
  Menu,Tray,Tip,%applicationname%

If starttip=1
{
  MouseGetPos,,,winid,ctrl
  If ctrl=Button1
  {
    WinGetClass,class,ahk_id %winid%
    If class=Shell_TrayWnd
      ToolTip,%timestring%
  }
  Else
    ToolTip
}
Goto,START


EXPAND:
StringGetPos,pos,string,"
If pos=0
  timepos=3
else
  timepos=1
StringSplit,timearray,string,"
LOOP1:
  FormatTime,week,,YWeek
  StringRight,week,week,2
  week+=0
  FormatTime,day,,YDay
  FormatTime,longday,,dddd
  StringLower,dllower,longday
  StringLower,dltitle,longday,T
  StringUpper,dlupper,longday  
  FormatTime,shortday,,ddd
  StringLower,dslower,shortday
  StringLower,dstitle,shortday,T
  StringUpper,dsupper,shortday 
  FormatTime,longmonth,,MMMM
  StringLower,mllower,longmonth
  StringLower,mltitle,longmonth,T
  StringUpper,mlupper,longmonth  
  FormatTime,shortmonth,,MMM
  StringLower,mslower,shortmonth
  StringLower,mstitle,shortmonth,T
  StringUpper,msupper,shortmonth 
  time=timearray%timepos%
  time:=%time%
  If time=
    Goto,NEXT1
  StringReplace,time,time,dddd,!!!!,All
  StringReplace,time,time,Dddd,$!!!,All
  StringReplace,time,time,DDDD,$$$$,All
  StringReplace,time,time,ddd,!!!,All
  StringReplace,time,time,Ddd,$!!,All
  StringReplace,time,time,Ddd,$$$,All
  StringReplace,time,time,mmmm,££££,All
  StringReplace,time,time,Mmmm,§£££,All
  StringReplace,time,time,MMMM,§§§§,All
  StringReplace,time,time,mmm,£££,All
  StringReplace,time,time,Mmm,§££,All
  StringReplace,time,time,MMM,§§§,All
  StringReplace,time,time,W,@@@@,All
  StringReplace,time,time,D,@@@,All
  FormatTime,time,,%time%
  StringReplace,time,time,!!!!,%dllower%,All
  StringReplace,time,time,$!!!,%dltitle%,All
  StringReplace,time,time,$$$$,%dlupper%,All
  StringReplace,time,time,!!!,%dslower%,All
  StringReplace,time,time,$!!,%dstitle%,All
  StringReplace,time,time,$$$,%dsupper%,All
  StringReplace,time,time,££££,%mllower%,All
  StringReplace,time,time,§£££,%mltitle%,All
  StringReplace,time,time,§§§§,%mlupper%,All
  StringReplace,time,time,£££,%mslower%,All
  StringReplace,time,time,§££,%mstitle%,All
  StringReplace,time,time,§§§,%msupper%,All
  StringReplace,time,time,@@@@,%week%,All
  StringReplace,time,time,@@@,%day%,All
  timearray%timepos%=%time%
NEXT1:
  timepos+=2 
If timepos<=%timearray0%
  Goto,LOOP1

timestring=
timepos=1 
LOOP2:
  time=timearray%timepos%
  time:=%time% 
  timestring=%timestring%%time%
  timepos+=1 
If timepos<=%timearray0%
  Goto,LOOP2
Return


SHOWCALENDAR:
Run,RunDll32.exe shell32.dll`,Control_RunDLL timedate.cpl,,UseErrorLevel
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  startformat1=HH mm
  startformat2=HH:mm
  tipformat=Dddd d.MM.yyy - "Day" D - "Week" W - HH:mm:ss
  starttip=1
  traytip=1
  startpadding=7
  startoffset=3
  Gosub,INIWRITE
  Gosub,ABOUT
}
IniRead,startpadding,%applicationname%.ini,Settings,startpadding
IniRead,startoffset,%applicationname%.ini,Settings,startoffset
IniRead,startformat1,%applicationname%.ini,Settings,startformat1
IniRead,startformat2,%applicationname%.ini,Settings,startformat2
IniRead,tipformat,%applicationname%.ini,Settings,tipformat
IniRead,starttip,%applicationname%.ini,Settings,starttip
IniRead,traytip,%applicationname%.ini,Settings,traytip
ControlGetPos,,,startstartwidth,,Button1,ahk_class Shell_TrayWnd
startwidth:=startstartwidth+startpadding
Return

INIWRITE:
IniWrite,%startpadding%,%applicationname%.ini,Settings,startpadding
IniWrite,%startoffset%,%applicationname%.ini,Settings,startoffset
IniWrite,%startformat1%,%applicationname%.ini,Settings,startformat1
IniWrite,%startformat2%,%applicationname%.ini,Settings,startformat2
IniWrite,%tipformat%,%applicationname%.ini,Settings,tipformat
IniWrite,%starttip%,%applicationname%.ini,Settings,starttip
IniWrite,%traytip%,%applicationname%.ini,Settings,traytip
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,SHOWCALENDAR
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


EXIT:
ExitApp


SETTINGS:
Gui,Destroy
Gui,Add,GroupBox,xm y+10 w310 h50,Start button format &1
Gui,Add,Edit,xp+10 yp+20 w290 vvstartformat1,%startformat1%

Gui,Add,GroupBox,xm y+10 w310 h50,Start button format &2
Gui,Add,Edit,xp+10 yp+20 w290 vvstartformat2,%startformat2%

Gui,Add,GroupBox,xm y+10 w310 h50,&Tray tip/Start tip format
Gui,Add,Edit,xp+10 yp+20 w290 vvtipformat,%tipformat%

Gui,Add,GroupBox,xm y+10 w310 h40,Show tip
Gui,Add,CheckBox,xm+10 yp+20 Checked%starttip% vvstarttip,&Start tip
Gui,Add,CheckBox,xm+160 yp Checked%traytip% vvtraytip,&Tray tip

Gui,Add,GroupBox,xm y+10 w310 h70,Start button &location
Gui,Add,Text,xm+10 yp+20,Padding (width)
Gui,Add,Text,xm+160 yp,Offset (x-position)

Gui,Add,Edit,xm+10 yp+20 w100 vvstartpadding
Gui,Add,UpDown,Range-999-999,%startpadding%

Gui,Add,Edit,xm+160 yp w100 vvstartoffset
Gui,Add,UpDown,Range-999-999,%startoffset%

help=Use " " around regular text.
help=%help%`n
help=%help%`nDate Formats (case sensitive)
help=%help%`n
help=%help%`nd`tDay of the month without leading zero (1 - 31)
help=%help%`ndd`tDay of the month with leading zero (01 – 31)
help=%help%`nddd`tLowercase abbreviated name for the day of the week (e.g. mon)
help=%help%`nDdd`tLike ddd, but Titlecase
help=%help%`nDDD`tLike ddd, but UPPERCASE
help=%help%`ndddd`tLowercase full name for the day of the week (e.g. monday)
help=%help%`nDddd`tLike ddd, but Titlecase
help=%help%`nDDDD`tLike ddd, but UPPERCASE
help=%help%`nM`tMonth without leading zero (1 – 12)
help=%help%`nMM`tMonth with leading zero (01 – 12)
help=%help%`nmmm`tLowercase abbreviated month name (e.g. jan)
help=%help%`nMmm`tLike mmm, but Titlecase
help=%help%`nMMM`tLike mmm, but UPPERCASE
help=%help%`nmmmm`tFull month name (e.g. january)
help=%help%`nMmmm`tLike mmmm, but Titlecase
help=%help%`nMMMM`tLike mmmm, but UPPERCASE
help=%help%`ny`tYear without century, without leading zero (0 – 99)
help=%help%`nyy`tYear without century, with leading zero (00 - 99)
help=%help%`nyyyy`tYear with century. Example: 2005
help=%help%`ngg`tPeriod/era string for the current user's locale (blank if none)
help=%help%`nD`tDay of the year
help=%help%`nW`tWeek of the year
help=%help%`n
help=%help%`nTime Formats (case sensitive)
help=%help%`n
help=%help%`nh`tHours without leading zero; 12-hour format (1 - 12)
help=%help%`nhh`tHours with leading zero; 12-hour format (01 – 12)
help=%help%`nH`tHours without leading zero; 24-hour format (0 - 23)
help=%help%`nHH`tHours with leading zero; 24-hour format (00– 23)
help=%help%`nm`tMinutes without leading zero (0 – 59)
help=%help%`nmm`tMinutes with leading zero (00 – 59)
help=%help%`ns`tSeconds without leading zero (0 – 59)
help=%help%`nss`tSeconds with leading zero (00 – 59)
help=%help%`nt`tSingle character time marker, such as A or P (depends on locale)
help=%help%`ntt`tMulti-character time marker, such as AM or PM (depends on locale) 
Gui,Add,Edit,xm y+20 r10 w310 ReadOnly -Wrap,%help%
help=
Gui,Add,Button,y+10 w75 Default GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
If vstartformat1<>
  startformat1:=vstartformat1
If vstartformat2<>
  startformat2:=vstartformat2
If vtipformat<>
  tipformat:=vtipformat
starttip:=vstarttip
traytip:=vtraytip
If vstartpadding<>
  startpadding:=vstartpadding
If vstartoffset<>
  startoffset:=vstartoffset
startwidth:=startstartwidth+startpadding
Gosub,INIWRITE
Gui,Destroy
Return

SETTINGSCANCEL:
Gui,Destroy
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.5
Gui,99:Font
Gui,99:Add,Text,y+10,Shows the time on the Start button
Gui,99:Add,Text,y+0,to show the current date and more
Gui,99:Add,Text,y+5,- DoubleClick the tray icon to show Windows' calendar
Gui,99:Add,Text,y+5,- Change the settings using Settings in the tray menu

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