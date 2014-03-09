;ShortcutFolder.ahk
; Creates and collects shortcuts to programs in a folder.
;Skrommel @ 2008

#SingleInstance,Ignore
#NoEnv
SetBatchLines,-1

applicationname=ShortcutFolder

Gosub,MENU

If 0=0
{
  FileSelectFolder,start,,3,Select a folder to search for programs
  If start=
  {
    MsgBox,0,%applicationname%,You didn't select a folder.
    ExitApp
  }
}   
Else
  start=%1%

If 2=
  depth=2

StringSplit,startdepth,start,\

FileCreateDir,%A_WorkingDir%\Shortcuts

TrayTip,%ShortcutFolder%,Searching %start%...
Loop,%start%\*.exe,0,1
{
  olddir:=dir
  dir:=A_LoopFileDir
  StringSplit,dirdepth,dir,\
  If (dir<>olddir And dirdepth0-startdepth0<=depth)
  {
    SplitPath,A_LoopFileLongPath,name,dir,ext,name_no_ext,drive
    FileCreateShortcut,%A_LoopFileLongPath%,%A_WorkingDir%\Shortcuts\%name_no_ext%.lnk,,,,%A_LoopFileLongPath%,,1,
  }
}
TrayTip,%ShortcutFolder%,Shortcuts stored in %A_WorkingDir%\Shortcuts
Sleep,3000
ExitApp


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
Gui,99:Add,Text,y+10,Find and create shortcuts to programs.
Gui,99:Add,Text,y+5,- Run it or add a folder to the command line.

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


EXIT:
ExitApp