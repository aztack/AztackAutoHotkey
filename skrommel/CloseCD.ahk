;CloseCD.ahk
; Closes all CD trays
; To only close some trays, add the drives to close to the command line.
;  Example: CloseCD.exe DEF
;Skrommel @2006

list=%1%
If 0=0
  DriveGet,list,List,CDROM

Loop,Parse,list
  Drive,Eject,%A_LoopField%:,1
