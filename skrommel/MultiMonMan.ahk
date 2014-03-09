;MultiMonMan.ahk
; Watch and control multiple monitors
;Skrommel @ 2006

#SingleInstance,Force
#NoEnv
SendMode,Input
SetBatchLines,-1
SetWinDelay,0
SetKeyDelay,0
CoordMode,Mouse,Screen
CoordMode,ToolTip,Screen
SysGet,titlebarh,4
SysGet,borderh,33

applicationname=MultiMonMan
Gosub,TRAYMENU

;ghost=1
;If ghost=1
;  Loop,4
;    Gui,%A_Index%:+E0x00000020
antialize=1
delay=25


INITIALIZE:
hdc_source:=DllCall("GetDC",UInt,0)
Loop,4
{
  monitor:=A_Index
  SysGet,%monitor%,Monitor,%monitor%
  If %monitor%Left<>
  {
    Gui,%monitor%:+Resize +AlwaysOnTop
    %monitor%Width:=%monitor%Right-%monitor%Left
    %monitor%Height:=%monitor%Bottom-%monitor%Top
    %monitor%Aspect:=%monitor%Height/%monitor%Width
    oldw:=w
    IniRead,x,%applicationname%.ini,%monitor%,x
    IniRead,y,%applicationname%.ini,%monitor%,y
    IniRead,w,%applicationname%.ini,%monitor%,w
    If x=Error
      x:=(monitor-1)*(oldw+2*borderh)
    If y=Error
      y:=0
    If w=Error
      w:=%monitor%Width/5
    Else
      w:=w-2*borderh
    Gui,%monitor%:Show,x%x% y%y% w%w% h-1,%monitor% - %applicationname%
    WinSet,Transparent,254,%monitor% - %applicationname%
    WinGet,mon_%monitor%,id,%monitor% - %applicationname% 
    hdc_target_%monitor%:=DllCall("GetDC",UInt,mon_%monitor%)
    DllCall("gdi32.dll\SetStretchBltMode",UInt,hdc_target_%monitor%,Int,4*antialize)  ; Antializing ?
  }
}


PAINT:
Loop
{
  ptooltip=0
  pcount=0
  Loop,4
  {
    pmonitor:=A_Index
    IfWinExist,%pmonitor% - %applicationname%
    {
      pcount+=1
      WinGetPos,px,py,pw,ph,%pmonitor% - %applicationname%
      pw:=pw-2*borderh
      ph:=pw*%pmonitor%Aspect
      If (pw<>poldw%pmonitor% Or ph<>poldh%pmonitor%)
        WinMove,%pmonitor% - %applicationname%,,,,,% ph+titlebarh+borderh*2
      poldw%pmonitor%:=pw
      poldh%pmonitor%:=ph
      DllCall("gdi32.dll\StretchBlt",UInt,hdc_target_%pmonitor%,Int,0,Int,0,Int,pw,Int,ph 
        ,UInt,hdc_source,UInt,%pmonitor%Left,UInt,%pmonitor%Top,Int,%pmonitor%Width,Int,%pmonitor%Height,UInt,0xCC0020) ; SRCCOPY 
      MouseGetPos,pmx,pmy
      pwx:=px+(pmx-%pmonitor%Left)/%pmonitor%Width*pw+borderh
      pwy:=py+(pmy-%pmonitor%Top)/%pmonitor%Height*ph+borderh+titlebarh
      If (pwx>=px+borderh And pwx<=px+pw+2*borderh And pwy>=py+borderh+titlebarh And pwy<=py+ph+2*borderh+titlebarh)
      {
        markx:=pwx-borderh-px
        marky:=pwy-borderh-titlebarh-py
        DllCall("MoveToEx",UInt,hdc_target_%pmonitor%,Int,markx-4,Int,marky,Str,0) 
        DllCall("LineTo",UInt,hdc_target_%pmonitor%,Int,markx+5,Int,marky) 
        DllCall("MoveToEx",UInt,hdc_target_%pmonitor%,Int,markx,Int,marky-4,Str,0) 
        DllCall("LineTo",UInt,hdc_target_%pmonitor%,Int,markx,Int,marky+5) 
        ptooltip+=1
        tx:=pwx
        ty:=pwy
      }
      Gosub,MOUSE
      Sleep,%delay%
    }
  }
  If ptooltip=0
    ToolTip
  If pcount=0
    ExitApp
}


