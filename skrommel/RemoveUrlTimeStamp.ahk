;RemoveUrlTimeStamp.ahk
; Remove prefixed creation date from favorites.
;Skrommel @2006

folder=%1%
If 0=0
{
  RegRead,favorites,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Favorites
  FileSelectFolder,folder,%favorites%,3,Select folder with favorites to prefix with creation date 
}

Loop,%folder%\*.url,0,1
{
  StringLeft,left,A_LoopFileName,15
  count=0
  Loop,Parse,left
  {
    char:=A_LoopField
    If char In 0,1,2,3,4,5,6,7,8,9
      count+=1
  }
  If (count=14 And char=" ")
  {
    StringTrimLeft,filename,A_LoopFileName,15
    FileMove,%A_LoopFileFullPath%,%A_LoopFileDir%\%filename%
  }
}  