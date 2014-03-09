;OnTop.ahk
; Puts a window on top of all others
;Skrommel @ 2005

START:
MouseGetPos,,,vindu,control
WinGet,vindustatus,ExStyle,ahk_id %vindu%
Transform,resultat,BitAnd,%vindustatus%,0x8
If resultat <> 0
  ToolTip,^
Else
  ToolTip,_
Sleep,50
Goto,START

LButton::
MouseGetPos,,,vindu,control
WinSet,AlwaysOnTop,Toggle,ahk_id %vindu%
If resultat = 0
{
  WinActivate,ahk_id %vindu%
  ToolTip,^
  Sleep,1000
}
Else
{
  ToolTip,_
  Sleep,1000  
  WinMinimize,ahk_id %vindu%
}
ExitApp

Esc::
RButton::
ToolTip,·
Sleep,1000
ExitApp