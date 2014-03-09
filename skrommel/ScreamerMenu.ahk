;ScreamerMenu.ahk
; Get easy access to your Screamer Radio stations, and more
;Skrommel @ 2007

#NoEnv
#SingleInstance,Force
SetBatchLines,-1
SetWinDelay,0

applicationname=ScreamerMenu

Gosub,INIREAD

Gui,+Resize +ToolWindow ;-Border

Gui,Add,Tab,x0 y0 h 25 w360 AltSubmit vtab,Stations|Favorites|History|Record|Options|About

Gui,Tab,1
Gui,Add,Edit,x0 y26 w210 vedit -WantReturn
Gui,Add,Button,x210 y25 w75 Default vfilter GFILTER,&Filter
Gui,Add,Button,x285 y25 w75 vrefresh1 GREFRESH1,&Refresh
Gui,Add,ListView,x0 y50 vlistview1 GLISTVIEW,Line|Station|Category|Id|Filter

Gui,Tab,2
Gui,Add,ListView,x0 y50 vlistview2 GLISTVIEW,Line|Station|Category|Id|Filter
Gui,Add,Button,x135 y25 w75 vstartup2 GSTARTUP,&Startup >
Gui,Add,Button,x210 y25 w75 vschedule2 GSCHEDULE,&Schedule >
Gui,Add,Button,x285 y25 w75 vrefresh2 GREFRESH1,&Refresh

Gui,Tab,3
Gui,Add,ListView,x0 y50 vlistview3 GLISTVIEW,Line|Station|Category|Id|Filter
Gui,Add,Button,x210 y25 w75 vlog3 GSHOWLOG,&Show log
Gui,Add,Button,x285 y25 w75 vrefresh3 GREFRESH3,&Refresh

Gui,Tab,4
Gui,Add,GroupBox,x10 y+10 w350 h90,
Gui,Add,CheckBox,xp+10 yp vautorec Checked%autorec%,&Use Auto record
Gui,Add,Text,,Parts of song titles or artists' names:
Gui,Add,Edit,w330 vfavs,%favs%
Gui,Add,Text,,Example: Abba,Beatles,Hound Dog

Gui,Add,GroupBox,x10 y+20 w350 h195,
Gui,Add,CheckBox,xp+10 yp vrunschedule GRECORDINIT Checked,Use &Schedule
Gui,Add,Text,,&Station:
Gui,Add,CheckBox,x200 yp voactive Checked,&Active
Gui,Add,Edit,x20 y+5 w330 vostation,%station%
Gui,Add,Text,y+15,Time and date:
Gui,Add,DateTime,x+5 yp-5 vostarttime Choose%starttime% w100,Time
Gui,Add,DateTime,x+5 vostartdate w100,%startdate%

Gui,Add,Text,x20 y+10,Action:
Gui,Add,Radio,x20 y+5 voplay Checked,&Play
Gui,Add,Radio,x100 yp vostop,&Stop
Gui,Add,Radio,x20 y+5 vorecstart,&RecStart
Gui,Add,Radio,x100 yp vorecstop,Re&cStop

Gui,Add,Text,x200 yp-35,Schedule:
Gui,Add,Radio,x200 y+5 voonce Checked,&Once
Gui,Add,Radio,x280 yp voweekly,&Weekly
Gui,Add,Radio,x200 y+5 vodaily,&Daily
Gui,Add,Radio,x280 yp vomonthly,&Monthly

Gui,Add,Button,x20 y+10 w75 GSCHEDULEEDIT,&Edit  ^
Gui,Add,Button,x+5 w75 GSCHEDULEADD,&Add  v
Gui,Add,Button,x+5 w75 GSCHEDULEREPLACE,&Replace  v
Gui,Add,Button,x+5 w75 GSCHEDULEDELETE,&Delete  X
;Gui,Add,Button,x200 y+5 w155 vorun GRECORDINIT,R&un

Gui,Add,ListView,x0 y+10 vlistview4 GLISTVIEW Checked,Active|Station        |Time     |Date         |Interval|Actions

Gosub,READSCHEDULE

