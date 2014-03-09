;HideDesktop.ahk
; Hide the desktop icons when the mouse is elsewhere
;Skrommel @2006

applicationname=HideDeskTop

#SingleInstance,Force
#NoEnv

OnExit,EXIT
Gosub,INIREAD
Gosub,TRAYMENU

Loop
{
  Sleep,100
  MouseGetPos,,,win
  WinGetClass,class,ahk_id %win%
  If (class="#32769" Or class="Progman")
  {
    IfWinNotExist,Program Manager
    {
      show=1
      Sleep,%showdelay%
    }
  }
  Else
  {
    IfWinExist,Program Manager
    {
      show=0
      Sleep,%hidedelay%
    }
  }

  MouseGetPos,,,win
  WinGetClass,class,ahk_id %win%
  If (class="#32769" Or class="Progman")
  {
    If show=1
      WinShow,Program Manager
  }
  Else
  {
      WinHide,Program Manager
  }
}
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  IniWrite,1000,%applicationname%.ini,Settings,hidedelay
  IniWrite,1000,%applicationname%.ini,Settings,showdelay
}
IniRead,hidedelay,%applicationname%.ini,Settings,hidedelay
IniRead,showdelay,%applicationname%.ini,Settings,showdelay
Return

SETTINGS:
Run,%applicationname%.ini
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,HideDesktop
Menu,Tray,Tip,%applicationname%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Hide the desktop icons when the mouse is elsewhere.
Gui,99:Add,Text,y+10,- To change the settings, choose Settings in the tray menu.

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


EXIT:
WinShow,Program Manager
ExitApp