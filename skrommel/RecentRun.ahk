;RecentRun.ahk
; Shows a list of the most recently run programs on the Start menu and in the tray
;Skrommel @2005

#SingleInstance,Force
#NoEnv
Menu,Tray,NoIcon
AutoTrim,Off
StringTrimRight,applicationname,A_ScriptName,4
Gosub,INI
IfInString,1,hide
  Menu,Tray,NoIcon
Else
If hidetrayicon<>1
  Menu,Tray,Icon

WS_EX_APPWINDOW=0x40000 
WS_EX_TOOLWINDOW=0x80 
GW_OWNER=4 

startup=1
Gosub,GETPROGRAMS
startup=0

START:
RegRead,recentmenu,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Start Menu
recentmenu=%recentmenu%\%menuname%
FileCreateDir,%recentmenu%
FileCreateDir,%shortcutfolder%
If deleteonstartup<>0
  Gosub,DELETESHORTCUTS
Gosub,UPDATEMENUS
Gosub,GETPROGRAMS


LOOP
{
  Sleep,100
  Gosub,GETPROGRAMS
  If updatemenus=1
    Gosub,UPDATEMENUS
}


GETPROGRAMS:
oldids=%allids%
allids=
updatemenus=0
WinGet,winids,List,,,Program Manager
Loop,%winids%
{
  Sleep,10
  StringTrimRight,winid,winids%A_Index%,0
  allids=%allids%%winid%`,
  If startup=1
    Continue
  IfInString,oldids,%winid%`,
    Continue
  WinGet,es,ExStyle,ahk_id %winid% 
  If !((!DllCall("GetWindow","UInt",winid,"UInt",GW_OWNER) And !(es & WS_EX_TOOLWINDOW)) Or (es & WS_EX_APPWINDOW)) 
    Continue
  WinGet,pid,PID,ahk_id %winid%
  path:=GetModuleFileNameEx(pid)
  If path=
    Continue
  info:=
  Loop,HKEY_CURRENT_USER,Software\Microsoft\Windows\ShellNoRoam\MUICache,0,0 
  { 
    Sleep,0
    IfInString,A_LoopRegName,%path% 
    { 
      RegRead,info 
      info:=" - " . info
      Break 
    } 
  }
  WinGet,program,ProcessName,ahk_id %winid%
  FileGetAttrib,attributes,%shortcutfolder%\%program%%info%.lnk
  IfNotInString,attributes,R
  IfInString,extensions,%ext%
  {
    SplitPath,program,,,ext,program,
    StringLower,program,program,T 
    FileCreateShortcut,%path%,%shortcutfolder%\%program%%info%.lnk
    updatemenus=1
  }
}
Return


UPDATEMENUS:
RegDelete,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu\%menuname%,Order
FileRemoveDir,%recentmenu%,1
FileCreateDir,%recentmenu%
FileDelete,%recentmenu%\*.lnk
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,

files=
Loop,%shortcutfolder%\*.lnk
{
  Sleep,10
  files=%files%%A_LoopFileTimeModified%`t%A_LoopFileName%`n
}
Sort,files,R

sortedfiles=
Loop,parse,files,`n
{
  Sleep,10
  If A_LoopField=
    Continue
  StringSplit,file_,A_LoopField,%A_Tab%
  sortedfiles=%sortedfiles%%file_2%`n
}
files=%sortedfiles%

