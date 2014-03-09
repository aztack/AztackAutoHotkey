;WinWarden.ahk
; Automatically control how to display a window.
; Move, maximize, minimize, restore, enable, disable, hide, show,
; ontop, bottom, alwaysontop, clip, transparent, transparent color,
; move relative to another window, stick to the edge of the screen,
; roll up and down, morph wide/tall/zoom in/zoom out.
;Skrommel @2005
;Tim Morck @2006

#Persistent
#SingleInstance,Force
SetBatchLines,-1
SetTitleMatchMode,2
DetectHiddenWindows,On
CoordMode,Mouse,Screen
CoordMode,ToolTip,Screen
SetWinDelay,0
AutoTrim,On

applicationname=WinWarden

Hotkey,!R,ROLLUP ;! - Alt key
Hotkey,!Up,ROLLUP ;there are also ^ - Ctrl, # - Win, + - Shift
Hotkey,!D,ROLLDOWN
Hotkey,!Down,ROLLDOWN ;if you change the symbols here, change them in CHECKHOTKEYS, too
Hotkey,!W,WIDE
Hotkey,!T,TALL
Hotkey,!I,ZOOMIN
Hotkey,!O,ZOOMOUT
Hotkey,!E,REMEMBER
Hotkey,!U,UNDO
Hotkey,!A,AONTOP
Hotkey,!B,TOBOTTOM
Hotkey,!S,SETTINGS
Hotkey,!H,HELP

Hotkey,!Numpad7,TOPLEFT
Hotkey,!Numpad8,TOPCENTER
Hotkey,!Numpad9,TOPRIGHT
Hotkey,!Numpad4,MIDDLELEFT
Hotkey,!Numpad5,CENTER
Hotkey,!Numpad6,MIDDLERIGHT
Hotkey,!Numpad1,BOTTOMLEFT
Hotkey,!Numpad2,BOTTOMCENTER
Hotkey,!Numpad3,BOTTOMRIGHT

Hotkey,^!Numpad4,LEFTHALF
Hotkey,^!Numpad6,RIGHTHALF
Hotkey,^!Numpad8,TOPHALF
Hotkey,^!Numpad2,BOTTOMHALF
Hotkey,^!Numpad7,TOPLEFTQTR
Hotkey,^!Numpad9,TOPRIGHTQTR
Hotkey,^!Numpad1,BOTTOMLEFTQTR
Hotkey,^!Numpad3,BOTTOMRIGHTQTR

Menu,Placemenu,Add,Top Left,TOPLEFT
Menu,Placemenu,Add,Top Center,TOPCENTER
Menu,Placemenu,Add,Top Right,TOPRIGHT
Menu,Placemenu,Add,Middle Left,MIDDLELEFT
Menu,Placemenu,Add,Middle Right,MIDDLERIGHT
Menu,Placemenu,Add,Bottom Left,BOTTOMLEFT
Menu,Placemenu,Add,Bottom Center,BOTTOMCENTER
Menu,Placemenu,Add,Bottom Right,BOTTOMRIGHT

Menu,Covermenu,Add,&Left Half,LEFTHALF
Menu,Covermenu,Add,&Right Half,RIGHTHALF
Menu,Covermenu,Add,&Top Half,TOPHALF
Menu,Covermenu,Add,&Bottom Half,BOTTOMHALF
Menu,Covermenu,Add,
Menu,Covermenu,Add,Top Left,TOPLEFTQTR
Menu,Covermenu,Add,Top Right,TOPRIGHTQTR
Menu,Covermenu,Add,Bottom Left,BOTTOMLEFTQTR
Menu,Covermenu,Add,Bottom Right,BOTTOMRIGHTQTR

Menu,Morphmenu,Add,&Wide,WIDE
Menu,Morphmenu,Add,&Tall,TALL
Menu,Morphmenu,Add,
Menu,Morphmenu,Add,Zoom &In,ZOOMIN
Menu,Morphmenu,Add,Zoom &Out,ZOOMOUT

If A_OSVersion not in WIN_95,WIN_98,WIN_NT
   transparencyon=Y
Else
   transparencyon=N

