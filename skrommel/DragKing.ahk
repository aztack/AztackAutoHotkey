;DragKing
; Automatically copy selections using mouse or Ctrl-C. 
; Reports number of selected chars, words and lines.
;Skrommel @2005

#SingleInstance,Force
SetBatchLines,-1
CoordMode,Mouse,Screen

applicationname=DragKing

SysGet,xdrag,68
SysGet,ydrag,69

Gosub,INIREAD
Gosub,TRAYMENU
If startdisabled=1
  Gosub,SWAP
Return

~^c::
Gosub,COPY
Return

~LButton::
MouseGetPos,oldmx,oldmy,oldwinid
Return

~LButton Up::
MouseGetPos,mx,my,winid
VarSetCapacity(rect, 16) 
DllCall("GetClientRect", "uint", oldwinid, "uint", &rect) 
rect_left  :=NumGet(rect,0, "int") 
rect_top   :=NumGet(rect,4, "int") 
rect_right :=NumGet(rect,8, "int") 
rect_bottom:=NumGet(rect,12,"int")
If (winid=oldwinid And (mx<oldmx-xdrag Or mx>oldmx+xdrag Or my<oldmy-ydrag Or my>oldmy+ydrag))
If (oldmx>=rect_left And oldmx<=rect_right And oldmy>=rect_top And oldmy<=rect_bottom)
  Gosub,COPY
  
ticks=%A_TickCount%
difticks=%ticks%
EnvSub,difticks,%oldticks%
If difticks<400
If (oldmx>=rect_left And oldmx<=rect_right And oldmy>=rect_top And oldmy<=rect_bottom)
  Gosub,Copy
oldticks=%ticks%
Return

~+LButton Up::
~^LButton Up::
  Gosub,COPY
Return

COPY:
Sleep,400  ;Wait for doubleclick to select
clipall=%Clipboardall%
Clipboard=
Send,^c
ClipWait,1
If Clipboard=
  Clipboard=%clipall%
Else
  Gosub,TRAYINFO
Return

