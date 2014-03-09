;PixelNotifier.ahk
; Watches a screen pixel for a specific color, and notifies the user when it occurs. 
;Skrommel @2005

#SingleInstance,Force

SysGet,workarea,MonitorWorkArea 

applicationname=PixelNotifier

Gosub,READINI
Gosub,ACTIVATEALL

LOOP:
Loop,%alarmscount%
{
  Sleep,500
  If active_%A_Index%=0
    Continue
  If triggered_%A_Index%=1
    Continue
  x:=alarms_%A_Index%_1
  y:=alarms_%A_Index%_2
  pixelcolor:=alarms_%A_Index%_3
  relative:=alarms_%A_Index%_4
  If relative=1
    CoordMode,Pixel,Screen
  Else
    CoordMode,Pixel,Relative
  PixelGetColor,readpixelcolor,x,y,RGB
  StringTrimLeft,readpixelcolor,readpixelcolor,2
  If readpixelcolor<>%pixelcolor%
    Continue
  triggered_%A_Index%=1
  message:=alarms_%A_Index%_5
  fullscreencolor:=alarms_%A_Index%_6
  Gui,%A_Index%:+Owner -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled +Caption +Border -ToolWindow
  Gui,%A_Index%:Color,%fullscreencolor%
  Gui,%A_Index%:Add,Button,X320 Y240 Default GOK_%A_Index%,%message%
  Gui,%A_Index%:Show,X-4 Y-4 W%workareaRight% H%workareaBottom%,%applicationname% %A_Index%
  SetTimer,TRIGGERED_%A_Index%,5000
  Gosub,TRIGGERED_%A_Index%    
}
Goto,LOOP


TRIGGERED_9:
triggered=9
Goto,TRIGGERED
TRIGGERED_8:
triggered=8
Goto,TRIGGERED
TRIGGERED_7:
triggered=7
Goto,TRIGGERED
TRIGGERED_6:
triggered=6
Goto,TRIGGERED
TRIGGERED_5:
triggered=5
Goto,TRIGGERED
TRIGGERED_4:
triggered=4
Goto,TRIGGERED
TRIGGERED_3:
triggered=3
Goto,TRIGGERED
TRIGGERED_2:
triggered=2
Goto,TRIGGERED
TRIGGERED_1:
triggered=1
Goto,TRIGGERED
TRIGGERED:
sound:=alarms_%triggered%_7
SoundPlay,%sound%
;WinSet,Top,,%applicationname% %triggered%
WinActivate,%applicationname% %triggered%
Return


OK_9:
ok=9
Goto,BUTTON
OK_8:
ok=8
Goto,BUTTON
OK_7:
ok=7
Goto,BUTTON
OK_6:
ok=6
Goto,BUTTON
OK_5:
ok=5
Goto,BUTTON
OK_4:
ok=4
Goto,BUTTON
OK_3:
ok=3
Goto,BUTTON
OK_2:
ok=2
Goto,BUTTON
OK_1:
ok=1
Goto,BUTTON
BUTTON:
SetTimer,TRIGGERED_%ok%,Off
Gui,%ok%:Destroy
active_%ok%=0
Gosub,TRAYMENU
Return


TOGGLE_9:
TOGGLE_8:
TOGGLE_7:
TOGGLE_6:
TOGGLE_5:
TOGGLE_4:
TOGGLE_3:
TOGGLE_2:
TOGGLE_1:
menu:=A_ThisMenuItemPos-2
If active_%menu%=0
{
  active_%menu%=1
  triggered_%menu%=0
  Gosub,TRAYMENU
}
Else
{
  Gosub,OK_%menu%
}
Return


