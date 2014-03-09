;Removable.ahk
; Eject removable drives by doubleclicking.
;Skrommel @2007

#SingleInstance,Force
#NoEnv
#NoTrayIcon

applicationname=Removable

Gui,+ToolWindow +Resize ;-Border -Caption
Gui,Margin,0,0
Gui,Add,ListView,Vlistview GLISTVIEW,Drive|Volume Label|Type|Free Space|Capacity|Filesystem|Status|Serial Number
Gui,Add,Text,vtext,%A_Space%For more tools, information and donations, visit 
Gui,Add,Text,x+5 cBlue vurl G1HOURSOFTWARE,www.1HourSoftware.com

hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 

DriveGet,list,List
Loop,Parse,list,
{
  drive:=A_LoopField ":"
  Gosub,DRIVEGET
  LV_Add("",drive,label,type,free " MB",capacity " MB",fs,status,serial)
}

Loop,8
  LV_ModifyCol(A_Index,"AutoHdr")

LV_ModifyCol(4,"Integer Right")
LV_ModifyCol(5,"Integer Right")
LV_ModifyCol(8,"Integer Right")
;LV_ModifyCol(3,"SortDesc")

Gui,Show,w600 h200,%applicationname%
Return


DRIVEGET:
DriveGet,type,Type,%drive%\

If type=CDROM
  DriveGet,status,StatusCD,%drive%\
Else
  DriveGet,status,Status,%drive%\

DriveGet,capacity,Capacity,%drive%\
If capacity=
  capacity=0
StringSplit,part_,capacity,
capacity=
Loop,% part_0
{
  If ((A_Index=4 Or A_Index=8) And part_0>A_Index)
    capacity:=capacity " "
  pos:=part_0-A_Index+1
  capacity:=capacity . part_%pos%
}
  
DriveSpaceFree,free,%drive%\
If free=
  free=0
StringSplit,part_,capacity,
free=
Loop,% part_0
{
  If ((A_Index=4 Or A_Index=8) And part_0>A_Index)
    free:=free " "
  pos:=part_0-A_Index+1
  free:=free . part_%pos%
}
  
DriveGet,fs,Fs,%drive%\
DriveGet,label,Label,%drive%\
DriveGet,serial,Serial,%drive%\
Return


LISTVIEW:
row:=A_EventInfo
If A_GuiEvent=DoubleClick
  Gosub,EJECT
Return


EJECT:
LV_GetText(drive,row,1)
LV_GetText(label,row,2)
LV_GetText(type,row,3)
LV_GetText(free,row,4)
LV_GetText(capacity,row,5)
LV_GetText(fs,row,6)
;LV_GetText(status,row,7)
LV_GetText(serial,row,8)


If type=CDROM
{
  DriveGet,status,StatusCD,%drive%\
  If status=open
  {
    ToolTip,Retracting %drive%...
    Drive,Eject,%drive%,1
  }
  Else
  {
    ToolTip,Ejecting %drive%...
    Drive,Eject,%drive%
  }
}

If type=Removable
{
  DriveGet,status,Status,%drive%\
  If status=NotReady
    ToolTip,%drive% already disconnected
  Else
  {
    ToolTip,Disconnecting %drive%...
    hVolume := DllCall("CreateFile"
        , Str, "\\.\" . drive
        , UInt, 0x80000000 | 0x40000000  ; GENERIC_READ | GENERIC_WRITE
        , UInt, 0x1 | 0x2  ; FILE_SHARE_READ | FILE_SHARE_WRITE
        , UInt, 0
        , UInt, 0x3  ; OPEN_EXISTING
        , UInt, 0, UInt, 0)
    if hVolume <> -1
    {
        DllCall("DeviceIoControl"
            , UInt, hVolume
            , UInt, 0x2D4808   ; IOCTL_STORAGE_EJECT_MEDIA
            , UInt, 0, UInt, 0, UInt, 0, UInt, 0
            , UIntP, dwBytesReturned  ; Unused.
            , UInt, 0)
        DllCall("CloseHandle", UInt, hVolume)
    }
  }
}
Sleep,3000
ToolTip
Gosub,DRIVEGET
LV_Modify(row,"",drive,label,type,free,capacity,fs,status,serial)
Return


1HOURSOFTWARE:
Run,http://www.1hoursoftware.com,,UseErrorLevel
Return


WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,winid,ctrl
  If ctrl in Static2
    DllCall("SetCursor","UInt",hCurs)
}
Return


GuiSize:
If A_EventInfo = 1  ; Minimized
  Return
GuiControl,Move,listview,% "W" . (A_GuiWidth) . " H" . (A_GuiHeight-20)
GuiControl,Move,text,% " Y" . (A_GuiHeight-17)
GuiControl,Move,url,% " Y" . (A_GuiHeight-17)
Return


GuiClose:
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
ExitApp