;Captain.ahk
; Copy and change a window's title
;Skrommel @ 2008


#NoEnv
#SingleInstance,Force
CoordMode,Mouse,Screen

applicationname=Captain
Gosub,INIREAD
Gosub,MENU
Gosub,TRAYMENU
ids=
Return


HOTKEY:
MouseGetPos,mx,my,mwin,mctrl
SendMessage,0x84,,(my<<16)|mx,,ahk_id %mwin% ;WM_NCHITTEST=0x84
If ErrorLevel=2 ;HTCAPTION
  Menu,menu,Show 
Return


MENU:
Menu,menu,Add,&Copy caption,COPY
Menu,menu,Add,C&hange caption,CHANGE
Return


COPY:
WinGetTitle,title,ahk_id %mwin%
Clipboard:=title
TOOLTIP("Caption copied: " title)
Return


CHANGE:
WinGetTitle,title,ahk_id %mwin%
InputBox,newtitle,%applicationname%,New title:,,,,,,,,%title%
If ErrorLevel=0
  If (newtitle<>title)
  {
    WinSetTitle,ahk_id %mwin%,,%newtitle%
    ids:=ids . mwin ","
    title_%mwin%:=newtitle
    SetTimer,UPDATE,-1000
  }  
Return

UPDATE:
Loop,Parse,ids,`,
{
  IfWinNotExist,ahk_id %A_LoopField%
  {
    StringReplace,ids,ids,% A_LoopField ",",
    title_%A_LoopField%=
    Continue
  }
  WinGetTitle,ctitle,ahk_id %A_LoopField%
  If (ctitle<>title_%A_LoopField%)
    WinSetTitle,ahk_id %A_LoopField%,,% title_%A_LoopField%
}
SetTimer,UPDATE,-1000
Return


TOOLTIP(tip)
{
  ToolTip,%tip%
  SetTimer,TOOLTIPOFF,-3000
}


TOOLTIPOFF:
ToolTip,
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
`;[Settings]
`;hotkey=MButton    `;!=Alt +=Shift ^=Ctrl #=Win 

[Settings]
hotkey=MButton
)
  FileAppend,%ini%,%applicationname%.ini
}
IniRead,hotkey,%applicationname%.ini,Settings,hotkey
If (hotkey="" Or hotkey="ERROR")
  hotkey=MButton
Hotkey,%hotkey%,HOTKEY,On
Return


SETTINGS:
Hotkey,%hotkey%,HOTKEY,Off
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
Hotkey,%hotkey%,HOTKEY,On
Return


EXIT:
ExitApp


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.2
Gui,99:Font
Gui,99:Add,Text,y+10,Copy and change a window's title
Gui,99:Add,Text,y+5,- Use the middle mousebutton on a window's caption
Gui,99:Add,Text,y+5,- Change hotkey using Settings in the tray menu

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

Gui,99:+AlwaysOnTop
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
