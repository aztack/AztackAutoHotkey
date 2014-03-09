;IdleMute.ahk
; Mutes the speaker when the computer has been idle for a while.
;Skrommel @2005

FileInstall,Mute.ico,Mute.ico
FileInstall,Sleep.ico,Sleep.ico
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
AutoTrim,Off

applicationname=IdleMute

Gosub,READINI
Gosub,TRAYMENU
If startmuted=2
  SoundSet,%lastmute%,,Mute
Else
  SoundSet,%startmuted%,,Mute
idle=0
running=0
enabled=1
SetTimer,IDLE,1000
Gosub,CHECKMUTE
Return


ACTIVE:
active=0
now=%A_Hour%%A_Min%
If (mutingstart<mutingend And now>mutingstart And now<mutingend)
  active=1
If (mutingstart>=mutingend And (now>mutingstart Or now<mutingend))
  active=1
Return


IDLE:
Gosub,ACTIVE
If enabled=1
If idle=0
If active=1
If A_TimeIdlePhysical>=%idletime%
{
  Gosub,PROGRAMS
  If running=0
  {
    SoundGet,oldmute,,Mute
    If mutewhenidle=1
      Gosub,MUTE
    idle=1
  }
  Gosub,MUTECOMMAND
}
If enabled=1
If idle=1
If A_TimeIdlePhysical<%idletime%
{
  If oldmute=Off
  If mutewhenidle=1
    GOsub,UNMUTE
  idle=0
  Gosub,UNMUTECOMMAND
}
Gosub,CHECKMUTE
Return


MUTE:
SoundGet,volume
If fademuting=1
{
  counter=%volume%
  counter-=1
  Loop,%volume%
  {
    counter-=1
    SoundSet,%counter%
    Sleep,50
  }
}
SoundSet,1,,Mute
SoundSet,%volume%
Return


UNMUTE:
If fademuting=1
{
  SoundGet,volume
  SoundSet,1
  SoundSet,0,,Mute
  counter=1
  Loop,%volume%
  {
    counter+=1
    SoundSet,%counter%
    Sleep,50
  }
}
Else
  SoundSet,0,,Mute
Return


