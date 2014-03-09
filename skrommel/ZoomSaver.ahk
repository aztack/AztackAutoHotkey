;ZoomSaver.ahk
; Scrolls big images accross the screen
;Skrommel @2005

#SingleInstance,Force
SetBatchLines,-1
SetWinDelay,0
DetectHiddenWindows,On
CoordMode,ToolTip,Screen

applicationname=ZoomSaver

Gosub,READINI
Gosub,TRAYMENU

If ontop=1
{
  HotKey,Esc,KEYPRESS
  HotKey,Right,KEYPRESS
  HotKey,Left,KEYPRESS
  HotKey,Up,KEYPRESS
  HotKey,Down,KEYPRESS
  HotKey,Space,KEYPRESS
  HotKey,Delete,KEYPRESS
}

activate=NA
putontop=-AlwaysOnTop
If ontop=1
{
  activate= 
  putontop=+AlwaysOnTop
}
StringLen,length,backcolor
If length=6
If ontop=1
{
  Gui,1:+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox +Disabled -Caption -Border -ToolWindow
  Gui,1:Margin,0,0
  Gui,1:Color,%backcolor%
  Gui,1:Show,NA X0 Y0 W%A_ScreenWidth% H%A_ScreenHeight% Vback,Background!
  If backtransparency<255
    WinSet,Transparent,%backtransparency%,Background!
  Else
  {
    WinSet,Transparent,255,Background!
    WinSet,Transparent,Off,Background!
  }
}

