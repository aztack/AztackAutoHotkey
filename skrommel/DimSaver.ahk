;DimSaver.ahk
; Screensaver that dims the screen.
;Skrommel @2006

#SingleInstance,Force
#Persistent
#NoTrayIcon 
#InstallKeybdHook 
#NoEnv
SetBatchLines,-1
SetWinDelay,0
CoordMode,Mouse,Screen

applicationname=DimSaver

SysGet,dragx,68 ;SM_CXDRAG 
SysGet,dragy,69 ;SM_CYDRAG 

SysGet,monitorcount,MonitorCount
l=0
t=0
r=0
b=0
Loop,%monitorcount%
{
  SysGet,monitor,Monitor,%A_Index%
  If (monitorLeft<l)
    l:=monitorLeft
  If (monitorTop<t)
    t:=monitorTop
  If (monitorRight>r)
    r:=monitorRight
  If (monitorBottom>b)
    b:=monitorBottom
}
r:=r+Abs(l)
b:=b+Abs(t)

firstmove=0

Gosub,READINI

StringLeft,param,1,2
If (param="" Or param="/c") 
  Goto,OPTIONS
If (param="/p")
  ExitApp


RUN:
MouseGetPos,x1,y1
WinGet,id0,ID,A
DllCall("ShowCursor","Int",0)

Gui,+ToolWindow -Caption +Border
Gui,Show,x0 y0 w0 h0,DimSaverGUI
WinSet,Transparent,0,DimSaverGUI
Gui,Add,Picture,x0 y0,%image%
Gui,Show,AutoSize
WinGetPos,px,py,pw,ph,DimSaverGUI
Gui,Destroy

Gosub,GUI

If keys=0
  WinActivate,ahk_id %id0%

;If moves=1
;  OnMessage(0x200,"WM_MOUSEMOVE")
If keys=1
  OnMessage(0x100,"WM_KEYDOWN")
If clicks=1
{
  OnMessage(0x201,"WM_LBUTTONDOWN")
  OnMessage(0x204,"WM_RBUTTONDOWN")
  OnMessage(0x207,"WM_MBUTTONDOWN")
}

now=%A_Hour%%A_Min%
step:=nighttrans/steps
If (now>day And now<night)
  step:=daytrans/steps
transparency:=0
Loop,%steps%
{
  transparency+=%step%
  Sleep,%delay%
  WinSet,Transparent,%transparency%,ahk_id %id1%
  If moves=1
    WM_MOUSEMOVE(0,0)
}
IfNotExist,%saver%
  Return
SetTimer,NEXT,% (hours*3600+minutes*60+seconds)*1000
If moves=1
  Loop
  {
    Sleep,100
    WM_MOUSEMOVE(0,0)
  }
Return


NEXT:
SetTimer,NEXT,Off
RunWait,%saver% /s


EXIT:
SetTimer,NEXT,Off
;OnMessage(0x200,"")
OnMessage(0x100,"")
OnMessage(0x201,"")
OnMessage(0x204,"")
OnMessage(0x207,"")
DllCall("ShowCursor","Int",1)

step:=transparency/lightensteps
Loop,%lightensteps%
{
  transparency-=%step%
  Sleep,%lightendelay%
  WinSet,Transparent,%transparency%,ahk_id %id1%
}
Gui,Destroy
ExitApp


GuiClose:
GUI:
Gui,+ToolWindow -Caption +Border +AlwaysOnTop
Gui,Margin,0,0
Gui,Color,%color%
Gui,Show,x0 y0 w0 h0,DimSaverGUI
WinGet,id1,ID,DimSaverGUI
WinSet,Transparent,0,ahk_id %id1%
WinMove,ahk_id %id1%,,%l%,%t%,%r%,%b%

