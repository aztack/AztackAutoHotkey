;AddUrlTimeStamp.ahk
; Prefix favorites with creation date.
;Skrommel @2006

folder=%1%
If 0=0
{
  RegRead,favorites,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Favorites
  FileSelectFolder,folder,%favorites%,3,Select folder with favorites to prefix with creation date 
  StringLen,favoriteslength,favorites
}

RegRead,links,HKEY_CURRENT_USER,Software\Microsoft\Internet Explorer\Toolbar,LinksFolderName

Loop,%folder%\*.url,0,1
{
  StringLeft,left,A_LoopFileName,15
  count=0
  Loop,Parse,left
  {
    char:=A_LoopField
    If char In 0,1,2,3,4,5,6,7,8,9
      count+=1
    Else
      Break
  }
  path=%A_LoopFileDir%\
  StringGetPos,linkspos,path,\%links%\
  StringLeft,left,A_LoopFileName,1

  If (left<>"+")
  If (linkspos<>favoriteslength)
  If (count<>14 Or char<>" ")
    FileMove,%A_LoopFileFullPath%,%A_LoopFileDir%\%A_LoopFileTimeModified% %A_LoopFileName%
}  