;RunToClose.ahk
; DoubleClicking a file in Explorer closes Explorer afterwards
;Skrommel @ 2009

#NoEnv
#SingleInstance,Force
SetBatchLines,-1
SetWinDelay,0
SendMode,Input

applicationname=RunToClose

SysGet,xdoubleclick,36
SysGet,ydoubleclick,37  
tdoubleclick:=DllCall("GetDoubleClickTime") 
Gosub,TRAYMENU
Return


~LButton::
Return


~LButton Up::
mx1:=mx
my1:=my
mwin1:=mwin
mctrl1:=mctrl
MouseGetPos,mx,my,mwin,mctrl
now1:=now
now:=A_TickCount

fullpath1:=fullpath
WinGetClass,class,ahk_id %mwin%
If class In Progman,WorkerW
{
  ControlGet,list,List,Selected,SysListView321,ahk_id %mwin%
  Loop,Parse,list,%A_Tab%
  {
    filename:=A_LoopField
    Break
  }
  RegRead,path,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Desktop
  fullpath:=path "\" filename
}
Else
If class In ExploreWClass,CabinetWClass
{
  fullpath:=ShellFolder(mwin)
  StringRight,last,fullpath,1
}
If (now1>=now-tdoubleclick And fullpath=fullpath1) ;And mx1>=mx-xdoubleclick And mx1<=mx+xdoubleclick And my1>=my-ydoubleclick And my1<=my+ydoubleclick And mwin1=mwin And mctrl1=mctrl)
  Gosub,DOUBLECLICK
Return


DOUBLECLICK:
If class In ExploreWClass,CabinetWClass
If last<>\
If mctrl In SysListView321
  WinClose,ahk_id %mwin1%
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


EXIT:
ExitApp


ABOUT:
Gui,2:Destroy
Gui,2:Add,Picture,Icon1,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,2:Font
Gui,2:Add,Text,xm,DoubleClicking a file in Explorer closes Explorer afterwards
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon2,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,2:Font
Gui,2:Add,Text,xm,For more tools, information and donations, visit
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm G1HOURSOFTWARE,www.1HourSoftware.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon5,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,DonationCoder
Gui,2:Font
Gui,2:Add,Text,xm,Please support the DonationCoder community
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm GDONATIONCODER,www.DonationCoder.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Picture,xm Icon6,%applicationname%.exe
Gui,2:Font,Bold
Gui,2:Add,Text,x+10 yp+10,AutoHotkey
Gui,2:Font
Gui,2:Add,Text,xm,This program was made using AutoHotkey
Gui,2:Font,CBlue Underline
Gui,2:Add,Text,xm GAUTOHOTKEY,www.AutoHotkey.com
Gui,2:Font
Gui,2:Add,Text,y+0,`t
Gui,2:Add,Text,y+0,`t

Gui,2:Add,Button,GABOUTOK Default w75,&OK
Gui,2:Show,,%applicationname% About

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


ABOUTOK:
Gui,2:Destroy
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCurs)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static8,Static13,Static18
    DllCall("SetCursor","UInt",hCurs)
  Return
}