If keepaspect=1
{
  If (pw/A_ScreenWidth>ph/A_ScreenHeight)
  {
    w:=A_ScreenWidth
    h:=ph*w/pw
    x:=0
    y:=(A_ScreenHeight-h)/2
  }
  Else
  {
    h:=A_ScreenHeight
    w:=pw*h/ph
    x:=(A_ScreenWidth-w)/2
    y:=0
  }
}
Else
{
  x:=0
  y:=0
  w:=A_ScreenWidth
  h:=A_ScreenHeight
}
IfExist,%image%
  Gui,Add,Picture,x%x% y%y% w%w% h%h%,%image%
Gui,Show
WinSet,Transparent,%transparency%,ahk_id %id1%
Return


WM_MOUSEMOVE(wParam,lParam)
{
  Global dragx
  Global dragy
  Global x1
  Global y1
  Global firstmove
  Global firsttime
  Global activity

  MouseGetPos,x2,y2
  If (x2<x1-dragx Or x2>x1+dragx Or y2<y1-dragy Or y2>y1+dragy)
  {
    If firstmove=0
    {
      DllCall("ShowCursor","Int",1)
      firsttime:=A_TickCount
      firstmove:=1
    }
    Else
      If (A_TickCount-firsttime>activity)
        Gosub,EXIT
    x1:=x2
    y1:=y2
  }
  Else
  If firstmove=1
  {
    DllCall("ShowCursor","Int",0)
    firstmove:=0
  }
  Return
}
WM_LBUTTONDOWN(wParam,lParam)
{
  Gosub,EXIT
  Return
}
WM_MBUTTONDOWN(wParam,lParam)
{
  Gosub,EXIT
  Return
}
WM_RBUTTONDOWN(wParam,lParam)
{
  Gosub,EXIT
  Return
}
WM_KEYDOWN(wParam,lParam)
{
  Gosub,EXIT
  Return
}





OPTIONS:
oday=%A_YYYY%%A_MM%%A_DD%%day%00
onight=%A_YYYY%%A_MM%%A_DD%%night%00
ohours:=hours
ominutes:=minutes
oseconds:=seconds

Gui,Destroy
Gui,Add,Tab,W330 H420 xm,Options|Actions|Image|ScreenSavers|About

Gui,Tab,1
Gui,Add,GroupBox,w310 h80 xm+10 y+10,&Day
Gui,Add,DateTime,Voday Choose%oday% 1 w100 xm+20 yp+20,HH:mm
Gui,Add,Text,x+20 yp+3,Start of day
Gui,Add,Edit,Vodaytrans w100 xm+20 y+10
Gui,Add,UpDown,Range0-255,%daytrans%
Gui,Add,Text,x+20 yp+3,Darkness  (0-255  255=black)

Gui,Add,GroupBox,w310 h80 xm+10 y+20,&Night
Gui,Add,DateTime,Vonight Choose%onight% 1 w100 xm+20 yp+20,HH:mm
Gui,Add,Text,x+20 yp+3,Start of night
Gui,Add,Edit,Vonighttrans w100 xm+20 y+10
Gui,Add,UpDown,Range0-255,%nighttrans%
Gui,Add,Text,x+20 yp+3,Darkness  (0-255  255=black)

Gui,Add,GroupBox,w310 h75 xm+10 y+20,Darken &Speed
Gui,Add,Edit,Vosteps w100 xm+20 yp+20
Gui,Add,UpDown,Range1-255,%steps%
Gui,Add,Text,x+20 yp+3,Steps`t(1-255  1=fastest)
Gui,Add,Edit,Vodelay w100 xm+20 yp+20
Gui,Add,UpDown,Range0-1000,%delay%
Gui,Add,Text,x+20 yp+3,Delay`t(0-1000  0=fastest)

Gui,Add,GroupBox,w310 h75 xm+10 y+20,&Lighten Speed
Gui,Add,Edit,Volightensteps w100 xm+20 yp+20
Gui,Add,UpDown,Range1-255,%lightensteps%
Gui,Add,Text,x+20 yp+3,Steps`t(1-255  1=fastest)
Gui,Add,Edit,Volightendelay w100 xm+20 yp+20
Gui,Add,UpDown,Range0-1000,%lightendelay%
Gui,Add,Text,x+20 yp+3,Delay`t(0-1000  0=fastest)