READINI:
IfNotExist,%applicationname%.ini
{
  inifile=;%applicationname%.ini
  inifile=%inifile%`n`;[Settings]
  inifile=%inifile%`n`;idletime=30                      `;Idle time before muting, in minutes 
  inifile=%inifile%`n`;latetime=30                      `;Idle time before muting, in minutes 
  inifile=%inifile%`n`;mutewhenidle=1			`;0=No 1=Yes  Mute when idle time exceeded?
  inifile=%inifile%`n`;mutingstart=0001                 `;HHMM or leave empty  Time to start muting when idle
  inifile=%inifile%`n`;mutingend=2359                   `;HHMM                 Time to end muting when idle
  inifile=%inifile%`n`;programs=winamp.exe,vlc.exe      `;List of programs that prevents muting
  inifile=%inifile%`n`;mutecommand=                     `;COmmand to run when muting
  inifile=%inifile%`n`;mutecommanddir=                  `;Working dir of command
  inifile=%inifile%`n`;mutecommandhide=0                `;0=No 1=Yes  Run command hidden?
  inifile=%inifile%`n`;unmutecommand=                   `;COmmand to run when unmuting
  inifile=%inifile%`n`;unmutecommanddir=                `;Working dir of command
  inifile=%inifile%`n`;unmutecommandhide=0              `;0=No 1=Yes  Run command hidden?
  inifile=%inifile%`n`;latecommand=                     `;COmmand to run when idle and muted
  inifile=%inifile%`n`;latecommanddir=                  `;Working dir of command
  inifile=%inifile%`n`;latecommandhide=0                `;0=No 1=Yes  Run command hidden?
  inifile=%inifile%`n`;startmuted=2                     `;0=Off 1=On 2=Use lastmute state  Startup mute state 
  inifile=%inifile%`n`;lastmute=                        `;0=Off 1=On  Last mute state, changed by startmuted
  inifile=%inifile%`n`;fademuting=1                     `;0=No 1=Yes  Fade on muting/unmuting?
  inifile=%inifile%`n`;hotkeymute=                      `;Hotkey to toggle the mute state
  inifile=%inifile%`n`;hotkeyvolumeup=                  `;Hotkey to increase the volume
  inifile=%inifile%`n`;hotkeyvolumedown=                `;Hotkey to decrease the volume
  inifile=%inifile%`n`;volumechange=10                  `;How much to increse/decrease volume when using hotkeys
  inifile=%inifile%`n`;showvolumebar=1                  `;0=No 1=Yes  Show the volume bar when changing volume?
  inifile=%inifile%`n`;playsound=                       `;File to play when changing volume
  inifile=%inifile%`n`;scroll=1                         `;Change volume when using the mouse scrollbutton over the Taskbar
  inifile=%inifile%`n
  inifile=%inifile%`n[Settings]
  inifile=%inifile%`nidletime=30
  inifile=%inifile%`nlatetime=30
  inifile=%inifile%`nmutewhenidle=1
  inifile=%inifile%`nmutingstart=0001
  inifile=%inifile%`nmutingend=2359
  inifile=%inifile%`nprograms=
  inifile=%inifile%`nmutecommand=
  inifile=%inifile%`nmutecommanddir=
  inifile=%inifile%`nmutecommandhide=0
  inifile=%inifile%`nunmutecommand=
  inifile=%inifile%`nunmutecommanddir=
  inifile=%inifile%`nunmutecommandhide=0
  inifile=%inifile%`nlatecommand=
  inifile=%inifile%`nlatecommanddir=
  inifile=%inifile%`nlatecommandhide=0
  inifile=%inifile%`nstartmuted=2
  inifile=%inifile%`nlastmute=
  inifile=%inifile%`nfademuting=1
  inifile=%inifile%`nhotkeymute=
  inifile=%inifile%`nhotkeyvolumeup=
  inifile=%inifile%`nhotkeyvolumedown=
  inifile=%inifile%`nvolumechange=10
  inifile=%inifile%`nshowvolumebar=0
  inifile=%inifile%`nscroll=1
  inifile=%inifile%`nplaysound=%SystemRoot%\Media\ding.wav
  FileAppend,%inifile%,%applicationname%.ini
  inifile=1
  Gosub,ABOUT
}
IniRead,idletime,%applicationname%.ini,Settings,idletime
IniRead,latetime,%applicationname%.ini,Settings,latetime
IniRead,mutewhenidle,%applicationname%.ini,Settings,mutewhenidle
IniRead,mutingstart,%applicationname%.ini,Settings,mutingstart
IniRead,mutingend,%applicationname%.ini,Settings,mutingend
IniRead,programs,%applicationname%.ini,Settings,programs
IniRead,startmuted,%applicationname%.ini,Settings,startmuted
IniRead,lastmute,%applicationname%.ini,Settings,lastmute
IniRead,fademuting,%applicationname%.ini,Settings,fademuting
IniRead,hotkeymute,%applicationname%.ini,Settings,hotkeymute
IniRead,hotkeyvolumeup,%applicationname%.ini,Settings,hotkeyvolumeup
IniRead,hotkeyvolumedown,%applicationname%.ini,Settings,hotkeyvolumedown
IniRead,volumechange,%applicationname%.ini,Settings,volumechange
IniRead,showvolumebar,%applicationname%.ini,Settings,showvolumebar
IniRead,playsound,%applicationname%.ini,Settings,playsound
IniRead,mutecommand,%applicationname%.ini,Settings,mutecommand
IniRead,mutecommanddir,%applicationname%.ini,Settings,mutecommanddir
IniRead,mutecommandhide,%applicationname%.ini,Settings,mutecommandhide
IniRead,unmutecommand,%applicationname%.ini,Settings,unmutecommand
IniRead,unmutecommanddir,%applicationname%.ini,Settings,unmutecommanddir
IniRead,unmutecommandhide,%applicationname%.ini,Settings,unmutecommandhide
IniRead,latecommand,%applicationname%.ini,Settings,latecommand
IniRead,latecommanddir,%applicationname%.ini,Settings,latecommanddir
IniRead,latecommandhide,%applicationname%.ini,Settings,latecommandhide
IniRead,scroll,%applicationname%.ini,Settings,scroll
idletime*=60000
latetime*=60000
If inifile=1
  Gosub,SETTINGS
If hotkeymute<>
  Hotkey,%hotkeymute%,TOGGLEMUTE
