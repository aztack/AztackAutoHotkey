;Kill.ahk
; Leftclick a window to close it.
; Ctrl-Leftclick to kill it.
; Esc Cancels.
;Skrommel @ 2005

#SingleInstance,Force
CoordMode,Mouse,Screen

MouseGetPos,x2,y2,winid,ctrlid
wx:=x2+15
wy:=y2+15
Gui,+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow
Gui,Margin,0,0
Gui,Color,AAAAAA
Gui,Add,Picture,Icon1,Kill.exe
Gui,Show,X%wx% Y%wy% W32 H32 NoActivate,KillSkull
WinSet,TransColor,AAAAAA,KillSkull

Loop
{
  MouseGetPos,x1,y1,winid,ctrlid
  If x1=%x2%
  If y1=%y2%
    Continue
  wx:=x1+15
  wy:=y1+15
  WinMove,KillSkull,,%wx%,%wy%
  GetKeyState,esc,Esc,P
  If esc=D
    Break

  GetKeyState,lbutton,LButton,P
  GetKeyState,lctrl,LCtrl,P
  GetKeyState,rctrl,RCtrl,P
  If lbutton=D
  If(lctrl="D" Or rctrl="D")
  {
    WinKill,ahk_id %winid%
    Break
  }
  Else
  {
    WinClose,ahk_id %winid%
    Break
  }
  x2=%x1%
  y2=%y2%
}
Gui,Destroy
ExitApp