If transparencyon=Y
{
   Hotkey,!0,TRANSPHKEY
   Hotkey,!1,TRANSPHKEY
   Hotkey,!2,TRANSPHKEY
   Hotkey,!3,TRANSPHKEY
   Hotkey,!4,TRANSPHKEY
   Hotkey,!5,TRANSPHKEY
   Hotkey,!6,TRANSPHKEY
   Hotkey,!7,TRANSPHKEY
   Hotkey,!8,TRANSPHKEY
   Hotkey,!9,TRANSPHKEY
   Menu,Transpmenu,Add,&Off,TRANSPMENU
   Menu,Transpmenu,Add,&10`%,TRANSPMENU
   Menu,Transpmenu,Add,&20`%,TRANSPMENU
   Menu,Transpmenu,Add,&30`%,TRANSPMENU
   Menu,Transpmenu,Add,&40`%,TRANSPMENU
   Menu,Transpmenu,Add,&50`%,TRANSPMENU
   Menu,Transpmenu,Add,&60`%,TRANSPMENU
   Menu,Transpmenu,Add,&70`%,TRANSPMENU
   Menu,Transpmenu,Add,&80`%,TRANSPMENU
   Menu,Transpmenu,Add,&90`%,TRANSPMENU
}

SysGet,captionheight,29
SysGet,monitor,MonitorWorkArea
hotkeys=Off
interval=500
topoffset=0
bottomoffset=0
leftoffset=0
rightoffset=0
IfExist,%applicationname%2.ini
{
   IniRead,hotkeys,%applicationname%2.ini,Parms,Hotkeys
   If not (hotkeys="On" or hotkeys="Off")
     IniWrite,Off,%applicationname%2.ini,Parms,Hotkeys

   IniRead,interval,%applicationname%2.ini,Parms,Interval
   If interval is not digit
   {
     IniWrite,500,%applicationname%2.ini,Parms,Interval
     interval=500
   }
   If interval<100
   {
     IniWrite,100,%applicationname%2.ini,Parms,Interval
     interval=100
   }

   IniRead,leftoffset,%applicationname%2.ini,Parms,Leftoffset
   If leftoffset is not digit
   {
     IniWrite,0,%applicationname%2.ini,Parms,Leftoffset
     leftoffset=0
   }
   If leftoffset>200
   {
     IniWrite,200,%applicationname%2.ini,Parms,Leftoffset
     leftoffset=0
   }

   IniRead,rightoffset,%applicationname%2.ini,Parms,Rightoffset
   If rightoffset is not digit
   {
     IniWrite,0,%applicationname%2.ini,Parms,Rightoffset
     rightoffset=0
   }
   If rightoffset>200
   {
     IniWrite,200,%applicationname%2.ini,Parms,Rightoffset
     rightoffset=0
   }

   IniRead,topoffset,%applicationname%2.ini,Parms,Topoffset
   If topoffset is not digit
   {
     IniWrite,0,%applicationname%2.ini,Parms,Topoffset
     topoffset=0
   }
   If topoffset>200
   {
     IniWrite,200,%applicationname%2.ini,Parms,Topoffset
     topoffset=0
   }

   IniRead,bottomoffset,%applicationname%2.ini,Parms,Bottomoffset
   If bottomoffset is not digit
   {
     IniWrite,0,%applicationname%2.ini,Parms,Bottomoffset
     bottomoffset=0
   }
   If bottomoffset>200
   {
     IniWrite,200,%applicationname%2.ini,Parms,Bottomoffset
     bottomoffset=0
   }

}
monitorLeft:=monitorLeft+leftoffset
monitorRight:=monitorRight-rightoffset
monitorTop:=monitorTop+topoffset
monitorBottom:=monitorBottom-bottomoffset
monitorWidth:=monitorRight-monitorLeft
monitorHeight:=monitorBottom-monitorTop

createdids=
activeids=
maxedids=
deactivatedids=
prevmodtime=00000000000000
actwinid:=WinActive("A")
Menu,Tray,Add,&Always on top,AONTOP ;need to do this for first execute of GETACTAONTOP
Gosub,GETACTAONTOP

SetTimer,MAIN,%interval%
Return


MAIN:
Gosub,READINI ;when the .ini file's Modified time stamp changes,
; ;READINI reads it and then calls TRAYMENU,
; ;since custom menu items may have changed

newactwinid:=WinActive("A")
If newactwinid<>0x0
IfNotInString,newactwinid,%actwinid%
{
   WinGetClass,newactwinclass,ahk_id %newactwinid%
   If newactwinclass not in Progman,Shell_TrayWnd,AutoHotkey
   {
     actwinid=%newactwinid% ;get the new active window ID for menu items
     Gosub,GETACTAONTOP
   }
}

type=Auto
WinGet,allwinids,List,,,Program Manager
Loop,%allwinids%
{
   StringTrimRight,winid,allwinids%A_Index%,0

   lineindex=0
   Loop,%autocount%
   {
     lineindex++

     If titlematch_Auto_%lineindex%=C
     {
       WinGetClass,sclass,ahk_id %winid%
       If sclass<>% title_Auto_%lineindex% ;try to find class
         Continue
     }
     Else
     {
       WinGetTitle,stitle,ahk_id %winid%
       If titlematch_Auto_%lineindex%=S
       {
         IfNotInString,stitle,% title_Auto_%lineindex% ;try to find string in title
           Continue
       }
       Else
       {
         If titlematch_Auto_%lineindex%=F
           StringLeft,stitle,stitle,titlelength_Auto_%lineindex% ;compare first characters in title
         Else
           StringRight,stitle,stitle,titlelength_Auto_%lineindex% ;compare last characters in title
         If stitle<>% title_Auto_%lineindex%
           Continue
       }
     }

     WinGetText,stext,ahk_id %winid%
     IfNotInString,stext,% text_Auto_%lineindex%
       Continue

     If mode_Auto_%lineindex%=Inside
     {
       MouseGetPos,hmx,hmy,hid
       WinGetTitle,htitle,ahk_id %hid%
       WinGetPos,hwx,hwy,hwidth,hheight,ahk_id %hid%

       IfNotInString,htitle,% title_Auto_%lineindex%
         Continue

       hwidth+=%hwx%
       hheight+=%hwy%

       If hmx>=%hwx%
       If hmx<=%hwidth%
       If hmy>=%hwy%
       If hmy<=%hheight%
         Gosub,INSIDE
     }

     If mode_Auto_%lineindex%=Outside
     {
       MouseGetPos,hmx,hmy,hid
       WinGetTitle,htitle,ahk_id %hid%

       IfNotInString,htitle,% title_Auto_%lineindex%
         Gosub,OUTSIDE
     }

     IfWinExist,ahk_id %winid%
     {
       If mode_Auto_%lineindex%=Creating
       {
         IfNotInString,createdids,%winid%
         {
           createdids=%createdids%`n%winid%
           Gosub,CREATING
         }
       }
     }
     Else
       StringReplace,createdids,createdids,`n%winid%

     Gosub,GETMAXIMIZE
     If smaximize=1
     {
       If mode_Auto_%lineindex%=Maximizing
       {
         IfNotInString,maxedids,%winid%
         {
           maxedids=%maxedids%`n%winid%
           Gosub,MAXIMIZING
         }
       }
       Else
       If mode_Auto_%lineindex%=Maximized
       {
         Gosub,MAXIMIZED
       }
     }
     Else
       StringReplace,maxedids,maxedids,`n%winid%

     IfWinActive,ahk_id %winid%
     {
       If mode_Auto_%lineindex%=Activating
       {
         IfNotInString,activeids,%winid%
         {
           activeids=%activeids%`n%winid%
           Gosub,ACTIVATING
         }
       }
       Else
       If mode_Auto_%lineindex%=Active
       {
         Gosub,ACTIVE
       }
     }
     Else
       StringReplace,activeids,activeids,`n%winid%

     IfWinNotActive,ahk_id %winid%
     {
       If mode_Auto_%lineindex%=Deactivating
       {
         IfNotInString,deactivatedids,%winid%
         {
           deactivatedids=%deactivatedids%`n%winid%
           Gosub,DEACTIVATING
         }
       }
       Else
       If mode_Auto_%lineindex%=Deactivated
       {
         Gosub,DEACTIVATED
       }
     }
     Else
       StringReplace,deactivatedids,deactivatedids,`n%winid%
   }
}
Return

GETACTAONTOP:
WinGet,xstyle,ExStyle,ahk_id %actwinid%
If (xstyle & 0x8) ;0x8 is WS_EX_TOPMOST
{
   activeaontop=Y
   Menu,Tray,Check,&Always on top
}
Else
{
   activeaontop=N
   Menu,Tray,Uncheck,&Always on top
}
Return

GETMAXIMIZE:
WinGet,state,MinMax,ahk_id %winid%
smaximize=0
If state=1
   smaximize=1
sminimize=0
If state=-1
   sminimize=1
srestore=0
If state=0
   srestore=1
Return


READINI:
IfNotExist,%applicationname%2.ini
{
   inifile=;%applicationname%2.ini
   inifile=%inifile%`n`;Automatically control how to display a window
   inifile=%inifile%`n`;Move, maximize, minimize, restore, enable, disable, hide, show, ontop, bottom,
   inifile=%inifile%`n`;alwaysontop, clip, transparent, transparent color, move relative to another window,
   inifile=%inifile%`n`;stick to the edge of the screen, roll up and down, morph wide/tall/zoom in/zoom out.
   inifile=%inifile%`n`;Skrommel @2005
   inifile=%inifile%`n`;Tim Morck @2006
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;If you have been using a previous version of %applicationname% and are wondering what
   inifile=%inifile%`n`;happened to the parameters you set up, they are probably still in %applicationname%.ini.
   inifile=%inifile%`n`;This is %applicationname%2.ini. Just copy them from there and paste them into here
   inifile=%inifile%`n`;and you will be all set (except see title matching just below). It is necessary
   inifile=%inifile%`n`;to have %applicationname%2.ini to provide new global parameters and documentation
   inifile=%inifile%`n`;of new features.
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;
   inifile=%inifile%`n`; 1: mode           Inside,Outside,Creating,Activating,Active,Maximizing,Maximized,
   inifile=%inifile%`n`;                      Deactivating,Deactivated
   inifile=%inifile%`n`;                    What mode of the window to control
   inifile=%inifile%`n`;                     Inside is used when the mouse is inside the window
   inifile=%inifile%`n`;                     Outside is used when the mouse is outside the window
   inifile=%inifile%`n`;                     Creating is used when the window is created
   inifile=%inifile%`n`;                     Activating is used every time the window is activated
   inifile=%inifile%`n`;                     Active is used for as long as the windows is active, but not aximized
   inifile=%inifile%`n`;                     Maximizing is used every time the window is maximized
   inifile=%inifile%`n`;                     Maximized is used for as long as the window is maximized
   inifile=%inifile%`n`;                     Deactivating is used every time another window is activated
   inifile=%inifile%`n`;                     Deactivated is used for as long as the window is inactive
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;                     Menu sets up custom menu items in the system tray icon menu that can
   inifile=%inifile%`n`;                      be applied manually to the active window, unlike the automatic modes
   inifile=%inifile%`n`;                      above
   inifile=%inifile%`n`;                       -does not use #'s 3, 4(except WholeScreen), and 5
   inifile=%inifile%`n`;                       -can be all before, all after, or interspersed with other modes
   inifile=%inifile%`n`;                       -appear in menu in same order as in this file
   inifile=%inifile%`n`; 2: title          abc
   inifile=%inifile%`n`;                    Text in the title of the window to control
   inifile=%inifile%`n`;                     Auto: wildcard match instead if * is last or first character
   inifile=%inifile%`n`;                       titletext* - match on first characters only
   inifile=%inifile%`n`;                       *titletext - match on last characters only
   inifile=%inifile%`n`;                      or match class instead of title if text between forward slashes(no*)
   inifile=%inifile%`n`;                       /titletext/ - class of the window to control
   inifile=%inifile%`n`;                       /#32770/ - class of Windows 98 open/save,control panel,+ for example
   inifile=%inifile%`n`;                      note: order of lines matters, only first line to match is applied`;
   inifile=%inifile%`n`;                            so put more specific matches first to make them exceptions
   inifile=%inifile%`n`;                     Menu: menu item text (Spacer for menu spacer)
   inifile=%inifile%`n`;                      You may put character & before unique selection character
   inifile=%inifile%`n`;                      you want to underline - not a,b,c,d,e,h,k,m,p,q,r,s,u
   inifile=%inifile%`n`; (in use, these will not be underlined)
   inifile=%inifile%`n`; 3: text           abc
   inifile=%inifile%`n`;                    Text inside the window to control
   inifile=%inifile%`n`; 4: otherwintitle  abc,WholeScreen
   inifile=%inifile%`n`;                    Text in the titlebar of the window to move relative to
   inifile=%inifile%`n`;                     WholeScreen is the whole screen including toolbars
   inifile=%inifile%`n`;                     Leave empty to move relative to the desktop
   inifile=%inifile%`n`; 5: otherwintext   abc
   inifile=%inifile%`n`;                    Text inside the window to move relative to
   inifile=%inifile%`n`; 6: x              x,x`%,-Left,+Left,-Center,Center,+Center,-Right,+Right,Caption
   inifile=%inifile%`n`;                   (except Menu: ignores 'outside' positions -Left,+Right)
   inifile=%inifile%`n`;                    Where to put the left edge of the window
   inifile=%inifile%`n`;                     a number followed by a `% moves in percentage of the other window
   inifile=%inifile%`n`;                     -Left moves the window to the left of the Left edge of the other window
   inifile=%inifile%`n`;                     +Left moves the window to the right of the Left edge of the other window
   inifile=%inifile%`n`;                     -Center moves the window to the left of the Center line of the other window
   inifile=%inifile%`n`;                     Center moves the window to the horizontal Center of the other window
   inifile=%inifile%`n`;                     +Center moves the window to the right of the Center line of the other window
   inifile=%inifile%`n`;                     -Right moves the window to the left of the Right edge of the other window
   inifile=%inifile%`n`;                     +Right moves the window to the right of the Right edge of the other window
   inifile=%inifile%`n`;                     Caption moves the window right of the Right edge of the other window
   inifile=%inifile%`n`;                       by a distance equal to the height of the Caption (title) bar
   inifile=%inifile%`n`;                       - when used with y=Caption, they work like Cascade
   inifile=%inifile%`n`; 7: y              x,x`%,-Top,+Top,-Center,Center,+Center,-Bottom,+Bottom,Caption
   inifile=%inifile%`n`;                   (except Menu: ignores 'outside' positions -Top,+Bottom)
   inifile=%inifile%`n`;                    Where to put the top edge of the window
   inifile=%inifile%`n`;                     a number followed by a `% moves in percentage of the other window
   inifile=%inifile%`n`;                     -Top moves the window above the Top edge of the other window
   inifile=%inifile%`n`;                     +Top moves the window below the Top edge of the other window
   inifile=%inifile%`n`;                     -Center moves the window above the Center line of the other window
   inifile=%inifile%`n`;                     Center moves the window to the vertical Center of the other window
   inifile=%inifile%`n`;                     +Center moves the window below the Center line of the other window
   inifile=%inifile%`n`;                     -Bottom moves the window above the Bottom edge of the other window
   inifile=%inifile%`n`;                     +Bottom moves the window below the Bottom edge of the other window
   inifile=%inifile%`n`;                     Caption moves the window below the Caption (title) bar of the other window
   inifile=%inifile%`n`; 8: width          x,x`%,Left,Right,Center
   inifile=%inifile%`n`;                    Width of the window
   inifile=%inifile%`n`;                     Center and Right stretches it relative to the other window
   inifile=%inifile%`n`; 9: height         x,x`%,Top,Bottom,Center,Caption
   inifile=%inifile%`n`;                    Height of the window
   inifile=%inifile%`n`;                     Center and Bottom stretches it relative to the other window
   inifile=%inifile%`n`;                     Caption shrinks it to the Caption (title) bar (like Roll Up)
   inifile=%inifile%`n`;10: alwaysontop    On,Off,Toggle
   inifile=%inifile%`n`;                    Moves a window in front of all other windows
   inifile=%inifile%`n`;11: transparency   0-255,Off
   inifile=%inifile%`n`;                    Makes a window transparent
   inifile=%inifile%`n`;12: transcolor     000000-FFFFFF,Off
   inifile=%inifile%`n`;                    Makes a specific color transparent
   inifile=%inifile%`n`;13: clipx          x,x`%,Off
   inifile=%inifile%`n`;                    Cuts away the outer edges of a window, clipx controls the left edge
   inifile=%inifile%`n`;                     Off turns off clipping
   inifile=%inifile%`n`;14: clipy          x,x`%
   inifile=%inifile%`n`;15: clipwidth      x,x`%,Width
   inifile=%inifile%`n`;                    Width is the width of the window
   inifile=%inifile%`n`;16: clipheight     x,x`%,Height
   inifile=%inifile%`n`;                    Height is the height of the window
   inifile=%inifile%`n`;17: path           path of the program/file to run
   inifile=%inifile%`n`;>17 Maximize       Maximizes the window
   inifile=%inifile%`n`;    Minimize       Minimizes the window
   inifile=%inifile%`n`;    Restore        Restores the window
   inifile=%inifile%`n`;    Show           Shows the window
   inifile=%inifile%`n`;    Hide           Hides the window
   inifile=%inifile%`n`;    Top            Moves the window on top of the other windows
   inifile=%inifile%`n`;    Bottom         Moves the window to the bottom of the other windows
   inifile=%inifile%`n`;    Enable         Enables mouse and keyboard input
   inifile=%inifile%`n`;    Disable        Disables mouse and keyboard input
   inifile=%inifile%`n`;    Ghost          Makes mouse clicks go through to the underlying window
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;The first 17 parameters must be in their right place, the rest must be separated by commas.
   inifile=%inifile%`n`;Also, all lines must contain at least 17 commas/parameters.
   inifile=%inifile%`n`;11-16 and Ghost for Windows XP, 2000, 2003 only.
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Example:
   inifile=%inifile%`n`;Maximizes all Notepad windows when activated, and, when deactivated,
   inifile=%inifile%`n`;puts them On top, makes them tranparent by 150, makes the color FFFFFF (white) transparent,
   inifile=%inifile%`n`;and, while deactivated, moves them to the Bottom Right of the desktop, resizes them to
   inifile=%inifile%`n`;150x150, cuts the window's 10 left and 10 top lines of pixels, keeping the remaining 80`%
   inifile=%inifile%`n`;width and height, and finally Ghosts them to pass through any mouseclicks.
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Creating    ,- Notepad,,,,,,,,,,,,,,,,,,,
   inifile=%inifile%`n`;Activating  ,- Notepad,,,,,,,,Off,Off,,Off,,,,,,Maximize,,
   inifile=%inifile%`n`;Active      ,- Notepad,,,,,,,,,,,,,,,,,,,
   inifile=%inifile%`n`;Maximizing  ,- Notepad,,,,,,,,,,,,,,,,,,,
   inifile=%inifile%`n`;Maximized   ,- Notepad,,,,,,,,,,,,,,,,,,,
   inifile=%inifile%`n`;Deactivating,- Notepad,,,,,,,,On,155,FFFFFF,,,,,,,,Restore,
   inifile=%inifile%`n`;Deactivated ,- Notepad,,,,-Right,-Bottom,150,150,,,,10,10,80`%,80`%,,,,,Ghost
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Example:
   inifile=%inifile%`n`; Makes Calculator stick inside the Bottom Right edge of the Notepad window when active,
   inifile=%inifile%`n`; and Left of and below the Top edge when deactivated.
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Active      ,Calc,,- Notepad,,-Right,-Bottom,,,On,,,,,,,,,,,
   inifile=%inifile%`n`;Deactivated ,Calc,,- Notepad,,-Left,+Top,,,Off,,,,,,,,,,,
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Example:
   inifile=%inifile%`n`; Rolls up Calculator when the mouse if outside its window.
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Inside      ,Calc,,,,,,,,,,,Off,,,,,,,,
   inifile=%inifile%`n`;Outside     ,Calc,,,,,,,,,,,0,0,Width,23,,,,,
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;There are also a few global parameters that you normally need not be concerned about...
   inifile=%inifile%`n`;1. The Hotkeys parameter can be set to On or Off (initially Off). You can set this
   inifile=%inifile%`n`;   to Off if the hotkeys of this program conflict with the hotkeys of another program.
   inifile=%inifile%`n`;2. The Interval parameter specifies the time in thousandths of a second (initially 500,
   inifile=%inifile%`n`;   not <100) between starting executions of the main processing loop. This can be made
   inifile=%inifile%`n`;   smaller to increase speed or larger to decrease CPU time used (if your computer is
   inifile=%inifile%`n`;   slow (note: does not take effect until next time program is run).
   inifile=%inifile%`n`;3. Each of the Top, Bottom, Left, and Right offset parameters specifies a distance
   inifile=%inifile%`n`;   in pixels (intially 0, not >200) from a screen edge. The screen area defined by
   inifile=%inifile%`n`;   an offset is then restricted so that %applicationname% does not position windows in this area
   inifile=%inifile%`n`;   (except for WholeScreen).
   inifile=%inifile%`n`;   You might change one or more of these offset parameters if:
   inifile=%inifile%`n`;   A. the Taskbar is not Always on top (see Start/Settings/Taskbar...) and you want it
   inifile=%inifile%`n`;      to show (otherwise, ..x=-Right,y=-Bottom.. or submenu item Bottom Right covers up
   inifile=%inifile%`n`;      the system tray). If for this reason, try using Bottomoffset=27 or so
   inifile=%inifile%`n`;      (Windows Standard display scheme, Windows 98)
   inifile=%inifile%`n`;   B. you want to try to keep one or more areas of the screen near an edge uncovered
   inifile=%inifile%`n`;      by windows to display desktop icons, toolbars, widgets, gadgets, etc.
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Notes on menu items:
   inifile=%inifile%`n`;1.  All window-changing menu items are applied to the active window only, so even if there
   inifile=%inifile%`n`;    are windows on the screen nothing will happen when a trying to apply a menu item
   inifile=%inifile%`n`;    unless one of these windows is the active window.
   inifile=%inifile%`n`;2.  Menu items will not be applied to windows controlled by Active mode, to avoid
   inifile=%inifile%`n`;    conflicts. So this too can cause nothing to happen when a trying to apply a menu item.
   inifile=%inifile%`n`;3.  If a custom menu line in the .ini file does not appear in the menu, it is probably
   inifile=%inifile%`n`;    because there is something wrong with one or more of the parameters in it.
   inifile=%inifile%`n`;4.  Roll Up/Roll Down - The original height of a rolled up window is saved and can be
   inifile=%inifile%`n`;    restored by Roll Down as long as the window has remained open, even if it has been
   inifile=%inifile%`n`;    minimized at some point. Windows that have been rolled up by Caption or closed in
   inifile=%inifile%`n`;    a rolled up state and reopened can be rolled down, which will result in a window with
   inifile=%inifile%`n`;    proportions the same as the available (that is, not including offset areas, if any)
   inifile=%inifile%`n`;    screen area.
   inifile=%inifile%`n`;5.  Center - Double-clicking the system tray icon centers the active window.
   inifile=%inifile%`n`;6.  Cover - The items in this submenu can be used to cover the available screen area
   inifile=%inifile%`n`;    with 2, 3, or 4 windows that each cover half or a quarter of the space.
   inifile=%inifile%`n`;7.  Place and Cover - Notice that for the hotkeys of the submenu items of these menu items,
   inifile=%inifile%`n`;    the positions of the hotkeys on the numeric keypad match the positions on the screen
   inifile=%inifile%`n`;    that the window will be moved to.
   inifile=%inifile%`n`;8.  Zoom In/Out - Zoom In doubles the area of a window while keeping the same center point
   inifile=%inifile%`n`;    unless its position or size are adjusted to keep all of it inside the available screen
   inifile=%inifile%`n`;    area. Zoom Out halves the area. Hint: Alt-I twice = 4X.
   inifile=%inifile%`n`;9.  Transparency - This does not appear on Windows 95/98/NT systems.
   inifile=%inifile%`n`;10. Undo/Remember - Undo is a slngle-level restore function that can be used to restore the
   inifile=%inifile%`n`;    size and position (and transparency if available) of the window that was most recently
   inifile=%inifile%`n`;    changed by use of a menu item (including custom items but not Roll Up or Roll Down),
   inifile=%inifile%`n`;    or that had its data saved by Remember. Undo is intended for quick use after an
   inifile=%inifile%`n`;    unappreciated change, or use after temporarily changing a window (even using the mouse)
   inifile=%inifile%`n`;    to work within it, but can be used later, provided that the window has remained open
   inifile=%inifile%`n`;    and no other window's data has been saved as a result of clicking a menu item.
   inifile=%inifile%`n`;11. Always on top/Send to Bottom - A check mark will appear in the menu next to the Always
   inifile=%inifile%`n`;    on top item if that is the status of the current active window. Send to Bottom will
   inifile=%inifile%`n`;    send an Always on top window to the bottom, changing its status to not Always on top.
   inifile=%inifile%`n`;12. Hotkeys - A check mark will appear in the menu next to Hotkeys if enabled. All standard
   inifile=%inifile%`n`;    menu and submenu items have hotkeys, except HotKeys and Exit (to prevent accidental
   inifile=%inifile%`n`;    inactivation). Hotkey assignments can be found in the Help window.
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;
   inifile=%inifile%`n`;Here's a pattern line for you to cut, paste, and modify, must have mode and title/menu item:
   inifile=%inifile%`n`;mode     , title/m.i. , text , otitle , otext , x , y , width , height , On/Off/Toggle , nnn/Off , hhhhhh/Off , cx , cy , cwidth , cheight , path ,  ,  ,  ,
   inifile=%inifile%`n`;Try not to delete any commas, and don't forget to remove the semicolon ( `; )
   inifile=%inifile%`n`;Here's a pattern line for postition/size only:
   inifile=%inifile%`n`;mode     , title/m.i. , text ,,, x , y , width , height ,,,,,,,,,,,,
   inifile=%inifile%`n`;And here's one for transparency/transcolor only:
   inifile=%inifile%`n`;mode     , title/m.i. , text ,,,,,,,, nnn/Off , hhhhhh/Off ,,,,,,,,,
   inifile=%inifile%`n
   inifile=%inifile%`nActive      ,Calc,,- Notepad,,-Right,-Bottom,,,On,,,,,,,,,,,
   inifile=%inifile%`nDeactivated ,Calc,,- Notepad,,-Left,+Top,,,Off,,,,,,,,,,,
   inifile=%inifile%`n
   inifile=%inifile%`n`;Stop    /\ enter automatic and menu parameters above this line /\
   inifile=%inifile%`n
   inifile=%inifile%`n[Parms]
   inifile=%inifile%`nHotkeys=Off
   inifile=%inifile%`nInterval=500
   inifile=%inifile%`nLeftoffset=0
   inifile=%inifile%`nRightoffset=0
   inifile=%inifile%`nTopoffset=0
   inifile=%inifile%`nBottomoffset=0
   inifile=%inifile%`n
   FileAppend,%inifile%,%applicationname%2.ini
}

FileGetTime,currmodtime,%applicationname%2.ini,M
IfNotInString,currmodtime,%prevmodtime% ; .ini file has been modified
{
   prevmodtime=%currmodtime%

   inifile=
   autocount=0
   menucount=0

   Loop,Read,%applicationname%2.ini
   {
     IfInString,A_LoopReadLine,`;Stop
       Break
     IfNotInString,A_LoopReadLine,`;
     IfInString,A_LoopReadLine,`,
     {
       StringSplit,part,A_LoopReadLine,`,

       2ndpart =%part2%
       If 2ndpart<>
       {
         1stpart =%part1%
         If 1stpart in Inside,Outside,Creating,Activating,Active,Maximizing,Maximized,Deactivating,Deactivated
         {
           asterpos:=InStr(2ndpart,"*")
           If asterpos=0 ;no asterisk in title - so it's not a wildcard
           {
             titlematch=S ;S - title string find, or...
             fslashpos:=InStr(2ndpart,"/")
             If fslashpos=1 ;could be a class name
             {
               fslashpos:=InStr(2ndpart,"/",False,2)
               If (fslashpos=StrLen(2ndpart))
                 titlematch=C ;C - class name match
             }
             Gosub,LOADAUTO
           }
           Else
           {
             If (asterpos=StrLen(2ndpart)) ;asterisk is last character
             {
               titlematch=F ;F - first title characters match
               Gosub,LOADAUTO
             }
             Else
             {
               If asterpos=1 ;or, asterisk is first character
               {
                 titlematch=L ;L - last title characters match
                 Gosub,LOADAUTO
               }
               Else
               {
                 titlematch=S ;S - title string find
                 Gosub,LOADAUTO
               }
             }
           }
         }
         Else
         If 1stpart=Menu
           Gosub,LOADMENU
       }
     }
   }
   Gosub,TRAYMENU ;builds new menu since there may be
; ;added/changed/deleted custom menu items
}
Return

LOADAUTO:
autocount++

mode_Auto_%autocount% =%part1% ;abc

titlematch_Auto_%autocount% =%titlematch% ;S(tring), F(irst), L(ast), or C(lass)
If titlematch=S
{
   titlelength_Auto_%autocount% =
   title_Auto_%autocount% =%2ndpart% ;abc
}
Else
{
   If titlematch=C
   {
     titlelength_Auto_%autocount%=
     StringTrimRight,2ndpart,2ndpart,1
     StringTrimLeft,title_Auto_%autocount%,2ndpart,1
   }
   Else
   {
     titlelength_Auto_%autocount%:=StrLen(2ndpart)-1
     If titlematch=F
       StringTrimRight,title_Auto_%autocount%,2ndpart,1
     Else
       StringTrimLeft,title_Auto_%autocount%,2ndpart,1
   }
}

text_Auto_%autocount% =%part3% ;abc
othertitle_Auto_%autocount% =%part4% ;abc,WholeScreen,empty to use screen
othertext_Auto_%autocount% =%part5% ;abc

type=Auto
count=%autocount%
Gosub,LOADEITHER
Return

LOADMENU:
menucount++

If 2ndpart=Spacer
{
   item_Menu_%menucount% = ;empty
   Return
}

If InStr(2ndpart,"&")=(StrLen(2ndpart))
   StringReplace,2ndpart,2ndpart,& ;since there's no character after it
Else
{
   amperpos:=InStr(2ndpart,"&")
   If amperpos>0
   {
     StringSplit,thischar,2ndpart
     selectpos:=amperpos+1
     selectchar:=thischar%selectpos%
     If selectchar in %A_Space%,r,d,p,c,m,e,u,a,b,k,s,h,q
       StringReplace,2ndpart,2ndpart,&,,All ;since there's no character to underline, or the ;; character will conflict with another menu item
   }
}
item_Menu_%menucount% =%2ndpart% ;abc

thispart =%part4%
If thispart=WholeScreen
   othertitle_Menu_%menucount% =WholeScreen ;WholeScreen only, or...
Else
   othertitle_Menu_%menucount% = ;empty
othertext_Menu_%menucount% = ;empty

type=Menu
count=%menucount%
Gosub,LOADEITHER
Return

LOADEITHER:
x_%type%_%count% =%part6%
If x_%type%_%count% not in -Left,+Left,-Center,Center,+Center,-Right,+Right,Caption
{
   thispart =%part6%
   Gosub,NUMTEST
   If validnum=N
     x_%type%_%count% = ;...or x,x%
}
Else
If type=Menu
   If x_%type%_%count% in -Left,+Right
      x_%type%_%count% =

y_%type%_%count% =%part7%
If y_%type%_%count% not in -Top,+Top,-Center,Center,+Center,-Bottom,+Bottom,Caption
{
   thispart =%part7%
   Gosub,NUMTEST
   If validnum=N
     y_%type%_%count% = ;...or x,x%
}
Else
If type=Menu
   If y_%type%_%count% in -Top,+Bottom
      y_%type%_%count% =

width_%type%_%count% =%part8%
If width_%type%_%count% not in Width,Right,Center
{
   thispart =%part8%
   Gosub,NUMTEST
   If validnum=N
     width_%type%_%count% = ;...or x,x%
}

height_%type%_%count% =%part9%
If height_%type%_%count% not in Height,Bottom,Center,Caption
{
   thispart =%part9%
   Gosub,NUMTEST
   If validnum=N
     height_%type%_%count% = ;...or x,x%
}

alwaysontop_%type%_%count% =%part10%
If alwaysontop_%type%_%count% not in On,Off,Toggle
   alwaysontop_%type%_%count%    =

If transparencyon=Y
{
   transparency_%type%_%count% =%part11% ;0-255,Off
   If transparency_%type%_%count%<>Off
   If transparency_%type%_%count% is not digit
     transparency_%type%_%count% =
   Else
     If transparency_%type%_%count%>255
       transparency_%type%_%count% =

   transcolor_%type%_%count% =%part12% ;000000-FFFFFF,Off
   If transcolor_%type%_%count%<>Off
   If transcolor_%type%_%count% is not xdigit
     transcolor_%type%_%count% =
   Else
     If StrLen(transcolor_%type%_%count%)<>6
       transcolor_%type%_%count% =

   clipx_%type%_%count% =%part13%
   If clipx_%type%_%count%<>Off
   {
     thispart =%part13%
     Gosub,NUMTEST
     If validnum=N
       clipx_%type%_%count% = ;...or x,x%
   }

   thispart =%part14%
   Gosub,NUMTEST
   If validnum=Y
     clipy_%type%_%count% =%part14% ;x,x%

   clipwidth_%type%_%count% =%part15%
   If clipwidth_%type%_%count%<>Width
   {
     thispart =%part15%
     Gosub,NUMTEST
     If validnum=N
       clipwidth_%type%_%count% = ;...or x,x%
   }

   clipheight_%type%_%count% =%part16%
   If clipheight_%type%_%count%<>Height
   {
     thispart =%part16%
     Gosub,NUMTEST
     If validnum=N
       clipheight_%type%_%count% = ;...or x,x%
   }

   clip_%type%_%count%=0
   If clipx_%type%_%count%>=0
   If clipy_%type%_%count%>=0
   If clipwidth_%type%_%count%>=0
   If clipheight_%type%_%count%>=0
     clip_%type%_%count%=1
   ghost_%type%_%count%=0
   IfInString,line,`,Ghost
     ghost_%type%_%count%=1
}

filepath_%type%_%count% =%part17% ;abc

maximize_%type%_%count%=0
IfInString,line,`,Maximize
   maximize_%type%_%count%=1
minimize_%type%_%count%=0
IfInString,line,`,Minimize
   minimize_%type%_%count%=1
restore_%type%_%count%=0
IfInString,line,`,Restore
   restore_%type%_%count%=1
hide_%type%_%count%=0
IfInString,line,`,Hide
   hide_%type%_%count%=1
show_%type%_%count%=0
IfInString,line,`,Show
   show_%type%_%count%=1
top_%type%_%count%=0
IfInString,line,`,Top
   top_%type%_%count%=1
bottom_%type%_%count%=0
IfInString,line,`,Bottom
   bottom_%type%_%count%=1
enable_%type%_%count%=0
IfInString,line,`,Enable
   enable_%type%_%count%=1
disable_%type%_%count%=0
IfInString,line,`,Disable
   disable_%type%_%count%=1
activate_%type%_%count%=0
IfInString,line,`,Activate
   activate_%type%_%count%=1
deactivate_%type%_%count%=0
IfInString,line,`,Deactivate
   deactivate_%type%_%count%=1
Return

NUMTEST:
validnum=Y
If thispart<>
{
   IfInString,thispart,`%
     StringTrimRight,thispart,thispart,1
   If thispart is not number
     validnum=N
}
Return


