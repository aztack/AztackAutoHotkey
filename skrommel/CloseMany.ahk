;CloseMany.ahk
; Close multiple programs or services at once
;Skrommel @2006

#SingleInstance,Force
#NoEnv
DetectHiddenWindows,On
DetectHiddenText,On
SetTitleMatchMode,Slow
SetBatchLines,-1
SetWinDelay,0

applicationname=CloseMany

Gosub,TRAYMENU
view=1
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 

OnExit, HandleExit 

success := DllCall( "advapi32.dll\LookupPrivilegeValueA" 
                  , "uint", 0 
                  , "str", "SeDebugPrivilege" 
                  , "int64*", luid_SeDebugPrivilege ) 
if ( ReportError( ErrorLevel or !success 
            , "LookupPrivilegeValue: SeDebugPrivilege" 
            , "success = " success ) ) 
   ExitApp 

Process, Exist 
pid_this := ErrorLevel 

hp_this := DllCall( "OpenProcess" 
                  , "uint", 0x400                                 ; PROCESS_QUERY_INFORMATION 
                  , "int", false 
                  , "uint", pid_this ) 
if ( ReportError( ErrorLevel or hp_this = 0 
            , "OpenProcess: pid_this" 
            , "hp_this = " hp_this ) ) 
   ExitApp 

success := DllCall( "advapi32.dll\OpenProcessToken" 
                  , "uint", hp_this 
                  , "uint", 0x20                                 ; TOKEN_ADJUST_PRIVILEGES 
                  , "uint*", ht_this ) 
if ( ReportError( ErrorLevel or !success 
            , "OpenProcessToken: hp_this" 
            , "success = " success ) ) 
   ExitApp 

VarSetCapacity( token_info, 4+( 8+4 ), 0 ) 
   EncodeInteger( 1, 4, &token_info, 0 ) 
   EncodeInteger( luid_SeDebugPrivilege, 8, &token_info, 4 ) 
      EncodeInteger( 2, 4, &token_info, 12 )                           ; SE_PRIVILEGE_ENABLED 

success := DllCall( "advapi32.dll\AdjustTokenPrivileges" 
                  , "uint", ht_this 
                  , "int", false 
                  , "uint", &token_info 
                  , "uint", 0 
                  , "uint", 0 
                  , "uint", 0 ) 
if ( ReportError( ErrorLevel or !success 
            , "AdjustTokenPrivileges: ht_this; SeDebugPrivilege ~ SE_PRIVILEGE_ENABLED" 
            , "success = " success ) ) 
   ExitApp 
   
Gosub,GUI
Return


HandleExit: 
   DllCall( "CloseHandle", "uint", ht_this ) 
   DllCall( "CloseHandle", "uint", hp_this ) 
ExitApp 


GUI:
Gui,Destroy
Gui,+Resize
Gui,Margin,0,0

Gui,Font,Bold
Gui,Add,Tab,-Buttons vtab xm+5 ym+5,Processes||Services
Gui,Font,

Gui,Tab,
Gui,Add,Button,w60 xm+150 ym+2 GABOUT ,&About
Gui,Add,Button,w60 x+10 GREFRESH Default,R&efresh
Gui,Add,Button,w60 x+0 GTOGGLEVIEW,S&witch

Gui,Tab,1
Gui,Add,Button,w60 xm+350 ym+2 GPCLOSE,&Close
Gui,Add,Button,w60 x+0 GPKILL,&Kill
Gui,Add,Button,w60 x+0 GPRESTART,&Restart
Gui,Add,Listview,Vplistview xm ym+27 -LV0x20,Name|Title|Description|Internal|Company|Pid|CommandLine|Path
ImageListID1:=IL_Create(10)
ImageListID2:=IL_Create(10,10,true)
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

Gui,Tab,2
Gui,Add,Button,w60 xm+350 ym+2 GSSTART,&Start
Gui,Add,Button,w60 x+0 GSSTOP,S&top
Gui,Add,Button,w60 x+0 GSRESTART,&Restart
Gui,Add,Button,w60 x+5 GSAUTO,&Auto
Gui,Add,Button,w60 x+0 GSDEMAND,D&emand
Gui,Add,Button,w60 x+0 GSDISABLE,&Disabled
Gui,Add,Listview,Vslistview xm ym+27 -LV0x20,Name|Service|State|Description|Start|Command|Dependencies|States|Pid|Type
ImageListID3:=IL_Create(10)
ImageListID4:=IL_Create(10,10,true)
LV_SetImageList(ImageListID3)
LV_SetImageList(ImageListID4)