Gui,Tab,2
Gui,Add,GroupBox,w310 h80 xm+10 y+10,&Actions that quit %applicationname%
Gui,Add,CheckBox,xm+20 yp+20 Checked%moves% vomoves,Mouse &Moves
Gui,Add,CheckBox,xm+20 y+5 Checked%clicks% voclicks,Mouse &Clicks
Gui,Add,CheckBox,xm+20 y+5 Checked%keys% vokeys,&Keys

Gui,Add,GroupBox,w310 h50 xm+10 y+20,&How long to ignore mouse movement before quitting
Gui,Add,Edit,Voactivity w100 xm+20 yp+20
Gui,Add,UpDown,Range0-9999,% activity
Gui,Add,Text,x+20 yp+3,ms`t(0-9999  0=shortest)

Gui,Tab,3
Gui,Add,GroupBox,w310 h80 xm+10 y+10,&Image to show when dimming
Gui,Add,Edit,Voimage w50 xm+20 yp+20 w290,%image%
Gui,Add,Button,xm+235 y+5 w75 Vobrowse GBROWSE,Browse
Gui,Add,GroupBox,w310 h50 xm+10 y+20,Image stretch
;Gui,Add,CheckBox,xm+20 yp+20 Checked%stretch% vostretch,&Stretch image
;Gui,Add,CheckBox,xm+20 yp+20 Checked%center% vocenter,&Center image
Gui,Add,CheckBox,xm+20 yp+20 Checked%keepaspect% vokeepaspect,&Keep aspect ratio
Gui,Add,GroupBox,w310 h50 xm+10 y+25,&Background color
Gui,Add,Edit,Vocolor w100 xm+20 yp+20,%color%
Gui,Add,Text,x+20 yp+3,RRGGBB

Gui,Tab,4
Gui,Add,GroupBox,w310 h260 xm+10 y+10,&ScreenSaver to run
Gui,Add,ListView,xm+20 yp+20 r12 w280 Checked AutoHdr,Ignore|ScreenSaver|Path
Loop,%A_WinDir%\*.scr
{
  If A_LoopFileName=%applicationname%.scr
    Continue
  If saver=%A_LoopFileDir%\%A_LoopFileName%
    LV_Add("Check","",A_LoopFileName,A_LoopFileDir)
  Else
    LV_Add("","",A_LoopFileName,A_LoopFileDir)
}
Loop,%A_WinDir%\System32\*.scr
{
  If saver=%A_LoopFileDir%\%A_LoopFileName%
    LV_Add("Check","",A_LoopFileName,A_LoopFileDir)
  Else
    LV_Add("","",A_LoopFileName,A_LoopFileDir)
}
LV_ModifyCol(2,"Sort")
LV_ModifyCol(2)
LV_ModifyCol(3)

Gui,Add,GroupBox,w310 h50 xm+10 y+30,&Time to wait before running selected ScreenSaver
Gui,Add,Edit,Vohours w50 xm+20 yp+20
Gui,Add,UpDown,Range0-23,%hours%
Gui,Add,Edit,Vominutes w50 x+0 yp
Gui,Add,UpDown,Range0-59,%minutes%
Gui,Add,Edit,Voseconds w50 x+0 yp
Gui,Add,UpDown,Range0-59,%seconds%
Gui,Add,Text,x+20 yp+3,Time to wait  (HH:MM:SS)

Gui,Tab,5
Gui,Add,Picture,xm+20 y+10 Icon1,%A_ScriptDir%\%applicationname%.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v2.2
Gui,Font
Gui,Add,Text,xm+20 yp+30,Screensaver that dims the screen.
Gui,Add,Text,,- Night- and daytime darkness levels
Gui,Add,Text,y+0,- Separate darken and lighten speeds
Gui,Add,Text,y+0,- Wakeup using mouse or keyboard
Gui,Add,Text,y+0,- Start another screensaver

Gui,Add,Text,,`t
Gui,Add,Picture,xm+20 yp+10 Icon2,%A_ScriptDir%\%applicationname%.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,xm+20 yp+30,For more tools and information, please stop by at
Gui,Font,CBlue Underline
Gui,Add,Text,GWWW,http://www.donationcoders.com/skrommel
Gui,Font

