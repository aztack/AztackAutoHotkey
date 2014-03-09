;RunScreenSaver.ahk
; Runs the screensaver
;Skrommel @ 2006

#NoTrayIcon
RegRead,screensaver,HKEY_CURRENT_USER,Control Panel\Desktop,ScrnSave.Exe
IfInString,screensaver,.scr
  Run,%screensaver% /s
Else
  Run,rundll32.exe desk.cpl`,InstallScreenSaver %screensaver%
