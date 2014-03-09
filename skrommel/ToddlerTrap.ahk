;ToddlerTrap.ahk
; Disables mouse and keyboard input to stop toddlers messing up your PC, or to allow for cleaning
;Skrommel @2005

#SingleInstance,Force
#NoTrayIcon

Gui,+AlwaysOnTop +ToolWindow
Gui,Add,Hotkey,Default
Gui,Show,,ToddlerTrap

Loop
{
  Sleep,0
  WinActivate,ToddlerTrap ahk_class AutoHotkeyGUI
  ControlFocus,msctls_hotkey321,ToddlerTrap ahk_class AutoHotkeyGUI
}
Return

Lbutton::
MouseGetPos,x,y,winid
WinGetTitle,title,ahk_id %winid%
WinGetClass,class,ahk_id %winid%
If title=ToddlerTrap
If class=AutoHotkeyGUI
  MouseClick,Left,,,,,D
Return

Lbutton Up::
MouseGetPos,x,y,winid
WinGetTitle,title,ahk_id %winid%
WinGetClass,class,ahk_id %winid%

If title=ToddlerTrap
If class=AutoHotkeyGUI
  MouseClick,Left,,,,,U
Return

Mbutton::
RButton::
XButton1::
XButton2::
Return

Browser_Back::
Browser_Forward::
Browser_Refresh::
Browser_Stop::
Browser_Search::
Browser_Favorites::
Browser_Home::
Volume_Mute::
Volume_Down::
Volume_Up::
Media_Next::
Media_Prev::
Media_Stop::
Media_Play_Pause::
Launch_Mail::
Launch_Media::
Launch_App1::
Launch_App2::
*WheelDown::
*WheelUp::
*PrintScreen::
*CtrlBreak::
*Pause::
*Break::
*Lwin::
*RWin::
*LAlt::
*RAlt::
Return

GuiClose:
ExitApp