TRAYMENU:
Menu,Tray,DeleteAll ;fresh start
Menu,Tray,NoStandard
Menu,Tray,Tip,%applicationname%

Loop,%menucount% ;custom menu items - item can be spacer
   Menu,Tray,Add,% item_Menu_%A_Index%,APPLYMENUITEM
If menucount>0 ;spacer before standard menu items
   Menu,Tray,Add,

Menu,Tray,Add,&Roll Up,ROLLUP
Menu,Tray,Add,Roll &Down,ROLLDOWN
Menu,Tray,Add,
Menu,Tray,Add,Center,CENTER
Menu,Tray,Add,&Place,:Placemenu
Menu,Tray,Add,&Cover,:Covermenu
Menu,Tray,Add,&Morph,:Morphmenu

If transparencyon=Y
   Menu,Tray,Add,&Transparency,:Transpmenu

Menu,Tray,Add,R&emember,REMEMBER
Menu,Tray,Add,&Undo,UNDO
Menu,Tray,Add,

Menu,Tray,Add,&Always on top,AONTOP
If activeaontop=N
   Menu,Tray,Uncheck,&Always on top
Else
   Menu,Tray,Check,&Always on top
Menu,Tray,Add,Send to &Bottom,TOBOTTOM
Menu,Tray,Add,

