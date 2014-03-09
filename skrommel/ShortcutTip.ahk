;ShortcutTip.ahk
; Prompts for a description when a shortcut is created. 
;Skrommel @ 2008

#SingleInstance,Force
#Persistent
#NoEnv
SetBatchLines,-1
Process,Priority,,High

applicationname=ShortcutTip

Gosub,TRAYMENU
OnExit,EXIT

;FOLDERSPY("Procedure to call when files change","List of folders to watch separated by comma")
FOLDERSPY("CHANGESHORTCUT",A_Desktop "," A_DesktopCommon "," A_StartMenu "," A_StartMenuCommon)
Return


CHANGESHORTCUT:
If action<>0x1   ;FILE_ACTION_ADDED
  Return
SplitPath,FullPath,name,dir,ext,name_no_ext,drive
If ext<>lnk
  Return
FileGetShortcut,%FullPath%,target,workingDir,args,description,iconFile,iconNum,runState
SplitPath,target,name,dir,ext,name_no_ext,drive
If ext Not In exe,com,bat,cmnd,pif
  Return
InputBox,description,%applicationname%,Please enter description to %name%,,,,,,,,%description%
FileCreateShortcut,%target%,%FullPath%,%workingDir%,%args%,%description%,%iconFile%,%shortcutKey%,%iconNumber%,%runState%
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
Gui,99:Add,Text,y+10,Prompts for a description when a shortcut is created. 

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


