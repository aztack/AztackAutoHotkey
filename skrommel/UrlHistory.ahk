;UrlHistory.ahk
; Watches the clipboard for web addresses and saves them with a comment.
;Skrommel @ 2006

#SingleInstance,Force
#Persistent

applicationname=UrlHistory

changed=0
Gosub,READINI
Gosub,TRAYMENU
Return


OnClipboardChange:
If watch<>1
  Return
If A_EventInfo<>1
  Return
If changed=1
  Return
urls=
end=
Loop
{
  start=999999
  StringGetPos,pos1,clipboard,http,,%end%
  StringGetPos,pos2,clipboard,www,,%end%
  StringGetPos,pos3,clipboard,ftp,,%end%

  If (pos1>-1)
    start:=pos1
  If (pos2<start And pos2>-1)
    start:=pos2
  If (pos3<start And pos3>-1)
    start:=pos3
  If start=999999
    Break

  StringGetPos,pos4,clipboard,%A_Space%,,%start%
  StringGetPos,pos5,clipboard,%A_Tab%,,%start%
  StringGetPos,pos6,clipboard,`n,,%start%

  end:=start
  If (pos4>-1)
    end:=pos4
  If (pos5<end And pos5>-1)
    end:=pos5
  If (pos6<end And pos6>-1)
    end:=pos6
  If (end=start)
    StringLen,end,clipboard

  length:=end-start
  StringMid,url,clipboard,%start%,%length%
  If url<>
  {
    WinGetActiveTitle,title
    InputBox,title,%applicationname%,Please enter comment for`n%url%,,400,150,,,,,%title%
    If ErrorLevel=0
      urls=%urls%%url% - %title%`n
  }
}
If urls<> 
{
  FileAppend,%urls%,%applicationname%.htm
}
GOSUB,TRAYMENU
Return


TRAYMENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,ADD
Menu,Tray,Default,%applicationname%
Menu,Tray,Add,
urls=
Loop,Read,%applicationname%.htm
{
  urls=%A_LoopReadLine%`n%urls%
  If (A_Index>lines)
    Break
}
Loop,Parse,urls,`n
{
  Menu,Tray,Add,%A_LoopField%,OPEN
}
Menu,Tray,Add,&Add Url...,ADD
Menu,Tray,Add,&Edit Urls...,EDIT
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,A&bout...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname%
Return


EDIT:
RunWait,Notepad.exe %applicationname%.htm,,UseErrorLevel
Gosub,TRAYMENU
Return


ADD:
InputBox,url,%applicationname%,Please enter web address,,400,150,,,,,http://
If ErrorLevel<>0
  Return
InputBox,comment,%applicationname%,Please enter comment for`n%url%,,400,150
If ErrorLevel<>0
  Return
FileAppend,%url% - %comment%`n,%applicationname%.htm
Gosub,TRAYMENU
Return


OPEN:
StringSplit,url_,A_ThisMenuItem,%A_Space%-

If run=1
{
  IfNotInString,url_1,http
  IfNotInString,url_1,ftp
  url=http://%url_1%
  Run,%url_1%,,UseErrorLevel
}
If paste=1
{
  changed=1
  clipboard=%url_1%
}
Sleep,2000
changed=0
Return


SETTINGS:
Gosub,READINI
RunWait,Notepad.exe %applicationname%.ini
Gosub,READINI
Return


READINI:
IfNotExist,%applicationname%.ini
{
  ini=`;[Settings]
  ini=%ini%`n`;lines=20   `;number of lines to show in the tray menu
  ini=%ini%`n`;watch=1    `;1=yes 0=no  watch the clipboard for urls
  ini=%ini%`n`;run=1      `;1=yes 0=no  open the clicked url in the default browser 
  ini=%ini%`n`;paste=1    `;1=yes 0=no  paste the clicked url to the clipboard
  ini=%ini%`n`;comment=1  `;1=yes 0=no  add a comment to the copied url
  ini=%ini%`n
  ini=%ini%`n[Settings]
  ini=%ini%`nlines=20
  ini=%ini%`nwatch=1
  ini=%ini%`nrun=1
  ini=%ini%`npaste=1
  ini=%ini%`ncomment=1
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
IniRead,lines,%applicationname%.ini,Settings,lines
IniRead,watch,%applicationname%.ini,Settings,watch
IniRead,run,%applicationname%.ini,Settings,run
IniRead,paste,%applicationname%.ini,Settings,paste
IniRead,comment,%applicationname%.ini,Settings,comment
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Watches the clipboard for web addresses and saves them with a comment
Gui,99:Add,Text,y+5,- Change settings using Settings in the tray menu
Gui,99:Add,Text,y+5,- Doubleclick the tray icon to add an url manually

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
