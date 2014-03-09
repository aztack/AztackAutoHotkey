;IpUpload.ahk
; Upload current IP address to an FTP server.
;
; Add the tags <ipaddress>, <time>, <username> or <computername> to the file to upload.
;  These tags are replaced with the current values. 
;
; Command line: IpUpload.exe <options>
;  -s <server>            IP address of FTP server 
;  -port <port>           Port of the FTP server
;  -l <local path>        Path of file to upload 
;  -r <remote path>       Folder on FTP server 
;  -u <user name>         User name 
;  -p <password>          Password 
;  -nic <network adaptor> What network adaptor to use, 1 to 4, 0=external IP retrieved from showmyip.com.  
;  -pause <minutes>       Time to wait between uploads, 0 exist 
;  -hide Hides the tray icon. 
; Example: IpUpload.exe -s ftp.server.com -port 21 -l "c:\folder1\file.htm" -r "/folder2" -u "user" -p "password" -nic 0 -pause 5 -hide 
;
;Skrommel @2006


#SingleInstance,Force
#NoTrayIcon
#NoEnv

applicationname=IpUpload

If 0=0
{
  Gosub,EXTERNALIP
  Gosub,TRAYMENU
  Gosub,ABOUT
  Return
}

nic=0
hide=
pause=0
proxy=
Loop,%0%
{
  current:=A_Index
  next:=A_Index+1

  If A_Index=-s
    server:=next
  Else
  If A_Index=-l
    local:=next
  Else
  If A_Index=-r
    remote:=next
  Else
  If A_Index=-u
    user:=next
  Else
  If A_Index=-p
    password:=next
  Else
  If A_Index=-nic
    nic:=next
  Else
  If A_Index=-pause
    pause:=next*1000*60
  Else
  If A_Index=-hide
    hide:=Hide
}

If hide=
  Gosub,TRAYMENU
If pause<1
  ExitApp

SplitPath,remote,remotefile,remotedir
Gosub,UPLOADIP
SetTimer,UPLOADIP,%pause%
Return


UPLOADIP:
If nic=0
  Gosub,EXTERNALIP
Else
{
  ipaddress:="A_IPAddress" . nic
  ipaddress:=%ipaddress%
}
Menu,Tray,Tip,%applicationname% - %ipaddress%
FileRead,file,%from%
StringReplace,file,file,<ipaddress>,%ipaddress%,All
StringReplace,file,file,<time>,%A_Now%,All
StringReplace,file,file,<username>,%A_UserName%,All
StringReplace,file,file,<computername>,%A_ComputerName%,All
FileDelete,upload\%to%
FileCreateDir,upload
FileAppend,%file%,upload\%to%

FtpOpen(server,port,user,password)
FtpSetCurrentDirectory(remotedir)
FtpPutFile(local,remotefile) 
FtpClose()
Return


EXTERNALIP:
URLDownloadToFile,http://www.showmyip.com,ipaddress.txt
FileReadLine,ipaddress,ipaddress.txt,1
ipaddress:=RegExReplace(ipaddress,"[^0-9.]","")
StringLeft,char,ipaddress,1
If char=.
  StringTrimLeft,ipaddress,ipaddress,1
StringRight,char,ipaddress,1
If char=.
  StringTrimRight,ipaddress,ipaddress,1
Return


SHOWIP:
Gui,Destroy
Gui,Add,Text,,IP address:
Gui,Add,Edit,x+5,%ipaddress%
Gui,Show,,IpUpload - 1 Hour Software
Return


TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Update IP,UPLOADIP
Menu,Tray,Add,&Show IP...,SHOWIP
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Menu,Tray,Icon
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v2.0
Gui,99:Font
Gui,99:Add,Text,y+10,Upload current IP address to an FTP server.
Gui,99:Add,Text,y+10,Add the tags <ipaddress>, <time>, <username> or <computername> to the file to upload.
Gui,99:Add,Text,y+10,Command line: IpUpload.exe <options>
Gui,99:Add,Text,y+10,%A_Space% -s <server>`t`t IP address of FTP server
Gui,99:Add,Text,y+0,%A_Space% -port <port>`t`t Port of the FTP server
Gui,99:Add,Text,y+0,%A_Space% -l <local path>`t`t Path of file to upload
Gui,99:Add,Text,y+0,%A_Space% -r <remote path>`t Folder on FTP server
Gui,99:Add,Text,y+0,%A_Space% -u <user name>`t`t User name
Gui,99:Add,Text,y+0,%A_Space% -p <password>`t`t Password
Gui,99:Add,Text,y+0,%A_Space% -nic <network adaptor>`t What network adaptor to use, 1 to 4, 0=external IP retrieved from showmyip.com
Gui,99:Add,Text,y+0,%A_Space% -pause <minutes>`t Time to wait between uploads, 0=exit
Gui,99:Add,Text,y+0,%A_Space% -hide`t`t`t Hides the tray icon
Gui,99:Add,Text,y+10,Example: IpUpload.exe -s ftp.server.com -post 21 -l "c:\folder1\file.htm" -r "/folder2" -u user -p password -nic 0 -pause 5 -hide

Gui,99:Add,Picture,xm y+20 Icon5,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,99:Font
Gui,99:Add,Text,y+10,For more tools, information and donations, please visit 
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon7,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,DonationCoder
Gui,99:Font
Gui,99:Add,Text,y+10,Please support the contributors at
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,AutoHotkey
Gui,99:Font
Gui,99:Add,Text,y+10,This tool was made using the powerful
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,99:Font

Gui,99:Show,,%applicationname% About
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

1HOURSOFTWARE:
  Run,http://www.1hoursoftware.com,,UseErrorLevel
Return

DONATIONCODER:
  Run,http://www.donationcoder.com,,UseErrorLevel
Return

AUTOHOTKEY:
  Run,http://www.autohotkey.com,,UseErrorLevel
Return

99GuiClose:
  Gui,99:Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static9,Static13,Static17
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return

EXIT:
ExitAPP


;Stolen from olfen at http://www.autohotkey.com/forum/topic10393.html

FtpCreateDirectory(DirName) { 
global ic_hInternet 
r := DllCall("wininet\FtpCreateDirectoryA", "uint", ic_hInternet, "str", DirName) 
If (ErrorLevel != 0 or r = 0) 
return 0 
else 
return 1 
} 

FtpRemoveDirectory(DirName) { 
global ic_hInternet 
r := DllCall("wininet\FtpRemoveDirectoryA", "uint", ic_hInternet, "str", DirName) 
If (ErrorLevel != 0 or r = 0) 
return 0 
else 
return 1 
} 

FtpSetCurrentDirectory(DirName) { 
global ic_hInternet 
r := DllCall("wininet\FtpSetCurrentDirectoryA", "uint", ic_hInternet, "str", DirName) 
If (ErrorLevel != 0 or r = 0) 
return 0 
else 
return 1 
} 

FtpPutFile(LocalFile, NewRemoteFile="", Flags=0) { 
;Flags: 
;FTP_TRANSFER_TYPE_UNKNOWN = 0 (Defaults to FTP_TRANSFER_TYPE_BINARY) 
;FTP_TRANSFER_TYPE_ASCII = 1 
;FTP_TRANSFER_TYPE_BINARY = 2 
If NewRemoteFile= 
NewRemoteFile := LocalFile 
global ic_hInternet 
r := DllCall("wininet\FtpPutFileA" 
, "uint", ic_hInternet 
, "str", LocalFile 
, "str", NewRemoteFile 
, "uint", Flags 
, "uint", 0) ;dwContext 
If (ErrorLevel != 0 or r = 0) 
return 0 
else 
return 1 
} 

