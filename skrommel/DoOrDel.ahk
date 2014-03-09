;DoOrDel.ahk
; Startup tool that will delete user defined folders
;  unless the right password is entered.
; Place EraserD from http://www.tolvanen.com/eraser 
;  in the same folder as this script for wiping
;Skrommel @2006


folders=Z:\Fo1,Z:\Fo2  ;List of folders to delete, separated by comma
password=1234          ;Password
time=60                ;Seconds to wait before deleting
wipe=1                 ;1=wipe files to prevent recovery, 0=don't wipe


FileInstall,EraserD.exe,EraserD.exe

#SingleInstance,Ignore
#NoTrayIcon

applicationname=DoOrDel

ticks=%A_TickCount%
SetTimer,DELETE,% time*1000
SetTimer,HIDE,50
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 

Gui,+ToolWindow +AlwaysOnTop
Gui,Add,Text,xm,Password?
Gui,Add,Edit,xm w100 vinput Password
Gui,Add,Button,x+5 gOK Default,&OK
Gui,Add,Text,xm vtimer,Seconds left:00000000
Gui,Font,CBlue Underline
Gui,Add,Text,xm G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font
Gui,Show,AutoSize,%applicationname%
Return

1HOURSOFTWARE:
Run,http://www.1hoursoftware.com,,UseErrorLevel
Return

OK:
Gui,Submit,NoHide
If input=%password%
  ExitApp
Return

GuiClose:
Return

HIDE:
WinHide,ahk_class #32770,CPU
WinActivate,%applicationname%
timeleft:=time+Floor((ticks-A_TickCount)/1000)
GuiControl,,timer,Seconds left: %timeleft%
Return

DELETE:
SetTimer,DELETE,Off
GuiControl,,timer,Deleting folders...
Loop,Parse,folders,`,
{
  If wipe=1
    Run,EraserD.exe -folder %A_LoopField% -subfolders,,Hide
  Else
    FileRemoveDir,%A_LoopField%,1
}
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
Sleep,3000
ExitApp

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static3
    DllCall("SetCursor","UInt",hCurs)
  Return
}