SCREENTOWIN:
WinGetPos,x,y,w,h,%monitor% - %applicationname%
w:=w-2*borderh
h:=w*%monitor%Aspect
MouseGetPos,mx,my
wx:=x+(mx-%monitor%Left)/%monitor%Width*w+borderh
wy:=y+(my-%monitor%Top)/%monitor%Height*h+borderh+titlebarh
Return


WINTOSCREEN:
MouseGetPos,mx,my,win  
WinGetTitle,title,ahk_id %win%
StringLeft,monitor,title,1
WinGetPos,x,y,w,h,ahk_id %win%
sx:=%monitor%Left+(mx-x-borderh)/(w-2*borderh)*%monitor%Width
sy:=%monitor%Top+(my-y-borderh-titlebarh)/(h-2*borderh-titlebarh)*%monitor%Height
Return


MOUSE:
MouseGetPos,mx,my,win  
WinGetTitle,title,ahk_id %win%
StringLeft,monitor,title,1
WinGetPos,x,y,w,h,ahk_id %win%
find=%monitor% - %applicationname%
If (title=find And mx>=x+borderh And mx<=x+w-2*borderh And my>=y+borderh+titlebarh And my<=y+h-2*borderh)
{
  oldlbutton:=lbutton
  GetKeyState,lbutton,LButton,P
  Hotkey,$LButton,LBUTTONDOWN,On
  Hotkey,$RButton,RBUTTONDOWN,On
}
Else
{
  Hotkey,$LButton,LBUTTONDOWN,Off
  Hotkey,$RButton,RBUTTONDOWN,Off
}
Return


LBUTTONDOWN:
Hotkey,$LButton Up,LBUTTONUP,On
Hotkey,$LButton,LBUTTONDOWN,Off
Gosub,WINTOSCREEN
MouseClick,Left,%sx%,%sy%,1,0,D
If ghost=1
  Loop,4
    Gui,%A_Index%:-E0x00000020
window:=monitor
Return


RBUTTONDOWN:
Hotkey,$RButton Up,RBUTTONUP,On
Hotkey,$RButton,RBUTTONDOWN,Off
Gosub,WINTOSCREEN
If ghost=1
  Loop,4
    Gui,%A_Index%:+E0x00000020
MouseClick,Right,%sx%,%sy%,1,0,D
If ghost=1
  Loop,4
    Gui,%A_Index%:-E0x00000020
window:=monitor
Return


LBUTTONUP:
Hotkey,$LButton Up,LBUTTONUP,Off
MouseClick,Left,,,1,0,U
monitor:=window
WinGetPos,x,y,w,h,%monitor% - %applicationname%
w:=w-2*borderh
h:=w*%monitor%Aspect
MouseGetPos,mx,my
wx:=x+(mx-%monitor%Left)/%monitor%Width*w+borderh
wy:=y+(my-%monitor%Top)/%monitor%Height*h+borderh+titlebarh
MouseMove,%wx%,%wy%,0
Return


RBUTTONUP:
Hotkey,$RButton Up,RBUTTONUP,Off
MouseClick,Right,,,1,0,U
monitor:=window
WinGetPos,x,y,w,h,%monitor% - %applicationname%
w:=w-2*borderh
h:=w*%monitor%Aspect
MouseGetPos,mx,my
wx:=x+(mx-%monitor%Left)/%monitor%Width*w+borderh
wy:=y+(my-%monitor%Top)/%monitor%Height*h+borderh+titlebarh
MouseMove,%wx%,%wy%,0
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add
Menu,Tray,Add,&Save Setup,SAVE
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v2.0
Gui,99:Font
Gui,99:Add,Text,y+10,Watch and control multiple monitors.
Gui,99:Add,Text,y+10,- Click-through and drag-through
Gui,99:Add,Text,y+10,- Resize and move windows
Gui,99:Add,Text,y+10,- Choose Save Setup to save window arrangement

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


SAVE:
Loop,4
{
  WinGetPos,x,y,w,h,%A_Index% - %applicationname%
  IfWinExist,%A_Index% - %applicationname%
  {
    IniWrite,%x%,%applicationname%.ini,%A_Index%,x
    IniWrite,%y%,%applicationname%.ini,%A_Index%,y
    IniWrite,%w%,%applicationname%.ini,%A_Index%,w
  }
}
Return


EXIT:
ExitApp