IniRead,hotkeys,%applicationname%2.ini,Parms,Hotkeys
Menu,Tray,Add,Hot&keys,HOTKEYS
Gosub,CHECKHOTKEYS

Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&Help...,HELP
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,Center
Return


CHECKHOTKEYS:
If hotkeys=On
{
   Menu,Tray,Check,Hot&keys
   Hotkey,!R,On
   Hotkey,!Up,On
   Hotkey,!D,On
   Hotkey,!Down,On
   Hotkey,!W,On
   Hotkey,!T,On
   Hotkey,!I,On
   Hotkey,!O,On
   Hotkey,!E,On
   Hotkey,!U,On
   Hotkey,!A,On
   Hotkey,!B,On
   Hotkey,!S,On
   Hotkey,!H,On
   Hotkey,!Numpad1,On
   Hotkey,!Numpad2,On
   Hotkey,!Numpad3,On
   Hotkey,!Numpad4,On
   Hotkey,!Numpad5,On
   Hotkey,!Numpad6,On
   Hotkey,!Numpad7,On
   Hotkey,!Numpad8,On
   Hotkey,!Numpad9,On
   Hotkey,^!Numpad1,On
   Hotkey,^!Numpad2,On
   Hotkey,^!Numpad3,On
   Hotkey,^!Numpad4,On
   Hotkey,^!Numpad6,On
   Hotkey,^!Numpad7,On
   Hotkey,^!Numpad8,On
   Hotkey,^!Numpad9,On

   If transparencyon=Y
   {
     Hotkey,!0,On
     Hotkey,!1,On
     Hotkey,!2,On
     Hotkey,!3,On
     Hotkey,!4,On
     Hotkey,!5,On
     Hotkey,!6,On
     Hotkey,!7,On
     Hotkey,!8,On
     Hotkey,!9,On
   }
}
Else
{
   Menu,Tray,Uncheck,Hot&keys
   Hotkey,!R,Off
   Hotkey,!Up,Off
   Hotkey,!D,Off
   Hotkey,!Down,Off
   Hotkey,!W,Off
   Hotkey,!T,Off
   Hotkey,!I,Off
   Hotkey,!O,Off
   Hotkey,!E,Off
   Hotkey,!U,Off
   Hotkey,!A,Off
   Hotkey,!B,Off
   Hotkey,!S,Off
   Hotkey,!H,Off
   Hotkey,!Numpad1,Off
   Hotkey,!Numpad2,Off
   Hotkey,!Numpad3,Off
   Hotkey,!Numpad4,Off
   Hotkey,!Numpad5,Off
   Hotkey,!Numpad6,Off
   Hotkey,!Numpad7,Off
   Hotkey,!Numpad8,Off
   Hotkey,!Numpad9,Off
   Hotkey,^!Numpad1,Off
   Hotkey,^!Numpad2,Off
   Hotkey,^!Numpad3,Off
   Hotkey,^!Numpad4,Off
   Hotkey,^!Numpad6,Off
   Hotkey,^!Numpad7,Off
   Hotkey,^!Numpad8,Off
   Hotkey,^!Numpad9,Off

   If transparencyon=Y
   {
     Hotkey,!0,Off
     Hotkey,!1,Off
     Hotkey,!2,Off
     Hotkey,!3,Off
     Hotkey,!4,Off
     Hotkey,!5,Off
     Hotkey,!6,Off
     Hotkey,!7,Off
     Hotkey,!8,Off
     Hotkey,!9,Off
   }
}
Return


