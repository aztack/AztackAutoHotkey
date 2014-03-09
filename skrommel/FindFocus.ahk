;FindFocus.ahk
; Find focused control
;Skrommel @2006

FileInstall,f1.gif,f1.gif
FileInstall,f2.gif,f2.gif

#SingleInstance,Force
#NoEnv
SetBatchLines,-1

applicationname=FindFocus

Gosub,TRAYMENU

found=0

START:
x1=0
y1=-1
WinGetPos,wx,wy,ww,wh,A
If found=1
{
  ToolTip,F,% x2-10,% y2-20
  Sleep,50
  ToolTip,F,% x2-5,% y2-20
  Sleep,50
}
Else
{
  x2:=-1
  y2:=20
}
ToolTip,F,% x2,% y2-20
Sleep,100

LOOP:
  Sleep,10
  found=0
  ImageSearch,x1,y1,0,% y1+1,% ww,% wh,*100 f1.gif
  If ErrorLevel=0
  {
    PixelGetColor,rgb1,% x1,% y1,RGB
    PixelGetColor,rgb2,% x1,% y1+1,RGB
    If (rgb1+rgb2=0xffffff)
{
    ImageSearch,x2,y2,% x1-1,% y1-1,% x1+6,% y1+2,*100 f2.gif
    If ErrorLevel=0
    {
      PixelGetColor,rgb1,% x2,% y2,RGB
      PixelGetColor,rgb2,% x2+1,% y2,RGB
      If (rgb1+rgb2=0xffffff)
        found=1
      Goto,START
    }
} 
  }
  Else
  {
    found=0
    Goto,START
  }
Goto,LOOP


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add
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
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Find the focused control in browsers
Gui,99:Add,Text,y+10,- Shows a flashing icon next to the focused control
Gui,99:Add,Text,y+10,- Not perfect, but better than nothing

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


EXIT:
ExitApp
