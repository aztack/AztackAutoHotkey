;Noise.ahk
; Sends keystrokes to keep the PC from falling asleep
;Skrommel @2005

#SingleInstance,Force
DetectHiddenWindows,On
SetKeyDelay,0,0

Menu,Tray,NoStandard
Menu,Tray,Add,&Show,SHOW
Menu,Tray,Add,E&xit,ButtonQuit
Menu,Tray,Default,&Show

Gui,+Owner -AlwaysOnTop -Disabled +SysMenu +Caption +Border +ToolWindow
Gui,Add,Edit,vchars
Gui,Add,Button,default,Quit
Gui,Show,,Noise!
Gui,Hide
SetTimer,MAKENOISE,60000
Return

MAKENOISE:
If A_TimeIdlePhysical<60000
  Return
chars=
GuiControl,,chars
Random,char,65,90   ;97,122
Transform,char,CHR,%char%
ControlSend,Edit1,{Blind}%char%,Noise!
Return

SHOW:
Gui,Show
Return

GuiClose:
GuiEscape:
Gui,Hide
Return

ButtonQuit:
ExitApp
