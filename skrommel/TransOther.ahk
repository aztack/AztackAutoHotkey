;TransOther.ahk
; Make transparent all but the active window
;Skrommel @ 2005

#SingleInstance,Force
SetWinDelay,0
SetBatchLines,-1

applicationname=TransOther

OnExit,STOP
Gosub,READINI
Gosub,TRAYMENU

START:
WinGet,id_,List,,,Program Manager
Loop,%id_%
{
  StringTrimRight,id,id_%A_Index%,0
  WinSet,Transparent,%trans%,ahk_id %id%
}
id:=0

Loop
{
  WinWaitNotActive,ahk_id %id%
  WinGet,id,Id,A
  WinGetClass,class,ahk_id %id%
  WinGetClass,oldclass,ahk_id %oldid%
  parent:=DllCall("GetParent","UInt",id)
  parent+=0
  If (id<>oldid)
  {
    If (class="Shell_TrayWnd") ; And oldclass="Progman")
      WinSet,Transparent,255,ahk_id %id%
    Else
      WinSet,Transparent,Off,ahk_id %id%
    If (parent<>oldid)
      WinSet,Transparent,%trans%,ahk_id %oldid%
    oldid:=id
  }
  Sleep,100
}


STOP:
WinGet,id_,List,,,Program Manager
Loop,%id_%
{
  StringTrimRight,id,id_%A_Index%,0
  WinSet,Transparent,Off,ahk_id %id%
}
WinSet,Transparent,Off,ahk_class Progman
Goto,EXIT


READINI:
IfNotExist,%applicationname%.ini
{
  ini=`;[Settings]
  ini=%ini%`n`;trans=150              `;0-255  Degree of transparency
  ini=%ini%`n
  ini=%ini%`n[Settings]
  ini=%ini%`ntrans=150
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
IniRead,trans,%applicationname%.ini,Settings,trans
Return


TRAYMENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Settings,SETTINGS
Menu,Tray,Add,&About,ABOUT
Menu,Tray,Add,E&xit,STOP
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


SETTINGS:
Gosub,READINI
RunWait,%applicationname%.ini
Reload


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Make transparent all but the active window
Gui,99:Add,Text,y+5,- Change transparency using Settings in the tray menu

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
  If ctrl in Static8,Static12,Static16
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp