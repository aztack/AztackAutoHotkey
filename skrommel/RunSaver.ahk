;RunSaver.ahk
; Screensaver that runs a command.
;Skrommel @2006

#NoTrayIcon 

applicationname=RunSaver

Gosub,INIREAD

StringLeft,param,1,2
If (param="" Or param="/c") 
  Goto,SETTINGS
If (param="/p")
  ExitApp

Run,%command%
ExitApp


INIREAD:
IfNotExist,%applicationname%.ini
{
  command=winver.exe
  Gosub,INIWRITE
}
IniRead,command,%applicationname%.ini,Settings,command
Return


INIWRITE:
IniWrite,%command%,%applicationname%.ini,Settings,command
Return


SETTINGS:
Gui,Destroy
Gui,Add,Tab,W330 H380 xm,Options|About

Gui,Tab
Gui,Add,Button,xm+10 y+10 GSETTINGSOK Default w75,&OK
Gui,Add,Button,x+5 yp GSETTINGSCANCEL w75,&Cancel

Gui,Tab,1
Gui,Add,GroupBox,w310 h80 xm+10 y+10,&Command
Gui,Add,Edit,vvcommand w50 xm+20 yp+20 w290,%command%
Gui,Add,Button,xm+235 y+5 w75 vvbrowse GBROWSE,Browse

Gui,Tab,2
Gui,Add,Picture,xm+20 ym+40 Icon1,%applicationname%.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,Font
Gui,Add,Text,xm+20 y+15,Screensaver that runs a command.
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm+20 y+10 Icon5,%applicationname%.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,xm+20 y+15,For more tools, information and donations, visit
Gui,Font,CBlue Underline
Gui,Add,Text,xm+20 y+0 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm+20 y+10 Icon7,%applicationname%.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,DonationCoder
Gui,Font
Gui,Add,Text,xm+20 y+15,Please support the DonationCoder community
Gui,Font,CBlue Underline
Gui,Add,Text,xm+20 y+0 GDONATIONCODER,www.DonationCoder.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm+20 y+10 Icon6,%applicationname%.scr
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,AutoHotkey
Gui,Font
Gui,Add,Text,xm+20 y+10,This program was made using AutoHotkey
Gui,Font,CBlue Underline
Gui,Add,Text,xm+20 y+0 GAUTOHOTKEY,www.AutoHotkey.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Show,,%applicationname% Settings

hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

BROWSE:
FileSelectFile,file
GuiControl,,vcommand,%file%
Return


SETTINGSOK:
Gui,Submit
command:=vcommand
Gosub,INIWRITE
Gosub,SETTINGSCANCEL
Return


SETTINGSCANCEL:
Gui,Destroy
ExitApp


1HOURSOFTWARE:
Run,http://www.1hoursoftware.com,,UseErrorLevel
Return

DONATIONCODER:
Run,http://www.donationcoder.com,,UseErrorLevel
Return

AUTOHOTKEY:
Run,http://www.autohotkey.com,,UseErrorLevel
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,winid,ctrl
  If ctrl in Static8,Static13,Static18
    DllCall("SetCursor","UInt",hCurs)
}