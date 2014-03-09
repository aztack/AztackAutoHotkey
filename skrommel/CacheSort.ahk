;CacheSort.ahk
; Automatically moves files from Internet Explorer's cache 
; into folders based on their extensions.
;Skrommel @2005    www.donationcoders.com/skrommel

#SingleInstance,Force
SetBatchLines,-1

applicationname=CacheSort

Gosub,READINI
Gosub,TRAYMENU
FileCreateDir,%targetpath%
TrayTip,%applicationname%,Sorting files into %targetpath%...
Gosub,UPDATE
TrayTip,
SetTimer,UPDATE,%updateinterval%
Return

UPDATE:
FileGetAttrib,attrib,%applicationname%.ini
IfInString,attrib,A
{
  FileSetAttrib,-A,%applicationname%.ini
  Reload
}
SetTimer,UPDATE,Off
Loop,%sourcepath%\*.*,0,1
{
  Sleep,1
  FileGetAttrib,attrib,%A_LoopFileLongPath%
  IfNotInString,attrib,A
    Continue
  FileSetAttrib,-A,%A_LoopFileLongPath%
  FileGetSize,size,%A_LoopFileLongPath%,K
  If size<%filesize%
    Continue
  SplitPath,A_LoopFileLongPath,name,dir,ext,name_no_ext,drive
  If filetypes<>
  IfNotInString,filetypes,%ext%`,
    Continue
  If name In %filestoignore%
    Continue
  FileGetTime,date,%A_LoopFileLongPath%,C
  targetname=%name_no_ext%_%date%.%ext%
  If sortbyext=1
  {
    targetfullpath=%targetpath%\%ext%\%targetname%
    FileCreateDir,%targetpath%\%ext%
  }
  Else
    targetfullpath=%targetpath%\%targetname%
  If movefiles=1
    FileMove,%A_LoopFileLongPath%,%targetfullpath%
  Else
    FileCopy,%A_LoopFileLongPath%,%targetfullpath%
  If ErrorLevel=0
  {
    If notify=1
      TrayTip,%applicationname%,Sorting %name%...
    If notifyaction=1
      Run,%notifycommand% %targetfullpath%
  }
}
TrayTip,
SetTimer,UPDATE,%updateinterval%
Return


READINI:
IfNotExist,%applicationname%.ini
{
  RegRead,sourcefolder,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Cache
  inifile=;%applicationname%.ini
  inifile=%inifile%`n`;[Settings]
  inifile=%inifile%`n`;sourcepath=%sourcefolder%			`;Where to find the files
  inifile=%inifile%`n`;targetpath=C:\%applicationname%				`;where to put the sorted files
  inifile=%inifile%`n`;movefiles=1						`;0=Copy 1=Move  Move or copy files?
  inifile=%inifile%`n`;sortbyext=1						`;1=yes 0=no  Sort files into folders named after their extension?
  inifile=%inifile%`n`;filesize=50						`;Ignore files smaller than this value
  inifile=%inifile%`n`;filetypes=avi,mpeg,mpg,mov,divx,mp4,swf,wmv		`;Names of filetypes to sort, leave empty to sort all filetypes 
  inifile=%inifile%`n`;filestoignore=index.dat,thumbs.db			`;Names of files to ignore
  inifile=%inifile%`n`;updateinterval=60					`;How often to check for new files, time in seconds
  inifile=%inifile%`n`;notify=1						`;1=yes 0=no  Show a tray notification when a file is moved?
  inifile=%inifile%`n`;notifyaction=0						`;1=yes 0=no  Run the traycommand action when a file is moved?
  inifile=%inifile%`n`;notifycommand=pbrush.exe				`;Command to run when a file is moved
  inifile=%inifile%`n`;traycommand=explorer.exe /e`,C:\%applicationname%		`;Command to run when doubleclicking the tray icon
  inifile=%inifile%`n
  inifile=%inifile%`n[Settings]
  inifile=%inifile%`nsourcepath=%sourcefolder%
  inifile=%inifile%`ntargetpath=C:\%applicationname%
  inifile=%inifile%`nmovefiles=1
  inifile=%inifile%`nsortbyext=1
  inifile=%inifile%`nfilesize=50
  inifile=%inifile%`nfiletypes=avi,mpeg,mpg,mov,divx,mp4,jpg,mp3,swf,wmv
  inifile=%inifile%`nfilestoignore=index.dat,thumbs.db
  inifile=%inifile%`nupdateinterval=10
  inifile=%inifile%`nnotify=1
  inifile=%inifile%`nnotifyaction=0
  inifile=%inifile%`nnotifycommand=pbrush.exe
  inifile=%inifile%`ntraycommand=explorer.exe /e`,C:\%applicationname%
  FileAppend,%inifile%,%applicationname%.ini
  inifile=
}
IniRead,sourcepath,%applicationname%.ini,Settings,sourcepath
IniRead,targetpath,%applicationname%.ini,Settings,targetpath
IniRead,movefiles,%applicationname%.ini,Settings,movefiles
IniRead,sortbyext,%applicationname%.ini,Settings,sortbyext
IniRead,filesize,%applicationname%.ini,Settings,filesize
IniRead,filetypes,%applicationname%.ini,Settings,filetypes
IniRead,filestoignore,%applicationname%.ini,Settings,filestoignore
IniRead,updateinterval,%applicationname%.ini,Settings,updateinterval
IniRead,notify,%applicationname%.ini,Settings,notify
IniRead,notifyaction,%applicationname%.ini,Settings,notifyaction
IniRead,notifycommand,%applicationname%.ini,Settings,notifycommand
IniRead,traycommand,%applicationname%.ini,Settings,traycommand
updateinterval*=1000
Return

EXPLORE:
Run,%traycommand%,,UseErrorLevel
Return

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,EXPLORE
Menu,Tray,Add,
Menu,Tray,Add,Explore Sorted &Cache,EXPLORE
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,SWAP
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Check,&Enabled
Menu,Tray,Tip,%applicationname%
Return

ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.1
Gui,99:Font
Gui,99:Add,Text,y+10,Automatically moves files from Internet Explorer's cache 
Gui,99:Add,Text,y+5,into folders based on their extensions.
Gui,99:Add,Text,y+10,- Change settings using Settings in the tray menu

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


SETTINGS:
Gosub,READINI
Run,%applicationname%.ini
Return

SWAP:
Menu,Tray,ToggleCheck,&Enabled
Pause,Toggle
Return

EXIT:
ExitApp