;Stolen from SKAN and Lexicos at http://www.autohotkey.com/forum/viewtopic.php?t=22862
FOLDERSPY(procedure,folders)
{
  Global CBA_ReadDir, actionprocedure:=procedure

  CBA_ReadDir:=RegisterCallback("ReadDirectoryChanges")
  Loop,Parse,folders,`,
    IfExist,%A_LoopField%
      BeginWatchingDirectory(A_LoopField,TRUE)
  SetTimer,WatchFolder,-1000
  Return
}

WatchFolder:
  ReadDirectoryChanges()
  SetTimer,WatchFolder,-1000
Return


BeginWatchingDirectory(WatchFolder, WatchSubDirs=true)
{
    local hDir, hEvent

    Loop %WatchFolder%, 1
      WatchFolder := A_LoopFileLongPath
    DllCall( "shlwapi\PathAddBackslashA", UInt,&Watchfolder )
    DirIdx += 1
   
    ; CreateFile: http://msdn2.microsoft.com/en-us/library/aa914735.aspx

    hDir := DllCall( "CreateFile"
                 , Str  , WatchFolder
                 , UInt , ( FILE_LIST_DIRECTORY := 0x1 )
                 , UInt , ( FILE_SHARE_READ     := 0x1 )
                        | ( FILE_SHARE_WRITE    := 0x2 )
                        | ( FILE_SHARE_DELETE   := 0x4 )
                 , UInt , 0
                 , UInt , ( OPEN_EXISTING := 0x3 )
                 , UInt , ( FILE_FLAG_BACKUP_SEMANTICS := 0x2000000  )
                        | ( FILE_FLAG_OVERLAPPED       := 0x40000000 )
                 , UInt , 0 )
   
    Dir%DirIdx%         := hDir
    Dir%DirIdx%Path     := WatchFolder
    Dir%DirIdx%Subdirs  := WatchSubDirs
    VarSetCapacity( Dir%DirIdx%FNI, 0x10000 )   ;SizeOf_FNI := ( 64KB := 1024 * 64 )
    VarSetCapacity( Dir%DirIdx%Overlapped, 20, 0 )
    hEvent := DllCall( "CreateEvent", UInt,0, Int,true, Int,false, UInt,0 )
    NumPut( hEvent, Dir%DirIdx%Overlapped, 16 )
   
    ; Maintain array of event handles to wait on.
    if ( VarSetCapacity(DirEvents) < DirIdx*4 )
    {   ; Expand by 16 directories (64 bytes) at a time.
        VarSetCapacity(DirEvents, DirIdx*4 + 60)
        ; Copy all previous event handles.
        Loop %DirIdx%
            NumPut( NumGet( Dir%A_Index%Overlapped, 16 ), DirEvents, A_Index*4-4 )
    }
    NumPut( hEvent, DirEvents, DirIdx*4-4 )
   
    DllCall( "ReadDirectoryChangesW"  ; http://msdn2.microsoft.com/en-us/library/aa365465.aspx
                , UInt , hDir
                , UInt , &Dir%DirIdx%FNI
                , UInt , 0x10000      ;SizeOf_FNI := ( 64KB := 1024 * 64 )
                , UInt , WatchSubDirs
                , UInt , ( FILE_NOTIFY_CHANGE_FILE_NAME   := 0x1   )
                       | ( FILE_NOTIFY_CHANGE_DIR_NAME    := 0x2   )
                       | ( FILE_NOTIFY_CHANGE_ATTRIBUTES  := 0x4   )
                       | ( FILE_NOTIFY_CHANGE_SIZE        := 0x8   )
                       | ( FILE_NOTIFY_CHANGE_LAST_WRITE  := 0x10  )
                       | ( FILE_NOTIFY_CHANGE_LAST_ACCESS := 0x20  )
                       | ( FILE_NOTIFY_CHANGE_CREATION    := 0x40  )
                       | ( FILE_NOTIFY_CHANGE_SECURITY    := 0x100 )
                , UInt , 0
                , UInt , &Dir%DirIdx%Overlapped
                , UInt , 0  )
}


; Handles one directory at a time.
; Returns non-zero if a change was detected.
; Returns zero if it timed out or a window message was received.
ReadDirectoryChanges(Timeout=-1)
{
    local hDir, r
    ; Wait for any event object to be signaled or a window message to be received.
    r := DllCall("MsgWaitForMultipleObjectsEx", UInt, DirIdx, UInt, &DirEvents
                                            , UInt, Timeout, UInt, 0x4FF, UInt, 0x6)
    if (r >= 0 && r < DirIdx) ; WAIT_OBJECT_*
    {
        r += 1
        ; At least one event object was signaled. Decode the FNI for this event.
        ; If more than one event object was signaled, this func must be called again.
        WatchFolder := Dir%r%Path
        PointerFNI := &Dir%r%FNI
        nReadLen := 0
        DllCall( "GetOverlappedResult", UInt, hDir
                    , UInt, &Dir%r%Overlapped, UIntP, nReadLen, Int, true )
        Gosub Decode_FILE_NOTIFY_INFORMATION
       
        ; Reset the event and call ReadDirectoryChangesW in async mode again.
        DllCall( "ResetEvent", UInt,NumGet( Dir%r%Overlapped, 16 ) )
        DllCall( "ReadDirectoryChangesW"
                , UInt , Dir%r%
                , UInt , &Dir%r%FNI
                , UInt , 0x10000   ;SizeOf_FNI := ( 64KB := 1024 * 64 )
                , UInt , Dir%r%WatchSubDirs
                , UInt , ( FILE_NOTIFY_CHANGE_FILE_NAME   := 0x1   )
                       | ( FILE_NOTIFY_CHANGE_DIR_NAME    := 0x2   )
                       | ( FILE_NOTIFY_CHANGE_ATTRIBUTES  := 0x4   )
                       | ( FILE_NOTIFY_CHANGE_SIZE        := 0x8   )
                       | ( FILE_NOTIFY_CHANGE_LAST_WRITE  := 0x10  )
                       | ( FILE_NOTIFY_CHANGE_LAST_ACCESS := 0x20  )
                       | ( FILE_NOTIFY_CHANGE_CREATION    := 0x40  )
                       | ( FILE_NOTIFY_CHANGE_SECURITY    := 0x100 )
                , UInt , 0
                , UInt , &Dir%r%Overlapped
                , UInt , 0  )
        return r
    }
    return 0
}


Decode_FILE_NOTIFY_INFORMATION:
;   PointerFNI := &FILE_NOTIFY_INFORMATION
  Loop
  {
    NextEntry   := NumGet( PointerFNI + 0  )
    Action      := NumGet( PointerFNI + 4  )
    FileNameLen := NumGet( PointerFNI + 8  )
    FileNamePtr :=       ( PointerFNI + 12 )

    VarSetCapacity( FileNameANSI, FileNameLen )
    DllCall( "WideCharToMultiByte", UInt,0, UInt,0, UInt,FileNamePtr, UInt
           , FileNameLen, Str,FileNameANSI, UInt,FileNameLen, UInt,0, UInt,0 )

    File := SubStr( FileNameANSI, 1, FileNameLen/2 )
    FullPath := WatchFolder . File

;    If ( Action = 0x1 )                            ; FILE_ACTION_ADDED   
;       Event := "New File"
;    If ( Action = 0x2 )                            ; FILE_ACTION_REMOVED 
;       Event := "Deleted"
;    If ( Action = 0x3 )                            ; FILE_ACTION_MODIFIED 
;       Event := "Modified"
;    If ( Action = 0x4 )                            ; FILE_ACTION_RENAMED_OLD_NAME
;       Event := "Renamed Fm"
;    If ( Action = 0x5 )                            ; FILE_ACTION_RENAMED_NEW_NAME
;       Event := "Renamed To"

    If (Action>=0x1 And Action<=0x5)
      Gosub,%actionprocedure%

    If !NextEntry
       Break
    Else
       PointerFNI := PointerFNI + NextEntry
  }
Return


EXIT:
  DllCall( "CloseHandle", UInt,hDir )
  ExitApp
Return
