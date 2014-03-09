;PauseProcess.ahk
; Pause a program and run programs before and after
;Skrommel @ 2007

FileInstall,pausep.exe,pausep.exe

applicationname=PauseProcess

#NoEnv
#SingleInstance,Off

If 0<>0
{
  Loop
  {
    Process,Wait,%1%
    pid:=ErrorLevel
    RunWait,pausep.exe %pid%,,Hide
    running=%running%%pid%,
    If 2<>
      RunWait,%2%
    RunWait,pausep.exe %pid% /r,,Hide
    Process,WaitClose,%pid%
    If 3<>
      RunWait,%3%
  }
}
Else
{
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Pause a program and run programs before and after.
Gui,99:Add,Text,y+5,- Command line:
Gui,99:Add,Text,y+5,PauseProcess.exe "<program to pause>" ["<program to run before>" "<program to run after>"]
Gui,99:Add,Text,y+5,- Example: 
Gui,99:Add,Text,y+5,PauseProcess.exe "Notepad.exe" "Pbrush.exe" "Calc.exe"
Gui,99:Add,Text,y+10,- Uses PauseP.exe by Daniel Turion at
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GPAUSEP,http://www.codeproject.com/threads/pausep.asp
Gui,99:Font

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
}

1HOURSOFTWARE:
  Run,http://www.1hoursoftware.com,,UseErrorLevel
Return

DONATIONCODER:
  Run,http://www.donationcoder.com,,UseErrorLevel
Return

AUTOHOTKEY:
  Run,http://www.autohotkey.com,,UseErrorLevel
Return

PAUSEP:
  Run,http://www.codeproject.com/threads/pausep.asp,,UseErrorLevel
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
  If ctrl in Static9,Static13,Static17,Static21
    DllCall("SetCursor","UInt",hCurs)
  Return
}