If hotkeyvolumeup<>
  Hotkey,%hotkeyvolumeup%,VOLUMEUP
If hotkeyvolumedown<>
  Hotkey,%hotkeyvolumedown%,VOLUMEDOWN
If scroll<>0
{
  scroll=1
  Hotkey,~WheelDown,WHEELDOWN
  Hotkey,~WheelUp,WHEELUP
}
Else
  scroll=0
Return


TRAYMENU:
Menu,Tray,Click,1 
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,DOUBLECLICK
Menu,Tray,Add,
Menu,Tray,Add,&Mute,TOGGLEMUTE
Menu,Tray,Add,&Volume...,VOLUME
Menu,Tray,Add,&Sound...,SOUND
Menu,Tray,Add,&Enabled,ENABLE
Menu,Tray,Add,
Menu,Tray,Add,Se&ttings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Menu,Tray,Check,&Enabled
Return


SINGLECLICK:
SetTimer,SingleClick,Off 
clicks=
Gosub,VOLUMEBAR
Return 


DOUBLECLICK: 
If clicks= 
{ 
  SetTimer,SingleClick,500
  clicks=1 
  Return 
} 
SetTimer,SingleClick,Off 
clicks= 
Gosub,TOGGLEMUTE
Return


VOLUMEBAR:
;If A_OSVersion=WIN_VISTA
Run,SndVol.exe -f ;,,UseErrorLevel
If ErrorLevel=1
  Run,SndVol32.exe /t ;,,UseErrorLevel
Return


VOLUME:
;If A_OSVersion=WIN_VISTA
Run,SndVol.exe,,UseErrorLevel
If ErrorLevel=1
  Run,SndVol32.exe,,UseErrorLevel
Return


SOUND:
Run,mmsys.cpl,,UseErrorLevel
Return


ENABLE:
If enabled=1
{
  Menu,Tray,UnCheck,&Enabled
  enabled=0
}
Else
{
  Menu,Tray,Check,&Enabled
  enabled=1
}
Return


TOGGLEMUTE:
SoundGet,muted,,Mute
If muted=Off
  Gosub,MUTE
Else
  Gosub,UNMUTE
Gosub,CHECKMUTE
Return


CHECKMUTE:
SoundGet,mute,,Mute
If mute=On
{
  IfExist,Mute.ico
    Menu,Tray,Icon,Mute.ico
  Else
    Menu,Tray,Icon,%applicationname%.exe,1
  Menu,Tray,Check,&Mute
}
Else
{
  If (active="1" And enabled="1" And running="0") 
  {
;    Menu,Tray,Icon,%applicationname%.exe,3,3
    SoundGet,trayvolume,,Volume
    trayvolume:=Ceil(trayvolume/10)
    If trayvolume>9
      trayvolume=9
    IfExist,%trayvolume%.ico
      Menu,Tray,Icon,%trayvolume%.ico
;    Else
;      Menu,Tray,Icon,%applicationname%.exe,%trayvolume%
  }
  Else
    IfExist,%applicationname%Sleep.ico
      Menu,Tray,Icon,Sleep.ico
;    Else
;      Menu,Tray,Icon,%applicationname%.exe,17
  Menu,Tray,UnCheck,&Mute
}
If mute<>%lastmute%
{
  If mute=On  
    IniWrite,1,%applicationname%.ini,Settings,lastmute
  Else
    IniWrite,0,%applicationname%.ini,Settings,lastmute
  lastmute=%mute%
}
Return


EXIT:
ExitApp


PROGRAMS:
running=0
WinGet,id,List,,,Program Manager
Loop,%id%
{
  Sleep,0
  StringTrimRight,winid,id%a_index%,0
  WinGet,program,ProcessName,ahk_id %winid%
  If program In %programs%
  {
    running=1
    Break
  }
}
Return


WHEELDOWN:
MouseGetPos,,,mwin
WinGetClass,class,ahk_id %mwin%
If class=Shell_TrayWnd
  SoundSet,-10
Return


WHEELUP:
MouseGetPos,,,mwin
WinGetClass,class,ahk_id %mwin%
If class=Shell_TrayWnd
  SoundSet,+10
Return


SETTINGS:
SetTimer,IDLE,OFF
If hotkeymute<>
  Hotkey,%hotkeymute%,Off
