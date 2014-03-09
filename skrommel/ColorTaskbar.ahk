;ColorTaskBar.ahk
; Makes the taskbar gradually shift through a range of colors
;Skrommel @ 2005

#SingleInstance,Force
#NoEnv
SetBatchLines,-1
SetWinDelay,0
CoordMode,Pixel,Screen
CoordMode,Mouse,Screen

applicationname=ColorTaskbar

OnMessage(0x201,"WM_LBUTTONDOWN") 
OnMessage(0x204,"WM_RBUTTONDOWN") 
OnMessage(0x207,"WM_MBUTTONDOWN") 
OnMessage(0x202,"WM_LBUTTONUP") 
OnMessage(0x205,"WM_RBUTTONUP") 
OnMessage(0x206,"WM_MBUTTONUP") 

Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,PAUSE
Menu,Tray,Add
Menu,Tray,Add,&Pause,PAUSE
Menu,Tray,Add
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%

WinGetPos,x,y,width,height,ahk_class Shell_TrayWnd
ConTrolGetPos,cx,cy,cw,ch,Button1,ahk_class Shell_TrayWnd
If width<%height%
{
  pixelx:=x+cx+cw/2
  pixely:=y+cy+ch
}
Else
{
  pixelx:=x+cx+cw+1
  pixely:=y+cy+ch/2
}

PixelGetColor,color,%pixelx%,%pixely%,RGB
WinSet,TransColor,%color%,ahk_class Shell_TrayWnd

Gui,-AlwaysOnTop +Owner -Caption +ToolWindow
Gui,Show,x%x% y%y% w%width% h%height%,TransWindow
WinSet,Top,,ahk_class Shell_TrayWnd

steps=50
oldr=255
oldg=255
oldb=255

WinGetPos,oldx,oldy,oldwidth,oldheight,ahk_class Shell_TrayWnd
Loop
{
  WinGetPos,x,y,width,height,ahk_class Shell_TrayWnd
  If (x<>oldx Or y<>oldy Or width<>oldwidth Or height<>oldheight)
  {
    WinMove,TransWindow,,x,y,width,height
    WinSet,Top,,ahk_class Shell_TrayWnd
    oldx=%x%
    oldy=%y%
    oldwidth=%width%
    oldheight=%height%
  }
  
  Random,newr,0,255
  Random,newg,0,255
  Random,newb,0,255
  
  rstep:=(newr-oldr)/steps
  gstep:=(newg-oldg)/steps
  bstep:=(newb-oldb)/steps
  
  r:=oldr
  g:=oldg
  b:=oldb
  
  oldr:=newr
  oldg:=newg
  oldb:=newb
  
  Loop,%steps%
  {
    Transform,newr,Floor,r
    SetFormat,Integer,Hex
    newr+=0
    SetFormat,Integer,D
    StringTrimLeft,newr,newr,2
    If r<17
      newr=0%newr%
    
    Transform,newg,Floor,g
    SetFormat,Integer,Hex
    newg+=0
    SetFormat,Integer,D
    StringTrimLeft,newg,newg,2
    If g<17
      newg=0%newg%
    
    Transform,newb,Floor,b
    SetFormat,Integer,Hex
    newb+=0
    SetFormat,Integer,D
    StringTrimLeft,newb,newb,2
    If b<17
      newb=0%newb%
    
    Gui,Color,%newr%%newg%%newb%
    Sleep,100

    r:=r+rstep
    g:=g+gstep
    b:=b+bstep
  }
}


PAUSE:
Pause,Toggle
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Makes the taskbar gradually shift through a range of colors

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
  If ctrl in Static9
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


WM_LBUTTONDOWN(wParam,lParam)
{
  MouseGetPos,mx,my
  ControlClick,x10 y%my%,ahk_class Shell_TrayWnd,,L,1,D
  Return
}

WM_LBUTTONUP(wParam,lParam)
{
  MouseGetPos,mx,my
  ControlClick,x10 y%my%,ahk_class Shell_TrayWnd,,L,1,U
  Return
}
WM_RBUTTONDOWN(wParam,lParam)
{
  MouseGetPos,mx,my
  ControlClick,x10 y%my%,ahk_class Shell_TrayWnd,,R,1,D
  Return
}
WM_RBUTTONUP(wParam,lParam)
{
  MouseGetPos,mx,my
  ControlClick,x10 y%my%,ahk_class Shell_TrayWnd,,R,1,U
  Return
}
WM_MBUTTONDOWN(wParam,lParam)
{
  MouseGetPos,mx,my
  ControlClick,x10 y%my%,ahk_class Shell_TrayWnd,,M,1,D
  Return
}
WM_MBUTTONUP(wParam,lParam)
{
  MouseGetPos,mx,my
  ControlClick,x10 y%my%,ahk_class Shell_TrayWnd,,M,1,U
  Return
}


EXIT:
WinSet,TransColor,Off,ahk_class Shell_TrayWnd
ExitApp