screenrel:=A_ScreenWidth/A_ScreenHeight
ToolTip,%applicationname% indexing...,0,0
files=
Loop,%path%\*.*,,%recurse%
{
  SplitPath,A_LoopFileFullPath,,,ext,,
  IfInString,filetypes,%ext%
    files=%files%%A_LoopFileFullPath%`n
}
;Sort,files
StringSplit,filesarray,files,`n
ToolTip,

numoffiles:=filesarray0
numoffiles-=1
If numoffiles<1
{
  Run,%applicationname%.ini
  MsgBox,0,%applicationname%,No images found!`n`nPlease edit %applicationname%.ini.
  ExitApp
}

If randomorder=1
Loop,Parse,files,`n
{
  Random,imagenum,1,%numoffiles%
}

Gui,2:Destroy
Gui,2:+Owner %putontop% -Resize -SysMenu -MinimizeBox -MaximizeBox +Disabled -Caption -Border -ToolWindow
Gui,2:Margin,0,0
Gui,2:Add,Picture,AltSubmit W0 H0 Vpic,%image%

counter=0
imagelist=
LOOP1:
  If randomorder=1
  {
    Random,imagenum,1,%numoffiles%
    imagelist=%imagelist%,%imagenum%
  }
  Else
  {
    counter+=1
    If counter>%numoffiles%
      counter=1
    If counter<0
      counter=%numoffiles%
    imagenum=%counter% 
  }
  image:=filesarray%imagenum%
  IfNotExist,%image%
    Goto,LOOP1
  GuiControl,2:,pic,*w0 *H0 %image%
  Gui,2:Show,%activate% AutoSize X%A_ScreenWidth% Y%A_ScreenHeight% W0 H0 Vgui,%applicationname%!
  Sleep,%pause%

  WinGetPos,,,width,height,%applicationname%!

  picrel:=width/height
  If picrel>=%screenrel%
  {
    If zoom=0
    {
      If height<=%A_ScreenHeight%
      {
        center:=A_ScreenHeight/2-height/2
        GuiControl,2:,pic, *w%width% *H%height% %image%
        Gui,2:Show,%activate% AutoSize X%A_ScreenWidth% Y%center% W0 H0 Vgui,%applicationname%!
      }
      Else
      {
        GuiControl,2:,pic, *w%width% *H%height% %image%
        Gui,2:Show,%activate% AutoSize X%A_ScreenWidth% Y0 W0 H0 Vgui,%applicationname%!
      }
    }
    Else
    {
      GuiControl,2:,pic, *w-1 *H%A_ScreenHeight% %image%
      Gui,2:Show,%activate% AutoSize X%A_ScreenWidth% Y0 W0 H0 Vgui,%applicationname%!
    }
    WinGetPos,,,width,height,%applicationname%!
    If ontop=1
      Winset,AlwaysOnTop,On,%applicationname%!
    Else
      WinSet,Bottom,,%applicationname%!

    If showinfo=1
    {
      ToolTip,%imagenum%/%numoffiles% width: %width% height:%height% %image%,%infox%,%infoy%
      WinSet,Transparent,%infotransparency%,%imagenum%/%numoffiles% width:
    }

    randomdir=2
    If randomdirection=1
      Random,randomdir,1,2
    dir=Left
    scrollx=-%pixelspeed%
    scrolly=0
    x=%A_ScreenWidth%
    y=0
    If randomdir=1
    {
      dir=Right
      scrollx=%pixelspeed%
      scrolly=0
      x=-%width%
      y=0
    }
    loop2:=Ceil((width+A_ScreenWidth)/pixelspeed)
    LOOP2:
      loop2-=1
      EnvAdd,x,%scrollx%
      WinMove,%applicationname%!,,%x%
      Sleep,pixelpause
    If loop2>0
      Goto,LOOP2
  }
  Else
  {
    If zoom=0
    {
      If width<=%A_ScreenWidth%
      {
        center:=A_ScreenWidth/2-width/2
        GuiControl,2:,pic,*w0 *H0 %image%
        Gui,2:Show,%activate% AutoSize X%center% Y%A_ScreenHeight% W0 H0 Vgui,%applicationname%!
      }
      Else
      {
        GuiControl,2:,pic, *w%A_ScreenWidth% *H-1 %image%
        Gui,2:Show,%activate% AutoSize X0 Y%A_ScreenHeight% W0 H0 Vgui,%applicationname%!
      }
    }
    Else
    {
      GuiControl,2:,pic, *w%A_ScreenWidth% *H-1 %image%
      Gui,2:Show,%activate% AutoSize X0 Y%A_ScreenHeight% W0 H0 Vgui,%applicationname%!
    }
    WinGetPos,,,width,height,%applicationname%!
    If ontop=1
      WinSet,AlwaysOnTop,On,%applicationname%!
    Else
      WinSet,Bottom,,%applicationname%!

    If showinfo=1
    {
      ToolTip,%imagenum%/%numoffiles% width: %width% height:%height% %image%,%infox%,%infoy%
      WinSet,Transparent,%infotransparency%,%imagenum%/%numoffiles% width:
      If ontop=0
      {
        WinSet,Bottom,,%imagenum%/%numoffiles% width:
        WinSet,Top,,%imagenum%/%numoffiles% width:
      }
    }

    randomdir=2
    If randomdirection=1
      Random,randomdir,1,2
    dir=Up
    scrollx=0
    scrolly=-%pixelspeed%
    x=0
    y=%A_ScreenHeight%
    If randomdir=1
    {
      dir=Down
      scrollx=0
      scrolly=%pixelspeed%
      x=0
      y=-%height%
    }
    loop3:=Ceil((height+A_ScreenHeight)/pixelspeed)
    LOOP3:
      loop3-=1
      EnvAdd,y,%scrolly%
      WinMove,%applicationname%!,,,%y%
      Sleep,pixelpause
    If loop3>0
      Goto,LOOP3
  }
Goto,LOOP1
ExitApp

READINI:
IfNotExist,%applicationname%.ini
{
  inifile=;%applicationname%.ini
  inifile=%inifile%`n`;[Settings]
  inifile=%inifile%`n`;path=%A_MyDocuments%  `;        Path to the images
  inifile=%inifile%`n`;filetypes=jpg gif bmp ico cur ani png tif exif wmf emf  `;        Image types separated by space
  inifile=%inifile%`n`;recurse=1                                               `;        Include images in subfolders
  inifile=%inifile%`n`;randomorder=0                                           `;0,1     Show images in random order 0=yes 1=no 
  inifile=%inifile%`n`;randomdirection=0                                       `;0,1     Scroll images all in all directions 
  inifile=%inifile%`n`;zoom=1                                                  `;0,1     Zoom small images
  inifile=%inifile%`n`;ontop=1                                                 `;0,1     Show images in front of other windows
  inifile=%inifile%`n`;                                                                  Also enables hotkeys and shows backwindow 
  inifile=%inifile%`n`;backcolor=000000                                        `;0,1     Color of the background
  inifile=%inifile%`n`;backtransparency=255                                    `;0-255   Transparency of the background
  inifile=%inifile%`n`;showinfo=1                                              `;0,1     Show image size and path as a ToolTip
  inifile=%inifile%`n`;infox=1                                                 `;0,1     Left edge of ToolTip
  inifile=%inifile%`n`;infoy=1                                                 `;0,1     Top edge of ToolTip
  inifile=%inifile%`n`;infotransparency=155                                    `;0,1     Transparency of ToolTip
  inifile=%inifile%`n`;pixelspeed=1                                            `;1-9999  Larger = faster, but jumpier movement 
  inifile=%inifile%`n`;pixelpause=10                                           `;0-9999  Larger = slower movement
  inifile=%inifile%`n`;pause=1000                                              `;0-9999  Number of ms to wait for next image
  inifile=%inifile%`n`;allowdelete=0                                           `;0,1     Alllow deleting by pressing Del
  inifile=%inifile%`n
  inifile=%inifile%`n[Settings]
  inifile=%inifile%`npath=%A_MyDocuments%
  inifile=%inifile%`nfiletypes=jpg gif bmp ico cur ani png tif exif wmf emf
  inifile=%inifile%`nrecurse=1
  inifile=%inifile%`nrandomorder=1
  inifile=%inifile%`nrandomdirection=1
  inifile=%inifile%`nzoom=1
  inifile=%inifile%`nontop=1
  inifile=%inifile%`nbackcolor=000000
  inifile=%inifile%`nbacktransparency=255
  inifile=%inifile%`nshowinfo=1
  inifile=%inifile%`ninfox=1
  inifile=%inifile%`ninfoy=1
  inifile=%inifile%`ninfotransparency=155
  inifile=%inifile%`npixelspeed=1
  inifile=%inifile%`npixelpause=10
  inifile=%inifile%`npause=1000
  inifile=%inifile%`nallowdelete=0
  FileAppend,%inifile%,%applicationname%.ini
  inifile=
}

IniRead,path,%applicationname%.ini,Settings,path
IniRead,filetypes,%applicationname%.ini,Settings,filetypes
IniRead,recurse,%applicationname%.ini,Settings,recurse
IniRead,randomorder,%applicationname%.ini,Settings,randomorder
IniRead,randomdirection,%applicationname%.ini,Settings,randomdirection
IniRead,zoom,%applicationname%.ini,Settings,zoom
IniRead,ontop,%applicationname%.ini,Settings,ontop
IniRead,backcolor,%applicationname%.ini,Settings,backcolor
IniRead,backtransparency,%applicationname%.ini,Settings,backtransparency
IniRead,showinfo,%applicationname%.ini,Settings,showinfo
IniRead,infox,%applicationname%.ini,Settings,infox
IniRead,infoy,%applicationname%.ini,Settings,infoy
IniRead,infotransparency,%applicationname%.ini,Settings,infotransparency
IniRead,pixelspeed,%applicationname%.ini,Settings,pixelspeed
IniRead,pixelpause,%applicationname%.ini,Settings,pixelpause
IniRead,pause,%applicationname%.ini,Settings,pause
IniRead,allowdelete,%applicationname%.ini,Settings,allowdelete
Return

KEYPRESS:
If A_ThisHotKey=Esc
  ExitApp
Else
If A_ThisHotKey=Left
{
  counter-=2
  loop2=0
  loop3=0
  Return
}
Else
If A_ThisHotKey=Right
{
  loop2=0
  loop3=0
  Return
}
Else
If A_ThisHotKey=Space
{
  Loop
  {
    Sleep,0
    GetKeyState,state,Space,P
    If state=U
      Break
  }
  Loop
  {
    Sleep,0
    GetKeyState,state,Right,P
    If state=D
      Break
    GetKeyState,state,Left,P
    If state=D
      Break
    GetKeyState,state,Space,P
    If state=D
      Break
  }
  Return
}
Else
If A_ThisHotKey=Delete
{
  If allowdelete=1
  {
    FileDelete,%image%
    loop2=0
    loop3=0
  }
  Return
}
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


SETTINGS:
Gosub,READINI
Run,%applicationname%.ini
Return


Exit:
GuiClose:
ExitApp


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Scrolls big images accross the screen.
Gui,99:Add,Text,y+5,- Change accents using Settings in the tray menu
Gui,99:Add,Text,y+5,- Space=Pause  Right=Next image  Left=Previous image  Del=Delete  Esc=Exit

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