If hotkeyvolumeup<>
  Hotkey,%hotkeyvolumeup%,Off
If hotkeyvolumedown<>
  Hotkey,%hotkeyvolumedown%,Off
If scroll<>0
{
  Hotkey,~WheelDown,Off
  Hotkey,~WheelUp,Off
}
minutes:=idletime/60000
hours:=Floor(minutes/60)
minutes:=minutes-hours*60
lateminutes:=latetime/60000
latehours:=Floor(lateminutes/60)
lateminutes:=lateminutes-latehours*60
omutingstart=%A_YYYY%%A_MM%%A_DD%%mutingstart%00
omutingend=%A_YYYY%%A_MM%%A_DD%%mutingend%00
oplaysound:=playsound
check0=
check1=
check2=
check%startmuted%=Checked
Gui,Destroy
Gui,Add,Tab,W330 H440 xm,Timers|Programs|Volume|Hotkeys

Gui,Tab,1
Gui,Add,GroupBox,w310 h70 xm+10 yp+30,&When should idle muting be active?
Gui,Add,Text,xm+20 yp+20,Time to start idle muting
Gui,Add,Text,xm+150 yp,Time to stop idle muting
Gui,Add,DateTime,Vomutingstart Choose%omutingstart% w100 xm+20 y+5,Time
Gui,Add,DateTime,Vomutingend Choose%omutingend% w100 xm+150 yp,Time

Gui,Add,GroupBox,w310 h70 xm+10 y+20,&How long should the PC be Idle before muting?
Gui,Add,Text,xm+20 yp+20,Hours
Gui,Add,Text,xm+150 yp,Minutes
Gui,Add,Edit,Vohours w100 xm+20 y+5
Gui,Add,UpDown,Range0-23,%hours%
Gui,Add,Edit,Vominutes w100 xm+150 yp
Gui,Add,UpDown,Range0-59,%minutes%

Gui,Add,GroupBox,w310 h70 xm+10 y+20,How long to be Idle && Muted before running a &command?
Gui,Add,Text,xm+20 yp+20,Hours
Gui,Add,Text,xm+150 yp,Minutes
Gui,Add,Edit,Volatehours w100 xm+20 y+5
Gui,Add,UpDown,Range0-23,%latehours%
Gui,Add,Edit,Volateminutes w100 xm+150 yp
Gui,Add,UpDown,Range0-59,%lateminutes%

Gui,Add,GroupBox,w310 h140 xm+10 y+20,What command to &run when Idle && Muted?
Gui,Add,Text,xm+20 yp+20,Command
Gui,Add,Edit,Volatecommand r1 w280 xm+20 y+5,%latecommand%
Gui,Add,Text,xm+20 y+5,Working Dir
Gui,Add,Edit,Volatecommanddir r1 w280 xm+20 y+5,%latecommanddir%
Gui,Add,Checkbox,Checked%latecommandhide% Volatecommandhide xm+20 y+10,Run hidden
Gui,Add,Button,GSETTINGSLATEBROWSE xm+225 yp-3 w75,B&rowse

Gui,Tab,2
Gui,Add,GroupBox,w310 h90 xm+10 ym+30,What &Programs should prevent idle muting?
Gui,Add,Edit,Voprograms r2 w280 xm+20 yp+20,%programs%
Gui,Add,Text,,Example: winamp.exe,vlc.exe,itunes.exe

Gui,Add,GroupBox,w310 h140 xm+10 y+25,What command to run when &Muting?
Gui,Add,Text,xm+20 yp+20,Command
Gui,Add,Edit,Vomutecommand r1 w280 xm+20 y+5,%mutecommand%
Gui,Add,Text,xm+20 y+5,Working Dir
Gui,Add,Edit,Vomutecommanddir r1 w280 xm+20 y+5,%mutecommanddir%
Gui,Add,Checkbox,Checked%mutecommandhide% Vomutecommandhide xm+20 y+10,Run hidden
Gui,Add,Button,GSETTINGSMUTEBROWSE xm+225 yp-3 w75,&Browse

