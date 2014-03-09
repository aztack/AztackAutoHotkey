;TicTocTitle.ahk
; Show time and date on the title bar
;Skrommel @2005

#SingleInstance,Force
SetWinDelay,0
AutoTrim,Off
StringCaseSense,On
StringTrimRight,applicationname,A_ScriptName,4

Gosub,READINI
Gosub,MENU
Gosub,START
Gosub,LOOP

START:
string=%titlestring%
Gosub,EXPAND
Gui,1:Destroy
Gui,1:+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -SysMenu -Caption -Border -ToolWindow
Gui,1:Font,C%color% S%size% W%boldness%,%font%
Gui,1:Add,Text,Vtext,%timestring%%A_Space%%A_Space%%A_Space%%A_Space%
Gui,1:Show,,%applicationname% - Title  ; NoActivate avoids deactivating the currently active window.
Gui,1:+LastFound
winid:=WinExist("A")
PixelGetColor,transcolor,1,1,RGB
Gui,1:+E0x20
WinSet,TransColor,%transcolor% 255,ahk_id %winid%
WinGetPos,tx,ty,twidth,theight,ahk_id %winid%
Return

LOOP:
Sleep,10
string=%titlestring%
Gosub,EXPAND
GuiControl,,text,%timestring%
WinGetActiveStats,atitle,awidth,aheight,ax,ay
;TrayTip,,%atitle%
If (atitle="" Or atitle="Program Manager" Or ax<-4 Or ay<-4 Or awidth<twidth*2)
{
  atitle=Program Manager
  SysGet,monitor,MonitorWorkArea
  ax:=4
  ay:=-4
  awidth:=monitorRight
  aheight:=monitorBottom
}
oldtx:=tx
oldty:=ty
tx:=ax+awidth-twidth+xoffset
ty:=ay+yoffset
If (tx<>oldtx Or ty<>oldty)
  WinMove,ahk_id %winid%,,%tx%,%ty%
Goto,LOOP


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

  StringReplace,time,time,caps,^~~~~,All
  StringReplace,time,time,num,^~~~,All
  StringReplace,time,time,scroll,^~~,All
  StringReplace,time,time,insert,^~,All

  StringReplace,time,time,week,@@@@,All
  StringReplace,time,time,day,@@@,All
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

  FormatTime,time,,%time%

  GetKeyState,state,CapsLock,T
  value=c
  If state=D
    value=C
  StringReplace,time,time,^~~~~,%value%,All
  GetKeyState,state,NumLock,T
  value=n
  If state=D
    value=N
  StringReplace,time,time,^~~~,%value%,All
  GetKeyState,state,ScrollLock,T
  value=s
  If state=D
    value=S
  StringReplace,time,time,^~~,%value%,All
  GetKeyState,state,Insert,T
  value=i
  If state=D
    value=I
  StringReplace,time,time,^~,%value%,All

  StringReplace,time,time,@@@@,%week%,All
  StringReplace,time,time,@@@,%day%,All
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


MENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,COPY
Menu,Tray,Default,%applicationname%
Menu,Tray,Add
Menu,Tray,Add,&Copy time and date,COPY
Menu,Tray,Add,&Settings,SETTINGS 
Menu,Tray,Add,&About,About 
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return 


COPY:
string=%copystring%
Gosub,EXPAND
SetEnv,Clipboard,%timestring%
ToolTip,%timestring%
Sleep,1000
ToolTip,
Return


