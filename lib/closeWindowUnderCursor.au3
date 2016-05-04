#include <WinAPI.au3>
$pos = _WinAPI_GetMousePos()
$hwnd = _WinAPI_WindowFromPoint($pos)
_WinAPI_ShowWindow($hwnd,0)
;WinClose($hwnd);
