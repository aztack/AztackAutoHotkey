;CreateShortcutThere.ahk
; Rightclick a file and select the contextmenu CreateShortcutThere... 
;  to choose where to place the shortcut
;Skrommel @ 2009

#NoEnv
#SingleInstance,Force
#NoTrayIcon

applicationname=CreateShortcutThere

filename=
Loop,%0%
  filename.=%A_Index% " "

If filename=
{
  Gosub,ABOUT
  Return
}
SplitPath,filename,name,dir,ext,name_no_ext,drive
FileSelectFolder,target,*%dir%,3,Choose where to create the shortcut to`n %filename%
If target<>
  FileCreateShortcut,%filename%,%target%\%name_no_ext% - Shortcut.lnk,%dir%,,,%filename%,,1,
ExitApp


INSTALL:
RegWrite,REG_SZ,HKEY_CLASSES_ROOT,*\shell\createshortcuthere,,&%applicationname%...
RegWrite,REG_SZ,HKEY_CLASSES_ROOT,*\shell\createshortcuthere\command,,"%A_ScriptDir%\%applicationname%.exe" "`%1"
RegRead,key,HKEY_CLASSES_ROOT,*\shell\createshortcuthere
If key=
  MsgBox,0,%applicationname%,Unable to install the context menu!
Else
  MsgBox,0,%applicationname%,Context menu installed!
Gosub,ABOUT
Return


UNINSTALL:
RegDelete,HKEY_CLASSES_ROOT,*\shell\createshortcuthere
RegRead,key,HKEY_CLASSES_ROOT,*\shell\createshortcuthere
If key<>
  MsgBox,0,%applicationname%,Unable to remove the context menu!
Else
  MsgBox,0,%applicationname%,Context menu removed!
Gosub,ABOUT
Return


ABOUT:
Gui,Destroy
Gui,Margin,20,20
Gui,Add,Picture,xm Icon1,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,Font
Gui,Add,Text,y+10,Rightclick a file and select the contextmenu CreateShortcutThere... 
Gui,Add,Text,xp y+5,to choose where to place the shortcut

RegRead,key,HKEY_CLASSES_ROOT,*\shell\createshortcuthere
If key=
  Gui,Add,Button,GINSTALL,&Install context menu
Else
  Gui,Add,Button,GUNINSTALL,&Remove context menu

Gui,Add,Picture,xm y+20 Icon2,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,y+10,For more tools, information and donations, please visit 
Gui,Font,CBlue Underline
Gui,Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font

Gui,Add,Picture,xm y+20 Icon7,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,DonationCoder
Gui,Font
Gui,Add,Text,y+10,Please support the contributors at
Gui,Font,CBlue Underline
Gui,Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
Gui,Font

Gui,Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,AutoHotkey
Gui,Font
Gui,Add,Text,y+10,This tool was made using the powerful
Gui,Font,CBlue Underline
Gui,Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,Font

Gui,Show,,%applicationname% About
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

GuiClose:
  Gui,Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
  ExitApp
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