Gui,Add,GroupBox,w310 h140 xm+10 y+20,What command to run when &Unmuting?
Gui,Add,Text,xm+20 yp+20,Command
Gui,Add,Edit,Vounmutecommand r1 w280 xm+20 y+5,%unmutecommand%
Gui,Add,Text,xm+20 y+5,Working Dir
Gui,Add,Edit,Vounmutecommanddir r1 w280 xm+20 y+5,%unmutecommanddir%
Gui,Add,Checkbox,Checked%unmutecommandhide% Vounmutecommandhide xm+20 y+10,Run hidden
Gui,Add,Button,GSETTINGSUNMUTEBROWSE xm+225 yp-3 w75,B&rowse

Gui,Tab,3
Gui,Add,GroupBox,w310 h80 xm+10 ym+30,Mute the speaker on &startup?
Gui,Add,Radio,%check0% Vostartmuted Group xm+20 yp+20,Start &Unmuted
Gui,Add,Radio,%check1%,Start &Muted
Gui,Add,Radio,%check2%,Use the &Previous mute state

Gui,Add,GroupBox,w310 h65 xm+10 y+20,Muting
Gui,Add,Checkbox,Checked%mutewhenidle% Vomutewhenidle xm+20 yp+20,Mute when &idle
Gui,Add,Checkbox,Checked%fademuting% Vofademuting xm+20 y+5,Fade out when muting/in when unmuting

Gui,Add,GroupBox,w310 h145 xm+10 y+20,Volume &Change (1-255)
Gui,Add,Edit,Vovolumechange w100 xm+20 yp+20
Gui,Add,UpDown,Range1-255,%volumechange%
Gui,Add,Checkbox,Checked%showvolumebar% Voshowvolumebar xm+20 y+10,Show &volumebar on volume change
Gui,Add,Text,xm+20 y+10,File to play on volume change
Gui,Add,Edit,Voplaysound r1 w280 xm+20 y+5,%playsound%
Gui,Add,Button,GSETTINGSPLAYSOUND xm+225 y+5 w75,&Browse
Gui,Add,Button,GSETTINGSLISTENSOUND xm+145 yp w75,&Play

Gui,Add,GroupBox,w310 h50 xm+10 y+20,&Mouse scrollbutton
Gui,Add,Checkbox,Checked%scroll% Voscroll xm+20 yp+20,Change volume when &scrolling over the Taskbar 

Gui,Tab,4
Gui,Add,GroupBox,w310 h110 xm+10 ym+30,&Mute Hotkey
Gui,Add,Checkbox,%shiftmute% Voshiftmute xm+20 yp+20,Shift
Gui,Add,Checkbox,%ctrlmute% Voctrlmute x+5,Ctrl
Gui,Add,Checkbox,%altmute% Voaltmute x+5,Alt
Gui,Add,Checkbox,%winmute% Vowinmute x+5,Win
Gui,Add,Checkbox,%lbuttonmute% Volbuttonmute xm+20 y+5,LButton
Gui,Add,Checkbox,%mbuttonmute% Vombuttonmute x+5,MButton
Gui,Add,Checkbox,%rbuttonmute% Vorbuttonmute x+5,RButton
Gui,Add,Edit,Uppercase Limit1 Vohotkeymute w100 xm+20 y+5
Gui,Add,Text,x+10 yp+2,or
Gui,Add,DropDownList,Vodlmute x+10 yp-2,|Space|Escape|Backspace|Delete|PrintScreen|Pause|CapsLock|Up|Down|Left|Right|PgUp|PgDown|Home|End|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|Num0|Num1|Num2|Num3|Num4|Num5|Num6|Num7|Num8|Num9|Num+|Num-|Num/|Num*|LButton|MButton|RButton|WheelDown|WheelUp
Gui,Add,Text,xm+20 y+10,Current hotkey: %hotkeymute%