Gui,Tab,
Gui,Add,Text,x+10 y+5 Vtext,For more tools, information and donations, visit
Gui,Font,Bold CBlue
Gui,Add,Text,x+0 yp G1HOURSOFTWARE VWWW,www.1HourSoftware.com
Gui,Font
Gui,Show,Maximized,%applicationname%
Gosub,GuiSize
Gosub,REFRESH
Return


REFRESH:
Gosub,PROGRAMS
Gosub,SERVICES
Return


PROGRAMS:
Gui,ListView,plistview
LV_Delete()
LV_ModifyCol(6,"Integer")

total:=EnumProcesses(pid_list) 

;   LV_Add( "", A_LoopField, GetModuleFileNameEx( A_LoopField ), GetRemoteCommandLine( A_LoopField ) ) 
Loop,Parse,pid_list,| 
{
  If A_LoopField=
    Continue
  part_2:=A_LoopField
  part_3:=GetRemoteCommandLine( A_LoopField )
  FileName:=GetModuleFileNameEx(part_2)
  SplitPath,filename,part_1
  WinGet,list_,List,ahk_pid %part_2%
  title=
  Loop,%list_%
  {
    id:=list_%A_Index%
    WinGetTitle,title,ahk_id %id%
    If title<>
      Break
  }
  ;MsgBox,%list_%`n%title%...`n%FileName%`n%part_2%
  iIndex=0
  hIcon:=DllCall("Shell32\ExtractAssociatedIconA",UInt,0,Str,FileName,UShortP,iIndex)
  If Not hIcon  ; Failed to load/find icon.
    IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
  Else
  {
    IconNumber:=DllCall("ImageList_ReplaceIcon",UInt,ImageListID1,Int,-1,UInt,hIcon)+1
    DllCall("ImageList_ReplaceIcon",UInt,ImageListID2,Int,-1,UInt,hIcon)
    DllCall("DestroyIcon",Uint,hIcon)
    LV_Add("Icon" . IconNumber,A_Space part_1,title,"","","",part_2,part_3,FileName)
  }
}

LV_ModifyCol()
LV_ModifyCol(3,"200")
LV_ModifyCol(4,"100")
LV_ModifyCol(5,"100")
LV_ModifyCol(1,"Sort")

Loop,% LV_GetCount()
{
  LV_GetText(filepath,A_Index,8)
   showver:=FileGetFullVer(filepath,0xFFFF,"`n")

  description=
  StringGetPos,start,showver,FileDescription
  If start>-1
  {    
    StringGetPos,start,showver,:,,%start%
    start+=2
    StringGetPos,end,showver,`n,,%start%
    length:=end-start+1
    StringMid,description,showver,%start%,%length%
  }

  internalname=
  StringGetPos,start,showver,InternalName
  If start>-1
  {
    StringGetPos,start,showver,:,,%start%
    start+=2
    StringGetPos,end,showver,`n,,%start%
    length:=end-start+1
    StringMid,internalname,showver,%start%,%length%
  }

  companyname=
  StringGetPos,start,showver,Company
  If start>-1
  {
    StringGetPos,start,showver,:,,%start%
    start+=2
    StringGetPos,end,showver,`n,,%start%
    length:=end-start+1
    StringMid,companyname,showver,%start%,%length%
  }

  LV_Modify(A_Index,"Col3",description,internalname,companyname)
}
Return


SERVICES:
Gui,ListView,slistview
LV_Delete()
LV_ModifyCol(9,"Integer")
sc=
CMDret_RunReturn("sc.exe queryex state= all",sc)
rows=
end=
Loop,Parse,sc,`n,`r
{
  If A_LoopField=
    Continue
  IfInString,A_LoopField,SERVICE_NAME:
  {
    StringGetPos,pos,A_LoopField,:
    pos+=1
    StringTrimLeft,service_name,A_LoopField,%pos%
    Continue
  }
  IfInString,A_LoopField,DISPLAY_NAME:
  {
    StringGetPos,pos,A_LoopField,:
    pos+=1
    StringTrimLeft,display_name,A_LoopField,%pos%
    Continue
  }
  IfInString,A_LoopField,TYPE               :
  {
    StringGetPos,pos,A_LoopField,:
    pos+=5
    StringTrimLeft,type,A_LoopField,%pos%
    StringLower,type,type,T
    Continue
  }
  IfInString,A_LoopField,STATE              :
  {
    StringGetPos,pos,A_LoopField,:
    pos+=6
    StringMid,state,A_LoopField,%pos%,7
    StringLower,state,state,T
  }
  IfNotInString,A_LoopField,:
  {
    StringGetPos,pos,A_LoopField,(
    pos+=1
    StringTrimLeft,states,A_LoopField,%pos%
    StringReplace,states,states,`,,`,%A_Space%,All
    StringReplace,states,states,),
    StringLower,states,states,T 
    Continue
  }
  IfInString,A_LoopField,PID                :
  {
    StringGetPos,pos,A_LoopField,:
    pos+=1
    StringTrimLeft,pid,A_LoopField,%pos%
    LV_Add("Icon",service_name,display_name,state,"","","","",states,pid,type)
    Continue    
  }
}
LV_ModifyCol()
LV_ModifyCol(4,"150")
LV_ModifyCol(5,"75")
LV_ModifyCol(6,"150")
LV_ModifyCol(7,"150")
LV_ModifyCol(1,"Sort")
LV_ModifyCol(3,"Sort")

Loop,% LV_GetCount()
{
  LV_GetText(text,A_Index,1)
  sc=
  CMDret_RunReturn("sc.exe qc " text,sc)
  StringSplit,sc_,sc,`n,`r
  StringTrimLeft,start_type,sc_5,33
  StringReplace,start_type,start_type,_START,,
  StringLower,start_type,start_type,T 
  StringTrimLeft,path_name,sc_7,29
  StringGetPos,start,sc,DEPENDENCIES
  start+=22
  StringGetPos,end,sc,SERVICE_START_NAME
  length:=end-start
  StringMid,dependencies,sc,%start%,%length%
  StringReplace,dependencies,dependencies,%A_Space%,,All
  StringReplace,dependencies,dependencies,:,`,%A_Space%,All

  SplitPath,path_name,name,dir,ext,name_no_ext,drive
  FileName=%dir%\%name%
  iIndex=0
  hIcon:=DllCall("Shell32\ExtractAssociatedIconA",UInt,0,Str,FileName,UShortP,iIndex)
  if not hIcon  ; Failed to load/find icon.
    IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
  else
  {
    IconNumber:=DllCall("ImageList_ReplaceIcon",UInt,ImageListID3,Int,-1,UInt,hIcon) + 1
    DllCall("ImageList_ReplaceIcon",UInt,ImageListID4,Int,-1,UInt,hIcon)
    DllCall("DestroyIcon",Uint,hIcon)
    LV_Modify(A_Index,"Col5 Icon" . IconNumber,start_type,path_name,dependencies)
  }
}

Loop,% LV_GetCount()
{
  LV_GetText(text,A_Index,1)
  sc=
  CMDret_RunReturn("sc.exe qdescription " text " 2048",sc)
  StringGetPos,pos,sc,DESCRIPTION
  pos+=27
  StringTrimLeft,description,sc,%pos%  
  LV_Modify(A_Index,"Col4",description)
}
Return


PRESTART:
Gui,ListView,plistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(pid,row,6)
  LV_GetText(process,row,1)
  TOOLTIP("Closing " command "...")
  WinClose,ahk_pid %pid%
}
Sleep,2000

