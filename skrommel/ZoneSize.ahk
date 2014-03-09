;ZoneSize.ahk
; Define zones that autosize windows dropped on them
;Skrommel @2006

FileInstall,pop.wav,pop.wav

#SingleInstance,Force
CoordMode,Mouse,Screen
CoordMode,Pixel,Screen
SetWinDelay,0
SetTitleMatchMode,2

applicationname=ZoneSize

OnMessage(0x001a,"WM_SETTINGCHANGE")

Gosub,INIREAD
Gosub,TRAYMENU
Gosub,CREATE

showing=0
moving=0
counter=0

Loop
{
  Sleep,100

  GetKeyState,lbutton,LButton,P
  If (lbutton="U")
    MouseGetPos,,,mwinid
  MouseGetPos,mx,my
  oldwx:=wx
  oldwy:=wy
  oldww:=ww
  oldwh:=wh
  WinGetPos,wx,wy,ww,wh,ahk_id %mwinid%
  WinGetClass,mclass,ahk_id %mwinid%
  WinGetTitle,mtitle,ahk_id %mwinid%
  oldawinid:=awinid
  WinGet,awinid,Id,A
  WinGetClass,aclass,ahk_id %awinid%
  If (aclass="Shell_TrayWnd" Or aclass="Progman" Or awinid=guiid)
    awinid:=oldawinid

  If (lbutton="D")
  If mclass Not In %ignoreclass%
  If mtitle Not Contains %ignoretitle%
  If (ignoreempty=0 Or mtitle<>"")
  If (mx>=wx And mx<wx+ww And my>=wy And my<wy+caption)
  {
    If (showzones=1 And (wx<oldwx-dragx Or wx>oldwx+dragx Or wy<oldwy-dragx Or wy>oldwy+dragx))
    {
      WinMove,ahk_id %guiid%,,0,0,%workareaRight%,%workareaBottom%
      showing=1
    }
    If (showzones=0 Or showing=1)
    If (wx<oldwx+dragx And wx>oldwx-dragx And wy<oldwy+dragy And wy>oldwy-dragy)
    {
      counter+=1
      If (counter>delay)
      {
        Loop,%zonecount%
        {
          zonel:=zone%A_Index%_1
          zonet:=zone%A_Index%_2
          zoner:=zone%A_Index%_3
          zoneb:=zone%A_Index%_4
          If (mx>zonel And mx<zoner And my>zonet And my<zoneb)
          {
            SoundPlay,pop.wav
            WinMove,ahk_id %mwinid%,,% zonel,% zonet,% zoner-zonel,% zoneb-zonet
            moving=1
            Break
          }
        }
        counter=0
      }
    }
  }

  If (lbutton="U")
  {
    counter=0
    If (moving=1)
    If (mx>zonel And mx<zoner And my>zonet And my<zoneb)
    {
      moving=0
      WinMove,ahk_id %mwinid%,,% zonel,% zonet,% zoner-zonel,% zoneb-zonet
    }

    If (showzones=0 Or showing=1)
    {
      WinMove,ahk_id %guiid%,,-1,-1,1,1
      showing=0
    }
  }
}
Return


WM_SETTINGCHANGE(wParam,lParam)
{
  Gosub,CREATE
  Return
}


CENTER:
SoundPlay,pop.wav
WinGetPos,ax,ay,aw,ah,ahk_id %awinid%
WinMove,ahk_id %awinid%,,% workareaRight/2-aw/2,% workareaBottom/2-ah/2
Return


CREATE:
SysGet,workarea,MonitorWorkArea
SysGet,caption,4 ;SM_CYCAPTION
SysGet,dragx,68 ;SM_CXDRAG
SysGet,dragy,69 ;SM_CYDRAG
dragx/=2
dragy/=2

Gui,9:Destroy

If (showzones=1)
{
  Gui,9:+ToolWindow +AlwaysOnTop -Caption -Border
  Gui,9:Margin,0,0
}

