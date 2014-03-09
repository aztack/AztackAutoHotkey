;ShortcutSync.ahk
; Command line tool to make shortcuts to files, preserving the tree structure, and removing missing files.
; Example: ShortcutSync.exe C:\Music D:\MusicLinks mp3 wav TrayTip
; Syntax:  ShortcutSync.exe <fromfolder> <tofolder> <extentions> [TrayTip]
; <fromfolder> the folder where the files are located
; <tofolder>   the folder where the links should be created
; <extensions> the file types to make links to
; TrayTip      add it for visual feedback
;Skrommel@2006

#SingleInstance,Off
SetBatchLines,-1

applicationname=ShortcutSync

from=%1%
to=%2%
traytip=0
ext=
Loop
{
  param:=A_Index+2
  If %param%=TrayTip
  {
    traytip=1
    Continue
  }
  If %param%=
    Break
  param:=%param%
  ext=%ext%%param%,
}
StringTrimRight,ext,ext,1

IfNotExist,%from%
  Goto,ABOUT
If to=
  Goto,ABOUT
If ext=
  Goto,ABOUT

If traytip=1
{
  tip=Syncing shortcuts...
  SetTimer,TIP,500
}

removed=0
folders=0
Loop,%to%\*.lnk,0,1   ;Remove links to missing files
{
  StringReplace,relative,A_LoopFileDir,%to%
  StringReplace,file,A_LoopFileName,.lnk
  IfNotExist,%from%%relative%\%file%
  {
    FileDelete,%A_LoopFileFullPath%
    FileRemoveDir,%to%%relative%,0
    If ErrorLevel=1
      folders+=1
    tip=Deleting: %to%%relative%\%A_LoopFileName%
    removed+=1    
  }
}

created=0
Loop,%from%\*.*,0,1   ;Create links to files
{
  StringReplace,relative,A_LoopFileDir,%from%
  If A_LoopFileExt In %ext%
  IfNotExist,%to%%relative%\%A_LoopFileName%.lnk
  {
    FileCreateDir,%to%%relative%
    FileCreateShortcut,%A_LoopFileFullPath%,%to%%relative%\%A_LoopFileName%.lnk
    tip=Linking: %to%%relative%\%A_LoopFileName%
    created+=1
  }
}

If traytip=1
{
  tip=Finished syncing shortcuts!`n%created% links created`n%removed% links removed`n%folders% folders removed
  Sleep,5000
}
ExitApp


TIP:
TrayTip,%applicationname%,%tip%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Make shortcuts to files, preserving the tree structure, and removing links to missing files.
Gui,99:Add,Text,y+5,- Example:`tShortcutSync.exe C:\Music D:\MusicLinks mp3 wav TrayTip
Gui,99:Add,Text,y+5,- Syntax:`tShortcutSync.exe <fromfolder> <tofolder> <extentions> [TrayTip]
Gui,99:Add,Text,y+0,<fromfolder>`tthe folder where the files are located
Gui,99:Add,Text,y+0,<tofolder>`tthe folder where the links should be created
Gui,99:Add,Text,y+0,<extensions>`tthe file types to make links to
Gui,99:Add,Text,y+5,TrayTip`t`tadd it for visual feedback

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
ExitApp

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static13,Static17,Static21
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return