SETTINGS:
Gui,2:Destroy
Gui,2:Add,GroupBox,xm y+10 w310 h50,&Title string
Gui,2:Add,Edit,xp+10 yp+20 w290 vstitlestring,%titlestring%
Gui,2:Add,GroupBox,xm y+10 w310 h50,&Copy string
Gui,2:Add,Edit,xp+10 yp+20 w290 scopystring,%copystring%
Gui,2:Add,GroupBox,xm y+10 w310 h50,&Font
Gui,2:Add,Edit,xp+10 yp+20 w290 vsfont,%font%
Gui,2:Add,GroupBox,xm y+10 w150 h50,&Size
Gui,2:Add,Edit,xp+10 yp+20 w130 vssize,%size%
Gui,2:Add,GroupBox,xm+160 yp-20 w150 h70,&Boldness
Gui,2:Add,Edit,xp+10 yp+20 w130 vsboldness,%boldness%
Gui,2:Add,Text,xp y+5,400=normal 700=bold
Gui,2:Add,GroupBox,xm yp+10 w150 h50,&Color
Gui,2:Add,Edit,xp+10 yp+20 w130 vscolor,%color%
Gui,2:Add,GroupBox,xm y+10 w150 h50,&X offset
Gui,2:Add,Edit,xp+10 yp+20 w130 vsxoffset,%xoffset%
Gui,2:Add,GroupBox,xm+160 yp-20 w150 h50,&Y offset
Gui,2:Add,Edit,xp+10 yp+20 w130 vsyoffset,%yoffset%

