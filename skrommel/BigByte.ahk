;BigByte.ahk
; Create accurately sized files.
;Skrommel @2005

#SingleInstance,Force
#NoTrayIcon
SetBatchLines,-1

Gui,Add,Text,,Filename
Gui,Add,Edit,vfilename w200,BigByte
Gui,Add,Text,Section,Size
Gui,Add,Edit,vfilesize w95,100
Gui,Add,Text,ys,B/KB/MB/GB/TB
Gui,Add,DropDownList,vbyte w95,Byte||KiloByte|MegaByte|GigaByte|TerraByte
Gui,Add,Text,xm,ASCII/Binary
Gui,Add,DropDownList,vfiletype w200,Binary||ASCII
Gui,Add,Text,xm,
Gui,Add,Text,xm vstatus,Please input values and press Create
Gui,Add,Text,xm,
Gui,Add,Button,ys ym+20 gCREATE vcreate,Create
Gui,Show,xCenter yCenter,BigByte by www.1HourSoftware.com
Return

CREATE:
Gui,Submit,NoHide
If filename=
{
  GuiControl,,status,Empty filename!
  Return
}

If filesize=
{
  GuiControl,,status,Empty size!
  Return
}

If filesize<1
{
  GuiControl,,status,Too small!
  Return
}

size:=filesize
If byte=KiloByte
  size:=size*1024
If byte=MegaByte
  size:=size*1024*1024
If byte=GigaByte
  size:=size*1024*1024*1024
If byte=TerraByte
  size:=size*1024*1024*1024*1024

GuiControl,Disable,create,
GuiControl,,status,Creating file...

If filetype=ASCII
{
  size-=1
  type=a
  Gosub,CREATEASCII
}
Else
{
  type=b
  Gosub,CREATEBINARY
}

goal=%size%
oldcounter=0
counter=1
string=
Loop
{
  If(counter>goal)
    Break
  RunWait,cmd /c copy /y /%type% %oldcounter% + %oldcounter% %counter%,,Hide
  oldcounter:=counter
  counter:=counter*2
  GuiControl,,status,Creating file %counter%...
}
  
sum=0
Loop
{
  counter/=2
  If(goal-counter<0)
    Continue
  If(goal-counter=0)
    Break
  goal-=%counter%
  string=%string% %counter% +
  sum+=%counter%
  GuiControl,,status,Creating file %counter%...
}
string=%string% %counter%
sum+=%counter%
RunWait,cmd /c copy /y /%type% %string% %filename%,,Hide

goal=%size%
counter=1
Loop
{
  If(counter>=goal)
    Break
  RunWait,cmd /c del %counter%,,Hide
  counter:=counter*2
}

GuiControl,,status,%filesize% %byte% %kind% %filename% created
GuiControl,Enable,create,
MsgBox,0,BigByte,%filesize% %byte% %kind% %filename% created
GuiControl,,status,Please input values and press Create
Return


CREATEASCII:
FileDelete,1
FileAppend,0,1
If ErrorLevel=1
{
  MsgBox,Error creating file! 
  GuiControl,Enable,create,
  Return
}
Return


CREATEBINARY:
hFile:=DllCall("CreateFile","str","1","Uint",0x40000000,"Uint",0,"UInt",0,"UInt",2,"Uint",0,"UInt",0)
If (ErrorLevel or hFile=-1)
{
  MsgBox,Error creating file!
  Return
}
result:=DllCall("WriteFile","UInt",hFile,"UChar *",0,"UInt",1,"UInt *",BytesActuallyWritten,"UInt",0)
If (!result or ErrorLevel)
{
  MsgBox,Error creating file!
  Return
}
result:=DllCall("CloseHandle","Uint",hFile)
If (!result or ErrorLevel)
{
  MsgBox,Error creating file!
  GuiControl,Enable,create,
  Return
}
Return

GuiClose:
ExitApp