;Stolen from SEAN at http://www.autohotkey.com/forum/viewtopic.php?p=132365#132365
ShellFolder(hWnd=0) 
{ 
   If   hWnd||(hWnd:=WinExist("ahk_class CabinetWClass"))||(hWnd:=WinExist("ahk_class ExploreWClass")) 
   { 
      COM_Init() 
      psh  :=   COM_CreateObject("Shell.Application") 
      psw  :=   COM_Invoke(psh, "Windows") 
      Loop, %   COM_Invoke(psw, "Count") 
         If   COM_Invoke(pwb:=COM_Invoke(psw, "Item", A_Index-1), "hWnd") <> hWnd 
            COM_Release(pwb) 
         Else   Break 
      pfv  :=   COM_Invoke(pwb, "Document") 
      sFolder   := COM_Invoke(pfi:=COM_Invoke(psf:=COM_Invoke(pfv, "Folder"), "Self"), "Path"), COM_Release(psf), COM_Release(pfi), pfi:=0 
      sFocus   := COM_Invoke(pfi:=COM_Invoke(pfv, "FocusedItem"), "Name"), COM_Release(pfi), pfi:=0 
      Loop, %   COM_Invoke(psi:=COM_Invoke(pfv, "SelectedItems"), "Count") 
         sSelect   .= COM_Invoke(pfi:=COM_Invoke(psi, "Item", A_Index-1), "Name") . "`n", COM_Release(pfi), pfi:=0 
      COM_Release(psi) 
      COM_Release(pfv) 
      COM_Release(pwb) 
      COM_Release(psw) 
      COM_Release(psh) 
      COM_Term() 
;      Return   "Folder:`t" . sFolder . "`nFocus:`t" . sFocus . "`n<Selected Items>`n" . sSelect 
      Return   sFolder "\" sSelect 
   } 
} 


;------------------------------------------------------------------------------
; COM.ahk Standard Library
; by Sean
; http://www.autohotkey.com/forum/topic22923.html
;------------------------------------------------------------------------------

COM_Init()
{
	Return	DllCall("ole32\OleInitialize", "Uint", 0)
}

COM_Term()
{
	Return	DllCall("ole32\OleUninitialize")
}

COM_VTable(ppv, idx)
{
	Return	NumGet(NumGet(1*ppv)+4*idx)
}

COM_QueryInterface(ppv, IID = "")
{
	If	DllCall(NumGet(NumGet(1*ppv)+0), "Uint", ppv, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)=0
	Return	ppv
}

COM_AddRef(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+4), "Uint", ppv)
}

COM_Release(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+8), "Uint", ppv)
}

COM_QueryService(ppv, SID, IID = "")
{
	DllCall(NumGet(NumGet(1*ppv)+4*0), "Uint", ppv, "Uint", COM_GUID4String(IID_IServiceProvider,"{6D5140C1-7436-11CE-8034-00AA006009FA}"), "UintP", psp)
	DllCall(NumGet(NumGet(1*psp)+4*3), "Uint", psp, "Uint", COM_GUID4String(SID,SID), "Uint", IID ? COM_GUID4String(IID,IID) : &SID, "UintP", ppv:=0)
	DllCall(NumGet(NumGet(1*psp)+4*2), "Uint", psp)
	Return	ppv
}

COM_FindConnectionPoint(pdp, DIID)
{
	DllCall(NumGet(NumGet(1*pdp)+ 0), "Uint", pdp, "Uint", COM_GUID4String(IID_IConnectionPointContainer, "{B196B284-BAB4-101A-B69C-00AA00341D07}"), "UintP", pcc)
	DllCall(NumGet(NumGet(1*pcc)+16), "Uint", pcc, "Uint", COM_GUID4String(DIID,DIID), "UintP", pcp)
	DllCall(NumGet(NumGet(1*pcc)+ 8), "Uint", pcc)
	Return	pcp
}

COM_GetConnectionInterface(pcp)
{
	VarSetCapacity(DIID, 16, 0)
	DllCall(NumGet(NumGet(1*pcp)+12), "Uint", pcp, "Uint", &DIID)
	Return	COM_String4GUID(&DIID)
}

COM_Advise(pcp, psink)
{
	DllCall(NumGet(NumGet(1*pcp)+20), "Uint", pcp, "Uint", psink, "UintP", nCookie)
	Return	nCookie
}

COM_Unadvise(pcp, nCookie)
{
	Return	DllCall(NumGet(NumGet(1*pcp)+24), "Uint", pcp, "Uint", nCookie)
}

COM_Enumerate(penum, ByRef Result, ByRef vt = "")
{
	VarSetCapacity(varResult,16,0)
	If (0 =	hr:=DllCall(NumGet(NumGet(1*penum)+12), "Uint", penum, "Uint", 1, "Uint", &varResult, "UintP", 0))
		Result:=(vt:=NumGet(varResult,0,"Ushort"))=8||vt<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr) : NumGet(varResult,8)
	Return	hr
}

