#SingleInstance,Force
#Persistent
CoordMode,Mouse,Screen
DetectHiddenWindows,On

StringTrimRight,applicationname,A_ScriptName,4
OnExit,EXIT

enabled=1
active=1
maxed=1
WinShow,ahk_class Shell_TrayWnd
WinGet,origtrans,Transparent,ahk_class Shell_TrayWnd
If (origtrans="Off" Or origtrans="")
  origtrans=255
WinSet,Transparent,255,ahk_class Shell_TrayWnd
Gosub,READINI
Gosub,TRAYMENU

START:
If notransmax=1
  SetTimer,NOTRANSMAX,1000,On
Else
  SetTimer,NOTRANSMAX,Off
SetTimer,MOUSEPOS,200,On
Gosub,UPDATE
Return


MOUSEPOS:
MouseGetPos,mx,my
If (notransmax=1 And maxed=1)
  Return
If active=0
{
  If (mx>=activatex And mx<=activatex+activatew And my>=activatey And my<=activatey+activateh)
    Gosub,SHOWTASKBAR
}
Else
  If (mx<tx Or mx>tx+tw Or my<ty Or my>ty+th)
    Gosub,HIDETASKBAR
Return


UPDATE:
WinGetPos,tx,ty,tw,th,ahk_class Shell_TrayWnd
activatex:=REPLACE(rectx)
activatey:=REPLACE(recty)
activatew:=REPLACE(rectw)
activateh:=REPLACE(recth)
Return

REPLACE(activate)
{
  Local local
  StringReplace,activate,activate,TaskbarX,%tx%,All
  StringReplace,activate,activate,TaskbarY,%ty%,All
  StringReplace,activate,activate,TaskbarW,%tw%,All
  StringReplace,activate,activate,TaskbarH,%th%,All
  StringReplace,activate,activate,ScreenWidth,%A_ScreenWidth%,All
  StringReplace,activate,activate,ScreenHeight,%A_ScreenHeight%,All
  StringSplit,number_,activate,+-*/
  StringSplit,operator_,activate,,0123456789
  sum:=activate
  Loop,% operator_0
  {
    current:=A_Index
    next:=A_Index+1
    If (operator_%A_Index%="+")
      number_%next%:=number_%current%+number_%next%
    If (operator_%A_Index%="-")
      number_%next%:=number_%current%-number_%next%
    If (operator_%A_Index%="*")
      number_%next%:=number_%current%*number_%next%
    If (operator_%A_Index%="/")
      number_%next%:=number_%current%/number_%next%
    sum:=number_%next%
  }
  Return,sum
}


SHOWTASKBAR:
If hidewheninactive=1
  WinShow,ahk_class Shell_TrayWnd
If fadein<>0
{
  WinGet,trans,Transparent,ahk_class Shell_TrayWnd
  If (trans="Off" Or trans="")
    trans=255
  loop=0
  If fadein>0
    loop:=Abs(insidetrans-trans)/fadein
  Loop,%loop%
  {
    trans+=%fadein%
    WinSet,Transparent,%trans%,ahk_class Shell_TrayWnd
  }
}
WinSet,Transparent,%insidetrans%,ahk_class Shell_TrayWnd
active=1
Return


HIDETASKBAR:
Gosub,UPDATE
If fadeout>0
{
  WinGet,trans,Transparent,ahk_class Shell_TrayWnd
  If (trans="Off" Or trans="")
    trans=255
  loop=0
  If fadeout>0
    loop:=Abs(outsidetrans-trans)/fadeout
  Loop,%loop%
  {
    trans-=%fadeout%
    WinSet,Transparent,%trans%,ahk_class Shell_TrayWnd
  }
}
WinSet,Transparent,%outsidetrans%,ahk_class Shell_TrayWnd
If hidewheninactive=1
  WinHide,ahk_class Shell_TrayWnd
active=0
Return


