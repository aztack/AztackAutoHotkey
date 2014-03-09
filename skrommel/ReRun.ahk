;ReRun.ahk
; Run the startup programs not already running
;Skrommel @ 2007


#SingleInstance,Force
#NoEnv
SetBatchLines,-1

applicationname=ReRun

Gosub,TRAYMENU

exclude=

TrayTip,%applicationname% v1.1 -  www.1HourSoftware.com,Starting startup programs not already running...

commandlines:=GetProcesses()

hkey=HKEY_LOCAL_MACHINE
key=Software\Microsoft\Windows\CurrentVersion\Run
Gosub,REGRUN

hkey=HKEY_CURRENT_USER
key=Software\Microsoft\Windows\CurrentVersion\Run
Gosub,REGRUN

RegRead,startupfolder,HKEY_LOCAL_MACHINE,Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,Common Startup
Gosub,STARTRUN
RegRead,startupfolder,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,Startup
Gosub,STARTRUN

Sleep,5000
ExitApp


REGRUN:
Loop,%hkey%,%key%,0,0
{
  RegRead,target
  If ErrorLevel=1
    Continue
  Gosub,RUN
}
Return


STARTRUN:
Transform,startupfolder,Deref,%startupfolder%
Loop,%startupfolder%\*.*,0,0
{
  FileGetShortcut,%A_LoopFileFullPath%,target,dir,args,desc,icon,iconnum,runstate
  If ErrorLevel=0
    Gosub,RUN
}
Return


RUN:
IfNotInString,commandlines,%target%
  Run,%target% %args%,%dir%,%runstate% UseErrorLevel
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add
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
Gui,99:Add,Text,y+10,Starting startup programs not already running

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
  If ctrl in Static7,Static11,Static15
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp


GetProcesses() ;stolen from AHK help
{
  d = `n  ; string separator
  s := 4096  ; size of buffers and arrays (4 KB)
  
  Process, Exist  ; sets ErrorLevel to the PID of this running script
  ; Get the handle of this script with PROCESS_QUERY_INFORMATION (0x0400)
  h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel)
  ; Open an adjustable access token with this process (TOKEN_ADJUST_PRIVILEGES = 32)
  DllCall("Advapi32.dll\OpenProcessToken", "UInt", h, "UInt", 32, "UIntP", t)
  VarSetCapacity(ti, 16, 0)  ; structure of privileges
  NumPut(1, ti, 0, 4)  ; one entry in the privileges array...
  ; Retrieves the locally unique identifier of the debug privilege:
  DllCall("Advapi32.dll\LookupPrivilegeValueA", "UInt", 0, "Str", "SeDebugPrivilege", "UIntP", luid)
  NumPut(luid, ti, 4, 8)
  NumPut(2, ti, 12, 4)  ; enable this privilege: SE_PRIVILEGE_ENABLED = 2
  ; Update the privileges of this process with the new access token:
  DllCall("Advapi32.dll\AdjustTokenPrivileges", "UInt", t, "Int", false, "UInt", &ti, "UInt", 0, "UInt", 0, "UInt", 0)
  DllCall("CloseHandle", "UInt", h)  ; close this process handle to save memory
  
  hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")  ; increase performance by preloading the libaray
  s := VarSetCapacity(a, s)  ; an array that receives the list of process identifiers:
  DllCall("Psapi.dll\EnumProcesses", "UInt", &a, "UInt", s, "UIntP", r)
  lines=
  Loop, % r // 4  ; parse array for identifiers as DWORDs (32 bits):
  {
     id := NumGet(a, A_Index * 4)
     l:=l . d . GetRemoteCommandLine(id)

;     ; Open process with: PROCESS_VM_READ (0x0010) | PROCESS_QUERY_INFORMATION (0x0400)
;     h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id)
;     VarSetCapacity(m, s)  ; an array that receives the list of module handles:
;     DllCall("Psapi.dll\EnumProcessModules", "UInt", h, "UInt", &m, "UInt", s, "UIntP", r)
;     VarSetCapacity(n, s, 0)  ; a buffer that receives the base name of the module:
;     e := DllCall("Psapi.dll\GetModuleBaseNameA", "UInt", h, "UInt", m, "Str", n, "Chr", s)
;     DllCall("CloseHandle", "UInt", h)  ; close process handle to save memory
;     If n  ; if image is not null add to list:
;        l = %l%%n%%d%
  }
  DllCall("FreeLibrary", "UInt", hModule)  ; unload the library to free memory
;  ; Remove the first and last items in the list (possibly ASCII signitures)
;  StringMid, l, l, InStr(l, d) + 1, InStr(l, d, false, 0) - 2 - InStr(l, d)
;  StringReplace, l, l, %d%, %d%, UseErrorLevel  ; gets the number of processes
;  MsgBox, 0, %ErrorLevel% Processes, %l%
;  ;Sort, l, C  ; uncomment this line to sort the list alphabetically
  Return,%l%
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