COM_Invoke(pdisp, sName, arg0="vT_NoNe",arg1="vT_NoNe",arg2="vT_NoNe",arg3="vT_NoNe",arg4="vT_NoNe",arg5="vT_NoNe",arg6="vT_NoNe",arg7="vT_NoNe",arg8="vT_NoNe",arg9="vT_NoNe")
{
	sParams	:= 0123456789
	Loop,	Parse,	sParams
		If	(arg%A_LoopField% == "vT_NoNe")
		{
			sParams	:= SubStr(sParams,1,A_Index-1)
			Break
		}
	VarSetCapacity(varg,16*nParams:=StrLen(sParams),0), VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,32,0), VarSetCapacity(ExcepInfo,32,0)
	Loop, 	Parse,	sParams
		If	arg%A_LoopField% Is Not Integer
         		NumPut(8,varg,(nParams-A_Index)*16,"Ushort"), NumPut(COM_SysAllocString(arg%A_LoopField%),varg,(nParams-A_Index)*16+8)
		Else	NumPut(SubStr(arg%A_LoopField%,1,1)="+" ? 9 : 3,varg,(nParams-A_Index)*16,"Ushort"), NumPut(arg%A_LoopField%,varg,(nParams-A_Index)*16+8)
	If	(nFlags:=SubStr(sName,0)<>"=" ? 3 : 12)=12
		sName:=SubStr(sName,1,-1), NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4)+4)
	If	(hr:=DllCall(NumGet(NumGet(1*pdisp)+20),"Uint",pdisp,"Uint",&varResult+16,"UintP",COM_Unicode4Ansi(wName,sName),"Uint",1,"Uint",LCID,"intP",dispID,"Uint"))=0&&(hr:=DllCall(NumGet(NumGet(1*pdisp)+24),"Uint",pdisp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nFlags,"Uint",NumPut(nParams,NumPut(&varg,DispParams)+4)-12,"Uint",&varResult,"Uint",&ExcepInfo,"Uint",0,"Uint"))<>0&&nFlags=3&&(lr:=DllCall(NumGet(NumGet(1*pdisp)+24),"Uint",pdisp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nFlags:=12,"Uint",NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4)+4)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0
		hr:=0
	Loop, %	nParams
		NumGet(varg,(A_Index-1)*16,"Ushort")=8 ? COM_SysFreeString(NumGet(varg,(A_Index-1)*16+8)) : ""
	Global	COM_VT
	Return	hr=0 ? nFlags=3 ? (COM_VT:=NumGet(varResult,0,"Ushort"))=8||COM_VT<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr) : NumGet(varResult,8) : 0 : COM_Error(hr,lr,&ExcepInfo,sName)
}

