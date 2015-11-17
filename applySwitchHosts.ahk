#Persistent
DetectHiddenWindows, On

SetTimer, ClickApplyButtonOnSwitchHosts, 360000
return

ClickApplyButtonOnSwitchHosts:
ControlClick,Button5,,&Apply,LEFT,1,
return