Gui,Add,GroupBox,w310 h110 xm+10 y+20,Volume &Up Hotkey
Gui,Add,Checkbox,%shiftvolumeup% Voshiftvolumeup xm+20 yp+20,Shift
Gui,Add,Checkbox,%ctrlvolumeup% Voctrlvolumeup x+5,Ctrl
Gui,Add,Checkbox,%altvolumeup% Voaltvolumeup x+5,Alt
Gui,Add,Checkbox,%winvolumeup% Vowinvolumeup x+5,Win
Gui,Add,Checkbox,%lbuttonvolumeup% Volbuttonvolumeup xm+20 y+5,LButton
Gui,Add,Checkbox,%mbuttonvolumeup% Vombuttonvolumeup x+5,MButton
Gui,Add,Checkbox,%rbuttonvolumeup% Vorbuttonvolumeup x+5,RButton
Gui,Add,Edit,Uppercase Limit1 Vohotkeyvolumeup w100 xm+20 y+5
Gui,Add,Text,x+10 yp+2,or
Gui,Add,DropDownList,Vodlvolumeup x+10 yp-2,|Space|Escape|Backspace|Delete|PrintScreen|Pause|CapsLock|Up|Down|Left|Right|PgUp|PgDown|Home|End|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|Num0|Num1|Num2|Num3|Num4|Num5|Num6|Num7|Num8|Num9|Num+|Num-|Num/|Num*|LButton|MButton|RButton|WheelDown|WheelUp
Gui,Add,Text,xm+20 y+10,Current hotkey: %hotkeyvolumeup%

Gui,Add,GroupBox,w310 h110 xm+10 y+20,Volume &Down Hotkey
Gui,Add,Checkbox,%shiftvolumedown% Voshiftvolumedown xm+20 yp+20,Shift
Gui,Add,Checkbox,%ctrlvolumedown% Voctrlvolumedown x+5,Ctrl
Gui,Add,Checkbox,%altvolumedown% Voaltvolumedown x+5,Alt
Gui,Add,Checkbox,%winvolumedown% Vowinvolumedown x+5,Win
Gui,Add,Checkbox,%lbuttonvolumedown% Volbuttonvolumedown xm+20 y+5,LButton
Gui,Add,Checkbox,%mbuttonvolumedown% Vombuttonvolumedown x+5,MButton
Gui,Add,Checkbox,%rbuttonvolumedown% Vorbuttonvolumedown x+5,RButton
Gui,Add,Edit,Uppercase Limit1 Vohotkeyvolumedown w100 xm+20 y+5
Gui,Add,Text,x+10 yp+2,or
Gui,Add,DropDownList,Vodlvolumedown x+10 yp-2,|Space|Escape|Backspace|Delete|PrintScreen|Pause|CapsLock|Up|Down|Left|Right|PgUp|PgDown|Home|End|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|Num0|Num1|Num2|Num3|Num4|Num5|Num6|Num7|Num8|Num9|Num+|Num-|Num/|Num*|LButton|MButton|RButton|WheelDown|WheelUp
Gui,Add,Text,xm+20 y+10,Current hotkey: %hotkeyvolumedown%
Gui,Tab,
Gui,Add,Button,GSETTINGSOK Default xm+175 y+75 w75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Gui,Show,,%applicationname% Settings
Return


SETTINGSPLAYSOUND:
FileSelectFile,oplaysound,3,,Open a file, Sound (*.wav; *.mid; *.mp3)
If oplaysound<>
  GuiControl,,oplaysound,%oplaysound%
Return


SETTINGSLISTENSOUND:
If oplaysound<>
  SoundPlay,%oplaysound%
Return


SETTINGSMUTEBROWSE:
FileSelectFile,omutecommand,3,,Open a file, Program (*.exe; *.com; *.cmd; *.bat; *.pif; *.lnk;)
If omutecommand<>
{
  GuiControl,,omutecommand,%omutecommand%
  SplitPath,omutecommand,name,dir,ext,name_no_ext,drive
  GuiControl,,omutecommanddir,%dir%
}
Return


SETTINGSUNMUTEBROWSE:
FileSelectFile,ounmutecommand,3,,Open a file, Program (*.exe; *.com; *.cmd; *.bat; *.pif; *.lnk;)
If ounmutecommand<>
{
  GuiControl,,ounmutecommand,%ounmutecommand%
  SplitPath,ounmutecommand,name,dir,ext,name_no_ext,drive
  GuiControl,,ounmutecommanddir,%dir%
}
Return

SETTINGSLATEBROWSE:
FileSelectFile,olatecommand,3,,Open a file, Program (*.exe; *.com; *.cmd; *.bat; *.pif; *.lnk;)
If olatecommand<>
{
  GuiControl,,olatecommand,%olatecommand%
  SplitPath,olatecommand,name,dir,ext,name_no_ext,drive
  GuiControl,,olatecommanddir,%dir%
}
Return

