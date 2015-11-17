setproxy(state = "Toggle"){

if (state ="ON" or state = 1)
regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
  else if (state="OFF" or state = 0)
    regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
  else if (state = "TOGGLE")
  {
      if ( regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1 ) 
	  {
		TrayTip,,Inside GFW, 2, 17
        regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
	  } else if (regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0 ) 
	  {
		TrayTip,,Outside GFW, 2, 17
        regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
		regwrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer,http=127.0.0.1:1080;https=127.0.0.1:1080;socks=127.0.0.1:1080
	  }
  }
  dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
  dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
  Return
}

RegRead(RootKey, SubKey, ValueName = "") {
   RegRead, v, %RootKey%, %SubKey%, %ValueName%
   Return, v
}
setproxy()

Sleep, 2000