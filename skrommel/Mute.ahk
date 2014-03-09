;Mute.ahk
; Mutes or unmutes the speaker
;Skrommel @ 2005

#NoTrayIcon
SoundSet,+1,,mute
SoundGet, soundmute,, mute
if soundmute = On
  ToolTip, Sound is Off
else
  ToolTip, Sound is On
Sleep, 2000
ExitApp

