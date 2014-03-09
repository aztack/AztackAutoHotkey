;CloseAndEject.ahk
;Close all open files before ejecting a drive.
; Press Eject to close all handles and eject the drives.
; Double leftclick a line to activate the process.
; Double rightclick a line to kill the process.
; Command line: CloseAndEject.exe <Drives> Eject
;  Example: CloseAndEject.exe DE Eject
;  Closes open files on drive D and E, ejects and exits.
;Skrommel @ 2008

FileInstall,handle.exe,handle.exe

#SingleInstance,Force
#NoEnv
#NoTrayIcon
SetBatchLines,-1
DetectHiddenWindows,On

applicationname=CloseAndEject

removable=
eject=0
Loop,%0%
{
  If %A_Index%=Eject
    eject=1
  Else
    removable:=%A_Index%
}
If removable=
  Gosub,INIREAD

Gui,+Resize
Gui,Margin,0,0
Gui,Add,Text,x+5 y+3,Drives:
Gui,Add,Edit,x+5 yp-3 w100 vvremovable,%removable%
Gui,Add,Button,x+5 w60 Default gEJECT,&Eject
Gui,Add,Button,x+5 w60 gRETRACT,&Retract
Gui,Add,Button,x+5 yp w60 gREFRESH,Re&fresh
Gui,Add,Button,x+5 yp w60 gABOUT,&About
Gui,Add,ListView,xm w400 h300 Checked vlistview gLISTVIEW,File|Folder|Program|Path|Pid|Handle
Gui,Add,Text,x5 y+5 vtext1, For more tools, information and donations, visit 
Gui,Font,CBlue Underline
Gui,Add,Text,x+5 yp h15 vtext2,www.1HourSoftware.com
Gui,Show,AutoSize,CloseAndEject - 1 Hour Software
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 


START:
Gui,Submit,NoHide
RunWait,%ComSpec% /c handle.exe -a > handles.txt,,Hide
Loop,Read,handles.txt
{
  StringGetPos,start,A_LoopReadLine,pid:
  If start>0
  {
    StringGetPos,stop,A_LoopReadLine,%A_Space%,,% start+5
    StringMid,pid,A_LoopReadLine,% start+5,% stop-start-4
    StringLeft,program,A_LoopReadLine,%start%
    programpath:=GetModuleFileNameEx(pid)
    SplitPath,programpath,programname,programdir
    Continue
  }
  
  find=Harddisk
  removable:=vremovable
  If removable=
    DriveGet,removable,List,Removable
  Loop,% StrLen(removable)
  {
    StringMid,drive,removable,%A_Index%,1
    find=%find%`,%drive%:\
  }
  Loop,Parse,find,`,
  {  
    StringGetPos,start,A_LoopReadLine,%A_LoopField%
    If start>0
    IfNotInstring,program,System
    {
      StringMid,handle,A_LoopReadLine,0,5
      StringTrimLeft,file,A_LoopReadLine,21
      If (A_LoopField="Harddisk")
      {
        StringGetPos,start,file,\,L4
        StringTrimLeft,file,file,% start
      
        Loop,% StrLen(removable)
        {
          StringMid,drive,removable,%A_Index%,1
          path=%drive%:%file%
          IfExist,%path%
          {
            FileGetAttrib,attrib,%path%
            IfInString,attrib,D
              LV_Add("Check","",path,programname,programdir,pid,handle)
            Else
            {
              SplitPath,path,name,dir
              If (StrLen(dir)=2)
                dir=%dir%\
              LV_Add("Check",name,dir,programname,programdir,pid,handle)
            }
          }
        }
      }
      Else
      {
        path:=file
        FileGetAttrib,attrib,%path%
        IfInString,attrib,D
          LV_Add("Check","",path,programname,programdir,pid,handle)
        Else
        {
          SplitPath,path,name,dir
          If (StrLen(dir)=2)
            dir=%dir%\
          LV_Add("Check",name,dir,programname,programdir,pid,handle)
        }
      }
      
    }
  }
}
LV_ModifyCol(2,"Sort")
LV_ModifyCol(5,"Integer")  
LV_ModifyCol(6,"Integer")  
Loop,6
  LV_ModifyCol(A_Index,"AutoHdr")
If eject=1
{
  Gosub,EJECT
  Gosub,EXIT
}
Return


EJECT:
Gosub,CLOSEHANDLES
drives=
Loop,% StrLen(removable)
{
  StringMid,drive,removable,%A_Index%,1
  Drive,Eject,%drive%:
  drives:=drives . drive ": "
}
If eject=0
{
  Gosub,REFRESH
  MsgBox,0,CloseAndEject - 1 Hour Software,Ejected %drives% 
}
Return


RETRACT:
drives=
Loop,% StrLen(removable)
{
  StringMid,drive,removable,%A_Index%,1
  Drive,Eject,%drive%:,1
  drives:=drives . drive ": "
}
Gosub,REFRESH
MsgBox,0,CloseAndEject - 1 Hour Software,Retracted %drives% 
Return


CLOSEHANDLES:
row=0
Loop
{
	row:=LV_GetNext(row,"C")
	If row=0
		Break
	LV_GetText(pid,row,5)
	LV_GetText(handle,row,6)
  Run,%ComSpec% /c handle.exe -c %handle% -p %pid%,,Hide,hpid
  WinWait,ahk_pid %hpid%
  ControlSend,,y{Enter},ahk_class ConsoleWindowClass
}
Return


REFRESH:
LV_Delete()
Gosub,START
Return


GuiSize:
If A_EventInfo=1
	Return
GuiControl,Move,listview,% "W" . A_GuiWidth . " H" . (A_GuiHeight-40)
GuiControl,Move,text1,% "Y" . (A_GuiHeight-15)
GuiControl,Move,text2,% "Y" . (A_GuiHeight-15)
Return


LISTVIEW:
If A_GuiEvent=DoubleClick
{
	LV_GetText(pid,A_EventInfo,5)
	WinShow,ahk_pid %pid%
  WinActivate,ahk_pid %pid%
}	
If A_GuiEvent=R
{
	LV_GetText(pid,A_EventInfo,5)
	Process,Close,%pid%
}
Gosub,REFRESH
Return


EXIT:
GuiClose:
Gosub,INIWRITE
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCur) 
ExitApp