FtpGetFile(RemoteFile, NewFile="", Flags=0) { 
;Flags: 
;FTP_TRANSFER_TYPE_UNKNOWN = 0 (Defaults to FTP_TRANSFER_TYPE_BINARY) 
;FTP_TRANSFER_TYPE_ASCII = 1 
;FTP_TRANSFER_TYPE_BINARY = 2 
If NewFile= 
NewFile := RemoteFile 
global ic_hInternet 
r := DllCall("wininet\FtpGetFileA" 
, "uint", ic_hInternet 
, "str", RemoteFile 
, "str", NewFile 
, "int", 1 ;do not overwrite existing files 
, "uint", 0 ;dwFlagsAndAttributes 
, "uint", Flags 
, "uint", 0) ;dwContext 
If (ErrorLevel != 0 or r = 0) 
return 0 
else 
return 1 
} 

FtpGetFileSize(FileName, Flags=0) { 
;Flags: 
;FTP_TRANSFER_TYPE_UNKNOWN = 0 (Defaults to FTP_TRANSFER_TYPE_BINARY) 
;FTP_TRANSFER_TYPE_ASCII = 1 
;FTP_TRANSFER_TYPE_BINARY = 2 
global ic_hInternet 
fof_hInternet := DllCall("wininet\FtpOpenFileA" 
, "uint", ic_hInternet 
, "str", FileName 
, "uint", 0x80000000 ;dwAccess: GENERIC_READ 
, "uint", Flags 
, "uint", 0) ;dwContext 
If (ErrorLevel != 0 or fof_hInternet = 0) 
return -1 

FileSize := DllCall("wininet\FtpGetFileSize", "uint", fof_hInternet, "uint", 0) 
DllCall("wininet\InternetCloseHandle",  "UInt", fof_hInternet) 
return, FileSize 
} 

FtpDeleteFile(FileName) { 
global ic_hInternet 
r :=  DllCall("wininet\FtpDeleteFileA", "uint", ic_hInternet, "str", FileName) 
If (ErrorLevel != 0 or r = 0) 
return 0 
else 
return 1 
} 

FtpRenameFile(Existing, New) { 
global ic_hInternet 
r := DllCall("wininet\FtpRenameFileA", "uint", ic_hInternet, "str", Existing, "str", New) 
If (ErrorLevel != 0 or r = 0) 
return 0 
else 
return 1 
} 

FtpOpen(Server, Port=21, Username=0, Password=0 ,Proxy="", ProxyBypass="") { 
IfEqual, Username, 0, SetEnv, Username, anonymous 
IfEqual, Password, 0, SetEnv, Password, anonymous 

If (Proxy != "") 
AccessType=3 
Else 
AccessType=1 
;#define INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration 
;#define INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net 
;#define INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy 
;#define INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS 

global ic_hInternet, io_hInternet, hModule 
hModule := DllCall("LoadLibrary", "str", "wininet.dll") 

io_hInternet := DllCall("wininet\InternetOpenA" 
, "str", A_ScriptName ;lpszAgent 
, "UInt", AccessType 
, "str", Proxy 
, "str", ProxyBypass 
, "UInt", 0) ;dwFlags 

If (ErrorLevel != 0 or io_hInternet = 0) { 
FtpClose() 
return 0 
} 

ic_hInternet := DllCall("wininet\InternetConnectA" 
, "uint", io_hInternet 
, "str", Server 
, "uint", Port 
, "str", Username 
, "str", Password 
, "uint" , 1 ;dwService (INTERNET_SERVICE_FTP = 1) 
, "uint", 0 ;dwFlags 
, "uint", 0) ;dwContext 

If (ErrorLevel != 0 or ic_hInternet = 0) 
return 0 
else 
return 1 
} 

FtpClose() { 
global ic_hInternet, io_hInternet, hModule 
DllCall("wininet\InternetCloseHandle",  "UInt", ic_hInternet) 
DllCall("wininet\InternetCloseHandle",  "UInt", io_hInternet) 
DllCall("FreeLibrary", "UInt", hModule) 
} 
