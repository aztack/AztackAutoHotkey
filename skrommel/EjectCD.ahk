;EjectCD.ahk
; Ejects all CD drives, or add the drives to eject to the command line.
;  Example: EjectCD.exe DEF
;Skrommel @2006

list=%1%
If 0=0
  DriveGet,list,List,CDROM

Loop,Parse,list
  Drive,Eject,%A_LoopField%:
