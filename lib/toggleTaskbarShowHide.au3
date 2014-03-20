;SHAppBarMessage
;Sends an appbar message to the system.
;
;Syntax
;UINT_PTR SHAppBarMessage( DWORD dwMessage, PAPPBARDATA pData );
;
;MSDN
;http://msdn2.microsoft.com/en-us/library/ms647647.aspx
;
;Author zHcH
;For more information,please visit
;http://hi.baidu.com/zhch_ao

;------------------------����һЩ��Ҫʹ�õı���----------------------------

Global Const $ABM_ACTIVATE = 0x06
Global Const $ABM_GETAUTOHIDEBAR = 0x07
Global Const $ABM_GETSTATE = 0x04
Global Const $ABM_SETSTATE = 0x0000000a
Global Const $ABM_GETTASKBARPOS = 0x05
Global Const $ABM_NEW = 0x00
Global Const $ABM_QUERYPOS = 0x02
Global Const $ABM_REMOVE = 0x01
Global Const $ABM_SETAUTOHIDEBAR = 0x08
Global Const $ABM_SETPOS = 0x03
Global Const $ABM_WINDOWPOSCHANGED = 0x09
;---
Global Const $ABS_ALWAYSONTOP = 0x2
Global Const $ABS_AUTOHIDE = 0x1
;---
Global Const $ABE_LEFT = 0
Global Const $ABE_TOP = 1
Global Const $ABE_RIGHT = 2
Global Const $ABE_BOTTOM = 3
;---

;--------------------------����APPBARDATA�ṹ��ָ��----------------------------
;��ϸ��Ϣ:http://msdn2.microsoft.com/en-us/library/ms538008.aspx

Global $pabd = DllStructCreate("dword;int;uint;uint;int;int;int;int;int")
DllStructSetData($pabd,1,DllStructGetSize($pabd)) ;cbSize
DllStructSetData($pabd,2,ControlGetHandle("Start","","Shell_TrayWnd")) ;hWnd

;-------------------------����SHAppBarMessage����------------------------------

Func SHAppBarMessage($Message,ByRef $pabd)
$lResult = DllCall("shell32.dll","int","SHAppBarMessage","int",$Message,"ptr",DllStructGetPtr($pabd))
If Not @error Then
If $lResult[0] Then
Return $lResult[0]
EndIf
EndIf
SetError(1)
Return False
EndFunc

;----------------------------------���ӿ�ʼ----------------------------------

;---------------------ep1.������������״̬


;DllStructSetData($pabd,9,$ABS_AUTOHIDE) ;�Զ�����,�Ҳ�λ�ڴ���ǰ

$result = SHAppBarMessage($ABM_GETSTATE,$pabd)
If BitAND($result,$ABS_AUTOHIDE) = $ABS_AUTOHIDE Then
   DllStructSetData($pabd,9,$ABS_ALWAYSONTOP) ;���Զ�����,��λ�ڴ���ǰ
   SHAppBarMessage($ABM_SETSTATE,$pabd) ;����ABM_SETSTATE��ϢӦ���޸�
Else
   DllStructSetData($pabd,9,BitOR($ABS_ALWAYSONTOP,$ABS_AUTOHIDE)) ;�Զ�����,��λ�ڴ���ǰ
   SHAppBarMessage($ABM_SETSTATE,$pabd) ;����ABM_SETSTATE��ϢӦ���޸�
EndIf

;---------------------ep2.��ȡ������״̬
#cs
$result = SHAppBarMessage($ABM_GETSTATE,$pabd)
If BitAND($result,$ABS_ALWAYSONTOP) = $ABS_ALWAYSONTOP Then ConsoleWrite("ALWAYSONTOP" & @LF)
If BitAND($result,$ABS_AUTOHIDE) = $ABS_AUTOHIDE Then ConsoleWrite("AUTOHIDE" & @LF)
#ce

;---------------------ep3.��������λ��
#cs
$result = SHAppBarMessage($ABM_GETTASKBARPOS,$pabd)
If $result Then
ConsoleWrite("Left : " & DllStructGetData($pabd,5) & @LF)
ConsoleWrite("Top : " & DllStructGetData($pabd,6) & @LF)
ConsoleWrite("Right : " & DllStructGetData($pabd,7) & @LF)
ConsoleWrite("Bottom: " & DllStructGetData($pabd,8) & @LF)
EndIf

Switch DllStructGetData($pabd,4)
Case 0
ConsoleWrite("ABE_LEFT" & @LF)
Case 1
ConsoleWrite("ABE_TOP" & @LF)
Case 2
ConsoleWrite("ABE_RIGHT" & @LF)
Case 3
ConsoleWrite("ABE_BOTTOM" & @LF)
EndSwitch
#ce

;----------------------------------���ӽ���--------------------------------------