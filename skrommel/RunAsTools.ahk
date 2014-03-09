;RunAsTools.ahk
; Collect your system tools and run them as another user
;Skrommel @ 2005

#SingleInstance,Force

applicationname=RunAsTools

Gosub,READINI
Gosub,TRAYMENU
Gosub,GUI
Return

GUI:
Gui,Destroy
Gui,+Resize
tabs=
Loop,%tabcount%
{
  tabname:=tabname_%A_Index%
  tabs=%tabs%%tabname%|
}
StringTrimRight,tabs,tabs,1

IniRead,closeonrun,%applicationname%.ini,Settings,closeonrun
IniRead,users,%applicationname%.ini,Settings,users
StringReplace,users,users,`,,||
StringReplace,users,users,`,,|,All

Gui,Add,Text,x10 ym,%A_Space%%A_Space%User
Gui,Add,ComboBox,vuser y+2 w100,%users%
Gui,Add,Text,x120 ym,%A_Space%%A_Space%Password
Gui,Add,Edit,Vpassword Password* y+2 w100
Gui,Add,Text,x230 ym,%A_Space%%A_Space%Domain
Gui,Add,Edit,Vdomain y+2 w100

Gui,Add,Text,x10,%A_Space%%A_Space%Command Line
Gui,Add,Edit,Vexecute x10 y+2 w260
Gui,Add,Button,x+10 w30 GEXECUTE,Execute

Gui,Add,Tab,xm y+5 w320 h23,%tabs%

Loop,%tabcount%
{
  column=1
  y=85
  tab=%A_Index%
  Gui,Tab,%tab%
  linecount:=linecount_%A_Index%
  Loop,%linecount%
  {
    name:=tab_%tab%_%A_Index%_1
    description:=tab_%tab%_%A_Index%_2
    program:=tab_%tab%_%A_Index%_3
    icon:=tab_%tab%_%A_Index%_6
    If icon=
      icon=%program%
    iconnumber:=tab_%tab%_%A_Index%_7
    If iconnumber=
      iconnumber=1
    If column=1
    {
      x:=20
      y:=y+34
    }
    Else
      x:=170
    Gui,Add,Pic,x%x% y%y% Options Icon%iconnumber% GRUN,%icon%
    Gui,Font,Bold
    Gui,Add,Text,x+5 yp+4 GRUN,%name%
    Gui,Font,Normal
    Gui,Add,Text,y+0 GRUN,%description%
    column*=-1
  }
}
Gui,Show,,%applicationname%
Return

EXECUTE:
Gui,Submit,NoHide
If password<>
  RunAs,%user%,%password%,%domain%
Transform,program,Deref,%execute%
Run,%execute%
RunAs,
If closeonrun=1
  Gui,Destroy
Return

RUN:
MouseGetPos,,,winid,id
ControlGet,activetab,Tab,,SysTabControl321,ahk_id %winid%
StringTrimLeft,id,id,6

prevtabs:=activetab-1
buttoncount=0
Loop,%prevtabs%
{
  buttoncount:=buttoncount+linecount_%A_Index%
}
id:=(id-1)/3-buttoncount
Transform,id,Floor,id
Gui,Submit,NoHide
program:=tab_%activetab%_%id%_3
arguments:=tab_%activetab%_%id%_4
workingdir:=tab_%activetab%_%id%_5
If password<>
  RunAs,%user%,%password%,%domain%
Transform,program,Deref,%program%
Transform,arguments,Deref,%arguments%
Run,%program% %arguments%,%workingdir%
RunAs,
If closeonrun=1
  Gui,Destroy
Return

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,GUI
Menu,Tray,Add,
Menu,Tray,Add,Show Window...,GUI
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return

TOGGLE:
Menu,Tray,ToggleCheck,&Enabled
Pause,Toggle
Return

SETTINGS:
Gosub,READINI
Run,%applicationname%.ini
Return


READINI:
IfNotExist,%applicationname%.ini
{
  ini=;[Settings]
  ini=%ini%`n`;users=Administrator,Guest   `;List of users to show
  ini=%ini%`n`;closeonrun=1                `;0=NO 1=Yes  Close the tool window when a program is run
  ini=%ini%`n`;
  ini=%ini%`n`;[Name of the first tab]
  ini=%ini%`n`;Name,Description,Program,Arguments,WorkingDir,Icon,IconNumber
  ini=%ini%`n`;Name,Description,Program,Arguments,WorkingDir,Icon,IconNumber
  ini=%ini%`n`; 
  ini=%ini%`n`;[Name of the second tab]
  ini=%ini%`n`;Name,Description,Program,Arguments,WorkingDir,Icon,IconNumber
  ini=%ini%`n`;
  ini=%ini%`n`;  Instead of `, (comma), use <comma>
  ini=%ini%`n
  ini=%ini%`n[Settings]
  ini=%ini%`nusers=Administrator,Guest
  ini=%ini%`ncloseonrun=1
  ini=%ini%`n
  ini=%ini%`n[Tools]
  ini=%ini%`nBoot.ini,Notepad,C:\Windows\Notepad.exe,C:\Boot.ini,C:\,C:\Windows\Notepad.exe,1
  ini=%ini%`nSystemEditor,MSConfig,MSConfig.exe,,,,
  ini=%ini%`nIpConfiguration,Command,cmd,/k ipconfig /all,,`%SystemRoot`%\system32\SHELL32.dll,19
  ini=%ini%`nFavorites,Explorer,Explorer.exe,/e<comma>`%UserProfile`%\Favorites,,`%SystemRoot`%\system32\SHELL32.dll,44
  ini=%ini%`nRegistryEditor,RegEdit,RegEdit.exe,,,,
  ini=%ini%`n[Games]
  ini=%ini%`nSolitaire,Card game,C:\Windows\System32\Sol.exe,,,
  FileAppend,%ini%,%applicationname%.ini
  ini=

Run,Services.msc
WinWait,ahk_class MMCMainFrame
WinActivate,ahk_class MMCMainFrame
WinWaitActive,ahk_class MMCMainFrame
Send,{Tab}Secondary Logon
Sleep,500,
Send,{Enter}
Sleep,500
MsgBox,0,%applicationname%,Please make shure that the Secondary Logon service is running,`nand set to automatically run on startup.
}
tabcount=0
Loop
{
  FileReadLine,line,%applicationname%.ini,%A_Index%
  If ErrorLevel<>0
    Break
  IfInString,line,[Settings]
    Continue
  IfInString,line,users=
    Continue
  IfInString,line,closeonrun=
    Continue
  StringLeft,char,line,1
  If char=`;
    Continue
  If char=[
  {
    tabcount+=1
    linecount_%tabcount%=0
    StringTrimLeft,line,line,1
    StringTrimRight,line,line,0
    StringTrimRight,tabname_%tabcount%,line,1
  }
  else
  {
    linecount_%tabcount%+=1
    temp:=linecount_%tabcount%
    StringSplit,tab_%tabcount%_%temp%_,line,`,
    Loop,7
    {
      StringReplace,tab_%tabcount%_%temp%_%A_Index%,tab_%tabcount%_%temp%_%A_Index%,<comma>,`,
    }
  }  
}
Return

GuiClose:
Gui,Destroy
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Run system tools as a different user.
Gui,99:Add,Text,y+5,- Change settings using Settings in the tray menu

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