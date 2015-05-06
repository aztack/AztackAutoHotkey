::curdate::
FormatTime, CurrentDateTime,, yyyy/M/d h:mm tt
SendInput %CurrentDateTime%
return

#IfWinActive ahk_class PX_WINDOW_CLASS
:cR*:settimeout::setTimeout(function(){},0);
#IfWinActive