;ClipStep.ahk
;Control multiple clipboards using only the keyboard's Ctrl-X-C-V
; Select some text, press Ctrl-C a couple of times to copy it to multiple new clipboards. 
; Now hold down Ctrl and press V repeatedly to step through the clipboards. C steps backwards. 
; When you've got the clipboard you want, release Ctrl to paste. 
; To delete a clipboard, hold down Ctrl, press V followed by X twice to delete, three times to 
; delete all, or once to cancel. Release Ctrl to accept. 
; The clipboards are saved to separate files, so place the sctipt in it's own folder. 
;Skrommel @2005

#SingleInstance,Force
SetBatchLines,-1

applicationname=ClipStep

numofclips=0
activeclip=1
paste=no
delete=no

Gosub,TRAYMENU
Gosub,INDEX

LOOP:
Sleep,100
GetKeyState,state,CTRL
If state=u
{
  If delete=delete
  { 
    readclip=filearray%activeclip%
    readclip:=%readclip%
    Filedelete,%readclip%.clip
    tooltip=Deleting Clip %activeclip% of %numofclips%
    Gosub,TOOLTIP
    Gosub,INDEX
    Gosub,FINDPREV
  }
  Else
  If delete=all
  {
    tooltip=Deleting all clips
    Gosub,TOOLTIP
    Filedelete,*.clip
    numofclips=0
    activeclip=0
    filearray1=0
    Gosub,INDEX
    activeclip=%numofclips%
  }
  Else    
  If paste=paste
  {
    readclip=filearray%activeclip%
    readclip:=%readclip%
    tooltip=Pasting clip %activeclip%
    Gosub,TOOLTIP
    Gosub,PASTECLIP
  }
  delete=no
  paste=no
}
Goto,LOOP


$^x::
If paste<>no
{
  If delete=delete
  {
    ToolTip,Delete all clips
    SetTimer,TOOLTIPOFF,Off
    delete=all
    paste=yes
    Return
  }
  Else
  If delete=cancel
  {
    If numofclips<1
    {
      tooltip=No clip exists
      Gosub,TOOLTIP
      Return
    }
    readclip=filearray%activeclip%
    readclip:=%readclip%
    FileRead,Clipboard,*c %readclip%.clip
    StringLeft,clip,Clipboard,100
    ToolTip,Delete Clip %activeclip% of %numofclips%`n%clip% 
    SetTimer,TOOLTIPOFF,Off
    delete=delete
    paste=yes
    Return
  }
  Else
  {
    tooltip=Cancel
    Gosub,TOOLTIP
    delete=cancel
    paste=yes
    Return
  }
}
clip1:=ClipboardAll
Clipboard=
Send,^x
ClipWait,1
clip2:=ClipboardAll
If clip2=
{
  tooltip=Empty selection
  Gosub,TOOLTIP
}
Else
If clip1<>%clip2%
{
  tooltip=Copying to clip 1
  Gosub,TOOLTIP
  Gosub,ADDCLIP
  Gosub,INDEX
}
Else
{
  tooltip=Same selection
  Gosub,TOOLTIP
}
clip1=
clip2=
Return

 
$^c::
If paste<>no
{
  If numofclips<1
  {
    tooltip=No clip exists
    Gosub,TOOLTIP
    delete=no
    paste=yes
    Return
  }
  Gosub,FINDPREV
  Gosub,SHOWCLIP
  delete=no
  paste=paste
  Return
}
clip1:=ClipboardAll
Clipboard=
Send,^c
clip2:=ClipboardAll
If clip2=
{
  tooltip=Empty selection
  Gosub,TOOLTIP
}
Else
If clip1<>%clip2%
{
  tooltip=Copying to clip 1
  Gosub,TOOLTIP
  Gosub,ADDCLIP
  Gosub,INDEX
}
Else
{
  tooltip=Same selection
  Gosub,TOOLTIP
}
clip1=
clip2=
Return

 
$^v::
If numofclips<1
{
  tooltip=No clip exists
  Gosub,TOOLTIP
  delete=no
  paste=yes
  Return
}
If paste<>no
  Gosub,FINDNEXT
Gosub,SHOWCLIP
delete=no
paste=paste
Return


ADDCLIP:
readclip=filearray1
readclip:=%readclip%
lastclip=%readclip%
lastclip+=1
numofclips+=1
activeclip=1
IfExist,%lastclip%.clip
  FileDelete,%lastclip%.clip
FileAppend,%ClipboardAll%,%lastclip%.clip
Return


SHOWCLIP:
readclip=filearray%activeclip%
readclip:=%readclip%
clip1:=ClipboardAll
IfExist,%readclip%.clip
  FileRead,Clipboard,*c %readclip%.clip
StringLeft,clip2,Clipboard,100
If clip2=
  clip2=... Image
ToolTip,Clip %activeclip% of %numofclips%`n%clip2% ... 
SetTimer,TOOLTIPOFF,Off
Clipboard:=clip1
clip1=
clip2=
Return
 

PASTECLIP:
readclip=filearray%activeclip%
readclip:=%readclip%
IfExist,%readclip%.clip
  FileRead,Clipboard,*c %readclip%.clip
Send,^v
delete=no
paste=no
Return


DELETECLIP:
delete=no
paste=no
Return


TOOLTIP:
ToolTip,%tooltip%
SetTimer,TOOLTIPOFF,900
Return


TOOLTIPOFF:
ToolTip,
SetTimer,TOOLTIP,Off
Return


INDEX:
filelist=
Loop,*.clip
{
  StringTrimRight,filename,A_LoopFileName,5
  filelist=%filelist%%filename%`n
}
StringTrimRight,filelist,filelist,1
Sort,filelist,N R
StringSplit,filearray,filelist,`n
numofclips=%filearray0%
Return


FINDNEXT:
  If numofclips<1
  {
    tooltip=No clip exists
    Gosub,TOOLTIP
    delete=no
    paste=yes
    Return
  }
activeclip+=1
If activeclip>%numofclips%
  activeclip=1
Return


FINDPREV:
  If numofclips<1
  {
    tooltip=No clip exists
    Gosub,TOOLTIP
    delete=no
    paste=yes
    Return
  }
activeclip-=1
If activeclip<1
  activeclip=%numofclips%
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
Gui,99:Add,Text,y+10,- Control multiple clipboards using only the keyboard's Ctrl-X-C-V
Gui,99:Add,Text,y+10,- Select some text, press Ctrl-C a couple of times to copy it to multiple new clipboards. 
Gui,99:Add,Text,y+5 ,Now hold down Ctrl and press V repeatedly to step through the clipboards. C steps backwards. 
Gui,99:Add,Text,y+5 ,When you've got the clipboard you want, release Ctrl to paste. 
Gui,99:Add,Text,y+10,- To delete a clipboard, hold down Ctrl, press V followed by X twice to delete, three times to 
Gui,99:Add,Text,y+5,delete all, or once to cancel. Release Ctrl to accept. 
Gui,99:Add,Text,y+10,- The clipboards are saved to separate files, so place the sctipt in it's own folder. 

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


EXIT:
ExitApp