NOTRANSMAX:
oldmaxed=%maxed%
maxed=0
SysGet,work,MonitorWorkArea 
WinGet,ids,List,,,Program Manager
Loop,%ids% 
{
  StringTrimRight,id,ids%A_Index%,0
  WinGetPos,wx,wy,ww,wh,ahk_id %id%
  If (wx<=workLeft And wy<=workTop And wx+ww>=workRight And wy+wh>=workBottom)
  {
    If oldmaxed=0
    {
      If hidewheninactive=1
        WinShow,ahk_class Shell_TrayWnd
      If fadein>0
      {
        WinGet,trans,Transparent,ahk_class Shell_TrayWnd
        If (trans="Off" Or trans="")
          trans=255
        loop=0
        If fadein>0
          loop:=Abs(notransmaxtrans-trans)/fadein
        Loop,%loop%
        {
          trans+=%fadein%
          WinSet,Transparent,%trans%,ahk_class Shell_TrayWnd
        }
      }
      WinSet,Transparent,%notransmaxtrans%,ahk_class Shell_TrayWnd
    }
    active=1
    maxed=1
    Break
  }
}
If maxed=0 And oldmaxed=1
{
  active=1
  maxed=1
}
Return


READINI:
IfNotExist,%applicationname%.ini
{
  fadein=2
  fadeout=1
  insidetrans=200
  outsidetrans=100
  notransmax=1
  notransmaxtrans=255
  hidewheninactive=1
  rectx=TaskbarX
  recty=TaskbarY
  rectw=TaskbarW
  recth=TaskbarH
  Gosub,INIWRITE
  Gosub,ABOUT
}
IniRead,fadein,%applicationname%.ini,Settings,fadein
IniRead,fadeout,%applicationname%.ini,Settings,fadeout
IniRead,insidetrans,%applicationname%.ini,Settings,insidetrans
IniRead,outsidetrans,%applicationname%.ini,Settings,outsidetrans
IniRead,notransmax,%applicationname%.ini,Settings,notransmax
IniRead,notransmaxtrans,%applicationname%.ini,Settings,notransmaxtrans
IniRead,hidewheninactive,%applicationname%.ini,Settings,hidewheninactive
IniRead,rectx,%applicationname%.ini,Settings,rectx
IniRead,recty,%applicationname%.ini,Settings,recty
IniRead,rectw,%applicationname%.ini,Settings,rectw
IniRead,recth,%applicationname%.ini,Settings,recth
Return


INIWRITE:
IniWrite,%fadein%,%applicationname%.ini,Settings,fadein
IniWrite,%fadeout%,%applicationname%.ini,Settings,fadeout
IniWrite,%insidetrans%,%applicationname%.ini,Settings,insidetrans
IniWrite,%outsidetrans%,%applicationname%.ini,Settings,outsidetrans
IniWrite,%notransmax%,%applicationname%.ini,Settings,notransmax
IniWrite,%notransmaxtrans%,%applicationname%.ini,Settings,notransmaxtrans
IniWrite,%hidewheninactive%,%applicationname%.ini,Settings,hidewheninactive
IniWrite,%rectx%,%applicationname%.ini,Settings,rectx
IniWrite,%recty%,%applicationname%.ini,Settings,recty
IniWrite,%rectw%,%applicationname%.ini,Settings,rectw
IniWrite,%recth%,%applicationname%.ini,Settings,recth
Return


TRAYMENU:
Menu,Tray,Click,1 
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,DOUBLECLICK
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,TOGGLE
Menu,Tray,Add,Taskbar &Properties...,PROPERTIES
Menu,Tray,Add,Se&ttings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Menu,Tray,Check,&Enabled
Return


SINGLECLICK:
SetTimer,SINGLECLICK,Off 
clicks=
Gosub,TOGGLE
Return 


DOUBLECLICK: 
SetTimer,NOTRANSMAX,Off
SetTimer,MOUSEPOS,Off
If clicks= 
{ 
  SetTimer,SINGLECLICK,500
  clicks=1 
  Return 
} 
SetTimer,SINGLECLICK,Off 
clicks= 
Gosub,SETTINGS
Return


TOGGLE:
If enabled=1
{
  enabled=0
  Menu,Tray,UnCheck,&Enabled
  IfExist,%applicationname%.exe
    Menu,Tray,Icon,%applicationname%.exe,4,1
  WinSet,Transparent,%origtrans%,ahk_class Shell_TrayWnd
  If notransmax=1
    SetTimer,NOTRANSMAX,Off
  SetTimer,MOUSEPOS,Off
}
Else
{
  enabled=1
  Menu,Tray,Check,&Enabled
  IfExist,%applicationname%.exe
    Menu,Tray,Icon,%applicationname%.exe,1,1
  Gosub,START
}
Return


PROPERTIES:
Run,rundll32 shell32.dll`,Options_RunDLL 1
Return


SETTINGS:
Gui,Destroy
Gui,Add,Tab,W330 H310 xm,Transparency|Activation
Gui,Tab,1
Gui,Add,GroupBox,w310 h70 xm+10 yp+30,Taskbar &Transparency  (0=Invisible 255=Solid)
Gui,Add,Text,xm+20 yp+20,When mouse Inside
Gui,Add,Text,xm+150 yp,When mouse Outside
Gui,Add,Edit,Voinsidetrans w100 xm+20 y+5
Gui,Add,UpDown,Range0-255,%insidetrans%
Gui,Add,Edit,Vooutsidetrans w100 xm+150 yp
Gui,Add,UpDown,Range0-255,%outsidetrans%

Gui,Add,GroupBox,w310 h70 xm+10 y+20,Fade &Speed  (0=Disabled 1=Slow 10=Fast)
Gui,Add,Text,xm+20 yp+20,Fade &In
Gui,Add,Text,xm+150 yp,Fade &Out
Gui,Add,Edit,Vofadein w100 xm+20 y+5
Gui,Add,UpDown,Range0-10,%fadein%
Gui,Add,Edit,Vofadeout w100 xm+150 yp
Gui,Add,UpDown,Range0-10,%fadeout%

Gui,Add,GroupBox,w310 h70 xm+10 y+20,Taskbar transparency when &maximized windows exist
Gui,Add,Text,xm+150 yp+20,Transparency
Gui,Add,Edit,Vonotransmaxtrans w100 xm+150 y+5
Gui,Add,UpDown,Range0-255,%notransmaxtrans%
Gui,Add,Checkbox,Checked%notransmax% Vonotransmax xm+20 yp+3,Change transparency

Gui,Tab,
Gui,Add,Button,GSETTINGSOK Default xm+10 y+30 w75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel

Gui,Tab,2
Gui,Add,GroupBox,w310 h70 xm+10 ym+30,Hide when inactive
Gui,Add,Checkbox,Checked%hidewheninactive% Vohidewheninactive xm+20 yp+20,Hide when &inactive
Gui,Add,Text,xm+20 y+5,* Remember to change Automatic hiding 
Gui,Add,Text,xm+20 y+0,in the Taskbar Properties.

Gui,Add,GroupBox,w310 h145 xm+10 yp+30,&Activation rectangle
Gui,Add,Text,xm+25 yp+20,X
Gui,Add,Text,xm+155 yp,Y
Gui,Add,Edit,Vorectx w100 xm+20 y+0,%rectx%
Gui,Add,Edit,Vorecty w100 xm+150 yp,%recty%
Gui,Add,Text,xm+25 y+5,Width
Gui,Add,Text,xm+155 yp,Height
Gui,Add,Edit,Vorectw w100 xm+20 y+0,%rectw%
Gui,Add,Edit,Vorecth w100 xm+150 yp,%recth%
Gui,Add,Text,xm+20 y+5,* Use screen coordinates or the strings TaskbarX, TaskbarY,
Gui,Add,Text,xm+20 y+0,TaskbarW, TaskbarH, ScreenWidth and ScreenHeight.
Gui,Add,Text,xm+20 y+0,You can also use simple expressions like ScreenWidth-1.


Gui,Show,,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
fadein:=ofadein
fadeout:=ofadeout
insidetrans:=oinsidetrans
outsidetrans:=ooutsidetrans
notransmax:=onotransmax
notransmaxtrans:=onotransmaxtrans
hidewheninactive:=ohidewheninactive
rectx:=orectx
recty:=orecty
rectw:=orectw
recth:=orecth
Gosub,INIWRITE
Gosub,SETTINGSCANCEL
Return


SETTINGSCANCEL:
Gui,Destroy
Gosub,START
Return


EXIT:
WinShow,ahk_class Shell_TrayWnd
If origtrans=255
  origtrans=Off
WinSet,Transparent,%origtrans%,ahk_class Shell_TrayWnd
WinSet,Redraw,,ahk_class Shell_TrayWnd
ExitApp


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.4
Gui,99:Font
Gui,99:Add,Text,y+10,Changes the transparency of the taskbar.
Gui,99:Add,Text,y+10,- Change transparency on mouseover and mouseout.
Gui,99:Add,Text,y+10,- Fade in, fade out, make solid when windows are maximized.
Gui,99:Add,Text,y+10,- Completely hide when inactive.
Gui,99:Add,Text,y+10,- Change the settings by choosing Settings in the Tray menu.

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
  If ctrl in Static11,Static15,Static19
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return

