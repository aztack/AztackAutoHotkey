;MicMute.ahk
; Toggles the microphone's input volume between 0% and 100%
;Skrommel @ 2005


#NoTrayIcon
SoundGet,micvol,Microphone:2,Volume
If micvol=0
{
  ToolTip,Mic is On
  If 0=0
    SoundSet,100,Microphone:2,Volume
  Else
    SoundSet,%1%,Microphone:2,Volume
}
Else
{
  ToolTip,Mic is Off
  SoundSet,0,Microphone:2,Volume
}
Sleep,2000
ExitApp

