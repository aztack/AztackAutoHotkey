;SmallMeasure.ahk
; A small screen ruler
; Move the corners to measure the distance
; When the mousebutton is down, use the arrow keys for fine grain moving
;Skrommel @ 2008 

#SingleInstance,Force
SetWindelay,0
CoordMode,ToolTip,Screen

applicationname=SmallMeasure

size=15

Gosub,MENU

Gui,1:+LastFound +Border -Caption +ToolWindow +AlwaysOnTop
gui1:=WinExist()
Gui,1:Color,0000FF
Gui,1:Margin,0,0
Gui,1:Font,S100
Gui,1:Add,Text,GMOVE Vvfrom,% Chr(255)
Gui,1:Show,W%size% H%size%
WinSet,Region,0-0 %size%-0 0-%size%,ahk_id %gui1%

Gui,2:+LastFound +Border -Caption +ToolWindow +AlwaysOnTop
gui2:=WinExist()
Gui,2:Color,FF0000
Gui,2:Margin,0,0
Gui,2:Font,S100
Gui,2:Add,Text,GMOVE Vvto,% Chr(255)
Gui,2:Show,W%size% H%size%
WinSet,Region,%size%-0 %size%-%size% 0-%size% ,ahk_id %gui2%
Return


~LButton::
MouseGetPos,mx,my,mwin,mctrl
If mwin In %gui1%,%gui2%
{
  moving=1
  SetTimer,MEASURE,100
  Gosub,MEASURE
}
Return

~LButton Up::
If moving=1
{
  moving=0
  SetTimer,MEASURE,Off 
  ToolTip
}

~*Right::
If moving=1
  MouseMove,1,0,0,R
Return

~*Left::
If moving=1
  MouseMove,-1,0,0,R
Return

~*Up::
If moving=1
  MouseMove,0,-1,0,R
Return

~*Down::
If moving=1
  MouseMove,0,1,0,R
Return

MOVE: 
 PostMessage,0xA1,2,,,A 
Return

MEASURE:
  MouseGetPos,mx,my,mwin,mctrl
  WinGetPos,wx2,wy2,,,ahk_id %gui2%
  WinGetPos,wx1,wy1,,,ahk_id %gui1%
  ToolTip,% "(" wx1 "," wy1 ") - (" wx2 "," wy2 ") = (" wx2+size-wx1 "," wy2+size-wy1 ") and " Round(Sqrt((wx2+size-wx1)**2+(wy2+size-wy1)**2)) " pixels long"
Return


MENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname%
Menu,Tray,Default,%applicationname%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,A small screen ruler
Gui,99:Add,Text,xp y+5,Move the corners to measure the distance.
Gui,99:Add,Text,y+5,When the mousebutton is down, use the arrow keys for fine grain moving.

Gui,99:Add,Picture,xm y+20 Icon2,%applicationname%.exe
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

ABOUTOK:
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

EXIT:
ExitApp