SETTINGSOK:
Gui,Submit
idletime:=ohours*60+ominutes
latetime:=olatehours*60+olateminutes
mutewhenidle:=omutewhenidle
StringMid,mutingstart,omutingstart,9,4
StringMid,mutingend,omutingend,9,4
startmuted:=ostartmuted-1
programs:=oprograms
mutecommand:=omutecommand
mutecommanddir:=omutecommanddir
mutecommandhide:=omutecommandhide
unmutecommand:=ounmutecommand
unmutecommanddir:=ounmutecommanddir
unmutecommandhide:=ounmutecommandhide
latecommand:=olatecommand
latecommanddir:=olatecommanddir
latecommandhide:=olatecommandhide
volumechange=%ovolumechange%
showvolumebar:=oshowvolumebar
volumechange:=ovolumechange
playsound:=oplaysound
fademuting:=ofademuting
scroll:=oscroll
  
HOTKEYS:
If(ohotkeymute<>"" Or odlmute<>"")
{
  hotkeymute=~
  If olbuttonmute=1
    hotkeymute=%hotkeymute%LButton `&%A_Space%
  If ombuttonmute=1
    hotkeymute=%hotkeymute%MButton `&%A_Space%
  If orbuttonmute=1
    hotkeymute=%hotkeymute%RButton `&%A_Space%
  If oshiftmute=1
    hotkeymute=%hotkeymute%+
  If octrlmute=1
    hotkeymute=%hotkeymute%^
  If oaltmute=1
    hotkeymute=%hotkeymute%!
  If owinmute=1
    hotkeymute=%hotkeymute%#
  hotkeymute=%hotkeymute%%ohotkeymute%
  hotkeymute=%hotkeymute%%odlmute%
  Hotkey,%hotkeymute%,TOGGLEMUTE
}

If(ohotkeyvolumeup<>"" Or odlvolumeup<>"")
{
  If hotkeyvolumeup<>
    Hotkey,%hotkeyvolumeup%,Off
  hotkeyvolumeup=~
  If olbuttonvolumeup=1
    hotkeyvolumeup=%hotkeyvolumeup%LButton `&%A_Space%
  If ombuttonvolumeup=1
    hotkeyvolumeup=%hotkeyvolumeup%MButton `&%A_Space%
  If orbuttonvolumeup=1
    hotkeyvolumeup=%hotkeyvolumeup%RButton `&%A_Space%
  If oshiftvolumeup=1
    hotkeyvolumeup=%hotkeyvolumeup%+
  If octrlvolumeup=1
    hotkeyvolumeup=%hotkeyvolumeup%^
  If oaltvolumeup=1
    hotkeyvolumeup=%hotkeyvolumeup%!
  If owinvolumeup=1
    hotkeyvolumeup=%hotkeyvolumeup%#
  hotkeyvolumeup=%hotkeyvolumeup%%ohotkeyvolumeup%
  hotkeyvolumeup=%hotkeyvolumeup%%odlvolumeup%
  Hotkey,%hotkeyvolumeup%,VOLUMEUP
}

