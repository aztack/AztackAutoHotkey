;TakeABreak.ahk
; Locks the computer at user defined intervals
; Change the work and pause time, and add your own message. 
; Timess are in minutes, so be careful! 
; The only way out is to restart the computer!
; Place it on the Start-menu's Programs\Startup to have it run on startup.
;Skrommel @2005


#SingleInstance,Ignore
#Persistent
;#NoTrayIcon

applicationname=TakeABreak

OnExit,NOTHING

Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,NoDefault

READINI:
IfNotExist,%applicationname%.ini
{
  ini=`;%applicationname%.ini
  ini=%ini%`n`;[Settings]
  ini=%ini%`n`;work=45					;How long a work session should last, in minutes
  ini=%ini%`n`;pause=15					;How long a pause should last, in minutes
  ini=%ini%`n`;message1=Please save your work!		;Message to display before a pause
  ini=%ini%`n`;message2=How about a little break?	;Message to display during a pause
  ini=%ini%`n
  ini=%ini%`n[Settings]
  ini=%ini%`nwork=45
  ini=%ini%`npause=15
  ini=%ini%`nmessage1=Please save your work!
  ini=%ini%`nmessage2=How about a little break?
  FileAppend,%ini%,%applicationname%.ini
  ini=

  ABOUT:
  about=Locks the computer in user defined intervals.
  about=%about%`n
  about=%about%`nEdit the %applicationname%.ini-file to change the work and pause time,
  about=%about%`nand add your own message. Times are in minutes, so be careful! 
  about=%about%`nThe only way out is to restart the computer!
  about=%about%`n
  about=%about%`nPlace it on the Start-menu's Programs\Startup to have it run on startup.
  about=%about%`n
  about=%about%`nSkrommel @2005    www.1HourSoftware.com
  MsgBox,0,%applicationname%,%about%
  about=
}
IniRead,work,%applicationname%.ini,Settings,work
IniRead,pause,%applicationname%.ini,Settings,pause
IniRead,message1,%applicationname%.ini,Settings,message1
If (message1="" Or message1="ERROR")
  message1=Please save your work!
IniRead,message2,%applicationname%.ini,Settings,message2
If (message2="" Or message2="ERROR")
  message2=How about a little break?

WORK:
RegWrite,REG_DWORD,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Policies\Explorer,NoLogoff,0
start=%A_Now%
end=%start%
If work<1
  work=1
EnvAdd,end,%work%,Minutes
EnvAdd,end,-1,Minutes
Loop
{
  left=%end%
  EnvSub,left,%A_Now%,Minutes
  Sleep,0
  IfWinActive,ahk_class #32770,CPU
    WinClose,ahk_class #32770,CPU
  If A_Now>%end%
    Break
  minutes:=left+2
  Menu,Tray,Tip,Pause begins in %minutes% minutes
}
start=%A_Now%
end=%start%
EnvAdd,end,1,Minutes
Loop
{
  RegWrite,REG_DWORD,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Policies\Explorer,NoLogoff,1
  left=%end%
  EnvSub,left,%A_Now%,Seconds
  ToolTip,Pause begins in %left% seconds`n`n%message1%
  Sleep,0
  IfWinActive,ahk_class #32770,CPU
    WinClose,ahk_class #32770,CPU
  If A_Now>%end%
    Break 
}

PAUSE:
start=%A_Now%
end=%start%
If work<1
  work=1
EnvAdd,end,%pause%,Minutes
EnvAdd,end,-1,Minutes
Loop
{
  BlockInput,On
  left=%end%
  EnvSub,left,%A_Now%,Minutes
  minutes:=left+2  
  ToolTip,Work resumes in %minutes% minutes`n`n%message2%
  Sleep,0
  IfWinActive,ahk_class #32770,CPU
    WinClose,ahk_class #32770,CPU
  If A_Now>%end%
    Break 
  Menu,Tray,Tip,Work resumes in %minutes% minutes
}
start=%A_Now%
end=%start%
EnvAdd,end,1,Minutes
Loop
{
  BlockInput,On
  left=%end%
  EnvSub,left,%A_Now%,Seconds
  ToolTip,Work resumes in %left% seconds
  Sleep,0
  IfWinActive,ahk_class #32770,CPU
    WinClose,ahk_class #32770,CPU
  If A_Now>%end%
    Break 
}

END:
BlockInput,Off
RegWrite,REG_DWORD,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Policies\Explorer,NoLogoff,0
ToolTip,Move the mouse to resume working
MouseGetPos,oldx,oldy
MOUSE:
MouseGetPos,x,y
If x=%oldx%
If y=%oldy%
  Goto,MOUSE
ToolTip,
Goto,WORK

NOTHING:
Return


ABOUT1:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Press a key three times or more to apply accents
Gui,99:Add,Text,y+5,- Change accents using Settings in the tray menu
Gui,99:Add,Text,y+5,- Doesn't work properly with shifted keys while CapsLock is on

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
