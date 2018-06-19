isGPD = true
LAlt & q::AltTab
LAlt & w::
  SendInput {Ctrl down}w{Ctrl up}
return
RAlt::
	SendInput /
return
RControl::
    SendInput '
return

LAlt & z::
    Send {LCtrl down}z{LCtrl up}
return
LAlt & s::
    Send {LCtrl down}s{LCtrl up}
return
LAlt & c::
    Send {LCtrl down}c{LCtrl up}
return
LAlt & v::
    Send {LCtrl down}v{LCtrl up}
return
LAlt & x::
    Send {LCtrl down}x{LCtrl up}
return
LAlt & y::
    Send {LCtrl down}y{LCtrl up}
return
LAlt & a::
    Send {LCtrl down}a{LCtrl up}
return
LAlt & r::
    Send {LCtrl down}r{LCtrl up}
return
LShift & Enter::
 Send :
return
; LAlt & LShift & f::
;     Send {LShift down}{LCtrl down}f{LCtrl up}{LShift up}
; return
Del::
    Send {BS}
return



#IfWinActive ahk_class Chrome_WidgetWin_1
    ;命令行操作
    LAlt & t::
      Send {LCtrl down}t{LCtrl up}
    return

#IfWinActive

; !1:: WinActivate, ahk_class PX_WINDOW_CLASS

#Include sleep-hibernate.ahk