COM_Invoke_(pdisp, sName, type0="",arg0="",type1="",arg1="",type2="",arg2="",type3="",arg3="",type4="",arg4="",type5="",arg5="",type6="",arg6="",type7="",arg7="",type8="",arg8="",type9="",arg9="")
{
	sParams	:= 0123456789
	Loop,	Parse,	sParams
		If	(type%A_LoopField% = "")
		{
			sParams	:= SubStr(sParams,1,A_Index-1)
			Break
		}
	VarSetCapacity(varg,16*nParams:=StrLen(sParams),0), VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,32,0), VarSetCapacity(ExcepInfo,32,0)
	Loop,	Parse,	sParams
		NumPut(type%A_LoopField%,varg,(nParams-A_Index)*16,"Ushort"), type%A_LoopField%&0x4000=0 ? NumPut(type%A_LoopField%=8 ? COM_SysAllocString(arg%A_LoopField%) : arg%A_LoopField%,varg,(nParams-A_Index)*16+8,type%A_LoopField%=5||type%A_LoopField%=7 ? "double" : type%A_LoopField%=4 ? "float" : "int64") : type%A_LoopField%=0x400C||type%A_LoopField%=0x400E ? NumPut(arg%A_LoopField%,varg,(nParams-A_Index)*16+8) : VarSetCapacity(_ref_%A_LoopField%,8,0) . NumPut(&_ref_%A_LoopField%,varg,(nParams-A_Index)*16+8) . NumPut(type%A_LoopField%=0x4008 ? COM_SysAllocString(arg%A_LoopField%) : arg%A_LoopField%,_ref_%A_LoopField%,0,type%A_LoopField%=0x4005||type%A_LoopField%=0x4007 ? "double" : type%A_LoopField%=0x4004 ? "float" : "int64")
	If	(nFlags:=SubStr(sName,0)<>"=" ? 3 : 12)=12
		sName:=SubStr(sName,1,-1), NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4)+4)
	If	(hr:=DllCall(NumGet(NumGet(1*pdisp)+20),"Uint",pdisp,"Uint",&varResult+16,"UintP",COM_Unicode4Ansi(wName,sName),"Uint",1,"Uint",LCID,"intP",dispID,"Uint"))=0&&(hr:=DllCall(NumGet(NumGet(1*pdisp)+24),"Uint",pdisp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nFlags,"Uint",NumPut(nParams,NumPut(&varg,DispParams)+4)-12,"Uint",&varResult,"Uint",&ExcepInfo,"Uint",0,"Uint"))<>0&&nFlags=3&&(lr:=DllCall(NumGet(NumGet(1*pdisp)+24),"Uint",pdisp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nFlags:=12,"Uint",NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4)+4)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0
		hr:=0
	Loop,	Parse,	sParams
		type%A_LoopField%&0x4000=0 ? (type%A_LoopField%=8 ? COM_SysFreeString(NumGet(varg,(nParams-A_Index)*16+8)) : "") : type%A_LoopField%=0x400C||type%A_LoopField%=0x400E ? "" : type%A_LoopField%=0x4008 ? (COM_BYREF_%A_LoopField%:=COM_Ansi4Unicode(NumGet(_ref_%A_LoopField%))) . COM_SysFreeString(NumGet(_ref_%A_LoopField%)) : (COM_BYREF_%A_LoopField%:=NumGet(_ref_%A_LoopField%,0,type%A_LoopField%=0x4005||type%A_LoopField%=0x4007 ? "double" : type%A_LoopField%=0x4004 ? "float" : "int64"))
	Global	COM_VT
	Return	hr=0 ? nFlags=3 ? (COM_VT:=NumGet(varResult,0,"Ushort"))=8||COM_VT<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr) : NumGet(varResult,8) : 0 : COM_Error(hr,lr,&ExcepInfo,sName)
}

COM_DispInterface(this, prm1="", prm2="", prm3="", prm4="", prm5="", prm6="", prm7="", prm8="")
{
	Critical
	If	A_EventInfo = 6
		DllCall(NumGet(NumGet(NumGet(this+8))+28),"Uint",NumGet(this+8),"Uint",prm1,"UintP",pname,"Uint",1,"UintP",0), VarSetCapacity(sfn,63), DllCall("user32\wsprintfA","str",sfn,"str","%s%S","Uint",this+40,"Uint",pname,"Cdecl"), COM_SysFreeString(pname), (pfn:=RegisterCallback(sfn,"C F")) ? (hResult:=DllCall(pfn,"Uint",prm5,"Uint",this,"Uint",prm6,"Cdecl")) . DllCall("kernel32\GlobalFree","Uint",pfn) : (hResult:=0x80020003)
	Else If	A_EventInfo = 5
		hResult:=DllCall(NumGet(NumGet(NumGet(this+8))+40),"Uint",NumGet(this+8),"Uint",prm2,"Uint",prm3,"Uint",prm5)
	Else If	A_EventInfo = 4
		NumPut(0,prm3+0), hResult:=0x80004001
	Else If	A_EventInfo = 3
		NumPut(0,prm1+0), hResult:=0
	Else If	A_EventInfo = 2
		NumPut(hResult:=NumGet(this+4)-1,this+4), hResult ? "" : COM_DisconnectObject(this)
	Else If	A_EventInfo = 1
		NumPut(hResult:=NumGet(this+4)+1,this+4)
	Else If	A_EventInfo = 0
		COM_IsEqualGUID(this+24,prm1)||InStr("{00020400-0000-0000-C000-000000000046}{00000000-0000-0000-C000-000000000046}",COM_String4GUID(prm1)) ? NumPut(this,prm2+0) . NumPut(NumGet(this+4)+1,this+4) . (hResult:=0) : NumPut(0,prm2+0) . (hResult:=0x80004002)
	Return	hResult
}