APPLYMENUITEM:
Critical
Gosub,CHECKACTIVE
If activematch=N
{
   type=Menu
   savelineindex=%lineindex%
   lineindex:=A_ThisMenuItemPos
;  lineindex-=10 ;if debugging and not "Menu,Tray,NoStandard"
   savewinid=%winid%
   winid=%actwinid%

   Gosub,MENUITEM

   type=Auto
   lineindex=%savelineindex%
   winid=%savewinid%
}
Gosub,REACTIVATE
Return


ROLLUP:
Gosub,CHECKACTIVE
If activematch=N
{
   WinGetPos,,,,rheight,ahk_id %actwinid%
   rheight%actwinid%=%rheight% ;save the window height so that it may be rolled down later
   WinMove,ahk_id %actwinid%,,,,,%captionheight%
}
Gosub,REACTIVATE
Return

ROLLDOWN:
Gosub,CHECKACTIVE
If activematch=N
{
   If rheight%actwinid%=
   {
     WinGetPos,,,rwidth,rheight,ahk_id %actwinid%
     If rheight=%captionheight% ;window was closed while rolled up

       rheight%actwinid%:=rwidth*(monitorHeight/monitorWidth)
; ;set height = width X screen height/width
; ;so window stays on screen
   }
   If rheight%actwinid%<>
   {
     WinMove,ahk_id %actwinid%,,,,,% rheight%actwinid% ;sets window to former (or calculated) height
     rheight%actwinid%=
   }
}
Gosub,REACTIVATE
Return


