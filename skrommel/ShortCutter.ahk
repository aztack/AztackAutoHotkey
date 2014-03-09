;ShortCutter.ahk
; Make autoupdating collections of shortcuts to certain filetypes
;Skrommel @ 2006

#Persistent
#SingleInstance,Force

applicationname=ShortCutter
open=0
Gosub,INIREAD
Gosub,TRAYMENU
If enabled=1
  enabled=0
Else
  enabled=1
Gosub,TOGGLE

Process,Priority,,Low
Gosub,TIMER
Return


TIMER:
If enabled=0
  Return
SetTimer,TIMER,%timer%,Off
Loop,%rules%
{
  active:=%A_Index%active
  If active=0
    Continue
  source:=%A_Index%source
  target:=%A_Index%target
  files:=%A_Index%files
  ignore:=%A_Index%ignore
  recurse:=%A_Index%recurse
  If (source="" Or target="")
    Continue
  Menu,Tray,Tip,%applicationname% - %files%
  FileCreateDir,%target%
  FileSetAttrib,-A,%target%\*.lnk,0,0
  Gosub,FIND
  Loop,%target%\*.lnk,0,0
  {
    Sleep,%delay%
    FileGetAttrib,attrib,%A_LoopFileLongPath%
    IfNotInString,attrib,A
    {
      FileGetShortcut,%A_LoopFileLongPath%,linktarget
      IfNotExist,%linktarget%
        FileDelete,%A_LoopFileLongPath%
    }
  }
}
SetTimer,TIMER,%timer%,On
Return


