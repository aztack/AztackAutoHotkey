;MouseClock.ahk
; Shows the current time next to the mouse cursor, and date and more in the tray
;Skrommel @2005

CoordMode,Mouse,Screen
START:
tid1=%A_HOUR%:%A_MIN%
MouseGetPos,x1,y1
If x2=%x1%
  If y2=%y1%
    If tid2=%tid1%
      Goto,UNMOVED
ToolTip,%tid1%
WinSet,TransColor,0x1EFFFF 100,%tid1%
UNMOVED:
StringTrimLeft,uke,A_YWeek,4
Menu,Tray,Tip,%A_DDDD% %A_DD%. %A_MMMM% %A_YYYY% - week %uke% - day %A_YDay%
Sleep,10
x2=%x1%
y2=%y1%
tid2=%tid1%
Goto,START