TOPLEFT:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorLeft
   wy:=monitorTop
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

TOPCENTER:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=(monitorRight-awidth)/2
   wy:=monitorTop
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

TOPRIGHT:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=monitorRight-awidth
   wy:=monitorTop
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

MIDDLELEFT:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=monitorLeft
   wy:=(monitorBottom-aheight)/2
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

CENTER:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=(monitorRight-awidth)/2
   wy:=(monitorBottom-aheight)/2
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

MIDDLERIGHT:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=monitorRight-awidth
   wy:=(monitorBottom-aheight)/2
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

BOTTOMLEFT:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=monitorLeft
   wy:=monitorBottom-aheight
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

BOTTOMCENTER:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=(monitorRight-awidth)/2
   wy:=monitorBottom-aheight
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

BOTTOMRIGHT:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wx:=monitorRight-awidth
   wy:=monitorBottom-aheight
   wwidth=
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return


LEFTHALF:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorLeft
   wy:=monitorTop
   wwidth:=monitorWidth/2
   wheight:=monitorHeight
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

RIGHTHALF:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorWidth/2
   wy:=monitorTop
   wwidth:=Ceil(monitorWidth/2)
   wheight:=monitorHeight
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

TOPHALF:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorLeft
   wy:=monitorTop
   wwidth:=monitorWidth
   wheight:=monitorHeight/2
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

BOTTOMHALF:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorLeft
   wy:=monitorHeight/2
   wwidth:=monitorWidth
   wheight:=Ceil(monitorHeight/2)
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

TOPLEFTQTR:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorLeft
   wy:=monitorTop
   wwidth:=monitorWidth/2
   wheight:=monitorHeight/2
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

TOPRIGHTQTR:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorWidth/2
   wy:=monitorTop
   wwidth:=Ceil(monitorWidth/2)
   wheight:=monitorHeight/2
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

BOTTOMLEFTQTR:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorLeft
   wy:=monitorHeight/2
   wwidth:=monitorWidth/2
   wheight:=Ceil(monitorHeight/2)
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

BOTTOMRIGHTQTR:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorWidth/2
   wy:=monitorHeight/2
   wwidth:=Ceil(monitorWidth/2)
   wheight:=Ceil(monitorHeight/2)
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return


WIDE:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx:=monitorLeft
   wy=
   wwidth:=monitorWidth
   wheight=
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

TALL:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETUNDODATA
   wx=
   wy:=monitorTop
   wwidth=
   wheight:=monitorHeight
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

ZOOMIN:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wwidth:=Round(awidth*1.4142)
   wheight:=Round(aheight*1.4142)
   wx:=ax+((awidth-wwidth)/2)
   wy:=ay+((aheight-wheight)/2)

   If (wx+wwidth)>monitorRight
     wx:=monitorRight-wwidth
   If (wy+wheight)>monitorBottom
     wy:=monitorBottom-wheight
   If wx<%monitorLeft%
     wx:=monitorLeft
   If wy<%monitorTop%
     wy:=monitorTop
   If (monitorWidth<wwidth)
     wwidth:=monitorWidth
   If (monitorHeight<wheight)
     wheight:=monitorHeight

   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return

