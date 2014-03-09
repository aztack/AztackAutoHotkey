;WhatCOlor.ahk
; Show and copy the RRGGBB color under the cursor.
;Skrommel @2005

#SingleInstance,Force
Loop
{
  Sleep,100
  MouseGetPos,x,y
  PixelGetColor,rgb,x,y,RGB
  StringTrimLeft,rgb,rgb,2
  ToolTip,%rgb%`nPress F12 to copy
  GetKeyState,state,F12,P
  If state=D
    Clipboard=%rgb%
}