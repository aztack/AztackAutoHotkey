;ControlFence.ahk
; Prevent the mouse from sliding off certain controls once inside.
;Skrommel @2006

#SingleInstance,Force
#Persistent
CoordMode,Mouse,Screen

applicationname=ControlFence

Gosub,INIREAD
Gosub,TRAYMENU

inside=0

Loop
{
  MouseGetPos,mx,my,mwin,mctrl,2
  If inside=0
  {
    WinGetClass,mclass,ahk_id %mctrl%
    If mclass In %controls%
    {
      inside=1
      WinGetPos,wx,wy,ww,wh,ahk_id %mctrl%
      ww:=wx+ww
      wh:=wy+wh
    }
  }
  If inside=1
  {
    If (mx<wx And left=1)
      mx:=wx
    If (mx>ww And right=1)
      mx:=ww
    If (my<wy And top=1)
      my:=wy
    If (my>wh And bottom=1)
      my:=wh
    MouseMove,%mx%,%my%

    If ((mx<wx And left=0) Or (mx>ww And right=0) Or (my<wy And top=0) Or (my>wh And bottom=0))
      inside=0
  }
  If showinfo=1
    ToolTip,%mclass%
  Sleep,100
}


TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Default,%applicationname%
Menu,Tray,Add,&Settings...,SETTINGS 
Menu,Tray,Add,&About...,About 
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname% 
Return 


SETTINGS:
Gui,Margin,20

Gui,Add,GroupBox,xm-10 y+10 w420 h130,&Controls
Gui,Add,Edit,xm yp+20 w400 h80 vvcontrols,%controls%
Gui,Add,Text,xm y+10,Format: Part_of_a_control's_name1,Part_of_a_control's_name2

Gui,Add,GroupBox,xm-10 y+20 w420 h80,Fences
Gui,Add,CheckBox,xm yp+20 vvleft Checked%left%,&Left fence 
Gui,Add,CheckBox,xm+150 yp vvtop Checked%top%,&Top fence
Gui,Add,CheckBox,xm y+5 vvright Checked%right%,&Right fence
Gui,Add,CheckBox,xm+150 yp vvbottom Checked%bottom%,&Bottom fence
Gui,Add,Text,xm y+10,Leave at least one unchecked

Gui,Add,GroupBox,xm-10 y+20 w420 h50,Information
Gui,Add,CheckBox,xm yp+20 vvshowinfo Checked%showinfo%,&Show control's name 

Gui,Add,Button,y+30 w75 gSETTINGSOK,&OK
Gui,Add,Button,x+5 yp w75 gSETTINGSCANCEL,&Cancel

Gui,Show,w440,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
If vcontrols<>
  controls:=vcontrols
left:=vleft
right:=vright
top:=vtop
bottom:=vbottom
showinfo:=vshowinfo
Gosub,INIWRITE
Gosub,SETTINGSCANCEL
Return

SETTINGSCANCEL:
Gui,Destroy
Return

GuiClose:
Gosub,SETTINGSCANCEL
Return

EXIT:
ExitApp


INIREAD:
IfNotExist,%applicationname%.ini 
{
  controls=ComboLBox
  left=1
  right=1
  top=0
  bottom=1
  showinfo=0
  Gosub,INIWRITE
  Gosub,ABOUT
}
IniRead,controls,%applicationname%.ini,Settings,controls
IniRead,left,%applicationname%.ini,Settings,left
IniRead,right,%applicationname%.ini,Settings,right
IniRead,top,%applicationname%.ini,Settings,top
IniRead,bottom,%applicationname%.ini,Settings,bottom
IniRead,showinfo,%applicationname%.ini,Settings,showinfo
Return


INIWRITE:
IniWrite,%controls%,%applicationname%.ini,Settings,controls
IniWrite,%left%,%applicationname%.ini,Settings,left
IniWrite,%right%,%applicationname%.ini,Settings,right
IniWrite,%top%,%applicationname%.ini,Settings,top
IniWrite,%bottom%,%applicationname%.ini,Settings,bottom
IniWrite,%showinfo%,%applicationname%.ini,Settings,showinfo
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Prevent the mouse from sliding off certain controls once inside.
Gui,99:Add,Text,y+10,- To change the settings, choose Settings in the tray menu.

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
  If ctrl in Static8,Static12,Static16
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return