ZOOMOUT:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   wwidth:=Round(awidth/1.4142)
   wheight:=Round(aheight/1.4142)
   wx:=ax+((awidth-wwidth)/2)
   wy:=ay+((aheight-wheight)/2)
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return


TRANSPHKEY:
transpnum:=A_ThisHotkey
transpnum++
Gosub,TRANSPARENCY
Return

TRANSPMENU:
transpnum:=A_ThisMenuItemPos
Gosub,TRANSPARENCY
Return

TRANSPARENCY:
Gosub,CHECKACTIVE
If activematch=N
{
   Gosub,GETWINDATA
   atransparency:=Round(((11-transpnum)*25.6)-1)
   Gosub,SETTRANSPACT
}
Gosub,REACTIVATE
Return


REMEMBER:
Gosub,CHECKACTIVE
If activematch=N
{
   uactwinid=
   Gosub,GETUNDODATA
}
Gosub,REACTIVATE
Return

UNDO:
Gosub,CHECKACTIVE
If activematch=N
{
   actwinid=%uactwinid%
   If utransparency<>
     Gosub,SETTRANSPACT
   wx:=ux
   wy:=uy
   wwidth:=uwidth
   wheight:=uheight
   Gosub,MOVESIZEACT
}
Gosub,REACTIVATE
Return


GETWINDATA:
WinGetPos,ax,ay,awidth,aheight,ahk_id %actwinid%
WinGet,atransparency,Transparent,ahk_id %actwinid%
Gosub,GETUNDODATA
Return

GETUNDODATA:
If uactwinid<>%actwinid%
{
   uactwinid=%actwinid%
   WinGetPos,ux,uy,uwidth,uheight,ahk_id %actwinid%
   WinGet,utransparency,Transparent,ahk_id %actwinid%
}
Return

MOVESIZEACT:
WinMove,ahk_id %actwinid%,,%wx%,%wy%,%wwidth%,%wheight%
Return

SETTRANSPACT:
WinSet,Transparent,%atransparency%,ahk_id %actwinid%
If atransparency=255
   WinSet,Transparent,Off,ahk_id %actwinid%
Return


AONTOP:
Gosub,CHECKACTIVE
If activematch=N
{
   If activeaontop=Y
   {
     activeaontop=N
     WinSet,AlwaysOnTop,Off,ahk_id %actwinid%
     Menu,Tray,Uncheck,&Always on top
   }
   Else
   {
     activeaontop=Y
     WinSet,AlwaysOnTop,On,ahk_id %actwinid%
     Menu,Tray,Check,&Always on top
   }
}
Gosub,REACTIVATE
Return

TOBOTTOM:
Gosub,CHECKACTIVE
If activematch=N
;If activeaontop=N ;uncomment to disallow applying if always on top
{
   activeaontop=N ;and comment this
   WinSet,Bottom,,ahk_id %actwinid%
   Menu,Tray,Uncheck,&Always on top ;and this
}
Return


CHECKACTIVE:
activematch=N
WinGetClass,cclass,ahk_id %actwinid%
If cclass=ToolbarWindow32 ;if XP and/or 64 bit, [If cclass in ToolbarWindow32,(otherclass),...] ?
{
   activematch=Y ;bypass menu commands, since this is a system window
   Return
}

WinGet,cstate,MinMax,ahk_id %actwinid%
If cstate=-1
{
   activematch=Y ;bypass menu commands, since this is a minimized window
   Return
}

WinGetTitle,ctitle,ahk_id %actwinid%
WinGetText,ctext,ahk_id %actwinid%
Loop %autocount%
{
   If mode_Auto_%A_Index%=Active
   {
     If titlematch_Auto_%A_Index%=S
     {
       IfInString,ctitle,% title_Auto_%A_Index% ;try to find string
       {
         Gosub,CHECKTEXT
         If activematch=Y
           Break
       }
     }
     Else
     {
       If titlematch_Auto_%A_Index%=F
         StringLeft,ctitle,ctitle,titlelength_Auto_%A_Index% ;try to match first characters
       Else
         StringRight,ctitle,ctitle,titlelength_Auto_%A_Index% ;try to match first characters
       If ctitle=% title_Auto_%A_Index%
       {
         Gosub,CHECKTEXT
         If activematch=Y
           Break
       }
     }
   }
}
Return

CHECKTEXT:
If text_Auto_%A_Index%=
   activematch=Y ;bypass menu commands, since these windows will just snap back, etc.
Else
   IfInString,ctext,% text_Auto_%A_Index%
     activematch=Y
Return


REACTIVATE:
WinActivate,ahk_id %actwinid%
Return


HOTKEYS:
If hotkeys=On
{
   IniWrite,Off,%applicationname%2.ini,Parms,Hotkeys
   Menu,Tray,Uncheck,Hot&keys
}
Else
{
   IniWrite,On,%applicationname%2.ini,Parms,Hotkeys
   Menu,Tray,Check,Hot&keys
}
Return

SETTINGS:
Gosub,READINI
Run,%applicationname%2.ini
Return

