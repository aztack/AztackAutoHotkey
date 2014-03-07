Global Const $WM_USER = 1024
Global Const $WM_LOOP = $WM_USER + 1
Global Const $WM_FLYER = $WM_USER + 2

GUICreate('WM_USER Get', 600, 400)
Global $lblLoop = GUICtrlCreateLabel('The default value...', 10, 10, 250, 15)

Global $txtTypeHere = GUICtrlCreateInput('', 10, 45, 250, 21)
Global $lblSetHere = GUICtrlCreateLabel('Empty for now...', 10, 71, 250, 15)
Global $btnSetNow = GUICtrlCreateButton('Set Now', 10, 96, 75, 23)

Global $lblInteralLoop = GUICtrlCreateLabel('Internal loop that blocks GUI', 10, 200, 250, 15)
Global $btnInternalLoop = GUICtrlCreateButton('Start Internal Loop', 10, 225, 150, 23)

GUIRegisterMsg($WM_LOOP, 'WM_LOOP')
GUIRegisterMsg($WM_FLYER, 'WM_FLYER')
GUISetState()


While (True)
	Switch (GUIGetMsg())
	Case $btnSetNow
	GUICtrlSetData($lblSetHere, GUICtrlRead($txtTypeHere))
	Case $btnInternalLoop
	InternalLoop()
	EndSwitch
WEnd


Func WM_LOOP($hWnd, $uMsg, $wParam, $lParam)
	CallByWM_LOOP(Int($lParam))
EndFunc

Func WM_FLYER($hWnd, $uMsg, $wParam, $lParam)
	SplashTextOn('WM_USER Get', "I'm gonna fly...", 160, 90, 0, 0, BitOR(1, 2, 32))
EndFunc

Func CallByWM_LOOP($i)
	GUICtrlSetData($lblLoop, $i)
EndFunc

Func InternalLoop()
	For $i = 1 To 500
	GUICtrlSetData($lblInteralLoop, $i)
	Sleep(10)
	Next
EndFunc