Gui,Tab,5
Gui,Add,GroupBox,x10 y+10 w350 h45,Snap to Screamer Radio
Gui,Add,Radio,x20 yp+20 vsnapnone Checked%snapnone%,None
Gui,Add,Radio,x+5 vsnapauto Checked%snapauto%,Auto
Gui,Add,Radio,x+5 vsnaptop Checked%snaptop%,Top
Gui,Add,Radio,x+5 vsnapbottom Checked%snapbottom%,Bottom
Gui,Add,CheckBox,x+5 vstretch Checked%stretch%,Stretch to fit

Gui,Add,GroupBox,x10 y+20 w350 h45,Titlebar
Gui,Add,CheckBox,x20 yp+20 vscrolling GSCROLLING Checked%scrolling%,Scroll song info accross the title bar

Gui,Add,GroupBox,x10 y+20 w350 h110,Startup and shutdown actions
Gui,Add,Text,x20 yp+20,Startup station:
Gui,Add,Edit,x100 w190 yp-3 vstartupstation,%startupstation%
Gui,Add,CheckBox,x20 y+5 vstart Checked%start%,Start Screamer Radio
Gui,Add,Text,,Screamer path:
Gui,Add,Edit,x100 yp-3 w190 r1 vscreamerpath,%screamerpath%
Gui,Add,Button,x+5 GBROWSE,Browse
Gui,Add,CheckBox,x20 y+5 vstop Checked%stop%,Stop Screamer Radio

Gui,Add,GroupBox,x10 y+20 w350 h50, ;Hotkeys  (Requires restart)
Gui,Add,CheckBox,xp+10 yp vusehotkeys Checked%usehotekeys%,Use &Hotkeys   (Requires restart)
Gui,Add,CheckBox,x+20 valllists Checked%alllists%,Works in the active list
Gui,Add,Text,x20 y+10,Modifiers:
Gui,Add,Edit,x100 yp-3 w50 vmodifiers,%modifiers%
Gui,Add,Text,x+10 yp+3,+=Shift  ^=Ctrl  !=Alt  #=Win

Gui,Add,GroupBox,x10 y+20 w350 h50, ;Log
Gui,Add,CheckBox,x20 yp vlog Checked%log%,&Save log
Gui,Add,Text,x20 y+10,Log size:
Gui,Add,Edit,x100 yp-3 w50 Right vlogsize,%logsize%
Gui,Add,Text,x+5 yp+3,KB   0=Unlimited

Gui,Tab,6
Gui,Add,Picture,xm y+10 Icon1,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.3
Gui,Font
Gui,Add,Text,xm y+20,Get easy access to your Screamer Radio stations
Gui,Add,Text,xm y+5,- List all stations in a simple listview
Gui,Add,Text,xm y+5,- Filter by a part of a station name or category
Gui,Add,Text,xm y+5,- Schedule recordings
Gui,Add,Text,xm y+5,- Automatically record your favorite artists
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm y+10 Icon5,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,xm y+20,For more tools, information and donations, visit
Gui,Font,CBlue Underline
Gui,Add,Text,xm y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm y+10 Icon7,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,DonationCoder
Gui,Font
Gui,Add,Text,xm y+20,Please support the DonationCoder community
Gui,Font,CBlue Underline
Gui,Add,Text,xm y+5 GDONATIONCODER,www.DonationCoder.com
Gui,Font
Gui,Add,Text,y+0,`t

Gui,Add,Picture,xm y+10 Icon6,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,AutoHotkey
Gui,Font
Gui,Add,Text,xm y+20,This program was made using AutoHotkey
Gui,Font,CBlue Underline
Gui,Add,Text,xm y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,Font
Gui,Add,Text,y+0,`t

Gosub,TRAYMENU

Loop,10
{
  key:=A_Index
  If key=10
    key=0
  Hotkey,%modifiers%%key%,HOTKEY
}
 
control=1
Gosub,REFRESH
control=2
Gosub,REFRESH
control=3
Gosub,REFRESH

If runschedule=1
  Gosub,RECORDINIT