Gui,Add,Text,,`t
Gui,Add,Picture,xm+20 yp+10 Icon6,%A_ScriptDir%\%applicationname%.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,AutoHotkey
Gui,Font
Gui,Add,Text,xm+20 yp+30,This tool is made using AutoHotkey
Gui,Font,CBlue Underline
Gui,Add,Text,GWWW,http://www.autohotkey.com
Gui,Font
Gui,Add,Text,,`t
Gui,Show,NoActivate,%applicationname% Settings

Gui,Tab,
Gui,Add,Button,GSETTINGSOK Default xm+10 y+0 w75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Return

BROWSE:
FileSelectFile,file
GuiControl,,oimage,%file%
Return


SETTINGSOK:
row=0
row:=LV_GetNext(row,"Checked")
If row=0
  saver=
Else
{
  LV_GetText(scr,row,2)
  LV_GetText(scrpath,row,3)
  saver=%scrpath%\%scr%
}
Gui,Submit

moves:=omoves
clicks:=oclicks
keys:=okeys
activity:=oactivity
If (odaytrans>=0 And odaytrans<=255)
  daytrans:=odaytrans
If (onighttrans>=0 And onighttrans<=255)
  nighttrans:=onighttrans
If odelay>=0
  delay:=odelay
If osteps>=1
  steps:=osteps
If olightendelay>=0
  lightendelay:=olightendelay
If olightensteps>=1
  lightensteps:=olightensteps
StringMid,day,oday,9,4
StringMid,night,onight,9,4
If (ohours>=0 And ohours<=24)
  hours:=ohours
If (ominutes>=0 And ominutes<=59)
  minutes:=ominutes
If (oseconds>=0 And oseconds<=59)
  seconds:=oseconds
If omovetox<>
  movetox:=omovetox
If omovetoy<>
  movetoy:=omovetoy
image:=oimage
stretch:=ostretch
shrink:=oshrink
center:=ocenter
keepaspect:=okeepaspect
If (StrLen(ocolor)=6)
  color:=ocolor
Gosub,WRITEINI
Gosub,SETTINGSCANCEL
Return


SETTINGSCANCEL:
Gui,Destroy
EXITAPP


AUTOHOTKEY:
Run,http://www.autohotkey.com,,UseErrorLevel
Return


WWW:
Run,http://www.donationcoders.com/skrommel,,UseErrorLevel
Return