If sortbydate=0
{
  StringLen,length,files
  StringGetPos,pos,files,`n,L%numberofshortcuts%
  If pos=-1
    pos=%length%
  StringLeft,top,files,%pos%
  StringTrimLeft,bottom,files,%pos%
  Sort,top
  files=%top%%bottom%
}

counter=0
Loop,parse,files,`n
{
  Sleep,10
  If A_LoopField=
    Continue
  FileGetShortcut,%shortcutfolder%\%A_LoopField%,Target,Dir,,Description,Icon,IconNumber,RunState
  FileGetAttrib,attributes,%shortcutfolder%\%A_LoopField%
  StringTrimRight,filename,A_LoopField,4
  IfInString,attributes,R
  {
    FileCreateShortcut,%Target%,%recentmenu%\%A_LoopField%,%Dir%,,%Description%,%Icon%,,%IconNumber%,%RunState%
    Menu,Tray,Add,%filename%,RUN
  }
  Else
  If counter<%numberofshortcuts%
  {
    Menu,Tray,Add,%filename%,RUN
    counter+=1
    If sortbydate=1
    {
      If A_OSVersion<>WIN_XP
      {
        number:=1000+counter
        StringTrimLeft,number,number,% 4-StrLen(numberofshortcuts)
        FileCreateShortcut,%Target%,%recentmenu%\%number% - %A_LoopField%,%Dir%,%Args%,%Description%,%Icon%,,%IconNumber%,%RunState%
      }
      Else
        FileCreateShortcut,%Target%,%recentmenu%\%counter% - %A_LoopField%,%Dir%,%Args%,%Description%,%Icon%,,%IconNumber%,%RunState%
    }
    Else
      FileCreateShortcut,%Target%,%recentmenu%\%A_LoopField%,%Dir%,%Args%,%Description%,%Icon%,,%IconNumber%,%RunState%
  }
}
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,Exit
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


RUN:
Run,%recentmenu%\%A_ThisMenuItem%.lnk
Return


EDITSHORTCUTS:
Run,Explorer.exe %shortcutfolder%
Return


DELETESHORTCUTS:
FileRemoveDir,%shortcutfolder%,1
FileCreateDir,%shortcutfolder%
FileDelete,%shortcutfolder%\*.lnk
Gosub,UPDATEMENUS
Return


SETTINGS:
Gui,Destroy
Gui,Add,GroupBox,xm ym+10 w320 h110,&Shortcuts
Gui,Add,Edit,xp+10 yp+20 w55 vsnumberofshortcuts,%numberofshortcuts%
Gui,Add,UpDown,Range0-999,%numberofshortcuts%
Gui,Add,Text,x+20 yp+5,Number of shortcuts
Gui,Add,Button,xm+10 y+10 w75 GEDITSHORTCUTS,Edi&t
Gui,Add,CheckBox,Checked%sortbydate% x+20 yp+5 vssortbydate, &Sort by date
Gui,Add,Button,xm+10 y+10 w75 GDELETESHORTCUTS,&Delete
Gui,Add,CheckBox,Checked%deleteonstartup% x+20 yp+5 vsdeleteonstartup, &Delete on startup
Gui,Add,GroupBox,xm y+25 w320 h50,&Menu name
Gui,Add,Edit,xp+10 yp+20 w300 vsmenuname,%menuname%
Gui,Add,GroupBox,xm y+20 w320 h80,&Shortcut folder
Gui,Add,Edit,xp+10 yp+20 w300 vsshortcutfolder,%shortcutfolder%
Gui,Add,Button,y+5 xp+225 w75 GBROWSE,&Browse
Gui,Add,GroupBox,xm y+20 w320 h50,&Extensions
Gui,Add,Edit,xp+10 yp+20 w300 vsextensions,%extensions%
Gui,Add,Button,xm y+20 w75 GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

BROWSE:
Gui,Submit,NoHide
IfNotInString,sshortcutfolder,\
  sshortcutfolder=%A_WorkingDir%\%sshortcutfolder%
FileSelectFolder,bselectfolder,*%sshortcutfolder%,3,RecentRun - Select a folder to store the shortcuts in
If bselectfolder<>
  GuiControl,,sshortcutfolder,%bselectfolder%
Return

SETTINGSOK:
Gui,Submit
sortbydate:=ssortbydate
deleteonstartup:=sdeleteonstartup
If snumberofshortcuts<>
  numberofshortcuts:=snumberofshortcuts
If smenuname<>
  menuname:=smenuname
If sshortcutfolder<>
  shortcutfolder:=sshortcutfolder
If sextensions<>
  extensions:=sextensions
StringReplace,extensions,extensions,%A_Space%
IniWrite,%sortbydate%,%applicationname%.ini,Settings,sortbydate
IniWrite,%deleteonstartup%,%applicationname%.ini,Settings,deleteonstartup
IniWrite,%numberofshortcuts%,%applicationname%.ini,Settings,numberofshortcuts
IniWrite,%menuname%,%applicationname%.ini,Settings,menuname
IniWrite,%shortcutfolder%,%applicationname%.ini,Settings,shortcutfolder
IniWrite,%extensions%,%applicationname%.ini,Settings,extensions
Goto,START
Return

SETTINGSCANCEL:
Gui,Destroy
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.5
Gui,99:Font
Gui,99:Add,Text,y+10,Shows a list of the most recently run programs on the Start menu and in the tray.
Gui,99:Add,Text,y+5,- Change the settings by choosing Settings in the Tray menu.
Gui,99:Add,Text,y+5,- To hide the tray icon, add /Hide to the command line.

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


INI:
IfNotExist,%applicationname%.ini
{
  IniWrite,0,%applicationname%.ini,Settings,sortbydate
  IniWrite,0,%applicationname%.ini,Settings,deleteonstartup
  IniWrite,30,%applicationname%.ini,Settings,numberofshortcuts
  IniWrite,Recent,%applicationname%.ini,Settings,menuname
  IniWrite,Recent,%applicationname%.ini,Settings,shortcutfolder
  IniWrite,.exe.com.cmd.bat.pif,%applicationname%.ini,Settings,extensions
}
IniRead,sortbydate,%applicationname%.ini,Settings,sortbydate
IniRead,deleteonstartup,%applicationname%.ini,Settings,deleteonstartup
IniRead,numberofshortcuts,%applicationname%.ini,Settings,numberofshortcuts
IniRead,menuname,%applicationname%.ini,Settings,menuname
IniRead,shortcutfolder,%applicationname%.ini,Settings,shortcutfolder
IniRead,extensions,%applicationname%.ini,Settings,extensions
StringReplace,extensions,extensions,%A_Space%
If menuname=ERROR
  menuname=Recent
If shortcutfolder=ERROR
  shortcutfolder=Recent
Return


EXIT:
ExitApp


GetModuleFileNameEx( p_pid ) ;By shimanov at http://www.autohotkey.com/forum/viewtopic.php?t=4182&postdays=0&postorder=asc&highlight=full+path&start=15
{ 
  if A_OSVersion in WIN_95,WIN_98,WIN_ME 
    return
  h_process := DllCall( "OpenProcess", "uint", 0x8|0x10|0x400, "int", false, "uint", p_pid ) 
  if ( ErrorLevel or h_process = 0 ) 
    return
  name_size = 255 
  VarSetCapacity( name, name_size ) 
  result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size ) 
  DllCall( "CloseHandle", h_process ) 
  return, name 
}