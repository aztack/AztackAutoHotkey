Toggle_HiddenFiles_Display(){
  RootKey = HKEY_CURRENT_USER
  SubKey  = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced

  RegRead, HiddenFiles_Status, % RootKey, % SubKey, Hidden

  if HiddenFiles_Status = 2
      RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 1 
  else 
      RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 2
  PostMessage, 0x111, 41504,,, ahk_id %ID%
}

;copy path from explorer
#IfWinActive ahk_class CabinetWClass
	^!c::
		dir := Explorer_GetPath()
		Run, cmd /k cd /d "%dir%"
	Return
	
	;save clipboard to txt
	^+v::
		dir := Explorer_GetPath()
		path = %dir%\clipboard_%A_NOW%.txt
		MsgBox,0,0,%path%
		text = %ClipBoard%
		ClipBoard = %text% ; Convert to text
		FileAppend, %Clipboard%,%path%
	Return
	
	;copy path of selected 
	#c::
		Clipboard := Explorer_GetSelected()
	Return
	
	~Alt & WheelUp::
	SendInput {Alt down}{Up} {Alt up}
	return
	
	~Alt & WheelDown::
	SendInput {Alt down}{Left} {Alt up}
	return
	
	^h::
		Toggle_HiddenFiles_Display()
		SendInput {F5}
	return
	
#IfWinActive