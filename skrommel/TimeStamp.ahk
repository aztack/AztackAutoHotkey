;TimeStamp.ahk
;Copies user defined times and dates to the Clipboard.
;Skrommel @2005

#SingleInstance,Force
#Persistent
AutoTrim,Off
StringCaseSense,On

applicationname=TimeStamp

Gosub,READINI
Gosub,MENU
SetTimer,AUTORELOAD,500

oldid=1
Return


AUTORELOAD:
FileGetAttrib,attrib,%applicationname%.ini
IfInString,attrib,A
{
  FileSetAttrib,-A,%applicationname%.ini
  ReLoad
}
Return


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
  StringReplace,time,time,nl,&&&,All
  StringReplace,time,time,tab,|||,All
  StringReplace,time,time,week,@@@@,All
  StringReplace,time,time,day,@@@,All
  StringReplace,time,time,dddd,!!!!,All
  StringReplace,time,time,Dddd,$!!!,All
  StringReplace,time,time,DDDD,$$$$,All
  StringReplace,time,time,ddd,!!!,All
  StringReplace,time,time,Ddd,$!!,All
  StringReplace,time,time,DDD,$$$,All
  StringReplace,time,time,mmmm,££££,All
  StringReplace,time,time,Mmmm,§£££,All
  StringReplace,time,time,MMMM,§§§§,All
  StringReplace,time,time,mmm,£££,All
  StringReplace,time,time,Mmm,§££,All
  StringReplace,time,time,MMM,§§§,All
  FormatTime,time,,%time%
  StringReplace,time,time,&&&,`r`n,All
  StringReplace,time,time,|||,%A_Tab%,All
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
If string_0=0
{
  Menu,Tray,Add,<empty>,UNLOCK
  Menu,Tray,Disable,<empty>
}
Else
Loop,%string_0%
{
  line:=string_%A_Index%
  StringLeft,shortline,line,20
  If shortline<>%line%
    shortline=%shortline%...
  Menu,Tray,Add,%shortline%,COPY
}
Menu,Tray,Add
Menu,Tray,Add,&Settings,SETTINGS 
Menu,Tray,Add,&About,About 
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname%
Return 


COPY:
id:=A_ThisMenuItemPos-2
If id<1
  string:=string_%oldid%
Else
{
  string:=string_%id%
  oldid:=id
}
Gosub,EXPAND
SetEnv,Clipboard,%timestring%
ToolTip,%timestring%
Sleep,2000
ToolTip,

Return


SETTINGS:
Gosub,READINI
Run,%applicationname%.ini
Return

EXIT:
ExitApp
Return


READINI:
IfNotExist,%applicationname%.ini 
{
ini=H:mm:ss - dddd d.MM.yyy - "d"day "w"week
ini=%ini%`nyyy.MM.d nlH:mm:ss
ini=%ini%`n
ini=%ini%`n`;%applicationname%.ini
ini=%ini%`n`;
ini=%ini%`n`;Formatting (case sensitive)
ini=%ini%`n`;
ini=%ini%`n`;nl   NewLine
ini=%ini%`n`;tab  Tab
ini=%ini%`n`;     Surround regular text with ""
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
ini=%ini%`n`;Day  Day of the year
ini=%ini%`n`;Week Week of the year
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
ini=%ini%`n`;Examples:
ini=%ini%`n`;
ini=%ini%`n`;H:mm:ss - dddd d.MM.yyy - "d"day "w"week
ini=%ini%`n`;yyy.MM.d nlH:mm:ss
FileAppend,%ini%,%applicationname%.ini
ini=
}
string_0=0
Loop,Read,%applicationname%.ini
{
  StringTrimRight,line,A_LoopReadLine,0
  If line=
    Continue
  StringLeft,char,line,1
  If char=`;
    Continue
  string_0+=1
  string_%A_Index%=%line% 
}
line=
Return



ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Copies user defined times and dates to the Clipboard
Gui,99:Add,Text,y+5,- Change accents using Settings in the tray menu
Gui,99:Add,Text,y+5,- Doubleclick the tray icon to copy the last used date and time to the clipboard

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