row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(pid,row,6)
  LV_GetText(process,row,1)
  TOOLTIP("Killing " command "...")
  Process,Close,%pid%
}

row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(pid,row,6)
  LV_GetText(command,row,7)
  LV_GetText(process,row,1)
  Process,WaitClose,%pid%,5
  If ErrorLevel=0
  {
    TOOLTIP("Restarting " command "...")
    Run,%command%
  }
  Else
    TOOLTIP(command "did not exit.")
}
Sleep,2000
Gosub,PROGRAMS
Return


PCLOSE:
Gui,ListView,plistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(pid,row,6)
  LV_GetText(command,row,1)
  TOOLTIP("Closing " command "...")
  WinClose,ahk_pid %pid%
}
Sleep,2000
Gosub,PROGRAMS
Return


PKILL:
Gui,ListView,plistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(pid,row,6)
  LV_GetText(command,row,1)
  TOOLTIP("Closing " command "...")
  WinClose,ahk_pid %pid%
}
Sleep,2000

row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(pid,row,6)
  TOOLTIP("Killing " command "...")
  Process,Close,%pid%
}
Sleep,2000
Gosub,PROGRAMS
Return


SSTOP:
Gui,ListView,slistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(text,row,1)
  TOOLTIP("Stopping " text "...")
  Run,cmd /c net stop %text%
}
Sleep,2000
Gosub,SERVICES
Return


SSTART:
Gui,ListView,slistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(text,row,1)
  TOOLTIP("Starting " text "...")
  Run,cmd /c net start %text%,,Hide
}
Sleep,2000
Gosub,SERVICES
Return


