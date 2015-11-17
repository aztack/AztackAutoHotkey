::curdate::
FormatTime, CurrentDateTime,, yyyy/MM/dd hh:mm:ss
SendInput %CurrentDateTime%
return

#IfWinActive ahk_class PX_WINDOW_CLASS
:cR*:settimeout::setTimeout(function(){},0);
#IfWinActive