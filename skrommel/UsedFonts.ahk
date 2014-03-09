;UsedFonts.ahk
; Show what fonts a Microsoft Word file uses
;Skrommel @2006

#NoEnv
SetBatchLines,-1

If 1=
{
  FileSelectFile,filename,3,, UsedFonts - 1 Hour Software - www.1HourSoftware.com,*.doc
  If filename=
    Return
}
Else
  filname=%1%

found=0
fonts=
data=
Loop
{
  offset:=A_Index
  
  moredata=%data%
  res:=BinRead(filename,data,128,128*(offset-1)) 
  
  If res=0 
    Break

  If found<1
  {
    moredata=%moredata%%data%
    IfInString,data,Times New Roman
    {
      found=1
      fonts=%data%
    }
    Else
    IfInString,moredata,Times New Roman
    {
      found=1
      fonts=%moredata%
    }
    If found=1
    {
      StringGetPos,pos,fonts,Times New Roman
      StringTrimLeft,fonts,fonts,%pos%
      Continue
    }
  }

  If found>0
  {
    found+=1
    fonts=%fonts%%data%
  }

  If found>20
    Break
}

space=0
clean=
Loop,Parse,fonts
{
  ascii:=Asc(A_LoopField)
  If ((ascii>=65 And ascii<=90) Or (ascii>=97 ANd ascii<=122)) ; Or (ascii>=48 And ascii<=57)) 
  {
    clean:=clean . A_LoopField
    space=0
  }
  Else
  If (ascii=32)
  {
    clean:=clean . A_LoopField
    space+=1
  }
  Else
  {
    If space=0
      clean=%clean%`n
    space+=1
  }
  
  If space>17
    Break
}

fonts=
Loop,Parse,clean,`n
{
  If (StrLen(A_LoopField)>2)
    fonts=%fonts%%A_LoopField%`n
}

MsgBox,0,UsedFonts - 1 Hour Software,%fonts%`nwww.1HourSoftware.com
ExitApp


; By Laszlo at http://www.autohotkey.com/forum/topic4546.html
/* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BinRead ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
|  - Open binary file 
|  - Read n bytes (n = 0: all) 
|  - From offset (offset < 0: counted from end) 
|  - Close file 
|  data (replaced) <- file[offset + 0..n-1] 
|  Return #bytes actually read 
*/ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

BinRead(file, ByRef data, n=0, offset=0) 
{ 
   h := DllCall("CreateFile","Str",file,"Uint",0x80000000,"Uint",3,"UInt",0,"UInt",3,"Uint",0,"UInt",0) 
   IfEqual h,-1, SetEnv, ErrorLevel, -1 
   IfNotEqual ErrorLevel,0,Return,0 ; couldn't open the file 

   m = 0                            ; seek to offset 
   IfLess offset,0, SetEnv,m,2 
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m) 
   IfEqual r,0, SetEnv, ErrorLevel, -3 
   IfNotEqual ErrorLevel,0, { 
      t = %ErrorLevel%              ; save ErrorLevel to be returned 
      DllCall("CloseHandle", "Uint", h) 
      ErrorLevel = %t%              ; return seek error 
      Return 0 
   } 

   TotalRead = 0 
   data = 
   IfEqual n,0, SetEnv n,0xffffffff ; almost infinite 

   format = %A_FormatInteger%       ; save original integer format 
   SetFormat Integer, Hex           ; for converting bytes to hex 

   Loop %n% 
   { 
      result := DllCall("ReadFile","UInt",h,"UChar *",c,"UInt",1,"UInt *",Read,"UInt",0) 
      if (!result or Read < 1 or ErrorLevel) 
         break 
      TotalRead += Read             ; count read 
;      c += 0                        ; convert to hex 
;      StringTrimLeft c, c, 2        ; remove 0x 
;      c = 0%c%                      ; pad left with 0 
;      StringRight c, c, 2           ; always 2 digits 
      c:=Chr(c)
      data:=data . c              ; append 2 hex digits 
   } 

   IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel% 

   h := DllCall("CloseHandle", "Uint", h) 
   IfEqual h,-1, SetEnv, ErrorLevel, -2 
   IfNotEqual t,,SetEnv, ErrorLevel, %t% 

   SetFormat Integer, %format%      ; restore original format 
   Totalread += 0                   ; convert to original format 
   Return TotalRead 
}