SRESTART:
Gui,ListView,slistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(text,row,1)
  TOOLTIP("Stopping " text "...")
  Run,cmd /c net stop %text%
}
Sleep,2000
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(text,row,1)
  TOOLTIP("Starting " text "...")
  Run,cmd /c net start %text%,,Hide
}
Sleep,2000
Gosub,SERVICES
Return


SAUTO:
Gui,ListView,slistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(text,row,1)
  TOOLTIP("Setting startup of " text " to Auto...")
  Run,cmd /c sc.exe config %text% start= auto,,Hide
}
Gosub,SERVICES
Return


SDISABLE:
Gui,ListView,slistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(text,row,1)
  TOOLTIP("Setting startup of " text " to Disabled...")
  Run,cmd /c sc.exe config %text% start= disabled,,Hide
}
Gosub,SERVICES
Return


SDEMAND:
Gui,ListView,slistview
row=0
Loop
{
  row:=LV_GetNext(row)
  If row=0
    Break
  LV_GetText(text,row,1)
  TOOLTIP("Setting startup of " text " to Demand...")
  Run,cmd /c sc.exe config %text% start= demand,,Hide
}
Gosub,SERVICES
Return


TOGGLEVIEW:
view+=1
If view>4
  view=1
If view=1 
{
  GuiControl,+Report,plistview
  GuiControl,+Report,slistview
}
If view=2 
{
  GuiControl,+Icon,plistview
  GuiControl,+Icon,slistview
}
If view=3 
{
  GuiControl,+IconSmall,plistview
  GuiControl,+IconSmall,slistview
}
If view=4 
{
  GuiControl,+List,plistview
  GuiControl,+List,slistview
}
Return


GuiSize:
If A_EventInfo=1
  Return
GuiControl,Move,tab,% "W" . A_GuiWidth . " H" . (A_GuiHeight-45)
GuiControl,Move,text,% "X10 Y" . (A_GuiHeight-17)
GuiControl,Move,www,% "X250 Y" . (A_GuiHeight-17)
GuiControl,Move,plistview,% "W" . A_GuiWidth . " H" . (A_GuiHeight - 45)
GuiControl,Move,slistview,% "W" . A_GuiWidth . " H" . (A_GuiHeight - 45)
Return


TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,GUI
Menu,Tray,Add,
Menu,Tray,Add,&Show...,GUI
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return 


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,- Close multiple programs or services at once

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
  If ctrl in Static7,Static11,Static14
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


TOOLTIP(tooltip)
{
  ToolTip,%tooltip%
  SetTimer,TOOLTIPOFF,3000
  Return
}


TOOLTIPOFF:
ToolTip,
SetTimer,TOOLTIPOFF,Off
Return


EXIT:
ExitApp


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


; ****************************************************************** 
; CMDret-AHK functions 
; version 1.05 beta 
; 
; Updated: March 13, 2006 
; by: corrupt 
; Code modifications and/or contributions made by: 
; Laszlo, shimanov, toralf  
; ****************************************************************** 
; Usage: 
; CMDin - command to execute 
; CMDout - variable to receive output 
; or use a variable for CMDout with a value = R to receive output 
; as a Return value instead 
; ****************************************************************** 
; Known Issues: 
; - If using dir be sure to specify a path (example: cmd /c dir c:\) 
; ****************************************************************** 
; Additional requirements: 
; - ExtractInteger and InsertInteger functions 
; ****************************************************************** 
; Code Start 
; ****************************************************************** 

CMDret_RunReturn(CMDin, Byref CMDout) 
{ 
  Global cmdretPID 
  SetBatchLines, -1 
  IF CMDout = R 
    RetValOut := True 
  VarSetCapacity(lpBuffer, 1024) 
  VarSetCapacity(sui,68, 0) 
  VarSetCapacity(pi, 16, 0) 
  VarSetCapacity(pa, 12, 0) 
  InsertInteger(12, pa, 0) 
  InsertInteger(1,  pa, 8) 
  IF (DllCall("CreatePipe", "UInt*",hRead, "UInt*",hWrite, "UInt",&pa, "Int",0) <> 0) 
  { 
    InsertInteger(68, sui, 0) 
    DllCall("GetStartupInfo", "UInt", &sui) 
    InsertInteger(0x100|0x1,  sui, 44) 
    InsertInteger(hWrite, sui, 60) 
    InsertInteger(hWrite, sui, 64) 
    InsertInteger("0", sui, 48) 
    IF (DllCall("CreateProcess", Int,0, Str,CMDin, Int,0, Int,0, Int,1, "UInt",0, Int,0, Int,0, UInt,&sui, UInt,&pi) <> 0) 
    { 
      cmdretPID := ExtractInteger(pi, 8) 
      Loop 
      { 
        IF (DllCall( "PeekNamedPipe", "uint", hRead, "uint", 0, "uint", 0, "uint", 0, "uint*", bSize, "uint", 0 ) > 0 ) 
        { 
          Process, Exist, %cmdretPID% 
          IF (ErrorLevel OR bSize > 0) 
          { 
            IF (bSize > 0) 
            { 
              VarSetCapacity(lpBuffer, bSize) 
              IF (DllCall("ReadFile", "UInt",hRead, "Str", lpBuffer, "Int",bSize, "UInt*",bRead, "Int",0) > 0) 
              { 
                IF bRead > 0 
                { 
                  DllCall("lstrcpyn", "UInt", &lpBuffer, "UInt", &lpBuffer, "Int", bRead) 
                  CMDout = %CMDout% %lpBuffer% 
                } 
              } 
            } 
          } 
          ELSE 
            break 
        } 
        ELSE 
         break 
        Sleep, 20 ; Optional - increase value to reduce processor load while waiting for data in the loop 
      } 
    } 
    cmdretPID= 
    DllCall("CloseHandle", UInt, hWrite) 
    DllCall("CloseHandle", UInt, hRead) 
    VarSetCapacity(lpBuffer, 0) 
  } 
  If (!RetValOut) 
   Return 
  StringTrimLeft, CMDout, CMDout, 2 
  RetValOut = %CMDout% 
  CMDout = R 
  Return, RetValOut  
} 

 
; ********************************* 
; ExtractInteger provided by Chris (comments removed) 
; - version from the AutoHotkey help file - Version 1.0.37.04 
; ********************************* 
; InsertInteger version suggested by Laszlo 
; ********************************* 
InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4) 
{ 
   Loop %pSize% 
      DllCall("RtlFillMemory", UInt,&pDest+pOffset+A_Index-1, UInt,1, UChar,pInteger >> 8*A_Index-8) 
} 

ExtractInteger(ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 4) 
{ 
   SourceAddress := &pSource + pOffset 
   result := 0 
   Loop %pSize% 
   { 
      result := result | (*SourceAddress << 8 * (A_Index - 1)) 
      SourceAddress += 1 
   } 
   if (!pIsSigned OR pSize > 4 OR result < 0x80000000) 
      return result 
   return -(0xFFFFFFFF - result + 1) 
}  



;olderrmode:=DllCall("SetErrorMode","UInt",1) ; SEM_FAILCRITICALERRORS=0x0001 
;DllCall("SetErrorMode","UInt",oldErrMode) 

FileGetFullVer(file,verFlags=0xFFFF,delim="")  ;by wOxxOm at www.autohotkey.com
{  
  ifEqual,delim,,delim=`n
; FLAGS: 0x0001 - numeric info 
;        0x0002 - file type 
;        0x0004 - file description 
;        0x0008 - company name 
;        0x0010 - FileVersion 
;        0x0020 - Comments 
;        0x0040 - InternalName 
;        0x0080 - LegalCopyright 
;        0x0100 - LegalTrademarks 
;        0x0200 - OriginalFilename 
;        0x0400 - ProductName 
;        0x0800 - ProductVersion 
;        0x1000 - PrivateBuild 
;        0x2000 - SpecialBuild 
;        0x4000 - LegalTrademarks1 

;        0x8000 - clean-up empty fields 

; VersionInfoStrings 
;   viPredefinedFirst = 0 
;   viLanguage = 0 
;   viComments = 1 
;   viCompanyName = 2 
;   viFileDescription = 3 
;   viFileVersion = 4 
;   viInternalName = 5 
;   viLegalCopyright = 6 
;   viLegalTrademarks = 7 
;   viOriginalFilename = 8 
;   viProductName = 9 
;   viProductVersion = 10 
;   viPrivateBuild = 11 
;   viSpecialBuild = 12 
;   viLegalTrademarks1 = 13  'Used by Office apps only? 
;   viLegalTrademarks2 = 14  'Used by Office apps only? 
;   viPredefinedLast = 14 

;typedef struct tagVS_FIXEDFILEINFO 
;    0  DWORD dwSignature; 
;    4  DWORD dwStrucVersion; 
;    8  DWORD dwFileVersionMS; 
;    12 DWORD dwFileVersionLS; 
;    16 DWORD dwProductVersionMS; 
;    20 DWORD dwProductVersionLS; 
;    24 DWORD dwFileFlagsMask; 
;    28 DWORD dwFileFlags; 
;    32 DWORD dwFileOS; 
;    36 DWORD dwFileType; 
;    40 DWORD dwFileSubtype; 
;    44 DWORD dwFileDateMS; 
;    48 DWORD dwFileDateLS; 

;   MAX_PATH = 260 
;   ; ----- VS_VERSION.dwFileFlags ----- 
;   VS_FFI_SIGNATURE = 0xFEEF04BD 
;   VS_FFI_STRUCVERSION = 0x10000 
;   VS_FFI_FILEFLAGSMASK = 0x3F 
;   ; ----- VS_VERSION.dwFileFlags ----- 
;   VS_FF_DEBUG = 0x1 
;   VS_FF_PRERELEASE = 0x2 
;   VS_FF_PATCHED = 0x4 
;   VS_FF_PRIVATEBUILD = 0x8 
;   VS_FF_INFOINFERRED = 0x10 
;   VS_FF_SPECIALBUILD = 0x20 
;   ; ----- VS_VERSION.dwFileOS ----- 
;   VOS_UNKNOWN = 0x0 
;   VOS_DOS = 0x10000 
;   VOS_OS216 = 0x20000 
;   VOS_OS232 = 0x30000 
;   VOS_NT = 0x40000 
;   VOS_DOS_WINDOWS16 = 0x10001 
;   VOS_DOS_WINDOWS32 = 0x10004 
;   VOS_OS216_PM16 = 0x20002 
;   VOS_OS232_PM32 = 0x30003 
;   VOS_NT_WINDOWS32 = 0x40004 
;   ; ----- VS_VERSION.dwFileType ----- 
;   VFT_UNKNOWN = 0x0 
;   VFT_APP = 0x1 
;   VFT_DLL = 0x2 
;   VFT_DRV = 0x3 
;   VFT_FONT = 0x4 
;   VFT_VXD = 0x5 
;   VFT_STATIC_LIB = 0x7 
;   ; **** VS_VERSION.dwFileSubtype for VFT_WINDOWS_FONT **** 
;   VFT2_FONT_RASTER = 0x1 
;   VFT2_FONT_VECTOR = 0x2 
;   VFT2_FONT_TRUETYPE = 0x3 
;   ; ----- VS_VERSION.dwFileSubtype for VFT_WINDOWS_DRV ----- 
;   VFT2_UNKNOWN = 0x0 
;   VFT2_DRV_PRINTER = 0x1 
;   VFT2_DRV_KEYBOARD = 0x2 
;   VFT2_DRV_LANGUAGE = 0x3 
;   VFT2_DRV_DISPLAY = 0x4 
;   VFT2_DRV_MOUSE = 0x5 
;   VFT2_DRV_NETWORK = 0x6 
;   VFT2_DRV_SYSTEM = 0x7 
;   VFT2_DRV_INSTALLABLE = 0x8 
;   VFT2_DRV_SOUND = 0x9 
;   VFT2_DRV_COMM = 0xA 

   version= 
   dummy:=1 
   fiSize:=dllCall("version\GetFileVersionInfoSizeA",str,file,uint,&dummy) 
   varSetCapacity(fi,fiSize,0) 
   loop,1 
   {
     if !dllCall("version\GetFileVersionInfoA",str,file, int,0, int,fiSize, uint,&fi) 
         break 
      if !dllCall("version\VerQueryValueA",uint,&fi, str,"\", uintp,fiFFI#, uintp,dummy) 
         break 
      varSetCapacity(fiFFI,13*4) 
      dllCall("RtlMoveMemory",uint,&fiFFI,uint,fiFFI#,uint,13*4) 
      version:=iif(verFlags & 1=0,"" 
                  ,"OwnVersion: " extractInteger(fiFFI,10,0,2) "." extractInteger(fiFFI,8,0,2) 
                  . iif(extractInteger(fiFFI,12,0,2)=0,"" 
                        ,"." extractInteger(fiFFI,14,0,2) "." extractInteger(fiFFI,12,0,2))) 
             . iif(verFlags & 2=0,"" 
                  ,"|FileType: " switch(extractInteger(fiFFI,36)+1,"" 
                        ,"Application","DLL" 
                        ,"" switch(extractInteger(fiFFI,40)+1,"","Printer ","Keyboard " 
                              ,"Language ","Display ","Mouse ","Network ","System " 
                              ,"Installable ", "Sound ","Comm. ") "driver" 
                        ,"" switch(extractInteger(fiFFI,40),"Raster","Vector","TrueType") " font" 
                        ,"VxD driver ", "Static Lib")) 
      if (verFlags & 0xFFFE) 
      {  
         if !dllCall("version\VerQueryValueA",uint,&fi, str,"\VarFileInfo\Translation", uintp,fiTrans#, uintp,dummy) 
            break 
         ifEqual,dummy,0, break 
         fiTrans:=0 
         dllCall("RtlMoveMemory",uintP,fiTrans,uint,fiTrans#,uint,4) 

         Lang#:=fiTrans & 0xFFFF 
         CP#:=fiTrans>>16 

         varSetCapacity(lang,256,0) 
         dummy:=dllCall("VerLanguageNameA",uint,Lang#, str,lang, uint,256) 
         stringLeft,lang,lang,%dummy% 

         sSubBlock:= "\StringFileInfo\" FmtHex(Lang#,4) . FmtHex(CP#,4) "\" 
         Company:=verGetStdValue(fi,sSubBlock "CompanyName") 
         if !Company 
         {  ; Try U.S. English...? 
            dummy:="\StringFileInfo\0409" FmtHex(CP#,4) "\" 
            Company:=verGetStdValue(fi,dummy "CompanyName") 
            if (Company) 
               sSubBlock:=dummy ; We probably found the MS version bug. 
         } 

         version:=version 
            . iif(verFlags & 4=0,"","|FileDescription: " verGetStdValue(fi,sSubBlock "FileDescription")) 
            . iif(verFlags & 8=0,"","|Company: " Company) 
            . iif(verFlags & 0x10,"|FileVersion: " verGetStdValue(fi,sSubBlock "FileVersion"),"") 
            . iif(verFlags & 0x20,"|Comments: " verGetStdValue(fi,sSubBlock "Comments"),"") 
            . iif(verFlags & 0x40,"|InternalName: " verGetStdValue(fi,sSubBlock "InternalName"),"") 
            . iif(verFlags & 0x80,"|LegalCopyright: " verGetStdValue(fi,sSubBlock "LegalCopyright"),"") 
            . iif(verFlags & 0x100,"|LegalTrademarks: " verGetStdValue(fi,sSubBlock "LegalTrademarks"),"") 
            . iif(verFlags & 0x200,"|OriginalFilename: " verGetStdValue(fi,sSubBlock "OriginalFilename"),"") 
            . iif(verFlags & 0x400,"|ProductName: " verGetStdValue(fi,sSubBlock "ProductName"),"") 
            . iif(verFlags & 0x800,"|ProductVersion: " verGetStdValue(fi,sSubBlock "ProductVersion"),"") 
            . iif(verFlags & 0x1000,"|PrivateBuild: " verGetStdValue(fi,sSubBlock "PrivateBuild"),"") 
            . iif(verFlags & 0x2000,"|SpecialBuild: " verGetStdValue(fi,sSubBlock "SpecialBuild"),"") 
            . iif(verFlags & 0x4000,"|LegalTrademarks1: " verGetStdValue(fi,sSubBlock "LegalTrademarks1") 
                                  . "|LegalTrademarks2: " verGetStdValue(fi,sSubBlock "LegalTrademarks2"),"") 
      } 
   } 
   if (verFlags & 0x8000) 
   {  dummy= 
      version=|%version%| 
      stringReplace,version,version,|v0.0| 
      loop,parse,version,| 
         if (A_LoopField) 
            dummy:=dummy . delim . A_LoopField 
      return strMid(dummy,2) 
   } 
   if (delim<>"|") 
      stringReplace,version,version,|,%delim%,all 
   return version 
} 

verGetStdValue(byref fi, value)
{  fiValue#:=0 
   dummy:=0 
   if !dllCall("version\VerQueryValueA",str,fi, str,value, uintp,fiValue#, uintp,dummy) 
      return 
   ifEqual,dummy,0, return 

   len:=dllCall("lstrlenA",uint,fiValue#) 
   varSetCapacity(fiValue,len+1,0) 
   dllCall("RtlMoveMemory",str,fiValue, uint,fiValue#, uint,len) 

      __trim:=A_AutoTrim 
      AutoTrim,on 
   fiValue=%fiValue% 
      AutoTrim,%__trim% 

   return fiValue 
} 

fmtHex(num,digits=8)                  ;without "0x" padded with "0"
{  
   varSetCapacity(s,digits+8,asc("0")) 
   __format:=A_FormatInteger 
   setformat,integer,hex 
   num+=0 
   s:=s . num 
   stringReplace,s,s,0x 
   setformat,integer,%__format% 
   return strRight(s,digits) 
} 

iif(expr, a, b)
{ 
   if (expr) 
      return a 
   else 
      return b 
} 

strLeft(s, n)
{ 
   stringLeft,s,s,%n% 
   return s 
} 

strRight(s, n)
{ 
   stringRight,s,s,%n% 
   return s 
} 

strMid(s, begin, n=0x7FFF, Left=0) ; if L<>0 then mid to the left
{ 
   if Left=0 
      stringMid,s,s,%begin%,%n% 
   else 
      stringMid,s,s,%begin%,%n%,L 
   return s 
} 

switch(idx,val1="",val2="",val3="",val4="",val5="",val6="",val7="",val8="" 
          ,val9="",val10="",val11="",val12="",val13="",val14="",val15="",val16="")
{ 
   return val%idx% 
} 


EncodeInteger( p_value, p_size, p_address, p_offset ) 
{ 
   loop, %p_size% 
      DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) ) 
} 


ReportError( p_condition, p_title, p_extra ) 
{ 
   if p_condition 
      MsgBox, 
         ( LTrim 
            [Error] %p_title% 
            EL = %ErrorLevel%, LE = %A_LastError% 
             
            %p_extra% 
         ) 
    
   return, p_condition 
} 


EnumProcesses( byref r_pid_list ) ;By shimanov at http://www.autohotkey.com/forum/viewtopic.php?t=9000
{ 
   if A_OSVersion in WIN_95,WIN_98,WIN_ME 
   { 
      MsgBox, This Windows version (%A_OSVersion%) is not supported. 
      return, false 
   } 
    
   pid_list_size := 4*1000 
   VarSetCapacity( pid_list, pid_list_size ) 
    
   status := DllCall( "psapi.dll\EnumProcesses", "uint", &pid_list, "uint", pid_list_size, "uint*", pid_list_actual ) 
   if ( ErrorLevel or !status ) 
      return, false 
       
   total := pid_list_actual//4 

   r_pid_list= 
   address := &pid_list 
   loop, %total% 
   { 
      r_pid_list := r_pid_list "|" ( *( address )+( *( address+1 ) << 8 )+( *( address+2 ) << 16 )+( *( address+3 ) << 24 ) ) 
      address += 4 
   } 
    
   StringTrimLeft, r_pid_list, r_pid_list, 1 
    
   return, total 
} 


GetRemoteCommandLine( p_pid_target ) ;By shimanov at http://www.autohotkey.com/forum/viewtopic.php?t=9000 
{ 
   hp_target := DllCall( "OpenProcess" 
                     , "uint", 0x10                              ; PROCESS_VM_READ 
                     , "int", false 
                     , "uint", p_pid_target ) 
   if ( ErrorLevel or hp_target = 0 ) 
   { 
      result = < error: OpenProcess > EL = %ErrorLevel%, LE = %A_LastError%, hp_target = %hp_target% 
      Gosub, return 
   } 

   hm_kernel32 := DllCall( "GetModuleHandle", "str", "kernel32.dll" ) 

   pGetCommandLineA := DllCall( "GetProcAddress", "uint", hm_kernel32, "str", "GetCommandLineA" ) 

   buffer_size = 6 
   VarSetCapacity( buffer, buffer_size ) 

   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pGetCommandLineA, "uint", &buffer, "uint", buffer_size, "uint", 0 ) 
   if ( ErrorLevel or !success ) 
   { 
      result = < error: ReadProcessMemory 1 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success% 
      Gosub, return 
   } 

   loop, 4 
      ppCommandLine += ( ( *( &buffer+A_Index ) ) << ( 8*( A_Index-1 ) ) ) 
    
   buffer_size = 4 
   VarSetCapacity( buffer, buffer_size, 0 ) 

   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", ppCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 ) 
   if ( ErrorLevel or !success ) 
   { 
      result = < error: ReadProcessMemory 2 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success% 
      Gosub, return 
   } 

   loop, 4 
      pCommandLine += ( ( *( &buffer+A_Index-1 ) ) << ( 8*( A_Index-1 ) ) ) 

   buffer_size = 32768 
   VarSetCapacity( result, buffer_size, 1 ) 
    
   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine, "uint", &result, "uint", buffer_size, "uint", 0 ) 
   if ( !success ) 
   { 
      loop, %buffer_size% 
      { 
         success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine+A_Index-1, "uint", &result, "uint", 1, "uint", 0 ) 
          
         if ( !success or Asc( result ) = 0 ) 
         { 
            buffer_size := A_Index 
            break 
         } 
      } 
      success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine, "uint", &result, "uint", buffer_size, "uint", 0 ) 
      if ( ErrorLevel or !success ) 
      { 
         result = < error: ReadProcessMemory 3 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success% 
         Gosub, return 
      } 
   } 

return: 
   DllCall( "CloseHandle", "uint", hp_target ) 
    
   return, result 
}