READINI:
IfNotExist,%A_ScriptDir%\%applicationname%.ini
{
  daytrans=125
  nighttrans=200
  day=0700
  night=2200
  hours:=0
  minutes:=1
  seconds:=0
  delay:=0
  steps:=255
  lightendelay:=0
  lightensteps:=25
  moves:=1
  clicks:=1
  keys:=1
  activity:=999
  saver=%A_WinDir%\System32\logon.scr
  movetox:=A_ScreenWidth
  movetoy:=A_ScreenHeight
  image:=
  stretch:=1
  shrink:=1
  center:=1
  keepaspect:=1
  color=000000
  Gosub,WRITEINI
}
Else
{
  IniRead,daytrans,%A_ScriptDir%\%applicationname%.ini,Settings,daytrans
  IniRead,nighttrans,%A_ScriptDir%\%applicationname%.ini,Settings,nighttrans
  IniRead,day,%A_ScriptDir%\%applicationname%.ini,Settings,day
  IniRead,night,%A_ScriptDir%\%applicationname%.ini,Settings,night
  IniRead,hours,%A_ScriptDir%\%applicationname%.ini,Settings,hours
  IniRead,minutes,%A_ScriptDir%\%applicationname%.ini,Settings,minutes
  IniRead,seconds,%A_ScriptDir%\%applicationname%.ini,Settings,seconds
  IniRead,steps,%A_ScriptDir%\%applicationname%.ini,Settings,steps
  IniRead,delay,%A_ScriptDir%\%applicationname%.ini,Settings,delay
  IniRead,lightensteps,%A_ScriptDir%\%applicationname%.ini,Settings,lightensteps
  IniRead,lightendelay,%A_ScriptDir%\%applicationname%.ini,Settings,lightendelay
  IniRead,moves,%A_ScriptDir%\%applicationname%.ini,Settings,moves
  IniRead,clicks,%A_ScriptDir%\%applicationname%.ini,Settings,clicks
  IniRead,keys,%A_ScriptDir%\%applicationname%.ini,Settings,keys
  IniRead,activity,%A_ScriptDir%\%applicationname%.ini,Settings,activity
  IniRead,saver,%A_ScriptDir%\%applicationname%.ini,Settings,saver
  IniRead,movetox,%A_ScriptDir%\%applicationname%.ini,Settings,movetox
  IniRead,movetoy,%A_ScriptDir%\%applicationname%.ini,Settings,movetoy
  IniRead,image,%A_ScriptDir%\%applicationname%.ini,Settings,image
  IniRead,stretch,%A_ScriptDir%\%applicationname%.ini,Settings,stretch
  IniRead,shrink,%A_ScriptDir%\%applicationname%.ini,Settings,shrink
  IniRead,center,%A_ScriptDir%\%applicationname%.ini,Settings,center
  IniRead,keepaspect,%A_ScriptDir%\%applicationname%.ini,Settings,keepaspect
  IniRead,color,%A_ScriptDir%\%applicationname%.ini,Settings,color
}
Return


WRITEINI:
Iniwrite,%daytrans%,%A_ScriptDir%\%applicationname%.ini,Settings,daytrans
Iniwrite,%nighttrans%,%A_ScriptDir%\%applicationname%.ini,Settings,nighttrans
Iniwrite,%day%,%A_ScriptDir%\%applicationname%.ini,Settings,day
Iniwrite,%night%,%A_ScriptDir%\%applicationname%.ini,Settings,night
IniWrite,%hours%,%A_ScriptDir%\%applicationname%.ini,Settings,hours
IniWrite,%minutes%,%A_ScriptDir%\%applicationname%.ini,Settings,minutes
IniWrite,%seconds%,%A_ScriptDir%\%applicationname%.ini,Settings,seconds
IniWrite,%steps%,%A_ScriptDir%\%applicationname%.ini,Settings,steps
IniWrite,%delay%,%A_ScriptDir%\%applicationname%.ini,Settings,delay
IniWrite,%lightensteps%,%A_ScriptDir%\%applicationname%.ini,Settings,lightensteps
IniWrite,%lightendelay%,%A_ScriptDir%\%applicationname%.ini,Settings,lightendelay
IniWrite,%moves%,%A_ScriptDir%\%applicationname%.ini,Settings,moves
IniWrite,%clicks%,%A_ScriptDir%\%applicationname%.ini,Settings,clicks
IniWrite,%keys%,%A_ScriptDir%\%applicationname%.ini,Settings,keys
IniWrite,%activity%,%A_ScriptDir%\%applicationname%.ini,Settings,activity
Iniwrite,%saver%,%A_ScriptDir%\%applicationname%.ini,Settings,saver
Iniwrite,%movetox%,%A_ScriptDir%\%applicationname%.ini,Settings,movetox
Iniwrite,%movetoy%,%A_ScriptDir%\%applicationname%.ini,Settings,movetoy
Iniwrite,%image%,%A_ScriptDir%\%applicationname%.ini,Settings,image
Iniwrite,%stretch%,%A_ScriptDir%\%applicationname%.ini,Settings,stretch
Iniwrite,%shrink%,%A_ScriptDir%\%applicationname%.ini,Settings,shrink
Iniwrite,%center%,%A_ScriptDir%\%applicationname%.ini,Settings,center
Iniwrite,%keepaspect%,%A_ScriptDir%\%applicationname%.ini,Settings,keepaspect
Iniwrite,%color%,%A_ScriptDir%\%applicationname%.ini,Settings,color
Return