INIREAD:
IfNotExist,%applicationname%.ini
{
  charstoignore=newlinecarridgereturn
  worddelimiters=spacetabnewlinecarridgereturn`,`;`%``:._\/()[]{}<>|§!"#¤=?^~¨*´'@£$€µ
  linedelimiters=newlinecarridgereturn
  startdisabled=0
  showtraytip=1
  showtooltip=0
  showmsgbox=0
  tiptime=3
  pastehotkey=~MButton
  togglehotkey=
  Gosub,INIWRITE
  Gosub,ABOUT
}
IniRead,charstoignore,%applicationname%.ini,Settings,charstoignore
IniRead,worddelimiters,%applicationname%.ini,Settings,worddelimiters
IniRead,linedelimiters,%applicationname%.ini,Settings,linedelimiters
IniRead,startdisabled,%applicationname%.ini,Settings,startdisabled
IniRead,showtraytip,%applicationname%.ini,Settings,showtraytip
IniRead,showtooltip,%applicationname%.ini,Settings,showtooltip
IniRead,showmsgbox,%applicationname%.ini,Settings,showmsgbox
IniRead,startdisabled,%applicationname%.ini,Settings,startdisabled
IniRead,tiptime,%applicationname%.ini,Settings,tiptime
IniRead,togglehotkey,%applicationname%.ini,Settings,togglehotkey
IniRead,pastehotkey,%applicationname%.ini,Settings,pastehotkey
StringReplace,charstoignore,charstoignore,space,%A_Space%
StringReplace,charstoignore,charstoignore,tab,%A_Tab%
StringReplace,charstoignore,charstoignore,newline,`n
StringReplace,charstoignore,charstoignore,carridgereturn,`r
StringReplace,worddelimiters,worddelimiters,space,%A_Space%
StringReplace,worddelimiters,worddelimiters,tab,%A_Tab%
StringReplace,worddelimiters,worddelimiters,newline,`n
StringReplace,worddelimiters,worddelimiters,carridgereturn,`r
StringReplace,linedelimiters,linedelimiters,space,%A_Space%
StringReplace,linedelimiters,linedelimiters,tab,%A_Tab%
StringReplace,linedelimiters,linedelimiters,newline,`n
StringReplace,linedelimiters,linedelimiters,carridgereturn,`r
If pastehotkey<>
  Hotkey,%pastehotkey%,PASTE,On UseErrorLevel
If togglehotkey<>
  Hotkey,%togglehotkey%,SWAP,On UseErrorLevel
Return


INIWRITE:
IniWrite,%charstoignore%,%applicationname%.ini,Settings,charstoignore
IniWrite,%worddelimiters%,%applicationname%.ini,Settings,worddelimiters
IniWrite,%linedelimiters%,%applicationname%.ini,Settings,linedelimiters
IniWrite,%startdisabled%,%applicationname%.ini,Settings,startdisabled
IniWrite,%showtraytip%,%applicationname%.ini,Settings,showtraytip
IniWrite,%showtooltip%,%applicationname%.ini,Settings,showtooltip
IniWrite,%showmsgbox%,%applicationname%.ini,Settings,showmsgbox
IniWrite,%startdisabled%,%applicationname%.ini,Settings,startdisabled
IniWrite,%tiptime%,%applicationname%.ini,Settings,tiptime
IniWrite,%togglehotkey%,%applicationname%.ini,Settings,togglehotkey
IniWrite,%pastehotkey%,%applicationname%.ini,Settings,pastehotkey
Return


TRAYINFO:
clip=%Clipboard%
numofchars=0
StringSplit,chars,clip,%chardelimiters%
Loop,%chars0%
{
  If chars%A_Index%<>
  {
    StringLen,length,chars%A_Index%
    numofchars+=%length%
  }
}
numofwords=0
StringSplit,words,clip,%worddelimiters%
Loop,%words0%
{
  If words%A_Index%<>
    numofwords+=1
}  
numoflines=0
StringSplit,lines,clip,%linedelimiters%
Loop,%lines0%
{
  If lines%A_Index%<>
    numoflines+=1
}  
If showtraytip=1
  Gosub,SHOWTRAYINFO
If showtooltip=1
  Gosub,SHOWTOOLINFO
If showmsgbox=1
  Gosub,SHOWMSGBOXINFO
Return

SHOWTRAYINFO:
TrayTip,
TrayTip,%applicationname%,Copied`tChars:`t%numofchars%`n`tWords:`t%numofwords%`n`tLines:`t%numoflines%,%tiptime%
Return

SHOWTOOLINFO:
ToolTip,Copied`tChars:`t%numofchars%`n`tWords:`t%numofwords%`n`tLines:`t%numoflines%,0,0
SetTimer,TOOLTIP,% tiptime*1000
Return

SHOWMSGBOXINFO:
MsgBox,0,%applicationname%,Copied`tChars:`t%numofchars%`n`tWords:`t%numofwords%`n`tLines:`t%numoflines%
Return

TOOLTIP:
SetTimer,TOOLTIP,Off
ToolTip,
Return

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,SWAP
Menu,Tray,Add,
Menu,Tray,Add,Show last &count...,SHOWMSGBOXINFO
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,SWAP
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Check,&Enabled
Menu,Tray,Tip,%applicationname%
Return


SETTINGS:
If pastehotkey<>
  Hotkey,%pastehotkey%,Off,UseErrorLevel
If togglehotkey<>
  Hotkey,%togglehotkey%,Off,UseErrorLevel
StringReplace,charstoignore,charstoignore,%A_Space%,space
StringReplace,charstoignore,charstoignore,%A_Tab%,tab
StringReplace,charstoignore,charstoignore,`n,newline
StringReplace,charstoignore,charstoignore,`r,carridgereturn
StringReplace,worddelimiters,worddelimiters,%A_Space%,space
StringReplace,worddelimiters,worddelimiters,%A_Tab%,tab
StringReplace,worddelimiters,worddelimiters,`n,newline
StringReplace,worddelimiters,worddelimiters,`r,carridgereturn
StringReplace,linedelimiters,linedelimiters,%A_Space%,space
StringReplace,linedelimiters,linedelimiters,%A_Tab%,tab
StringReplace,linedelimiters,linedelimiters,`n,newline
StringReplace,linedelimiters,linedelimiters,`r,carridgereturn

Gui,Margin,30,10
Gui,Add,Tab,xm-20 ym w240 h350,Options|Hotkeys|Counting

Gui,Tab,1
Gui,Add,GroupBox,xm-10 ym+30 w220 h45,Startup
Gui,Add,CheckBox,xm yp+20 vvstartdisabled Checked%startdisabled%,&Start disabled

Gui,Add,GroupBox,xm-10 y+20 w220 h80,Status
Gui,Add,CheckBox,xm yp+20 vvshowtraytip Checked%showtraytip%,Show &tray tip
Gui,Add,CheckBox,xm y+5 vvshowtooltip Checked%showtooltip%,Show t&ool tip
Gui,Add,CheckBox,xm y+5 vvshowmsgbox Checked%showmsgbox%,Show &message box
Gui,Add,GroupBox,xm-10 y+20 w220 h50,Time to show tip (seconds)
Gui,Add,Edit,xm yp+20 vvtiptime,
Gui,Add,UpDown,Limit0-99,%tiptime%

Gui,Tab,2
Gui,Add,GroupBox,xm-10 ym+30 w220 h70,Disable %applicationname%
Gui,Add,Hotkey,xm yp+20 w200 vvtogglehotkey
StringReplace,currenthotkey,togglehotkey,^,Ctrl +%A_Space%
StringReplace,currenthotkey,currenthotkey,!,Alt +%A_Space%
StringReplace,currenthotkey,currenthotkey,+,Shift +%A_Space%
Gui,Add,Text,xm y+5,Current hotkey: %currenthotkey%

Gui,Add,GroupBox,xm-10 y+20 w220 h220,Paste
Gui,Add,Text,xm yp+20,`t* Not all combinations work!
Gui,Add,CheckBox,y+5 vvpastectrl,&Ctrl
Gui,Add,CheckBox,y+5 vvpastealt,&Alt
Gui,Add,CheckBox,y+5 vvpasteshift,S&hift
Gui,Add,CheckBox,y+5 vvpasteleft,&Left mousebutton
Gui,Add,CheckBox,y+5 vvpastemiddle,&Middle mousebutton
Gui,Add,CheckBox,y+5 vvpasteright,&Right mousebutton
Gui,Add,Hotkey,y+5 w200 vvpastehotkey
StringTrimLeft,currenthotkey,pastehotkey,1
StringReplace,currenthotkey,currenthotkey,+,Shift +%A_Space%
StringReplace,currenthotkey,currenthotkey,^,Ctrl +%A_Space%
StringReplace,currenthotkey,currenthotkey,!,Alt +%A_Space%
StringReplace,currenthotkey,currenthotkey,&, +%A_Space%
Gui,Add,Text,xm y+5 w200,Current hotkey: %currenthotkey%

Gui,Tab,3
Gui,Add,Text,xm ym+30 w200,Add the characters you want to ignore or use as delimiters. Note the special space, tab, newline (LF), and carridge return (CR)
Gui,Add,GroupBox,xm-10 y+10 w220 h80,&Line delimiters
Gui,Add,Edit,xm yp+20 w200 h50 vvlinedelimiters,%linedelimiters%
Gui,Add,GroupBox,xm-10 y+20 w220 h80,&Word delimiters
Gui,Add,Edit,xm yp+20 w200 h50 vvworddelimiters,%worddelimiters%
Gui,Add,GroupBox,xm-10 y+20 w220 h80,&Characters to ignore
Gui,Add,Edit,xm yp+20 w200 h50 vvcharstoignore,%charstoignore%

Gui,Tab
Gui,Add,Button,xm-10 y+30 w75 gSETTINGSOK,OK
Gui,Add,Button,x+5 yp w75 gSETTINGSCANCEL,Cancel

Gui,Show,AutoSize,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
startdisabled:=vstartdisabled
showtraytip:=vshowtraytip
showtooltip:=vshowtooltip
showmsgbox:=vshowmsgbox

If vtogglehotkey<>
  togglehotkey:=vtogglehotkey

hotkey=
If vpastectrl=1
  hotkey=%hotkey%^
If vpastealt=1
  hotkey=%hotkey%!
If vpasteshift=1
  hotkey=%hotkey%+
If vpasteleft=1
  hotkey:=hotkey "LButton & "
If vpastemiddle=1
  hotkey:=hotkey "MButton & "
If vpasteright=1
  hotkey:=hotkey "RButton & "
If vpastehotkey<>
  hotkey=%hotkey%%vpastehotkey%
StringRight,end,hotkey,3
If (end=" & ")
  StringTrimRight,hotkey,hotkey,3  
If hotkey<>
  pastehotkey=~%hotkey%

Gosub,INIWRITE
Gosub,INIREAD
Gosub,SETTINGSCANCEL
Return


SETTINGSCANCEL:
Gui,DESTROY
If pastehotkey<>
  Hotkey,%pastehotkey%,PASTE,On UseErrorLevel
If togglehotkey<>
  Hotkey,%togglehotkey%,SWAP,On UseErrorLevel
Return


SWAP:
Menu,Tray,ToggleCheck,&Enabled
Suspend,Toggle
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.3
Gui,99:Font
Gui,99:Add,Text,y+10,Automatically copies mouse selections to the clipboard.
Gui,99:Add,Text,y+10,- Reports the number of copied characters, words and lines.
Gui,99:Add,Text,y+10,- Change the settings by choosing Settings in the Tray menu.

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



PASTE:
Send,^v
Return

