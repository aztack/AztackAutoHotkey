/*
** Console-Slide.ahk - Slide Down a Window, like the Quake 3-style console
**
**   Updated: Thu, Aug 11, 2011 --- 8/11/11, 12:19:19am EDT
**  Keywords: Quake 3 console
**  Location: r.secsrv.net/AutoHotkey/Scripts/Console-Slide
**
**    Author: JSLover - r.secsrv.net/JSLover - r.secsrv.net/JSLoverAHK
*/

#SingleInstance force
#NoEnv
SetTitleMatchMode, 2

Console_window =quake
Console_cmd=cmd

Console_SlideDown_speed:=100
Console_SlideUp_speed:=100

^`::
SetWinDelay, 1
DetectHiddenWindows, On
if (!hwndConsole:=WinExist(Console_window)) {
	Run, %Console_cmd%
	WinWaitNotActive
	WinWaitActive, %Console_window%
	WinHide
}
if (hwndConsole:=WinExist(Console_window)) {
	if (!WinVisible()) {
		WinShow
		WinActivate
		Gosub, Console_SlideDown
	} else {
		Gosub, Console_SlideUp
		WinHide
		if (WinActive()) {
			Send, !{Esc}
		}
		;//need to move the focus somewhere else.
		;//WinActivate ahk_class Shell_TrayWnd
	}
}
DetectHiddenWindows, Off
return

WinVisible(p_window="") {
	A_DetectHiddenWindows_bkp:=A_DetectHiddenWindows
	DetectHiddenWindows, Off
	Visible:=WinExist(p_window)
	DetectHiddenWindows, %A_DetectHiddenWindows_bkp%
	return Visible
}

Console_SlideDown:
direction=1
Gosub, Console_Slide
return

Console_SlideUp:
direction=-1
Gosub, Console_Slide
return

Console_Slide:
WinGetPos, x, y, w, h
SysGet, s, MonitorWorkArea

if (direction=1) {
	y_dest:=floor((sBottom-h)/2)
	if (y_dest<-4) {
		y_dest:=0
	}

	y_inc:=Console_SlideDown_speed

	y:=sTop-h
} else if (direction=-1) {
	y_dest:=sTop-h

	y_inc:=-Console_SlideUp_speed
}

Loop {
	WinMove, , , , y
	if (y=y_dest) {
		break
	}
	if ((direction=1 && y+y_inc>y_dest) || (direction=-1 && y+y_inc<y_dest)) {
		y_inc:=y_dest-y
	}
	y+=y_inc
}
return