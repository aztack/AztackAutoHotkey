Gui, Add, Button, x26 y10 w100 h30 Gon , PAC On
Gui, Add, Button, x26 y50 w100 h30 Goff , PAC Off
Gui, Show, x129 y99 h86 w154, Proxy Toggler
Return


on:
setproxy("ON")
ExitApp
return


off:
setproxy("OFF")
ExitApp
return


setproxy(state="")
{ 
if(state = "")
state = "ON"
if (state ="ON")
RegWrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,AutoConfigURL,file://d:/prog/uc5ncfw.pac
   else if (state="OFF")
RegDelete,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,AutoConfigURL


   dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
   dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
   Return
}
;----------------------------------------------------------
; Function RegRead
;----------------------------------------------------------
RegRead(RootKey, SubKey, ValueName = "") {
   RegRead, v, %RootKey%, %SubKey%, %ValueName%
   Return, v
}


GuiClose:
ExitApp