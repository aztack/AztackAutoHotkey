;DelEmpty.ahk
; List and delete empty folders.
;Skrommel @2006

#SingleInstance,Force
#NoTrayIcon
SetBatchLines,-1

applicationname=DelEmpty

OnExit,EXIT

Process,Exist
pid:=ErrorLevel

Gui,+Resize
Gui,Add,Button,Default GBROWSE xm ym,Browse
Gui,Add,Button,GDELETE x+5 ym,Delete
Gui,Add,Button,GABOUT x+5 ym,About
Gui,Font,Bold CBlue
Gui,Add,Text,x+10 ym+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,Font
Gui,Add,ListView,Checked Count100 Vlistview GLISTVIEW xm,Delete|Files|Folders|Programs|Size (KB)|Path
Gui,Add,Text,vstatus w300,Press Browse to start counting
Gui,Show,H400,DelEmpty - List and delete empty folders - 1 Hour Software by Skrommel

hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 

includefolders=0
startfolder=
Return


COUNT:
LV_Delete()
LV_ModifyCol(1,"AutoHdr")
LV_ModifyCol(2,"AutoHdr Integer")
LV_ModifyCol(3,"AutoHdr Integer")
LV_ModifyCol(4,"AutoHdr Integer")
LV_ModifyCol(5,"AutoHdr Integer")
LV_ModifyCol(6,"AutoHdr")

Loop,%startfolder%\*.*,2,1
{
  files=0
  folders=0
  programs=0
  size=0
  Loop,%A_LoopFileLongPath%\*.*,1,1
  {
    FileGetAttrib,attrib,%A_LoopFileLongPath%
    IfInString,attrib,D
      folders+=1
    Else
    If A_LoopFileExt In exe,com,cmd,bat,pif
      programs+=1
    Else
      files+=1
    size+=%A_LoopFileSizeKB%
    GuiControl,,status,Counting - %files%
  }
  If (files=0 And programs=0)
    LV_Add("Check","",files,folders,programs,size,A_LoopFileLongPath)
  Else
    LV_Add("","",files,folders,programs,size,A_LoopFileLongPath)
}

LV_ModifyCol(4,"Sort")
LV_ModifyCol(3,"Sort")
LV_ModifyCol(2,"Sort")
GuiControl,,status,Check the folders you want to delete and press Delete
Return


BROWSE:
Gui,Submit,NoHide
FileSelectFolder,newstartfolder,*%startfolder%
If newstartfolder<>
{
  startfolder=%newstartfolder%
  Gosub,COUNT
}
Return


DELETE:
MsgBox,1,DelEmpty,Delete checked folders and their files and subfolders?
IfMsgBox,Cancel
  Return
Loop
{
  row:=LV_GetNext(0,"C")
  If row=0
    Break
  LV_GetText(folder,row,6)
  FileRemoveDir,%folder%,1
  LV_Delete(row)
  GuiControl,,status,Deleting - %A_Index%
}
GuiControl,,status,
LV_Delete()
MsgBox,0,DelEmpty,Finished deleting!
GuiControl,,status,Press Browse to start counting
Return


LISTVIEW:
If A_GuiEvent=DoubleClick
{
  LV_GetText(folder,A_EventInfo,6)
  Run,Explorer.exe /e`,%folder%
}
Return


ABOUT:
Gui,2:Destroy
Gui,2:Add,Picture,Icon1,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,Delempty v1.2
Gui,2:Font
Gui,2:Add,Text,xm,List and delete empty folders.
Gui,2:Add,Text,xm,- Show file-, folder-, programcount and size of files and subfolders.
Gui,2:Add,Text,xm,- Sort by files, size or path.
Gui,2:Add,Text,xm,- Doubleclick to explore a folder.
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

ABOUTOK:
Gui,2:Destroy
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,winid,ctrl
  If ctrl in Static1,Static11,Static16,Static21
    DllCall("SetCursor","UInt",hCurs)
  Return
}

GuiSize:
If A_EventInfo=1
  Return
GuiControl,Move,listview, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 60)
GuiControl,Move,status,% "Y" . (A_GuiHeight - 20)
Return


GuiClose:
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
Goto,EXIT


EXIT:
Process,Close,%pid%
ExitApp
