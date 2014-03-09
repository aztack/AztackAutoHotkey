;CutAway.ahk
; Cut away parts of a window.
; Leftclick and drag to cut.
; Rightclick or ESC to undo.
;Skrommel @ 2008

#SingleInstance,Force

applicationname=CutAway

TIP:
SetTimer,TIP,Off
oldmx2:=mx2
oldmy2:=my2
MouseGetPos,mx2,my2
If (Abs(mx2-mx1)>2 And Abs(my2-my1)>2 And mx2<>oldmx2 And my2<>oldmy2)
{  
  WinSet,Region,% mx1 "-" my1 " W" mx2-mx1 " H" my2-my1,ahk_id %mwin1%
  ToolTip,%applicationname%`n`nLeftclick and drag to cut`nRightclick or ESC to undo`n`nwww.1HourSoftware.com,,,2
}
SetTimer,TIP,100
Return

LButton::
MouseGetPos,mx1,my1,mwin1
WinActivate,ahk_id %mwin1%
ToolTip,+,%mx1%,%my1%,1
SetTimer,TIP,100
Return

LButton Up::
SetTimer,TIP,Off
ExitApp

Esc::
*RButton::
MouseGetPos,,,mwin1
WinSet,Region,,ahk_id %mwin1%
ExitApp