ADD:
Gosub,DEACTIVATEALL
Loop
{
  CoordMode,Pixel,Screen
  CoordMode,Mouse,Screen
  MouseGetPos,sx,sy
  PixelGetColor,readpixelcolor,sx,sy,RGB
  StringTrimLeft,readpixelcolor,readpixelcolor,2
  CoordMode,Mouse,Relative
  MouseGetPos,x,y
  ToolTip,Color:`t%readpixelcolor%`nScreenCoord:`t%sx% %sy%`nWindowCoord:`t%x% %y%`n`nPress`tto add`n1=`tScreenCoord`n2=`tWindowCoord`nEsc=Cancel
  GetKeyState,screen,1,P
  If screen=D
  {
    FileAppend,`n%sx%`,%sy%`,%readpixelcolor%`,1`,Message`,FFFFFF`,C:\Windows\Ding.wav,%applicationname%.ini
    ToolTip,
    Gosub,SETTINGS
    Break   
  }
  GetKeyState,window,2,P
  If window=D
  {
    FileAppend,`n%x%`,%y%`,%readpixelcolor%`,2`,Message`,FFFFFF`,C:\Windows\Ding.wav,%applicationname%.ini
    ToolTip,
    Gosub,SETTINGS
    Break   
  }
  GetKeyState,esc,Esc,P
  If esc=D
  {
    ToolTip,
    Break
  }
}
Return


SETTINGS:
Gosub,DEACTIVATEALL
Gosub,READINI
Run,%applicationname%.ini
Return


READINI:
IfNotExist,%applicationname%.ini
{
ini=`;%applicationname%.ini
ini=%ini%`n`;
ini=%ini%`n`;Syntax:
ini=%ini%`n`;
ini=%ini%`n`;x,y,pixelcolor,relative,message,fullscreencolor,sound
ini=%ini%`n`;
ini=%ini%`n`; x                               Horizontal positon of the pixel to watch
ini=%ini%`n`; y                               vertical positon of the pixel to watch
ini=%ini%`n`; pixelcolor=000000-FFFFFF        RGB-color of the pixel to watch
ini=%ini%`n`; relative=1,2                    Find pixel relative to 1=the screen or 2=the active window
ini=%ini%`n`; message                         The message to display
ini=%ini%`n`; fullscreencolor=000000-FFFFFF   Color of the fullscreen notification
ini=%ini%`n`; sound                           Path to the WAV-file
ini=%ini%`n`;
ini=%ini%`n`;Example:
ini=%ini%`n`;
ini=%ini%`n`;0,0,FFFFFF,White color detected!,0,0000FF,C:\Windows\Media\Ding.wav
ini=%ini%`n`;  Watches the screenposition 0,0 for the color white and plays a sound and 
ini=%ini%`n`;  displays a blue message window with the text White color detected!
ini=%ini%`n
ini=%ini%`n200,200,FFFFFF,1,White color detected!,0000FF,C:\Windows\Media\Ding.wav
ini=%ini%`n400,400,FFFFFF,1,White color detected!,FF0000,C:\Windows\Media\Ding.wav
FileAppend,%ini%,%applicationname%.ini
ini=
}
alarmscount=0
Loop,Read,%applicationname%.ini
{
  IfInString,A_LoopReadLine,`;
    Continue
  IfNotInString,A_LoopReadLine,`,
    Continue
  alarmscount+=1
  StringSplit,alarms_%alarmscount%_,A_LoopReadLine,`,
}
Return


TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,TOGGLE
Menu,Tray,Add,
Loop,%alarmscount%
{
  message:=alarms_%A_Index%_5
  Menu,Tray,Add,&%A_Index%:%message%,TOGGLE_%A_Index%
  If active_%A_Index%=1
    Menu,Tray,Check,&%A_Index%:%message%
}
Menu,Tray,Add,
Menu,Tray,Add,&Enable All,ACTIVATEALL
Menu,Tray,Add,&Disable All,DEACTIVATEALL
Menu,Tray,Add,
Menu,Tray,Add,&Add alarm...,Add
Menu,Tray,Add,&Edit alarms...,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return 


TOGGLE:
Pause,Toggle
Return


ACTIVATEALL:
Loop,%alarmscount%
{
  active_%A_Index%=1
  triggered_%A_Index%=0
  Gosub,TRAYMENU
}
Return


DEACTIVATEALL:
Loop,%alarmscount%
{
  SetTimer,TRIGGERED_%A_Index%,Off
  Gui,%A_Index%:Destroy
  active_%A_Index%=0
  triggered_%A_Index%=0
  Gosub,TRAYMENU
}
Return

 
ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Watches a screen pixel for a specific color, and notifies the user when it occurs.
Gui,99:Add,Text,y+5,- Change settings using Settings in the tray menu
Gui,99:Add,Text,y+5,- Shows a message, plays a sound and fills the whole screen with color

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