FIND:
Loop,%source%\*.*,2,% (recurse="Yes")
{
  Sleep,%delay%
  If enabled=0
    Return
  folderpath:=A_LoopFileLongPath
  If status=1
    TrayTip,%applicationname%,%folderpath%
  Loop,Parse,files,`,
  {
    type:=A_LoopField
    Loop,%folderpath%\%type%,0,0
    {
      path:=A_LoopFileLongPath
      name:=A_LoopFileName
      If path Contains %ignore%
        Continue
      exist=0
      counter=0
      version=
      Loop
      {
        Sleep,%delay%
        If counter>0
          version=-%counter%
        IfExist,%target%\%A_LoopFileName%%version%.lnk
        {
          FileGetShortcut,%target%\%A_LoopFileName%%version%.lnk,linktarget
          If (linktarget=path)
          {
            exist=1
            Break
          }
          counter+=1
        }
        Else
          Break
      }
      If exist=0
      {
        FileCreateShortcut,%path%,%target%\%A_LoopFileName%%version%.lnk,%folderpath%,,%path%
        FileGetTime,date,%path%,M 
        FileSetTime,%date%,%target%\%A_LoopFileName%%version%.lnk
      }
      Else
      {
        FileSetAttrib,+A,%target%\%A_LoopFileName%%version%.lnk
        FileGetTime,date,%path%,M 
        FileSetTime,%date%,%target%\%A_LoopFileName%%version%.lnk
      }
    }
  }
}
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  start=1
  delay=5
  timer=60000
  status=0

  1active=1
  1source=C:\
  1target=%A_Desktop%\Images
  1files=*.jpg,*.jpeg
  1ignore=Recycled,Temporary
  1recurse=Yes

  2active=1
  2source=C:\
  2target=%A_Desktop%\Music
  2files=*.mp3
  2ignore=Recycled,Temporary
  2recurse=Yes
  
  rules=2
  Gosub,INIWRITE
}
Else
{
  IniRead,start,%applicationname%.ini,Settings,start
  If start=1
    enabled=1
  Else
    enabled=0
  IniRead,delay,%applicationname%.ini,Settings,delay
  IniRead,timer,%applicationname%.ini,Settings,timer
  IniRead,status,%applicationname%.ini,Settings,status
  rules=1
  Loop
  {
    IniRead,active,%applicationname%.ini,%A_Index%,active
    IniRead,source,%applicationname%.ini,%A_Index%,source
    IniRead,target,%applicationname%.ini,%A_Index%,target
    IniRead,files,%applicationname%.ini,%A_Index%,files
    IniRead,ignore,%applicationname%.ini,%A_Index%,ignore
    IniRead,recurse,%applicationname%.ini,%A_Index%,recurse
    If (source="ERROR" And target="ERROR" And files="ERROR")
      Break
    If (source="" And target="" And files="")
      Break
    %rules%active:=active
    %rules%source:=source
    %rules%target:=target
    %rules%files:=files
    %rules%ignore:=ignore
    %rules%recurse:=recurse
    rules+=1
  }
  rules-=1
}
Return


INIWRITE:
Iniwrite,%start%,%applicationname%.ini,Settings,start
Iniwrite,%delay%,%applicationname%.ini,Settings,delay
Iniwrite,%timer%,%applicationname%.ini,Settings,timer
Iniwrite,%status%,%applicationname%.ini,Settings,status
count=1
Loop,%rules%
{
  If (%A_Index%source="" And %A_Index%target="" And %A_Index%files="" And %A_Index%ignore="" And %A_Index%recurse="")
  {
    IniDelete,%applicationname%.ini,%A_Index%,
    Continue
  }
  active:=%A_Index%active
  source:=%A_Index%source
  target:=%A_Index%target
  files:=%A_Index%files
  ignore:=%A_Index%ignore
  recurse:=%A_Index%recurse
  Iniwrite,%active%,%applicationname%.ini,%count%,active
  Iniwrite,%source%,%applicationname%.ini,%count%,source
  Iniwrite,%target%,%applicationname%.ini,%count%,target
  Iniwrite,%files%,%applicationname%.ini,%count%,files
  Iniwrite,%ignore%,%applicationname%.ini,%count%,ignore
  Iniwrite,%recurse%,%applicationname%.ini,%count%,recurse
  count+=1
}
count-=1
rules:=count
Gosub,INIREAD
Return


SETTINGS:
oldenabled:=enabled
enabled=0
insert=0
Gui,99:Destroy
Gui,99:Add,Tab,w580 h370,Rules|Options
Gui,99:Tab,1
Gui,99:Add,ListView,w560 h300 GLISTVIEW NoSort -Multi Checked,Active|Source|Target|Files|Ignore|Recurse?
Gui,99:Default

Loop,%rules%
{
  If (%A_Index%source="" And %A_Index%target="" And %A_Index%files="" And %A_Index%ignore="" And %A_Index%recurse="")
    Continue
  LV_ADD("","",%A_Index%source,%A_Index%target,%A_Index%files,%A_Index%ignore,%A_Index%recurse)
  If %A_Index%active=1
    LV_Modify(LV_GetCount(),"Check")
}
LV_ADD("","","","","","","")

Gui,99:Tab,1
Gui,99:Add,Button,w75 x20 y340 GSETTINGSEDIT,&Edit
Gui,99:Add,Button,w75 x+5 GSETTINGSINSERT,&Insert
Gui,99:Add,Button,w75 x+5 GSETTINGSDELETE,&Delete

Gui,99:Add,Button,w75 x+5 GSETTINGSMOVEUP,Move &Up
Gui,99:Add,Button,w75 x+5 GSETTINGSMOVEDOWN,Move &Down

Gui,99:Tab,2
Gui,99:Add,GroupBox,x20 y50 w300,Timer - How often to check for new files?
Gui,99:Add,Edit,x30 yp+20 w75 votimer,% Floor(timer/1000)
Gui,99:Add,Text,x+5 yp+5,seconds

Gui,99:Add,GroupBox,x20 y+30 w300,Delay - How long to wait between file operations (0-100)?
Gui,99:Add,Edit,x30 yp+20 w75 vodelay,%delay%
Gui,99:Add,Text,x+5 yp+5,ms

Gui,99:Add,GroupBox,x20 y+30 w300,Status
If status=1
  Gui,99:Add,CheckBox,xp+10 yp+20 vostatus Checked,Show status in the tray
Else
  Gui,99:Add,CheckBox,xp+10 yp+20 vostatus,Show status in the tray
Gui,99:Add,GroupBox,x20 y+30 w300,Startup
If start=1
  Gui,99:Add,CheckBox,xp+10 yp+20 vostart Checked,Start enabled
Else
  Gui,99:Add,CheckBox,xp+10 yp+20 vostart,Start enabled
Gui,99:Tab
Gui,99:Add,Button,x425 y340 w75 Default GSETTINGSOK,&OK
Gui,99:Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel

Gui,99:Show,w600 h390,%Applicationname% Settings
Return


LISTVIEW:
If A_GuiEvent=DoubleClick
  Gosub,SETTINGSEDIT
Return


SETTINGSINSERT:
row:=LV_GetNext(0,"Focused") 
insert=1
Gosub,SETTINGSEDIT
Return


SETTINGSDELETE:
row:=LV_GetNext(0,"Focused") 
If (row=LV_GetCount())
  Return
LV_Delete(row)
LV_Modify(row,"Select")
LV_Modify(row,"Focus")
Return


SETTINGSEDIT:
row:=LV_GetNext(0,"Focused")
If row=0
  Return
LV_GetText(source,row,2)
LV_GetText(target,row,3)
LV_GetText(files,row,4)
LV_GetText(ignore,row,5)
LV_GetText(recurse,row,6)

Gui,98:Destroy
Gui,98:+ToolWindow

Gui,98:Add,GroupBox,x10 w560 h50,&Source - Where to look for files
Gui,98:Add,Edit,xp+10 yp+20 w460 vosource,%source%
Gui,98:Add,Button,x+5 yp w75 GBROWSESOURCE,&Browse...

Gui,98:Add,GroupBox,x10 y+20 w560 h50,&Target - Where to store the shortcuts
Gui,98:Add,Edit,xp+10 yp+20 w460 votarget,%target%
Gui,98:Add,Button,x+5 yp w75 GBROWSETARGET,B&rowse...

Gui,98:Add,GroupBox,x10 y+20 w480 h70,&Files - What files to create shortcuts to
Gui,98:Add,Edit,xp+10 yp+20 w460 vofiles,%files%
Gui,98:Add,Text,y+5 300,Supports wildcards * ?. Example: *.jp*g

Gui,98:Add,GroupBox,x10 y+20 w480 h70,&Ignore - What (parts of) filenames to ignore
Gui,98:Add,Edit,xp+10 yp+20 w460 voignore,%ignore%
Gui,98:Add,Text,y+5 300,No wildcards. Example: jpg,jpeg,C:\Boot.ini

options=No|Yes|
StringReplace,options,options,%recurse%,%recurse%|
Gui,98:Add,GroupBox,x10 y+20 w300 h70,&Recurse - Search subfolders?
Gui,98:Add,DropDownList,xp+10 yp+20 w150 vorecurse,%options%
Gui,98:Add,Text,y+5 300,No, Yes

Gui,98:Add,Button,x420 y340 w75 Default GEDITOK,&OK
Gui,98:Add,Button,x+5 w75 GEDITCANCEL,&Cancel

Gui,98:Show,w580 h370,%applicationname% Edit
Return


BROWSESOURCE:
Gui,98:+LastFound
guiid:=WinExist("A")
ControlGetText,sourcefolder,Edit1,ahk_id %guiid% 
FileSelectFolder,chosenfolder,*%sourcefolder%,3,Select a source folder
If chosenfolder=
  chosenfolder:=sourcefolder
ControlSetText,Edit1,%chosenfolder%,ahk_id %guiid%
Return


BROWSETARGET:
Gui,98:+LastFound
guiid:=WinExist("A")
ControlGetText,targetfolder,Edit2,ahk_id %guiid% 
FileSelectFolder,chosenfolder,*%targetfolder%,3,Select a target folder
If chosenfolder=
  chosenfolder:=targetfolder
ControlSetText,Edit2,%targetfolder%,ahk_id %guiid%
Return


EDITOK:
Gui,98:Submit,NoHide
If (osource="" Or otarget="" Or ofiles="")
  MsgBox,0,%applicationname% - Error,Please fill inn Source, Target and Files
Else
{
  Gui,99:Default
  If insert=1
    LV_Insert(row,"Focus","",osource,otarget,ofiles,oignore,orecurse)
  Else
  {    
    LV_Modify(row,"Focus","",osource,otarget,ofiles,oignore,orecurse)
    If (row=LV_GetCount())
      LV_ADD("","","","","","","")
  }
  Gosub,EDITCANCEL
}
Return


EDITCANCEL:
Gui,98:Destroy
insert=0
Return


SETTINGSMOVEUP:
row:=LV_GetNext(0,"Focused")
If row=1
  Return
If (row=LV_GetCount())
  Return
LV_GetText(source2,row,2)
LV_GetText(target2,row,3)
LV_GetText(files2,row,4)
LV_GetText(ignore2,row,5)
LV_GetText(recurse2,row,6)

row-=1
LV_GetText(source1,row,2)
LV_GetText(target1,row,3)
LV_GetText(files1,row,4)
LV_GetText(ignore1,row,5)
LV_GetText(recurse1,row,6)

LV_Modify(row,"Select","",source2,target2,files2,ignore2,recurse2)
LV_Modify(row,"Focus")

row+=1
LV_Modify(row,"","",source1,target1,files1,ignore1,recurse1)
Return


SETTINGSMOVEDOWN:
row:=LV_GetNext(0,"Focused") 
If (row>=LV_GetCount()-1)
  Return
LV_GetText(source2,row,2)
LV_GetText(target2,row,3)
LV_GetText(files2,row,4)
LV_GetText(ignore2,row,5)
LV_GetText(recurse2,row,6)

row+=1
LV_GetText(source1,row,2)
LV_GetText(target1,row,3)
LV_GetText(files1,row,4)
LV_GetText(ignore1,row,5)
LV_GetText(recurse1,row,6)

LV_Modify(row,"Select","",source2,target2,files2,ignore2,recurse2)
LV_Modify(row,"Focus")

row-=1
LV_Modify(row,"","",source1,target1,files1,ignore1,recurse1)
Return


SETTINGSOK:
Gui,99:Submit,NoHide
If otimer>0
  timer:=otimer*1000
If odelay>0
  delay:=odelay
status:=ostatus
start:=ostart
count=1
Loop % LV_GetCount()
{
  checked:=LV_GetNext(count-1,"Checked")
  If (checked=count)
    %count%active=1
  Else
    %count%active=0
  LV_GetText(%count%source,A_Index,2)
  LV_GetText(%count%target,A_Index,3)
  LV_GetText(%count%files,A_Index,4)
  LV_GetText(%count%ignore,A_Index,5)
  LV_GetText(%count%recurse,A_Index,6)
  If (%count%source="" And %count%target="" And %count%files="" And %count%ignore="" And %count%recurse="")
    Continue
  count+=1
}
rules:=count
Gosub,INIWRITE
Gosub,SETTINGSCANCEL
Return


SETTINGSCANCEL:
Gui,98:Destroy
Gui,99:Destroy
enabled:=oldenabled
Gosub,TIMER
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,SETTINGS
Menu,Tray,Add
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&Enabled,TOGGLE
Menu,Tray,Add
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


TOGGLE:
If enabled=1
{
  enabled=0
  Menu,Tray,UnCheck,&Enabled
  ;Menu,Tray,Icon,%applicationname%.exe,3
}
Else
{
  enabled=1
  Menu,Tray,Check,&Enabled
  ;Menu,Tray,Icon,%applicationname%.exe,1
}  
Return


ABOUT:
Gui,97:Destroy
Gui,97:Add,Picture,Icon1,%applicationname%.exe
Gui,97:Font,Bold
Gui,97:Add,Text,x+10 yp+10,%applicationname% v1.1
Gui,97:Font
Gui,97:Add,Text,xm,Make autoupdating collections of shortcuts to certain filetypes.
Gui,97:Add,Text,xm,- Rightclick the tray icon to configure
Gui,97:Add,Text,xm,- Choose Settings to change rules and options
Gui,97:Add,Text,xm,- Choose Enable to Start or Stop all the rules
Gui,97:Add,Text,y+0,`t

Gui,97:Add,Picture,xm Icon5,%applicationname%.exe
Gui,97:Font,Bold
Gui,97:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,97:Font
Gui,97:Add,Text,xm,For more tools, information and donations, visit
Gui,97:Font,CBlue Underline
Gui,97:Add,Text,xm G1HOURSOFTWARE,www.1HourSoftware.com
Gui,97:Font
Gui,97:Add,Text,y+0,`t

Gui,97:Add,Picture,xm Icon7,%applicationname%.exe
Gui,97:Font,Bold
Gui,97:Add,Text,x+10 yp+10,DonationCoder
Gui,97:Font
Gui,97:Add,Text,xm,Please support the DonationCoder community
Gui,97:Font,CBlue Underline
Gui,97:Add,Text,xm GDONATIONCODER,www.DonationCoder.com
Gui,97:Font
Gui,97:Add,Text,y+0,`t

Gui,97:Add,Picture,xm Icon6,%applicationname%.exe
Gui,97:Font,Bold
Gui,97:Add,Text,x+10 yp+10,AutoHotkey
Gui,97:Font
Gui,97:Add,Text,xm,This program was made using AutoHotkey
Gui,97:Font,CBlue Underline
Gui,97:Add,Text,xm GAUTOHOTKEY,www.AutoHotkey.com
Gui,97:Font
Gui,97:Add,Text,y+0,`t

Gui,97:Add,Button,GABOUTOK Default w75,&OK
Gui,97:Show,,%applicationname% About

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

ABOUTOK:
Gui,97:Destroy
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,winid,ctrl
  If ctrl in Static12,Static17,Static22
    DllCall("SetCursor","UInt",hCurs)
}

EXIT:
ExitApp