HELP:
help=Controls how to display a window
help=%help%`n
help=%help%`nMove, maximize, minimize, restore, enable, disable, hide, show,
help=%help%`nontop, bottom, alwaysontop, clip, transparent, transparent color,
help=%help%`nmove relative to another window, stick to the edge of the screen,
help=%help%`nroll up and down, morph wide/tall/zoom in/zoom out.
help=%help%`n
help=%help%`nHotkey assignments:
help=%help%`n(Hotkeys must be on)
help=%help%`nAlt-R (or up /\) - Roll up active window
help=%help%`nAlt-D (or down \/) - roll Down active window
help=%help%`nAlt-[keypad#] - place active window at edge location
help=%help%`nCtrl-Alt-[keypad#] - cover part of screen area with active window
help=%help%`nAlt-W - expand active window horizontally (Wide)
help=%help%`nAlt-T - expand active window vertically (Tall)
help=%help%`nAlt-I - zoom In active window (2X area)
help=%help%`nAlt-O - zoom Out active window (.5X area)
If transparencyon=Y
   help=%help%`nAlt-[#] - set transparency level of active window
help=%help%`nAlt-E - rEmember active window data for later undo
help=%help%`nAlt-U - Undo changes to active window
help=%help%`nAlt-A - change Always on top status of active window
help=%help%`nAlt-B - move active window to Bottom of others
help=%help%`nAlt-S - edit Settings file
help=%help%`nAlt-H - display this Help window
help=%help%`n
help=%help%`nFor more information,read %applicationname%2.ini
help=%help%`nby rightclicking the tray icon and selecting Settings.
help=%help%`n
help=%help%`nSkrommel @2005    http://www.1HourSoftware.com
help=%help%`nTim Morck @2006
MsgBox,0,%applicationname%,%help%
help=
Return

EXIT:
ExitApp


INSIDE:
OUTSIDE:
CREATING:
ACTIVATING:
ACTIVE:
MAXIMIZING:
MAXIMIZED:
DEACTIVATING:
DEACTIVATED:

MENUITEM:

Gosub,MOVE
Gosub,MINMAX
Gosub,SHOW
Gosub,TOP
Gosub,ENABLE
Gosub,ACTIVATE

If transparencyon=Y
{
   Gosub,TRANSPARENT
   Gosub,TRANSCOLOR
   Gosub,CLIPGHOST
}

Gosub,RUN
Return

MOVE:
x:=x_%type%_%lineindex% ;so the arrays are not changed
y:=y_%type%_%lineindex%
width:=width_%type%_%lineindex%
height:=height_%type%_%lineindex%

WinGetPos,sx,sy,swidth,sheight,ahk_id %winid%

If type=Menu
If uactwinid<>%winid%
{
   uactwinid=%winid% ;save current data for possible undo of custom menu item
   ux:=sx
   uy:=sy
   uwidth:=swidth
   uheight:=sheight
   WinGet,utransparency,Transparent,ahk_id %winid%
}

If othertitle_%type%_%lineindex%=WholeScreen
{
   ox:=0
   oy:=0
   owidth:=A_ScreenWidth
   oheight:=A_ScreenHeight
}
Else
{
   ox:=monitorLeft
   oy:=monitorTop
   owidth:=monitorRight
   oheight:=monitorBottom
}

;*****
If othertitle_%type%_%lineindex%<>
IfWinExist,% othertitle_%type%_%lineindex%,% othertext_%type%_%lineindex%
{
   WinGet,otherwinid,ID,% othertitle_%type%_%lineindex%,% othertext_%type%_%lineindex%
   WinGetPos,ox,oy,owidth,oheight,ahk_id %otherwinid%
}
;*****
;    note: since a window (B) that is minimized has a position of x=3000,y=3000 (W98), if it is the other window
;    that controls the position of a window (A), A will be 'pulled' off the screen along with B if B is minimized.
;    To avoid this, and instead position A relative to the screen as though B does not exist when B is minimized,
;    use this code instead:
;
;If othertitle_%type%_%lineindex%<>
;IfWinExist,% othertitle_%type%_%lineindex%,% othertext_%type%_%lineindex%
;{
;  WinGet,mstate,MinMax,% othertitle_%type%_%lineindex%,% othertext_%type%_%lineindex%
;  If mstate<>-1 ;other window not minimized
;  {
;    WinGet,otherwinid,ID,% othertitle_%type%_%lineindex%,% othertext_%type%_%lineindex%
;    WinGetPos,ox,oy,owidth,oheight,ahk_id %otherwinid%
;  }
;}
;*****

;    note: a window (A) 'attached' to the outside of an other window (B) (such as x=-Left does) will be positioned
;    relative to the screen if the other window does not exist, and so will be 'pushed' just outside the screen
;    (or screen area if offsets are used). To avoid this, don't use x=-Left, x=+Right, y=-Top, or y=+Bottom
;    unless A will only exist when B exists.

If x=+Left
   x:=0
Else
If x=+Right
   x:=owidth
Else
If x=+Center
   x:=owidth/2
Else
If x=Caption
   x:=captionheight ;shift right (x) by height (y) for Cascade effect
Else
IfInString,x,`%
{
   StringTrimRight,x,x,1
   x:=owidth*x/100+ox
}

If y=+Top
   y:=0
Else
If y=+Bottom
   y:=oheight
Else
If y=+Center
   y:=oheight/2
Else
If y=Caption
   y:=captionheight
Else
IfInString,y,`%
{
   StringTrimRight,y,y,1
   y:=oheight*y/100
}

If width=
   width:=swidth
If height=
   height:=sheight

If width=Width
   width:=owidth
Else
If width=Right
   width:=owidth-x
Else
If width=Center
   width:=owidth/2-x
Else
IfInString,width,`%
{
   StringTrimRight,width,width,1
   width:=owidth*width/100
}

If height=Height
   height:=oheight
Else
If height=Bottom
   height:=oheight-y
Else
If height=Center
   height:=oheight/2-y
Else
If height=Caption
{
   height:=captionheight ;roll up window
   WinGetPos,,,,rheight,ahk_id %winid%
   rheight%winid%=%rheight% ;save the window height so that it may be rolled down later
}
Else
IfInString,height,`%
{
   StringTrimRight,height,height,1
   height:=oheight*height/100
}

If x=-Left
   x:=ox-width
Else
If x=-Right
   x:=owidth-width+ox
Else
If x=-Center
   x:=owidth/2-width+ox
Else
If x=Center
   x:=owidth/2-width/2+ox
Else
   x:=x+ox

If y=-Top
   y:=oy-height
Else
If y=-Bottom
   y:=oheight-height+oy
Else
If y=-Center
   y:=oheight/2-height+oy
Else
If y=Center
   y:=oheight/2-height/2+oy
Else
   y:=y+oy

WinMove,ahk_id %winid%,,%x%,%y%,%width%,%height%
Return

MINMAX:
If maximize_%type%_%lineindex%=1
   WinMaximize,ahk_id %winid%
If minimize_%type%_%lineindex%=1
   WinMinimize,ahk_id %winid%
If restore_%type%_%lineindex%=1
   WinRestore,ahk_id %winid%
Return

SHOW:
If show_%type%_%lineindex%=1
   WinShow,ahk_id %winid%
If hide_%type%_%lineindex%=1
   WinHide,ahk_id %winid%
Return

TOP:
If alwaysontop_%type%_%lineindex%<>
   WinSet,AlwaysOnTop,% alwaysontop_%type%_%lineindex%,ahk_id %winid%
If top_%type%_%lineindex%=1
   WinSet,Top,,ahk_id %winid%
If bottom_%type%_%lineindex%=1
   WinSet,Bottom,,ahk_id %winid%
Return

ENABLE:
If enable_%type%_%lineindex%=1
   WinSet,Enable,,ahk_id %winid%
If disable_%type%_%lineindex%=1
   WinSet,Disable,,ahk_id %winid%
Return

ACTIVATE:
If activate_%type%_%lineindex%=1
   WinActivate,ahk_id %winid%
Return

TRANSPARENT:
If transparency_%type%_%lineindex%<>
If transparency%winid%<>transparency_%type%_%lineindex%
{
   transparency%winid%=% transparency_%type%_%lineindex%

   WinSet,Transparent,% transparency_%type%_%lineindex%,ahk_id %winid%
   If (transparency_%type%_%lineindex%="Off"
    or transparency_%type%_%lineindex%="255")
     WinSet,Transparent,Off,ahk_id %winid%
}
Return

TRANSCOLOR:
If transcolor_%type%_%lineindex%<>
If transcolor%winid%<>transcolor_%type%_%lineindex%
{
   transcolor%winid%=% transcolor_%type%_%lineindex%

   If A_OSVersion=WIN_XP
   {
     WinGet,stransparency,Transparent,ahk_id %winid%
     WinSet,Transparent,Off,ahk_id %winid%
     WinSet,TransColor,% transcolor_%type%_%lineindex% stransparency,ahk_id %winid%
   }
   Else
   {
     WinSet,Transparent,Off,ahk_id %winid%
     WinSet,TransColor,% transcolor_%type%_%lineindex%,ahk_id %winid%
     If transparency_%type%_%lineindex%<>Off
     If transparency_%type%_%lineindex%<255
       WinSet,Transparent,% transparency_%type%_%lineindex%,ahk_id %winid%
   }
}
Return

CLIPGHOST:
clipx:=clipx_%type%_%lineindex% ;so the arrays are not changed
clipy:=clipy_%type%_%lineindex%
clipwidth:=clipwidth_%type%_%lineindex%
clipheight:=clipheight_%type%_%lineindex%

WinGetPos,sx,sy,swidth,sheight,ahk_id %winid%
IfInString,clipwidth,`%
{
   StringTrimRight,clipwidth,clipwidth,1
   clipwidth:=swidth*clipwidth/100
}
IfInString,clipheight,`%
{
   StringTrimRight,clipheight,clipheight,1
   clipheight:=sheight*clipheight/100
}

If clip_%type%_%lineindex%=0
If ghost_%type%_%lineindex%=0
   WinSet,Region,,ahk_id %winid%

WinGetPos,sx,sy,swidth,sheight,ahk_id %winid%
MouseGetPos,mx,my
mx-=%sx%
my-=%sy%

If clipx=Off
   clipx=0
If clipx=
   clipx=0
If clipy=
   clipy=0

If clipwidth=Width
   clipwidth=%swidth%
Else
If clipwidth=
   clipwidth=%swidth%

If clipwidth=Height
   clipwidth=%sheight%
Else
If clipheight=
   clipheight=%sheight%

If ghost_%type%_%lineindex%=1
{
   SetEnv,mx1,%mx%
   SetEnv,my1,%my%
   EnvAdd,mx1,2
   EnvAdd,my1,2
   EnvSub,mx,1
   EnvSub,my,1
   WinSet,Region,%clipx%-%clipy% %clipwidth%-%clipy% %clipwidth%-%clipheight% %clipx%-%clipheight% %clipx%-%clipy%  %mx%-%my% %mx1%-%my% %mx1%-%my1% %mx%-%my1% %mx%-%my%,ahk_id %winid%
}
Else
If clip_%type%_%lineindex%=1
{
   WinGetPos,sx,sy,swidth,sheight,ahk_id %winid%
   WinSet,Region,%clipx%-%clipy% w%clipwidth% H%clipheight%,ahk_id %winid%
}
Return

RUN:
If filepath_%type%_%lineindex%<>
   Run,% filepath_%type%_%lineindex%
Return