COM_DispGetParam(pDispParams, Position = 0, vt = 8)
{
	VarSetCapacity(varResult,16,0)
	DllCall("oleaut32\DispGetParam", "Uint", pDispParams, "Uint", Position, "Ushort", vt, "Uint", &varResult, "UintP", nArgErr)
	Return	NumGet(varResult,0,"Ushort")=8 ? COM_Ansi4Unicode(NumGet(varResult,8)) . COM_SysFreeString(NumGet(varResult,8)) : NumGet(varResult,8)
}

COM_DispSetParam(val, pDispParams, Position = 0, vt = 8)
{
	Return	NumPut(vt=8 ? COM_SysAllocString(val) : val,NumGet(NumGet(pDispParams+0)+(NumGet(pDispParams+8)-Position)*16-8),0,vt=11||vt=2 ? "short" : "int")
}

COM_Error(hr = "", lr = "", pExcepInfo = "", sName = "")
{
  Return

	Static	bDebug:=1
	If Not	(sName="" ? 0*bDebug:=hr : bDebug)
	Return
	hr ? (VarSetCapacity(sError,1023),VarSetCapacity(nError,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",hr<>0x80020009 ? hr : (bExcep:=1)*(hr:=NumGet(pExcepInfo+28)) ? hr : hr:=NumGet(pExcepInfo+0,0,"Ushort")+0x80040200,"Uint",0,"str",sError,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError,"str","0x%08X","Uint",hr,"Cdecl")) : sError:="The COM Object may not be a valid one!`n", lr ? (VarSetCapacity(sError2,1023),VarSetCapacity(nError2,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",lr,"Uint",0,"str",sError2,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError2,"str","0x%08X","Uint",lr,"Cdecl")) : ""
	MsgBox, 260, COM Error Notification, % "Function Name:`t""" . sName . """`nERROR:`t" . sError . "`t(" . nError . ")" . (bExcep ? SubStr(NumGet(pExcepInfo+24) ? DllCall(NumGet(pExcepInfo+24),"Uint",pExcepInfo) : "",1,0) . "`nPROG:`t" . COM_Ansi4Unicode(NumGet(pExcepInfo+4)) . COM_SysFreeString(NumGet(pExcepInfo+4)) . "`nDESC:`t" . COM_Ansi4Unicode(NumGet(pExcepInfo+8)) . COM_SysFreeString(NumGet(pExcepInfo+8)) . "`nHELP:`t" . COM_Ansi4Unicode(NumGet(pExcepInfo+12)) . COM_SysFreeString(NumGet(pExcepInfo+12)) . "," . NumGet(pExcepInfo+16) : "") . (lr ? "`n`nERROR2:`t" . sError2 . "`t(" . nError2 . ")" : "") . "`n`nWill Continue?"
	IfMsgBox, No, Exit
}

COM_CreateIDispatch()
{
	Static	IDispatch
	If Not	VarSetCapacity(IDispatch)
	{
		VarSetCapacity(IDispatch,28,0),   nParams=3112469
		Loop,   Parse,   nParams
		NumPut(RegisterCallback("COM_DispInterface","",A_LoopField,A_Index-1),IDispatch,4*(A_Index-1))
	}
	Return &IDispatch
}

COM_GetDefaultInterface(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp) +12), "Uint", pdisp , "UintP", ctinf)
	If	ctinf
	{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	DllCall(NumGet(NumGet(1*pdisp)+ 0), "Uint", pdisp, "Uint" , pattr, "UintP", ppv)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	If	ppv
	DllCall(NumGet(NumGet(1*pdisp)+ 8), "Uint", pdisp),	pdisp := ppv
	}
	Return	pdisp
}

COM_GetDefaultEvents(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	VarSetCapacity(IID,16), DllCall("RtlMoveMemory", "Uint", &IID, "Uint", pattr, "Uint", 16)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Loop, %	DllCall(NumGet(NumGet(1*ptlib)+12), "Uint", ptlib)
	{
		DllCall(NumGet(NumGet(1*ptlib)+20), "Uint", ptlib, "Uint", A_Index-1, "UintP", TKind)
		If	TKind <> 5
			Continue
		DllCall(NumGet(NumGet(1*ptlib)+16), "Uint", ptlib, "Uint", A_Index-1, "UintP", ptinf)
		DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
		nCount:=NumGet(pattr+48,0,"Ushort")
		DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
		Loop, %	nCount
		{
			DllCall(NumGet(NumGet(1*ptinf)+36), "Uint", ptinf, "Uint", A_Index-1, "UintP", nFlags)
			If	!(nFlags & 1)
				Continue
			DllCall(NumGet(NumGet(1*ptinf)+32), "Uint", ptinf, "Uint", A_Index-1, "UintP", hRefType)
			DllCall(NumGet(NumGet(1*ptinf)+56), "Uint", ptinf, "Uint", hRefType , "UintP", prinf)
			DllCall(NumGet(NumGet(1*prinf)+12), "Uint", prinf, "UintP", pattr)
			nFlags & 2 ? DIID:=COM_String4GUID(pattr) : bFind:=COM_IsEqualGUID(pattr,&IID)
			DllCall(NumGet(NumGet(1*prinf)+76), "Uint", prinf, "Uint" , pattr)
			DllCall(NumGet(NumGet(1*prinf)+ 8), "Uint", prinf)
		}
		DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
		If	bFind
			Break
	}
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	bFind ? DIID : "{00000000-0000-0000-0000-000000000000}"
}

COM_GetGuidOfName(pdisp, Name, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf:=0
	DllCall(NumGet(NumGet(1*ptlib)+44), "Uint", ptlib, "Uint", COM_Unicode4Ansi(Name,Name), "Uint", 0, "UintP", ptinf, "UintP", memID, "UshortP", 1)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	GUID := COM_String4GUID(pattr)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Return	GUID
}

COM_GetTypeInfoOfGuid(pdisp, GUID, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf := 0
	DllCall(NumGet(NumGet(1*ptlib)+24), "Uint", ptlib, "Uint", COM_GUID4String(GUID,GUID), "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	ptinf
}

; A Function Name including Prefix is limited to 63 bytes!
COM_ConnectObject(psource, prefix = "", DIID = "")
{
	If Not	DIID
		0+(pconn:=COM_FindConnectionPoint(psource,"{00020400-0000-0000-C000-000000000046}")) ? (DIID:=COM_GetConnectionInterface(pconn))="{00020400-0000-0000-C000-000000000046}" ? DIID:=COM_GetDefaultEvents(psource) : "" : pconn:=COM_FindConnectionPoint(psource,DIID:=COM_GetDefaultEvents(psource))
	Else	pconn:=COM_FindConnectionPoint(psource,SubStr(DIID,1,1)="{" ? DIID : DIID:=COM_GetGuidOfName(psource,DIID))
	If	!pconn || !ptinf:=COM_GetTypeInfoOfGuid(psource,DIID)
	{
		MsgBox, No Event Interface Exists!
		Return
	}
	psink:=COM_CoTaskMemAlloc(40+StrLen(prefix)+1), NumPut(1,NumPut(COM_CreateIDispatch(),psink+0)), NumPut(psource,NumPut(ptinf,psink+8))
	DllCall("RtlMoveMemory", "Uint", psink+24, "Uint", COM_GUID4String(DIID,DIID), "Uint", 16)
	DllCall("RtlMoveMemory", "Uint", psink+40, "Uint", &prefix, "Uint", StrLen(prefix)+1)
	NumPut(COM_Advise(pconn,psink),NumPut(pconn,psink+16))
	Return	psink
}

COM_DisconnectObject(psink)
{
	Return	COM_Unadvise(NumGet(psink+16),NumGet(psink+20)), COM_Release(NumGet(psink+16)), COM_Release(NumGet(psink+8)), COM_CoTaskMemFree(psink)
}

COM_CreateObject(CLSID, IID = "", CLSCTX = 5)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(CLSID,1,1)="{" ? COM_GUID4String(CLSID,CLSID) : COM_CLSID4ProgID(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)
	Return	ppv
}

COM_ActiveXObject(ProgID)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "Uint", 5, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetObject(Moniker)
{
	DllCall("ole32\CoGetObject", "Uint", COM_Unicode4Ansi(Moniker,Moniker), "Uint", 0, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetActiveObject(ProgID)
{
	DllCall("oleaut32\GetActiveObject", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "UintP", punk)
	DllCall(NumGet(NumGet(1*punk)+0), "Uint", punk, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	DllCall(NumGet(NumGet(1*punk)+8), "Uint", punk)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_CLSID4ProgID(ByRef CLSID, ProgID)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromProgID", "Uint", COM_Unicode4Ansi(ProgID,ProgID), "Uint", &CLSID)
	Return	&CLSID
}

COM_GUID4String(ByRef CLSID, String)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromString", "Uint", COM_Unicode4Ansi(String,String,38), "Uint", &CLSID)
	Return	&CLSID
}

COM_ProgID4CLSID(pCLSID)
{
	DllCall("ole32\ProgIDFromCLSID", "Uint", pCLSID, "UintP", pProgID)
	Return	COM_Ansi4Unicode(pProgID) . COM_CoTaskMemFree(pProgID)
}

COM_String4GUID(pGUID)
{
	VarSetCapacity(String, 38 * 2 + 1)
	DllCall("ole32\StringFromGUID2", "Uint", pGUID, "Uint", &String, "int", 39)
	Return	COM_Ansi4Unicode(&String, 38)
}

COM_IsEqualGUID(pGUID1, pGUID2)
{
	Return	DllCall("ole32\IsEqualGUID", "Uint", pGUID1, "Uint", pGUID2)
}

COM_CoCreateGuid()
{
	VarSetCapacity(GUID, 16, 0)
	DllCall("ole32\CoCreateGuid", "Uint", &GUID)
	Return	COM_String4GUID(&GUID)
}

COM_CoTaskMemAlloc(cb)
{
	Return	DllCall("ole32\CoTaskMemAlloc", "Uint", cb)
}

COM_CoTaskMemFree(pv)
{
		DllCall("ole32\CoTaskMemFree", "Uint", pv)
}

COM_CoInitialize()
{
	Return	DllCall("ole32\CoInitialize", "Uint", 0)
}

COM_CoUninitialize()
{
		DllCall("ole32\CoUninitialize")
}

COM_SysAllocString(sString)
{
	Return	DllCall("oleaut32\SysAllocString", "Uint", COM_Ansi2Unicode(sString,wString))
}

COM_SysFreeString(bstr)
{
		DllCall("oleaut32\SysFreeString", "Uint", bstr)
}

COM_SysStringLen(bstr)
{
	Return	DllCall("oleaut32\SysStringLen", "Uint", bstr)
}

COM_SafeArrayDestroy(psa)
{
	Return	DllCall("oleaut32\SafeArrayDestroy", "Uint", psa)
}

COM_VariantClear(pvarg)
{
	Return	DllCall("oleaut32\VariantClear", "Uint", pvarg)
}

COM_AtlAxWinInit(Version = "")
{
	COM_Init()
	If Not	DllCall("GetModuleHandle", "str", "atl" . Version)
		DllCall("LoadLibrary"    , "str", "atl" . Version)
	Return	DllCall("atl" . Version . "\AtlAxWinInit")
}

COM_AtlAxWinTerm(Version = "")
{
	COM_Term()
	If   hModule :=	DllCall("GetModuleHandle", "str", "atl" . Version)
	Return		DllCall("FreeLibrary"    , "Uint", hModule)
}

COM_AtlAxAttachControl(pdsp, hWnd, Version = "")
{
	Return	DllCall("atl" . Version . "\AtlAxAttachControl", "Uint", punk:=COM_QueryInterface(pdsp,0), "Uint", hWnd, "Uint", 0), COM_Release(punk)
}

COM_AtlAxCreateControl(hWnd, Name, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxCreateControl", "Uint", COM_Unicode4Ansi(Name,Name), "Uint", hWnd, "Uint", 0, "Uint", 0)=0
	Return	COM_AtlAxGetControl(hWnd, Version)
}

COM_AtlAxGetControl(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetControl", "Uint", hWnd, "UintP", punk)=0
		pdsp:=COM_QueryInterface(punk), COM_Release(punk)
	Return	pdsp
}

COM_AtlAxGetHost(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetHost", "Uint", hWnd, "UintP", punk)=0
		pdsp:=COM_QueryInterface(punk), COM_Release(punk)
	Return	pdsp
}

COM_AtlAxCreateContainer(hWnd, l, t, w, h, Name = "", Version = "")
{
	Return	DllCall("CreateWindowEx", "Uint",0x200, "str", "AtlAxWin" . Version, "Uint", Name ? &Name : 0, "Uint", 0x54000000, "int", l, "int", t, "int", w, "int", h, "Uint", hWnd, "Uint", 0, "Uint", 0, "Uint", 0)
}

COM_AtlAxGetContainer(pdsp, bCtrl = "")
{
	DllCall(NumGet(NumGet(1*pdsp)+ 0), "Uint", pdsp, "Uint", COM_GUID4String(IID_IOleWindow,"{00000114-0000-0000-C000-000000000046}"), "UintP", pwin)
	DllCall(NumGet(NumGet(1*pwin)+12), "Uint", pwin, "UintP", hCtrl)
	DllCall(NumGet(NumGet(1*pwin)+ 8), "Uint", pwin)
	Return	bCtrl ? hCtrl : DllCall("GetParent", "Uint", hCtrl)
}

COM_Ansi4Unicode(pString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	sString
}

COM_Unicode4Ansi(ByRef wString, sString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Ansi2Unicode(ByRef sString, ByRef wString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Unicode2Ansi(ByRef wString, ByRef sString, nSize = "")
{
	pString := wString + 0 > 65535 ? wString : &wString
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	&sString
}

COM_ScriptControl(sCode, sLang = "", bEval = False, sFunc = "", sName = "", pdisp = 0, bGlobal = False)
{
	COM_Init()
	psc  :=	COM_CreateObject("MSScriptControl.ScriptControl")
		COM_Invoke(psc, "Language", sLang ? sLang : "VBScript")
	sFunc ?	COM_Invoke(psc, "AddCode", sCode) : ""
	sName ?	COM_Invoke(psc, "AddObject", sName, "+" . pdisp, bGlobal) : ""
	ret  :=	COM_Invoke(psc, bEval ? "Eval" : "ExecuteStatement", sFunc ? sFunc : sCode)
	COM_Release(psc)
	COM_Term()
	Return	ret
}
