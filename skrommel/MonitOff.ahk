;MonitOff.ahk
; Turns off the monitor at user defined idle times during the day
;Skrommel @ 2008

#SingleInstance,Force
#NoEnv

applicationname=MonitOff

Gosub,INIREAD
Gosub,TRAYMENU

off=0
Loop
{
  Sleep,1000
  now=%A_Hour%%A_Min%

  If (A_TimeidlePhysical>idleoutside And now<start Or now>=end And off=0)
    Gosub,OFF
  Else
  If (A_TimeidlePhysical>idleinside And now>=start And now<end And off=0) 
    Gosub,OFF
  Else
    off=0
}

OFF:
  SendMessage,0x112,0xF170,2,,Program Manager
  off=1
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
`;[Settings]
`;start=0900`tHHMM`tStart time for idleinside
`;end=1700`tHHMM`tEnd time for idleinside
`;idleinside=5`tM`tTime to wait when inside start-end
`;idleoutside=30`tM`tTime to wait when outside start-end

[Settings]
start=0900
end=1700
idleinside=5
idleoutside=30
)
  FileAppend,%ini%,%applicationname%.ini
}
IniRead,start,%applicationname%.ini,Settings,start
IniRead,end,%applicationname%.ini,Settings,end
IniRead,idleinside,%applicationname%.ini,Settings,idleinside
IniRead,idleoutside,%applicationname%.ini,Settings,idleoutside
If !(start>=0000 And start<=2400)
{
  start=0900
  IniWrite,%start%,%applicationname%.ini,Settings,start
}
If !(end>=0000 And end<=2400)
{
  end=1700
  IniWrite,%end%,%applicationname%.ini,Settings,end
}
If !(idleinside>=1 And idleinside<=1440)
{
  idleinside=1
  IniWrite,%idleinside%,%applicationname%.ini,Settings,idleinside
}
If !(idleoutside>=1 And idleoutside<=1440)
{
  idleoutside=1
  IniWrite,%idleoutside%,%applicationname%.ini,Settings,idleoutside
}
idleinside*=60000
idleoutside*=60000
Return


EXIT:
ExitApp


SETTINGS:
Gui,Destroy
FileRead,ini,%applicationname%.ini
Gui,Font,Courier New
Gui,Add,Edit,Vnewini -Wrap W400,%ini%
Gui,Font
Gui,Add,Button,GSETTINGSOK Default W75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Gui,Show,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
FileDelete,%applicationname%.ini
FileAppend,%newini%,%applicationname%.ini
Gosub,INIREAD
Return


GuiEscape:
GuiClose:
SETTINGSCANCEL:
Gui,Destroy
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add
Menu,Tray,Add,&Settings...,SETTINGS
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
Gui,99:Add,Text,y+10,Turns off the monitor at user defined idle times during the day
Gui,99:Add,Text,y+5,- Change settings using Settings in the Tray menu

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