zonecount=0
Loop,Parse,zones,|
{
  count:=A_Index
  StringSplit,zone%count%_,A_LoopField,`,
  If (zone%count%_0=0)
    Break
  IfInString,zone%count%_1,`%
  {
    StringReplace,zone%count%_1,zone%count%_1,`%,
    zone%count%_1:=workareaRight*zone%count%_1/100
  }
  IfInString,zone%count%_2,`%
  {
    StringReplace,zone%count%_2,zone%count%_2,`%,
    zone%count%_2:=workareaBottom*zone%count%_2/100
  }
  IfInString,zone%count%_3,`%
  {
    StringReplace,zone%count%_3,zone%count%_3,`%,
    zone%count%_3:=workareaRight*zone%count%_3/100
  }
  IfInString,zone%count%_4,`%
  {
    StringReplace,zone%count%_4,zone%count%_4,`%,
    zone%count%_4:=workareaBottom*zone%count%_4/100
  }

  If (showzones=1)
  {
    zonex:=zone%count%_1
    zoney:=zone%count%_2-6
    zonew:=zone%count%_3-zone%count%_1
    zoneh:=zone%count%_4-zone%count%_2+6
    Gui,9:Add,GroupBox,x%zonex% y%zoney% w%zonew% h%zoneh%
  }
  zonecount:=count
}

If (showzones=1)
{
  Gui,9:Show,x0 y0 w%workareaRight% h%workareaBottom%
  Gui,9:+LastFound
  WinGet,guiid,Id,A
  PixelGetColor,rgb,% zone1_1+5,% zone1_2+5,RGB
  WinSet,TransColor,%rgb%,ahk_id %guiid%
  WinMove,ahk_id %guiid%,,-1,-1,1,1
}
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  delay=5
  showzones=1
  zones=0,0,200,200|0`%,50`%,100`%,100`%
  ignoreclass=#32768
  ignoretitle=
  ignoreempty=1
  Gosub,INIWRITE
  Gosub,ABOUT
}
IniRead,delay,%applicationname%.ini,Settings,delay
IniRead,showzones,%applicationname%.ini,Settings,showzones
IniRead,zones,%applicationname%.ini,Settings,zones
IniRead,ignoreclass,%applicationname%.ini,Settings,ignoreclass
IniRead,ignoretitle,%applicationname%.ini,Settings,ignoretitle
IniRead,ignoreempty,%applicationname%.ini,Settings,ignoreempty
Return

INIWRITE:
IniWrite,%delay%,%applicationname%.ini,Settings,delay
IniWrite,%showzones%,%applicationname%.ini,Settings,showzones
IniWrite,%zones%,%applicationname%.ini,Settings,zones
IniWrite,%ignoreclass%,%applicationname%.ini,Settings,ignoreclass
IniWrite,%ignoretitle%,%applicationname%.ini,Settings,ignoretitle
IniWrite,%ignoreempty%,%applicationname%.ini,Settings,ignoreempty
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,CENTER
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
Stringreplace,splitzones,zones,|,`n,All

Gui,Add,GroupBox,xm y+10 w310 h200,&Zones
Gui,Add,Edit,xp+10 yp+20 w290 h120 vvzones,%splitzones%
Gui,Add,Text,xp y+5,Format:`t<left>,<top>,<right>,<bottom>
Gui,Add,Text,xp y+0,%A_Space%or`t<left>`%,<top>`%,<right>`%,<bottom>`%
Gui,Add,CheckBox,xm+10 yp+20 Checked%showzones% vvshowzones,&Show zones

Gui,Add,GroupBox,xm y+10 w310 h50,Time to hover before sizing  (1/10 of a second)
Gui,Add,Edit,xm+10 yp+20 w100 vvdelay
Gui,Add,UpDown,Range0-999,%delay%

Gui,Add,GroupBox,xm y+10 w310 h85,&Classes to ignore
Gui,Add,Edit,xp+10 yp+20 w290 h40 vvignoreclass,%ignoreclass%
Gui,Add,Text,xp y+5,Format: <classname>,<classname>

Gui,Add,GroupBox,xm y+10 w310 h105,&Part of window titles to ignore
Gui,Add,Edit,xp+10 yp+20 w290 h40 vvignoretitle,%ignoretitle%
Gui,Add,Text,xp y+5,Format: <part of title>,<part of title>
Gui,Add,CheckBox,xm+10 y+5 Checked%ignoreempty% vvignoreempty,&Ignore titleless windows

Gui,Add,Button,y+20 w75 Default GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
Stringreplace,vzones,vzones,`n,|,All
Loop
{
  IfNotInString,vzones,||
    Break
  Stringreplace,vzones,vzones,||,|,All
}  
  
delay:=vdelay
showzones:=vshowzones
zones:=vzones
ignoreclass:=vignoreclass
ignoretitle:=vignoretitle
ignoreempty:=vignoreempty
Gosub,INIWRITE
Gosub,CREATE
Return

SETTINGSCANCEL:
Gui,Destroy
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Define zones that autosize windows dropped on them.
Gui,99:Add,Text,y+5,- Hold a window over a zone for .5 sec to autosize it.
Gui,99:Add,Text,y+5,- Doubleclick the tray icon to center the active window.
Gui,99:Add,Text,y+5,- Change the settings using Settings in the tray menu.

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