INIREAD:
IfNotExist,%applicationname%.ini
{
  DriveGet,cdrom,List,Cdrom
  DriveGet,removable,List,Removable
  removable=%cdrom%%removable%
;  eject=0
;  exit=0
  Gosub,INIWRITE
}
IniRead,removable,%applicationname%.ini,Settings,removable
;IniRead,eject,%applicationname%.ini,Settings,eject
;IniRead,exit,%applicationname%.ini,Settings,exit
Return


INIWRITE:
If eject=0
  IniWrite,%removable%,%applicationname%.ini,Settings,removable
;IniWrite,%eject%,%applicationname%.ini,Settings,eject
;IniWrite,%exit%,%applicationname%.ini,Settings,exit
Return


ABOUT:
Gui,2:Destroy
Gui,2:Add,Text,y-5,`t
Gui,2:Add,Picture,xm Icon1,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,2:Font
Gui,2:Add,Text,xm,Close all open files before ejecting a drive.
Gui,2:Add,Text,xm,- Press Eject to close all handles and eject the drives.
Gui,2:Add,Text,xm,- Double leftclick a line to activate the process.
Gui,2:Add,Text,xm,- Double rightclick a line to kill the process.
Gui,2:Add,Text,xm,- Command line: CloseAndEject.exe <Drives> Eject
Gui,2:Add,Text,xm+10,Example: CloseAndEject.exe DE Eject
Gui,2:Add,Text,xm+10,Closes open files on drive D and E, ejects and exits.
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon2,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,2:Font
Gui,2:Add,Text,xm,For more tools, information and donations, visit
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm G1HOURSOFTWARE,www.1HourSoftware.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon5,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,DonationCoder
Gui,2:Font
Gui,2:Add,Text,xm,Please support the DonationCoder community
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm GDONATIONCODER,www.DonationCoder.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon6,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,AutoHotkey
Gui,2:Font
Gui,2:Add,Text,xm,This program was made using AutoHotkey
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm GAUTOHOTKEY,www.AutoHotkey.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Button,GABOUTOK Default w75,&OK
Gui,2:Show,,%applicationname% About
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

2GuiEscape:
2GuiClose:
ABOUTOK:
Gui,2:Destroy
Return


WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static3,Static15,Static20,Static25
    DllCall("SetCursor","UInt",hCurs)
  Return
}


GetModuleFileNameEx( p_pid ) ;by shimanov at www.autohotkey 
{ 
   if A_OSVersion in WIN_95,WIN_98,WIN_ME 
   { 
;      MsgBox,This Windows version (%A_OSVersion%) is not supported. 
      return 
   } 

   /* 
      #define PROCESS_VM_READ           (0x0010) 
      #define PROCESS_QUERY_INFORMATION (0x0400) 
   */ 
   h_process:=DllCall( "OpenProcess","uint",0x10|0x400,"int",false,"uint",p_pid ) 
   if ( ErrorLevel or h_process = 0 ) 
   { 
;      MsgBox,[OpenProcess] failed 
      return 
   } 
    
   name_size = 255 
   VarSetCapacity( name,name_size ) 
    
   result:=DllCall( "psapi.dll\GetModuleFileNameExA","uint",h_process,"uint",0,"str",name,"uint",name_size ) 
;   if ( ErrorLevel or result = 0 ) 
;      MsgBox,[GetModuleFileNameExA] failed 
    
   DllCall( "CloseHandle",h_process ) 
    
   return,name 
}
