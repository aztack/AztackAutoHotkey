;NoStrayClicks.ahk
; Prevents stray clicks on the mousepad when editing documents
;Skrommel @ 2005

CoordMode,Mouse,Screen
SysGet,caption,51 ;SM_CYSMCAPTION

applicationname=NoStrayClicks
Gosub,TRAYMENU

Gui,+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow
Gui,Margin,0,0
Gui,Color,FFFFFF
Gui,Font,C00000 S20 W1,Wingdings
Gui,Add,Text,Vtext,±
Gui,Show,X-50 Y-50 W50 H50 NoActivate,MousePos
WinSet,TransColor,FFFFFF 150,MousePos
GuiControl,,text,

counter=0

START:
  start=0
  ToolTip,
  Input,key,L1 V,{LWin}{RWin}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
  MouseGetPos,x1,y1
  WinGetActiveStats,wtitle,wwidth,wheight,wx,wy
  wx:=wx+caption ;Floor(wwidth/2)
  wy:=wy+wheight-caption
  MouseMove,%wx%,%wy%,0
  SetTimer,MOUSEMOVED,100
LOOP:
  Input,key,L1 V,{LWin}{RWin}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
  If start=1
    Goto,START
  WinGetActiveTitle,newwtitle
  If newwtitle<>%wtitle%
  {
    SetTimer,MOUSEMOVED,Off
    GuiControl,,text,
    MouseMove,%x1%,%y1%,0
    Goto,START
  }
Goto,LOOP
 
MOUSEMOVED:
  MouseGetPos,x2,y2
  mx:=x2-wx
  my:=y2-wy
  x1:=x1+mx
  y1:=y1+my
  GuiControl,,text,±
  Gui,Show,X%x1% Y%y1% W100 H100 NoActivate,MousePos
  WinSet,Topmost,,MousePos
  If (mx>4) || (mx<-4) || (my>4) || (my<-4)
  {
    SetTimer,MOUSEMOVED,Off
    GuiControl,,text,
    MouseMove,%x1%,%y1%,0
    start=1
    Return
  }
  MouseMove,%wx%,%wy%,0
Return

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,SWAP
Menu,Tray,Add,
Menu,Tray,Add,&Enable,ON
Menu,Tray,Add,&Disable,OFF
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return

SWAP:
Pause,Toggle
Return

ON:
Pause,On
Return

OFF:
Pause,Off
Return

ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.1
Gui,99:Font
Gui,99:Add,Text,y+10,Prevents stray clicks on the mousepad when editing a document

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
  If ctrl in Static7,Static11,Static15
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return

EXIT:
ExitApp