If startupstation<>
  WinMenuSelectItem,ahk_id %screamerid%,,3&,%startupstation%

keys=

Gui,Show,,%applicationname%
Gui,+LastFound
smid:=WinExist("A")

autorecing=0
SetTimer,LOG,3000
SetTimer,MOVE,100
Return


MOVE:
  SetTimer,MOVE,Off
  WinWait,ahk_class #32770,!,0.2,,Slider1
  If ErrorLevel=0
  {
    WinGet,id,Id,ahk_class #32770
    parent:=DllCall("GetParent",UInt,id)
    If (parent=screamerid)
    {
      WinGetTitle,title,ahk_id %id%
      WinClose,ahk_id %id%
      TrayTip,%applicationname%,%title%
    }
  }
  WinGet,exstyle,ExStyle,ahk_id %screamerid%
  screamerontop:=(exstyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
  WinGet,exstyle,ExStyle,ahk_id %smid%
  ontop:=(exstyle & 0x8)
  If (ontop<>screamerontop)
  If screamerontop
    WinSet,AlwaysOnTop,On,ahk_id %smid%
  Else  
    WinSet,AlwaysOnTop,Off,ahk_id %smid%

  WinGetPos,x,y,w,h,ahk_id %screamerid%
  WinGetPos,smx,smy,smw,smh,ahk_id %smid%
  SysGet,work,MonitorWorkArea

;  Gui,Submit,NoHide

  If snapauto=1
  {
    If (y+h+100>=workBottom-workTop)
      WinMove,ahk_id %smid%,,% x,% workTop,% w,% y-workTop
    Else
      WinMove,ahk_id %smid%,,% x,% y+h,% w,% workBottom-workTop-y-h
  }

  snapy=
  snaph=
  If snaptop=1
  {
    If stretch=1
    {
      snapy:=workTop
      snaph:=y-workTop
    }
    Else
      snapy:=y-smh
  }

  If snapbottom=1
  {
    snapy:=y+h
    If stretch=1
      snaph:=workBottom-workTop-y-h
  }
  
  If snapnone=0
    WinMove,ahk_id %smid%,,% x,% snapy,% w,% snaph

  oldactiveid:=activeid
  WinGet,activeid,Id,A
  If activeid Not In %screamerid%,%smid%
    WinHide,ahk_id %smid%
  Else
  IfWinNotExist,ahk_id %screamerid%
    WinHide,ahk_id %smid%
  Else
  IfWinNotExist,ahk_id %smid%
    WinShow,ahk_id %smid%

  If (activeid<>oldactiveid)
  If (activeid=screamerid)
    WinSet,Topmost,,ahk_id %smid%
  
  oldactive:=active

  IfWinExist,Screamer Radio ahk_class #32770,Presets
    WinClose,Screamer Radio ahk_class #32770,Presets

  If scrolling=1
  If scrollength>20
  {
    scrollpos+=1
    If (scrollpos>scrollength)
      scrollpos=0
    AutoTrim,Off
    oldtitlebar:=titlebar
    WinGetTitle,titlebar,ahk_id %screamerid%
    If (titlebar=titletext)
      titlebar:=oldtitlebar
    If (song<>titlebar)
      titletext:=name . "          "
    Else
      titletext:=song . "          "
    StringLeft,last,titletext,% scrollpos
    StringRight,first,titletext,% scrollength-scrollpos
    titletext=%first%%last%
    AutoTrim,On
    WinSetTitle,ahk_id %screamerid%,,%titletext%
  }
  SetTimer,MOVE,100
Return


REFRESH1:
TrayTip,%applicationname%,Refreshing channels...
control=1
Gosub,REFRESH
TrayTip
Return

REFRESH2:
control=2
Gosub,REFRESH
Return

REFRESH3:
control=3
Gosub,REFRESH
Return


REFRESH:
DetectHiddenWindows,On
WinGet,dialogs,List,ahk_class #32770,Slider1
id=0
Loop,%dialogs%
{
  id:=dialogs%A_Index%
  WinGet,process,ProcessName,ahk_id %id%
  If process=screamer.exe
    Break
}
If id=0
{
  If start=1
  {
    Run,%screamerpath%,,UseErrorLevel,screamerpid
    Sleep,3000
    WinWait,ahk_pid %screamerpid%,,5
    If ErrorLevel=1
    {
      TrayTip,%applicationname%,Can't find Screamer Radio!
      Sleep,3000
      ExitApp
    }
    Sleep,2000
    Goto,REFRESH
  }  
}

Loop
{
  parent:=DllCall("GetParent",UInt,id)
  If parent=0
    Break
  id:=parent
}

screamerid:=id
hMenu:=DllCall("GetMenu","UInt",screamerid) 
If hMenu=0
{
  TrayTip,%applicationname%,Can't connect to Screamer Radio!
  Sleep,3000
  ExitApp
}

GuiControl,-Redraw,listview%control% 
Gui,ListView,listview%control%
LV_Delete()
If control=1 
  GetMenu(hMenu,0,4,0,control) 
If control=2
  GetMenu(hMenu,0,3,0,control) 
If control=3
  GetMenu(hMenu,0,1,1,control) 
LV_ModifyCol()
LV_ModifyCol(1,"Integer")
LV_ModifyCol(4,0)
LV_ModifyCol(5,0)
GuiControl,+Redraw,listview%control% 
DetectHiddenWindows,Off
Return 


FILTER:
Gui,Submit,NoHide
If edit=
{
  Gosub,REFRESH
  Return
}
GuiControl,-Redraw,listview1 
Gui,ListView,listview1
line=1
Loop % LV_GetCount()
{
  LV_GetText(menu,line,2)
  LV_GetText(location,line,3)
  If (InStr(menu,edit) Or InStr(location,edit))
  {
    LV_Modify(line,"Col1",line)
    line+=1
  }
  Else
  {
    LV_Delete(line)
  }
}
;LV_ModifyCol(1,"Sort")
GuiControl,+Redraw,listview1 
Return


STARTUP:
StringRight,control,A_GuiControl,1
Gui,ListView,listview%control%
row:=LV_GetNext(0)
LV_GetText(station,row,2)
GuiControl,,startupstation,%station%
GuiControl,Choose,tab,5
Return


SCHEDULE:
StringRight,control,A_GuiControl,1
Gui,ListView,listview%control%
row:=LV_GetNext(0)
LV_GetText(station,row,2)
GuiControl,,ostation,%station%
GuiControl,Choose,tab,4
Return


SCHEDULEEDIT:
action=Edit
StringRight,control,A_GuiControl,1
Gui,ListView,listview%control%
row:=LV_GetNext(0)

active=0
checked:=LV_GetNext(row-1,"C")
If (checked=row)
  active=1
LV_GetText(station,row,2)
LV_GetText(starttime,row,3)
LV_GetText(startdate,row,4)
LV_GetText(interval,row,5)
LV_GetText(actions,row,6)

GuiControl,,ostation,%station%
GuiControl,,oactive,%active%
GuiControl,,ostarttime,%startdate%%starttime%
GuiControl,,ostartdate,%startdate%

If interval=Once
  GuiControl,,oonce,1
Else
If interval=Daily
  GuiControl,,odaily,1
Else
If interval=Weekly
  GuiControl,,oweekly,1
Else
If interval=Monthly
  GuiControl,,omontly,1

oplay=0
If actions Contains Play
  oplay=1
GuiControl,,oplay,%oplay%
ostop=0
If actions Contains Stop
  ostop=1
GuiControl,,ostop,%ostop%
orecstart=0
If actions Contains RecStart
  orecstart=1
GuiControl,,orecstart,%orecstart%
orecstop=0
If actions Contains RecStop
  orecstop=1
GuiControl,,orecstop,%orecstop%
Return


SCHEDULEADD:
action=Add
Gosub,SCHEDULEOK
Return


SCHEDULEDELETE:
Gui,ListView,listview4
row:=LV_GetNext(0)
LV_Delete(row)
Return


SCHEDULEREPLACE:
action=Replace


SCHEDULEOK:
Gui,Submit,NoHide
If ostation<>
  station:=ostation
active:="-Check"
If oactive=1
  active:="Check"
StringLeft,startdate,ostartdate,8
StringRight,starttime,ostarttime,6
If oonce=1
  interval=Once
Else
If odaily=1
  interval=Daily
Else
If oweekly=1
  interval=Weekly
Else
If omonthly=1
  interval=Monthly

actions=
If oplay=1
  actions=%actions% Play
If ostop=1
  actions=%actions% Stop
If orecstart=1
  actions=%actions% RecStart
If orecstop=1
  actions=%actions% RecStop

Gui,ListView,listview4
If action=Add
{
  LV_Add("","",station,starttime,startdate,interval,actions)
  row:=LV_GetCount()
  LV_Modify(row,active)
}
Else
If action=Replace
{
  row:=LV_GetNext(0)
  LV_Modify(row,"","",station,starttime,startdate,interval,actions)
  LV_Modify(row,active)  
}
Gosub,RECORDINIT
Return


RECORDINIT:
Gui,Submit,NoHide
If runschedule=0
{
  SetTimer,RECORDLOOP,Off
  Return
}

Gui,ListView,listview4
rows:=0
Loop,% LV_GetCount()
{
  checked:=LV_GetNext(A_Index-1,"C")
  If (checked<>A_Index)
    Continue
  rows+=1
  LV_GetText(station%rows%,A_Index,2)
  LV_GetText(starttime,A_Index,3)
  LV_GetText(startdate,A_Index,4)
  LV_GetText(interval%rows%,A_Index,5)
  LV_GetText(actions%rows%,A_Index,6)
  start%rows%=%startdate%%starttime%

  Loop
  {
    If interval%rows%=Once
      Break
    If interval%rows%=Hourly
      start%rows%+=1,Hours
    If interval%rows%=Daily
      start%rows%+=1,Days
    If interval%rows%=Weekly
      start%rows%+=7,Days
    If interval%rows%=Monthly
      start%rows%+=28,Days
    If (start%rows%>=A_Now)
      Break
  }
}

SetTimer,RECORDLOOP,1000
Return


RECORDLOOP:
SetTimer,RECORDLOOP,Off
now:=A_Now
next:=now
next+=3,Seconds

Loop,% rows
{
  If (start%A_Index%>=now And start%A_Index%<=next)
  {
    station:=station%A_Index%
    actions:=actions%A_Index%
    TrayTip,%applicationname%,%actions% %station%
    If actions In Play,RecStart
    {
      If station<>
      {
        WinMenuSelectItem,ahk_id %screamerid%,,3&,%station%
        Sleep,3000
      }
      ControlSend,Button2,{Space},ahk_id %screamerid%
    }
    If actions In Stop
      ControlSend,Button3,{Space},ahk_id %screamerid%
    If actions In Mute
      ControlSend,Button5,{Space},ahk_id %screamerid%
    If actions In RecStart
    {
      ControlGetText,rectext,Button8,ahk_id %screamerid%
      If rectext Not Contains !
        ControlSend,Button8,!r,ahk_id %screamerid%
    }
    If actions In RecStop
    {
      ControlGetText,rectext,Button8,ahk_id %screamerid%
      If rectext Contains !
        ControlSend,Button8,!r,ahk_id %screamerid%
    }
    Sleep,3000
  }
  
  If (start%A_Index%<now)
  Loop
  {
    If interval%A_Index%=Once
      Break
    If interval%A_Index%=Hourly
      start%A_Index%+=1,Hours
    If interval%A_Index%=Daily
      start%A_Index%+=1,Days
    If interval%A_Index%=Weekly
      start%A_Index%+=7,Days
    If interval%A_Index%=Monthly
      start%A_Index%+=28,Days
    If (start%A_Index%>=A_Now)
      Break
  }
}
SetTimer,RECORDLOOP,1000
Return


HOTKEY:
SetTimer,DOHOTKEY,Off
StringRight,key,A_ThisHotkey,1
keys=%keys%%key%
ToolTip,%keys%
SetTimer,DOHOTKEY,1000
Return


DOHOTKEY:  
SetTimer,DOHOTKEY,Off
If alllists=0
{
  keys+=2
  WinMenuSelectItem,ahk_id %screamerid%,,3&,%keys%&
}
Else
{
  Gui,Submit,NoHide
  GuiControlGet,activetab,,tab
  If activetab<=3
  {
    Gui,ListView,listview%activetab%
    LV_GetText(nID,keys,4)
    PostMessage,0x111,nID,0,,ahk_id %screamerid%
  }
}
keys=
ToolTip
Return


SCROLLING:
Gui,Submit,NoHide
If scrolling=0
  WinSetTitle,ahk_id %screamerid%,,%name%
Else
  WinSetTitle,ahk_id %screamerid%,,%song%
Return


LOG:
SetTimer,LOG,Off
Gui,Submit,NoHide
oldname:=name
oldsong:=song
ControlGetText,name,Static4,ahk_id %screamerid%
ControlGetText,url,Static5,ahk_id %screamerid%
ControlGetText,song,Static1,ahk_id %screamerid%
ControlGetText,format,Static2,ahk_id %screamerid%
StatusBarGetText,stream,2,ahk_id %screamerid%

If (name<>oldname)
{
  If log=1
    FileAppend,`n%name%`n%url%`n%stream%`n%format%`n,%A_ScriptDir%\log.txt
}

If (song<>oldsong)
{
  Loop
  {
    WinGetTitle,titlebar,ahk_id %screamerid%
    scrollength:=StrLen(titlebar)
    scrollpos=0
    If titlebar<>
      Break
    Sleep,100
  }

  Gosub,REFRESH2
  Gosub,REFRESH3

  If log=1
    FileAppend,%A_Now% - %song%`n,%A_ScriptDir%\log.txt
  
  If autorec=1
  {
    If autorecing=0
    {
      If song Contains %favs%
      {
        ControlGetText,rectext,Button8,ahk_id %screamerid%
        If rectext Not Contains !
        {
          autorecing=1
          recsong=%song%
          ControlSend,Button8,!r,ahk_id %screamerid%
          TrayTip,%applicationname%,Autorecording %song%...
          Sleep,1000
        }
      }
    }
    Else
    If autorecing=1
    {
      If song Not Contains %favs%
      {
        autorecing=0
        recsong=
        ControlGetText,rectext,Button8,ahk_id %screamerid%
        If rectext Contains !
        {
          ControlSend,Button8,!r,ahk_id %screamerid%
          TrayTip,%applicationname%,Stopped autorecording %recsong%...
          Sleep,1000
        }
      }
    }
  }
}
SetTimer,LOG,1000
Return


SHOWLOG:
Run,%A_ScriptDir%\log.txt
Return


LISTVIEW:
If A_GuiEvent=DoubleClick
{
  StringRight,control,A_GuiControl,1
  Gui,ListView,listview%control%
  If control=4
  {
    Gosub,SCHEDULEEDIT
    Return
  }
  LV_GetText(nID,A_EventInfo,4)
  PostMessage,0x111,nID,0,,ahk_id %screamerid%
}
Return


SHOW:
WinShow,ahk_id %smid%
WinSet,Topmost,ahk_id %smid%
Return


BROWSE:
FileSelectFile,SelectedFile,3,,Locate Screamer,Screamer (screamer.exe)
If SelectedFile=
  MsgBox,No file selected
Else
  GuiControl,,screamerpath,%SelectedFile%
Return


GuiSize:
If A_EventInfo = 1
  Return
GuiControl,Move,tab,% "W" . (A_GuiWidth) . " H" . (A_GuiHeight)
GuiControl,Move,listview1,% "W" . (A_GuiWidth) . " H" . (A_GuiHeight-50)
GuiControl,Move,listview2,% "W" . (A_GuiWidth) . " H" . (A_GuiHeight-50)
GuiControl,Move,listview3,% "W" . (A_GuiWidth) . " H" . (A_GuiHeight-50)
ControlGetPos,recx,recy,recw,rech,SysListView324,ScreamerMenu  
GuiControl,Move,listview4,% "W" . (A_GuiWidth) . " H" . (A_GuiHeight-recy+20)
Return


GetMenu(_hMenu, _menuLevel=0, root=0, depth=0, list="") ;Stolen from PhiLho at http://www.autohotkey.com/forum/topic8492.html
{ 
  local menuItemCount, indent, nPos, length, lpString, id, hSubMenu, path

  menuItemCount := DllCall("GetMenuItemCount", "UInt", _hMenu) 
  Loop %menuItemCount% 
  { 
      nPos := A_Index - 1 
      length := DllCall("GetMenuString" 
         , "UInt", _hMenu 
         , "UInt", nPos 
         , "UInt", 0   ; NULL 
         , "Int", 0   ; Get length 
         , "UInt", 0x0400)   ; MF_BYPOSITION 
      VarSetCapacity(lpString, length + 1)   ; I don't check the result... 
      length := DllCall("GetMenuString" 
         , "UInt", _hMenu 
         , "UInt", nPos 
         , "Str", lpString 
         , "Int", length + 1 
         , "UInt", 0x0400) 
      id := DllCall("GetMenuItemID", "UInt", _hMenu, "Int", nPos) 
      hSubMenu := DllCall("GetSubMenu", "UInt", _hMenu, "Int", nPos) 

      If _menuLevel=0
      {
        line=0
        index=0
        If (A_Index=root)
          index=1
      }
      
      If index=1
      If (hSubMenu!=0)
      { 
         path%_menuLevel%:=lpString
         GetMenu(hSubMenu, _menuLevel+1, root, depth, list) 
      }
      Else
      {
        line+=1
        path=
        Loop % _menuLevel
        {
          part:=A_Index-1
          path:=path . path%part% . " - "
        }
        If id>0
        {
          If (_menuLevel>depth)
          {
            If lpString Contains Add to Favorites,Add current station to Favorites,Web &Directory
              line-=1
            Else
            {
              StringReplace,path,path,&,,All
              If list<>1
                StringReplace,lpString,lpString,&,,All
              If list=3
                StringTrimLeft,lpString,lpString,3
              StringTrimRight,path,path,3
              Gui,ListView,listview%list%
              LV_Add("",line,lpString,path,id)
            }
          }
        }
        Else
          line-=1
      }
  }
} 


TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,SHOW
Menu,Tray,Add,
Menu,Tray,Default,%applicationname%
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname% 
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


EXIT:
Gosub,INIWRITE
Gosub,WRITESCHEDULE
If stop=1
  WinClose,ahk_id %screamerid%

If logsize>0
{
  FileGetSize,logfilesize,log.txt
  logsize:=logfilesize-logsize*1024
  size=0
  Loop,Read,log.txt,log.new
  {
    size:=size+StrLen(A_LoopReadLine)+1
    If (size>logsize)
      FileAppend,%A_LoopReadLine%`n
  }
  FileMove,log.new,log.txt,1
}
ExitApp


INIREAD:
IfNotExist,%applicationname%.ini
{
  IniWrite,0,%applicationname%.ini,Settings,snapnone
  IniWrite,1,%applicationname%.ini,Settings,snapauto
  IniWrite,0,%applicationname%.ini,Settings,snaptop
  IniWrite,0,%applicationname%.ini,Settings,snapbottom
  IniWrite,1,%applicationname%.ini,Settings,stretch
  IniWrite,1,%applicationname%.ini,Settings,scrolling

  IniWrite,0,%applicationname%.ini,Settings,runschedule
  IniWrite,%A_Space%,%applicationname%.ini,Settings,startupstation
  IniWrite,0,%applicationname%.ini,Settings,start
  IniWrite,%A_Space%,%applicationname%.ini,Settings,screamerpath
  IniWrite,%A_Space%,%applicationname%.ini,Settings,stop

  IniWrite,0,%applicationname%.ini,Settings,autorec
  IniWrite,%A_Space%,%applicationname%.ini,Settings,favs

  IniWrite,1,%applicationname%.ini,Settings,usehotkeys
  IniWrite,0,%applicationname%.ini,Settings,alllists
  IniWrite,^,%applicationname%.ini,Settings,modifiers
  
  IniWrite,0,%applicationname%.ini,Settings,log
  IniWrite,100,%applicationname%.ini,Settings,logsize
}

IniRead,snapnone,%applicationname%.ini,Settings,snapnone
IniRead,snapauto,%applicationname%.ini,Settings,snapauto
IniRead,snaptop,%applicationname%.ini,Settings,snaptop
IniRead,snapbottom,%applicationname%.ini,Settings,snapbottom
IniRead,stretch,%applicationname%.ini,Settings,stretch
IniRead,scrolling,%applicationname%.ini,Settings,scrolling
If scrolling=Error
  scrolling=1

IniRead,runschedule,%applicationname%.ini,Settings,runschedule
IniRead,startupstation,%applicationname%.ini,Settings,startupstation
IniRead,start,%applicationname%.ini,Settings,start
IniRead,screamerpath,%applicationname%.ini,Settings,screamerpath
IniRead,stop,%applicationname%.ini,Settings,stop

IniRead,autorec,%applicationname%.ini,Settings,autorec
IniRead,favs,%applicationname%.ini,Settings,favs

IniRead,usehotkeys,%applicationname%.ini,Settings,usehotkeys
IniRead,alllists,%applicationname%.ini,Settings,alllists
IniRead,modifiers,%applicationname%.ini,Settings,modifiers

IniRead,log,%applicationname%.ini,Settings,log
IniRead,logsize,%applicationname%.ini,Settings,logsize
Return

READSCHEDULE:
Gui,ListView,listview4
Loop
{
  IniRead,sched,%applicationname%.ini,Schedule,%A_Index%
  If sched=Error
    Break
  StringSplit,action_,sched,|
  active=
  If action_1=1
    active=Check
  LV_Add(active,"",action_2,action_3,action_4,action_5,action_6)
}
Return


INIWRITE:
Gui,Submit,NoClose
IniWrite,%snapnone%,%applicationname%.ini,Settings,snapnone
IniWrite,%snapauto%,%applicationname%.ini,Settings,snapauto
IniWrite,%snaptop%,%applicationname%.ini,Settings,snaptop
IniWrite,%snapbottom%,%applicationname%.ini,Settings,snapbottom
IniWrite,%stretch%,%applicationname%.ini,Settings,stretch
IniWrite,%scrolling%,%applicationname%.ini,Settings,scrolling

IniWrite,%runschedule%,%applicationname%.ini,Settings,runschedule
IniWrite,%startupstation%,%applicationname%.ini,Settings,startupstation
IniWrite,%start%,%applicationname%.ini,Settings,start
IniWrite,%screamerpath%,%applicationname%.ini,Settings,screamerpath
IniWrite,%stop%,%applicationname%.ini,Settings,stop

IniWrite,%autorec%,%applicationname%.ini,Settings,autorec
IniWrite,%favs%,%applicationname%.ini,Settings,favs

IniWrite,%usehotkeys%,%applicationname%.ini,Settings,usehotkeys
IniWrite,%alllists%,%applicationname%.ini,Settings,alllists
IniWrite,%modifiers%,%applicationname%.ini,Settings,modifiers

IniWrite,%log%,%applicationname%.ini,Settings,log
IniWrite,%logsize%,%applicationname%.ini,Settings,logsize
Return

WRITESCHEDULE:
IniDelete,%applicationname%.ini,Schedule
Gui,ListView,listview4
Loop,% LV_GetCount()
{
  active=0
  checked:=LV_GetNext(A_Index-1,"C")
  If (checked=A_Index)
    active=1
  LV_GetText(station,A_Index,2)
  LV_GetText(starttime,A_Index,3)
  LV_GetText(startdate,A_Index,4)
  LV_GetText(interval,A_Index,5)
  LV_GetText(actions,A_Index,6)
  IniWrite,%active%|%station%|%starttime%|%startdate%|%interval%|%actions%,%applicationname%.ini,Schedule,%A_Index%
}
Return