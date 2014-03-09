;WinLock.ahk
; Lock individual windows with a password.
;Skrommel @ 2005

#SingleInstance,Ignore
SetWinDelay,0
DetectHiddenWindows,On
CoordMode,Mouse,Screen
CoordMode,ToolTip,Screen

applicationname=WinLock

error=
password=
locked=
Gosub,TRAYMENU

Loop
{
Loop,%locked_0%
{
  winid:=locked_%A_Index%
  WinSet,Disable,,ahk_id %winid%
  Sleep,500
}
}

TRAYMENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,LOCK
Menu,Tray,Add
Menu,Tray,Add,&Lock,CLICK
Menu,Tray,Add,&Unlock All,UNLOCK
Menu,Tray,Add
StringSplit,locked_,locked,`,
If locked=
{
  Menu,Tray,Disable,&Unlock All
  Menu,Tray,Add,<empty>,UNLOCK
  Menu,Tray,Disable,<empty>
}
Else
{
  locked_0-=1
  Loop,%locked_0%
  {
    winid:=locked_%A_Index%
    WinGetTitle,fulltitle,ahk_id %winid%  
    StringLeft,title,fulltitle,20
    If title<>%fulltitle%
      title=%title%...
    Menu,Tray,Add,%title%,UNLOCK
  }
}
Menu,Tray,Add
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,&Exit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return

CLICK:
Loop
{
  MouseGetPos,x,y,winid,controlid
  IfInString,locked,%winid%
    ToolTip,Already locked!
  Else
    ToolTip,Unlocked
  GetKeyState,state,LButton,
  If state=D
  {
    IfInString,locked,%winid%
    {
      WinGetPos,x,y,,,ahk_id %winid%
      ToolTip,Already locked!,%x%,%y%
      Sleep,2000
      ToolTip,
    }
    Else
      Gosub,LOCK
    Break
  }
  Sleep,100
}
Return

LOCK:
If password=
InputBox,password,%applicationname%,%error%Password:,Hide,200,150
If password=
{
   error=Empty password!`n`n
   Goto,LOCK
}
error=
locked=%locked%%winid%`,
WinSet,Disable,,ahk_id %winid%
WinGetPos,x,y,,,ahk_id %winid%
ToolTip,Locking...,%x%,%y%
Gosub,TRAYMENU
Sleep,2000
ToolTip,
Return

UNLOCK:
InputBox,input,%applicationname%,%error%Password?,Hide,200,150
If input<>%password%
{
   error=Wrong password!`n`n
   Goto,UNLOCK
}
error=
id:=A_ThisMenuItemPos-5
If id<1
  Loop,%locked_0%
  {
    winid:=locked_%A_Index%
    StringReplace,locked,locked,%winid%`,
    WinSet,Enable,,ahk_id %winid%
    WinActivate,ahk_id %winid%
    WinGetPos,x,y,,,ahk_id %winid%
    ToolTip,Unlocking...,%x%,%y%
  }
Else
{
  winid:=locked_%id%
  StringReplace,locked,locked,%winid%`,
  WinSet,Enable,,ahk_id %winid%
  WinActivate,ahk_id %winid%
  WinGetPos,x,y,,,ahk_id %winid%
  ToolTip,Unlocking...,%x%,%y%
}
Gosub,TRAYMENU
Sleep,2000
ToolTip,
Return

OnExit,TRAYMENU
Return

EXIT:
If locked<>
{
  error=Some windows are still locked!`n`n
  Gosub,UNLOCK
}
ExitApp


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Lock individual windows with a password
Gui,99:Add,Text,y+5,- Only light protection

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
