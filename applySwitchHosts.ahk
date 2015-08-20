#Persistent

SetTimer, ClickApplyButtonOnSwitchHosts, 30000
return

ClickApplyButtonOnSwitchHosts:
DetectHiddenWindows, On
ControlClick,Button5,,&Apply,LEFT,1,
return