help=Date Formats (case sensitive)
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
help=%help%`nday`tDay of the year
help=%help%`nweek`tWeek of the year
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
help=%help%`n
help=%help%`nOther Formats (case sensitive)
help=%help%`n
help=%help%`ncaps`tCaps Lock state
help=%help%`nnum`tNum Lock state
help=%help%`nscroll`tScroll Lock state
help=%help%`ninsert`tInstert state
Gui,2:Add,Edit,xm y+20 r10 w310 ReadOnly -Wrap,%help%
help=
Gui,2:Add,Button,y+10 w75 GSETTINGSOK,&OK
Gui,2:Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,2:Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,2:Submit
If stitlestring<>
  titlestring:=stitlestring
If scopystring<>
  copystring:=scopystring
If sfont<>
  font:=sfont
If ssize<>
  size:=ssize
If sboldness<>
  boldness:=sboldness
If scolor<>
  color:=scolor
If sxoffset<>
  xoffset:=sxoffset
If syoffset<>
  yoffset:=syoffset
IniWrite,%font%,%applicationname%.ini,Settings,font
IniWrite,%titlestring%,%applicationname%.ini,Settings,titlestring
IniWrite,%copystring%,%applicationname%.ini,Settings,copystring
IniWrite,%size%,%applicationname%.ini,Settings,size
IniWrite,%boldness%,%applicationname%.ini,Settings,boldness
IniWrite,%color%,%applicationname%.ini,Settings,color
IniWrite,%xoffset%,%applicationname%.ini,Settings,xoffset
IniWrite,%yoffset%,%applicationname%.ini,Settings,yoffset
Gosub,START
Return

SETTINGSCANCEL:
Gui,2:Destroy
Return


EXIT:
  ExitApp
Return


READINI:
IfNotExist,%applicationname%.ini 
{
  ini=[Settings]
  ini=%ini%`ntitlestring=H:mm:ss - dddd d.MM.yyy - "d"day "w"week - capsnumscrollinsert
  ini=%ini%`ncopystring=yyy.MM.d H:mm:ss
  ini=%ini%`nfont=MS sans serif
  ini=%ini%`nsize=9
  ini=%ini%`nboldness=700
  ini=%ini%`n`;1-1000 400=normal 700=bold
  ini=%ini%`ncolor=FFFFFF
  ini=%ini%`nxoffset=-50
  ini=%ini%`nyoffset=0`n

  
  ini=%ini%`n`;%applicationname%.ini
  ini=%ini%`n`;
  ini=%ini%`n`;Date Formats (case sensitive)
  ini=%ini%`n`;
  ini=%ini%`n`;d    Day of the month without leading zero (1 - 31)
  ini=%ini%`n`;dd   Day of the month with leading zero (01 – 31)
  ini=%ini%`n`;ddd  Lowercase abbreviated name for the day of the week (e.g. mon)
  ini=%ini%`n`;Ddd  Like ddd`, but Titlecase
  ini=%ini%`n`;DDD  Like ddd`, but UPPERCASE
  ini=%ini%`n`;dddd Lowercase full name for the day of the week (e.g. monday)
  ini=%ini%`n`;Dddd Like ddd`, but Titlecase
  ini=%ini%`n`;DDDD Like ddd`, but UPPERCASE
  ini=%ini%`n`;M    Month without leading zero (1 – 12)
  ini=%ini%`n`;MM   Month with leading zero (01 – 12)
  ini=%ini%`n`;mmm  Lowercase abbreviated month name (e.g. jan)
  ini=%ini%`n`;Mmm  Like mmm`, but Titlecase
  ini=%ini%`n`;MMM  Like mmm`, but UPPERCASE
  ini=%ini%`n`;mmmm Full month name (e.g. january)
  ini=%ini%`n`;Mmmm Like mmmm`, but Titlecase
  ini=%ini%`n`;MMMM Like mmmm`, but UPPERCASE
  ini=%ini%`n`;y    Year without century`, without leading zero (0 – 99)
  ini=%ini%`n`;yy   Year without century`, with leading zero (00 - 99)
  ini=%ini%`n`;yyyy Year with century. Example: 2005
  ini=%ini%`n`;gg   Period/era string for the current user's locale (blank if none)
  ini=%ini%`n`;day  Day of the year
  ini=%ini%`n`;week Week of the year
  ini=%ini%`n`;
  ini=%ini%`n`;Time Formats (case sensitive)
  ini=%ini%`n`;
  ini=%ini%`n`;h    Hours without leading zero; 12-hour format (1 - 12)
  ini=%ini%`n`;hh   Hours with leading zero; 12-hour format (01 – 12)
  ini=%ini%`n`;H    Hours without leading zero; 24-hour format (0 - 23)
  ini=%ini%`n`;HH   Hours with leading zero; 24-hour format (00– 23)
  ini=%ini%`n`;m    Minutes without leading zero (0 – 59)
  ini=%ini%`n`;mm   Minutes with leading zero (00 – 59)
  ini=%ini%`n`;s    Seconds without leading zero (0 – 59)
  ini=%ini%`n`;ss   Seconds with leading zero (00 – 59)
  ini=%ini%`n`;t    Single character time marker`, such as A or P (depends on locale)
  ini=%ini%`n`;tt   Multi-character time marker`, such as AM or PM (depends on locale) 
  ini=%ini%`n`;
  ini=%ini%`n`;Other Formats (case sensitive)
  ini=%ini%`n`;
  ini=%ini%`n`;caps   Caps Lock state
  ini=%ini%`n`;num    Num Lock state
  ini=%ini%`n`;scroll Scroll Lock state
  ini=%ini%`n`;insert Insert state
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
IniRead,font,%applicationname%.ini,Settings,font
IniRead,titlestring,%applicationname%.ini,Settings,titlestring
IniRead,copystring,%applicationname%.ini,Settings,copystring
IniRead,size,%applicationname%.ini,Settings,size
IniRead,boldness,%applicationname%.ini,Settings,boldness
IniRead,color,%applicationname%.ini,Settings,color
IniRead,xoffset,%applicationname%.ini,Settings,xoffset
IniRead,yoffset,%applicationname%.ini,Settings,yoffset
Return


ABOUT:
Gui,2:Destroy
Gui,2:Add,Picture,Icon1,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,%applicationname% v1.5
Gui,2:Font
Gui,2:Add,Text,xm,Shows the current time, date and more on the title bar.
Gui,2:Add,Text,xm,- Doubleclick the tray icon to copy the date and time to the clipboard.
Gui,2:Add,Text,xm,- To change the apperance, choose Settings in the tray menu.
Gui,2:Add,Text,y+0,`t
Gui,2:Add,Picture,xm Icon5,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,2:Font
Gui,2:Add,Text,xm,For more tools, information and donations, visit
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm G1HOURSOFTWARE,www.1HourSoftware.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon7,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,DonationCoder
Gui,2:Font
Gui,2:Add,Text,xm,Please support the DonationCoder community
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm GDONATIONCODER,www.DonationCoder.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon6,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,AutoHotkey
Gui,2:Font
Gui,2:Add,Text,xm,This program was made using AutoHotkey
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm GAUTOHOTKEY,www.AutoHotkey.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Button,GABOUTOK Default w75,&OK
Gui,2:Show,,%applicationname% About

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
Gui,2:Destroy
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static10,Static15,Static20
    DllCall("SetCursor","UInt",hCurs)
  Return
}