;CloseToQuit.ahk
;  Close programs before the system shuts down
;  Usage: Add the process name, class or a part of the caption of the programs
;         you want to close to the settings dialog.
;Skrommel @ 2008


#NoEnv
#SingleInstance,Force
DetectHiddenWindows,On
SetWinDelay,0
SetBatchLines,-1

applicationname=CloseToQuit

Gosub,MENU

DllCall("kernel32.dll\SetProcessShutdownParameters",UInt,0x4FF,UInt,0)
OnMessage(0x11,"WM_QUERYENDSESSION")
Return


WM_QUERYENDSESSION(wParam,lParam)
{
  Global applicationname

  Gui,+LastFound 
  self:=WinExist()

Loop
{
  IniRead,line,%applicationname%.ini,Actions,%A_Index%
  If line=Error
    Break
  StringSplit,part,line,`,
  action:=part1
  program:=part2
  parameters:=part3 . part4 . part5 . part6 . part7 . part8 . part9
  If action=Run
    Run,%action% %parameters%,,UseErrorLevel
  If action In Close,Kill
{
  WinGet,ids,List,,,Program Manager
  Loop,%ids%
  {
    id:=ids%A_Index%
    If id=%self%
      Continue
    WinGet,process,ProcessName,ahk_id %id%
    WinGetClass,class,ahk_id %id%
    WinGetTitle,title,ahk_id %id%
    If process=%program%
    {
      If action=Close
        WinClose,ahk_id %id%
      Else
        Process,Close,ahk_id %id%
    }
    Else
    If class=%program%
    {
      If action=Close
        WinClose,ahk_id %id%
      Else
        Process,Close,ahk_id %id%
    }
    Else
    IfInString,title,%program%
    {
      If action=Close
        WinClose,ahk_id %id%
      Else
        Process,Close,ahk_id %id%
    }
  }
}
}
}
ExitApp


SETTINGS:
actions=Close||Kill|Run|

Gui,Destroy
Gui,Add,ListView,w520 GEDIT,Action|Program|Parameters

Loop
{
  IniRead,line,%applicationname%.ini,Actions,%A_Index%
  If line=Error
    Break
  StringSplit,part,line,`,
  action:=part1
  program:=part2
  parameters:=part3 . part4 . part5 . part6 . part7 . part8 . part9
  LV_Add("",action,program,parameters)
}
LV_Add("","","","")
LV_ModifyCol(1,105)
LV_ModifyCol(2,215)
LV_ModifyCol(3,195)

Gui,Add,Button,w75 Default GUPDATE,^ &Update
Gui,Add,Button,x+5 w75 GEDIT,v &Edit
Gui,Add,Button,x+30 w75 GDELETE,x &Delete

Gui,Add,Text,xm w100 h15,Action
Gui,Add,DropDownList,xp yp+15 w100 vvaction,%actions%
Gui,Add,Text,x120 yp-15 w200 h15,Program, Class or Part of a window caption
Gui,Add,Edit,xp yp+15 w200 vvprogram,
Gui,Add,Text,x330 yp-15 w200 h15,Parameters
Gui,Add,Edit,xp yp+15 w200 vvparameters,

Gui,Add,Button,xm w75 GOK,&OK
Gui,Add,Button,x+5 w75 GCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return


EDIT:
row:=LV_GetNext(0,"Focused") 
If row=0
  row:=LV_GetCount()
LV_GetText(action,row,1)
LV_GetText(program,row,2)
LV_GetText(parameters,row,3)
StringReplace,actions,actions,||,|,All
StringReplace,actions,actions,%action%,%action%|
GuiControl,,vaction,|%actions%
GuiControl,,vprogram,%program%
GuiControl,,vparameters,%parameters%
Return


UPDATE:
Gui,Submit,NoHide
row:=LV_GetNext(0,"Focused") 
If row=0
  row:=LV_GetCount()
LV_Modify(row,"",vaction,vprogram,vparameters) 
If (row=LV_GetCount())
  LV_Add("","","","")
Return


DELETE:
row:=LV_GetNext(0,"Focused")
If row=0
  Return
If (row=LV_GetCount())
  Return
LV_Delete(row)
GuiControl,,vaction,|Close||Kill|Run|
GuiControl,,vprogram,
GuiControl,,vparameters,
Return


OK:
IniDelete,%applicationname%.ini,Actions
line=0
Loop,% LV_GetCount()
{
  line+=1
  LV_GetText(action,A_Index,1)
  LV_GetText(program,A_Index,2)
  LV_GetText(parameters,A_Index,3)
  If program=
    Continue
  IniWrite,%action%`,%program%`,%parameters%,%applicationname%.ini,Actions,%line%
}
Gui,Destroy
Return


CANCEL:
Gui,Destroy
Return


MENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
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
Gui,99:Add,Text,y+10,Close programs before the system shuts down.
Gui,99:Add,Text,y+10,- To change settings, use Settings in the tray menu.

Gui,99:Add,Picture,xm y+20 Icon2,%applicationname%.exe
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

ABOUTOK:
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