If(ohotkeyvolumedown<>"" Or odlvolumedown<>"")
{
  If hotkeyvolumedown<>
    Hotkey,%hotkeyvolumedown%,Off
  hotkeyvolumedown=~
  If olbuttonvolumedown=1
    hotkeyvolumedown=%hotkeyvolumedown%LButton `&%A_Space%
  If ombuttonvolumedown=1
    hotkeyvolumedown=%hotkeyvolumedown%MButton `&%A_Space%
  If orbuttonvolumedown=1
    hotkeyvolumedown=%hotkeyvolumedown%RButton `&%A_Space%
  If oshiftvolumedown=1
    hotkeyvolumedown=%hotkeyvolumedown%+
  If octrlvolumedown=1
    hotkeyvolumedown=%hotkeyvolumedown%^
  If oaltvolumedown=1
    hotkeyvolumedown=%hotkeyvolumedown%!
  If owinvolumedown=1
    hotkeyvolumedown=%hotkeyvolumedown%#
  hotkeyvolumedown=%hotkeyvolumedown%%ohotkeyvolumedown%
  hotkeyvolumedown=%hotkeyvolumedown%%odlvolumedown%
  Hotkey,%hotkeyvolumedown%,VOLUMEDOWN
}

IniWrite,%idletime%,%applicationname%.ini,Settings,idletime
IniWrite,%latetime%,%applicationname%.ini,Settings,latetime
IniWrite,%mutewhenidle%,%applicationname%.ini,Settings,mutewhenidle
IniWrite,%mutingstart%,%applicationname%.ini,Settings,mutingstart
IniWrite,%mutingend%,%applicationname%.ini,Settings,mutingend
IniWrite,%programs%,%applicationname%.ini,Settings,programs
IniWrite,%mutecommand%,%applicationname%.ini,Settings,mutecommand
IniWrite,%mutecommanddir%,%applicationname%.ini,Settings,mutecommanddir
IniWrite,%mutecommandhide%,%applicationname%.ini,Settings,mutecommandhide
IniWrite,%unmutecommand%,%applicationname%.ini,Settings,unmutecommand
IniWrite,%unmutecommanddir%,%applicationname%.ini,Settings,unmutecommanddir
IniWrite,%unmutecommandhide%,%applicationname%.ini,Settings,unmutecommandhide
IniWrite,%latecommand%,%applicationname%.ini,Settings,latecommand
IniWrite,%latecommanddir%,%applicationname%.ini,Settings,latecommanddir
IniWrite,%latecommandhide%,%applicationname%.ini,Settings,latecommandhide
IniWrite,%startmuted%,%applicationname%.ini,Settings,startmuted
IniWrite,%hotkeymute%,%applicationname%.ini,Settings,hotkeymute
IniWrite,%hotkeyvolumeup%,%applicationname%.ini,Settings,hotkeyvolumeup
IniWrite,%hotkeyvolumedown%,%applicationname%.ini,Settings,hotkeyvolumedown
IniWrite,%volumechange%,%applicationname%.ini,Settings,volumechange
IniWrite,%showvolumebar%,%applicationname%.ini,Settings,showvolumebar
IniWrite,%playsound%,%applicationname%.ini,Settings,playsound
IniWrite,%fademuting%,%applicationname%.ini,Settings,fademuting
IniWrite,%scroll%,%applicationname%.ini,Settings,scroll
idletime*=60000
latetime*=60000
Gosub,SETTINGSCANCEL
Return


SETTINGSCANCEL:
If hotkeymute<>
  Hotkey,%hotkeymute%,On
If hotkeyvolumeup<>
  Hotkey,%hotkeyvolumeup%,On
If hotkeyvolumedown<>
  Hotkey,%hotkeyvolumedown%,On
If scroll=1
{
  Hotkey,~WheelDown,WHEELDOWN,On
  Hotkey,~WheelUp,WHEELUP,On
}
Gui,Destroy
SetTimer,IDLE,On
Return


VOLUMEUP:
If showvolumebar=1
  Gosub,VOLUMEBAR
SoundSet,+%volumechange%
If playsound<>
  SoundPlay,%playsound% 
Return


VOLUMEDOWN:
If showvolumebar=1
  Gosub,VOLUMEBAR
SoundSet,-%volumechange%
If playsound<>
  SoundPlay,%playsound% 
Return


MUTECOMMAND:
omutecommandhide=
If mutecommandhide=1
  omutecommandhide=Hide
If mutecommand<>
  Run,%mutecommand%,%mutecommanddir%,%mutecommandhide% UseErrorLevel
If latetime>0
  SetTimer,LATECOMMAND,%latetime%
Return


UNMUTECOMMAND:
ounmutecommandhide=
If unmutecommandhide=1
  ounmutecommandhide=Hide
If unmutecommand<>
  Run,%unmutecommand%,%unmutecommanddir%,%unmutecommandhide% UseErrorLevel
SetTimer,LATECOMMAND,Off
Return


LATECOMMAND:
SetTimer,LATECOMMAND,Off
Run,%latecommand%,,UseErrorLevel
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v2.2
Gui,99:Font
Gui,99:Add,Text,y+10,Mutes the speaker after a period of inactivity.
Gui,99:Add,Text,y+10,- Change the settings by choosing Settings in the Tray menu.
Gui,99:Add,Text,y+10,- Vista: In the properties dialog for the file, 
Gui,99:Add,Text,y+5,change the compatibility setting to "Windows XP"

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
