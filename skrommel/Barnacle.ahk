;Barnacle.ahk
; Add toolbars to your favorite programs
;Skrommel @ 2008

FileInstall,Barnacle.rtf,Barnacle.rtf
FileCreateDir,Toolbars
FileInstall,Toolbars\Calc.ini,Toolbars\Calc.ini
FileInstall,Toolbars\Notepad.ini,Toolbars\Notepad.ini
FileCreateDir,Images
FileInstall,Images\EditCut.ico,Images\EditCut.ico

#SingleInstance,Force
#NoEnv
SetBatchLines,-1
SetWinDelay,0

applicationname=Barnacle

SysGet,menuh,15 ;SM_CYMENU

Gosub,INIREAD
Gosub,TRAYMENU
Gosub,START
OnExit,EXIT

ids=
Loop
{
  Sleep,100
  WinGet,activeid,ID,A
  WinGetClass,class,ahk_id %activeid%
  MouseGetPos,mx,my,mid,mctrl
  WinGetClass,mclass,ahk_id %mid%

  active=0
  Loop,% toolbars
  {
    currentclass:=%A_Index%class
    If (class=currentclass)
    {
      hWnd:=activeid
      active:=A_Index
      IfNotInString,ids,%hWnd%`,
      {
        ids=%ids%%hWnd%,
        %hWnd%new:=MENU(hWnd)
      }
      Gosub,PAINT
    }
    If (mclass=currentclass)
    {
      hWnd:=mid
      active:=A_Index
      IfNotInString,ids,%hWnd%`,
      {
        ids=%ids%%hWnd%,
        %hWnd%new:=MENU(hWnd)
      }
      Gosub,PAINT
    }
  }

  If (active>0 And mclass=class And mx>=toolbarx And mx<toolbarx+toolbarw And my>=toolbary And my<=toolbary+toolbarh)
  {
    If hotkeys<>On
    {
      Hotkey,$~LButton,LEFT,On
      Hotkey,$~RButton,RIGHT,On
      Hotkey,$~MButton,MIDDLE,On
    }
    oldbutton:=button
    button:=Ceil((mx-cxWindowBorders+1)/buttonw)
    If (button<>oldbutton)
    {
      tooltip:=%active%tip%button%
      ToolTip,%tooltip%,% toolbarx+button*buttonw,% toolbary+buttonh+10
    }
    hotkeys=On
  }
  Else
  If hotkeys=On
  {
    Hotkey,$LButton Up,LEFTUP,Off
    Hotkey,$RButton Up,RIGHTUP,Off
    Hotkey,$MButton Up,MIDDLEUP,Off
    Hotkey,$~LButton,LEFT,Off
    Hotkey,$~RButton,RIGHT,Off
    Hotkey,$~MButton,MIDDLE,Off
    button=
    ToolTip,
    Hotkeys=Off
  }

  If showinfo=1
  {
    PixelGetColor,mcolor,%mx%,%my%,RGB
    StringTrimLeft,mcolor,mcolor,2
    TrayTip,%applicationname%,X: %mx% Y:%my%`nClass: %mclass%`nControl: %mctrl%`nColor: %mcolor%
  }
}
Return


LEFT:
RIGHT:
MIDDLE:
Hotkey,$LButton Up,LEFTUP,On
Hotkey,$RButton Up,RIGHTUP,On
Hotkey,$MButton Up,MIDDLEUP,On
Hotkey,$~LButton,LEFT,Off
Hotkey,$~RButton,RIGHT,Off
Hotkey,$~MButton,MIDDLE,Off
ToolTip,%tooltip%,% toolbarx+button*buttonw,% toolbary+buttonh
Return

LEFTUP:
action:=%active%leftaction%button%
ToolTip,%action%,% toolbarx+button*buttonw,% toolbary+buttonh ;Left %active% %button%: 
Gosub,ACTION
Return

RIGHTUP:
action:=%active%rightaction%button%
ToolTip,%action%,% toolbarx+button*buttonw,% toolbary+buttonh ;Right %active% %button%: 
Gosub,ACTION
Return

MIDDLEUP:
action:=%active%middleaction%button%
ToolTip,%action%,% toolbarx+button*buttonw,% toolbary+buttonh ;Middle %active% %button%: 
Gosub,ACTION
Return


ACTION:
IfInString,action,Send`,
{
  StringTrimLeft,action,action,5
  Send,%action%
}
IfInString,action,Run`,
{
  StringTrimLeft,action,action,4
  StringSplit,action_,action,`,
  Run,%action_1%,%action_2%,%action_3%
}
IfInString,action,Control`,
{
  StringTrimLeft,action,action,8
  StringSplit,action_,action,`,
  ControlClick,%action_1%,ahk_id %hWnd%,,%action_2%,%action_3%,%action_4%
}
IfInString,action,Menu`,
{
  StringTrimLeft,action,action,5
  StringSplit,action_,action,`,
  If action_1=0&
  {
    StringTrimRight,item_2,action_2,1
    hSysMenu:=DllCall("GetSystemMenu", "Uint", hWnd, "int", False) 
    If action_0=2
    {
      nID     :=DllCall("GetMenuItemID", "Uint", hSysMenu, "int", item_2-1) ; produce -1 for a SubMenu item 
      PostMessage, 0x112, nID, 0, , ahk_id %hWnd%   ; WM_SYSCOMMAND
    }
    Else
    {
      StringTrimRight,item_2,action_2,1
      StringTrimRight,item_3,action_3,1
      hSysMenu:=DllCall("GetSubMenu", "Uint", hSysMenu, "int", item_2-1) 
      nID     :=DllCall("GetMenuItemID", "Uint", hSysMenu, "int", item_3-1) 
      PostMessage, 0x112, nID, 0, , ahk_id %hWnd%   ; WM_SYSCOMMAND
    }
  }
  Else
    WinMenuSelectItem,ahk_id %hWnd%,,%action_1%,%action_2%,%action_3%,%action_4%,%action_5%,%action_6%
}
IfInString,action,Mouse`,
{
  StringTrimLeft,action,action,6
  StringSplit,action_,action,`,
  If action_5=Screen
    CoordMode,Mouse,Screen
  MouseClick,%action_1%,%action_2%,%action_3%,%action_4%,%action_5%
  If action_5=Screen
    CoordMode,Mouse,Relative
}
IfInString,action,Window`,
{
  StringTrimLeft,action,action,7
  StringSplit,action_,action,`,
  If action_1=Move
    WinMove,ahk_id %hWnd%,,%action_2%,%action_3%,%action_4%,%action_5%
  If action_1=AlwaysOnTop
    WinSet,AlwaysOnTop,Toggle,ahk_id %hWnd%,,
  If action_1=Bottom
    WinSet,Bottom,,ahk_id %hWnd%,,
}
Return


MENU(hWnd)
{
  hMenu :=DllCall("GetMenu","UInt",hWnd)
  If hMenu=0
  {
    hMenu :=DllCall("CreateMenu")
    DllCall("SetMenu","UInt",hWnd,"UInt",hMenu)
    uFlags:=0x1 | 0x4000 ;MF_BITMAP:=0x0004 MF_MENUBREAK:=0x40 MF_GRAYED:=0x1 MF_RIGHTJUSTIFY:=0x4000 MF_OWNERDRAW:=0x0100
    new=1
  }
  Else
  {
    uFlags:=0x40 | 0x1 | 0x4000 ;MF_BITMAP:=0x0004 MF_MENUBREAK:=0x40 MF_GRAYED:=0x1 MF_RIGHTJUSTIFY:=0x4000 MF_OWNERDRAW:=0x0100
    new=0 
  }
  lpNewItem:=applicationname
  VarSetCapacity(uIDNewItem,4,1)
  DllCall("AppendMenu",UInt,hMenu,UInt,uFlags,UInt,&uIDNewItem,STR,lpNewItem)
  DllCall("DrawMenuBar",UInt,hWnd)
  Return,%new%
}


START:
  Gui,+ToolWindow +AlwaysOnTop
  Gui,1:Add,Text,,Loading images...
  Gui,1:Show,w200 h200 Barnacle

  SysGet,iconw,11 ;SM_CXICON
  SysGet,iconh,12 ;SM_CYICON 

  ScreenDC  :=DllCall("GetWindowDC",UInt,0) 
  MemDC     :=DllCall("CreateCompatibleDC",UInt,ScreenDC)
  MemBmp    :=DllCall("CreateCompatibleBitmap",UInt,ScreenDC,UInt,A_ScreenWidth,UInt,toolbars*buttonh)
  oldMemBmp :=DllCall("SelectObject",UInt,MemDC,UInt,MemBmp)

  hBrush:=DllCall("GetStockObject",UInt,18)  ;DC_BRUSH
          DllCall("SelectObject",UInt,MemDC,UInt,hBrush)
  
  buttony:=-buttonh
  Loop,%toolbars%
  {
    toolbar:=A_Index
    buttony+=%buttonh%
    buttons:=%toolbar%buttons
    buttonx:=-buttonw

    color:=%toolbar%color
    StringLeft,left,color,2
    StringTrimLeft,color,color,2
    hColor:="0x00" . color . left  ;0x00bbggrr
    DllCall("SetDCBrushColor",UInt,MemDC,UInt,hColor)
    VarsetCapacity(rect,16,0)
    InsertInteger(0,rect,0)
    InsertInteger((toolbar-1)*buttonh,rect,4)
    InsertInteger(A_ScreenWidth,rect,8)
    InsertInteger(toolbar*buttonh,rect,12)
    DllCall("FillRect",UInt,MemDC,Int,&rect,UInt,hBrush)
    InsertInteger(0,rect,0)
    InsertInteger(0,rect,4)
    InsertInteger(iconw,rect,8)
    InsertInteger(iconh,rect,12)
  
    DllCall("SetStretchBltMode",UInt,MemDC,Int,4)  ; Halftone better quality

    Loop,%buttons%
    {
      button:=A_Index
      image:=%toolbar%image%button%
      buttonx+=%buttonw%

      guiw=
      Loop
      {
        Gui,2:-Caption -Border +ToolWindow +AlwaysOnTop
        Gui,2:Margin,0,0
        color:=%toolbar%color
        Gui,2:Color,%color%
        StringSplit,image_,image,`,
        If image_2<>
          image_2=Icon%image_2%
        Gui,2:Add,Picture,W%guiw% H-1 %image_2%,%image_1%
        Gui,2:Show,NoActivate,Barnacle Icon Loader
        WinGet,guiid,Id,Barnacle Icon Loader
        WinGetPos,guix,guiy,guiw,guih,ahk_id %guiid%
        If (guiw<=A_ScreenWidth And guiw<=A_ScreenHeight)
          Break
        Gui,2:Destroy
        guiw/=10
      }
      LoadDC:=DllCall("GetWindowDC",UInt,guiid)
      DllCall("StretchBlt",UInt
              ,MemDC,Int,buttonx+(buttonw-imagew)/2,Int,buttony+(buttonh-imageh)/2,Int,imagew,Int,imageh,UInt
              ,LoadDC,Int,0,Int,0,Int,guiw,Int,guih,UInt,0x00CC0020) 
      Gui,2:Destroy
    }
  }
  Gui,1:Destroy

  VarSetCapacity(pwi,64,0)  ;windowinfo
  InsertInteger(64,pwi,0)   ;cbSize
  VarSetCapacity(pbmi,32,0) ;menubarinfo
  InsertInteger(32,pbmi,0)  ;cbSize
Return


PAINT:
DllCall("GetWindowInfo",UInt,hwnd,Int,&pwi)
  
  rcWindow_left  :=ExtractInteger(pwi,4,True)
  rcWindow_top   :=ExtractInteger(pwi,8,True)
  rcWindow_right :=ExtractInteger(pwi,12,True)
  rcWindow_bottom:=ExtractInteger(pwi,16,True)
  rcClient_left  :=ExtractInteger(pwi,20,True)
  rcClient_top   :=ExtractInteger(pwi,24,True)
; rcClient_right :=ExtractInteger(pwi,28,True)
  rcClient_bottom:=ExtractInteger(pwi,32,True)
; dwStyle        :=ExtractInteger(pwi,36,True)
; dwExstyle      :=ExtractInteger(pwi,40,True)
; dwWindowStatus :=ExtractInteger(pwi,44,True)
  cxWindowBorders:=ExtractInteger(pwi,48,True)
  cyWindowBorders:=ExtractInteger(pwi,52,True)
; atomWindowType :=ExtractInteger(pwi,56,True)
; wCreatorVersion:=ExtractInteger(pwi,60,True)
  
  toolbarx:=rcClient_left-rcWindow_left
  toolbary:=rcClient_top-buttonh-rcWindow_top
;  toolbarw:=rcClient_right-rcClient_left
  toolbarh:=buttonh
  toolbartest:=rcClient_bottom-rcClient_top
  If (toolbartest=0)
    toolbarh:=0

DllCall("GetMenuBarInfo",Int,hWnd,Int,0xFFFFFFFD,Int,0,Int,&pbmi)    ;idObject=OBJID_MENU  ;idItem

; rcBar_left  :=ExtractInteger(pbmi,4,False)
; rcBar_top   :=ExtractInteger(pbmi,8,False)
  rcBar_right :=ExtractInteger(pbmi,12,False)
; rcBar_bottom:=ExtractInteger(pbmi,16,False)

  toolbarw:=rcBar_right

  ScreenDC:=DllCall("GetWindowDC",UInt,hWnd) 
            DllCall("StretchBlt",UInt
                    ,ScreenDC,Int,toolbarx,Int,toolbary,Int,toolbarw,Int,toolbarh,UInt
                    ,MemDC,Int,0,Int,(active-1)*buttonh,Int,toolbarw,Int,toolbarh,UInt,0x00CC0020 ) 
Return


STOP:  
  DllCall("DeleteObject",UInt,MemBmp)
  DllCall("DeleteDC"    ,UInt,MemDC )

  Loop,Parse,ids,`,
  {
    hWnd:=A_LoopField
    hMenu:=DllCall("GetMenu",UInt,hWnd) 
    IfWinExist,ahk_id %hWnd%
    {
      nPos:=DllCall("GetMenuItemCount",UInt,hMenu)-1
      If nPos>0
      {
        menuid:=DllCall("GetMenuItemID",UInt,hMenu,Int,nPos)
        
        uFlags:=0x0 ;MF_BYCOMMAND:=0x0 MF_BYPOSITION:=0x40 
        DllCall("RemoveMenu",UInt,hMenu,UInt,menuid,UInt,uFlags)
        DllCall("DeleteMenu",UInt,hMenu,UInt,menuid,UInt,uFlags)
        DllCall("DrawMenuBar",UInt,hWnd)
      }
    }
    If (%hWnd%new=1)
    {
      DllCall("DestroyMenu",UInt,hMenu)
      DllCall("SetMenu",UInt,hWnd,UInt,0)
    }
  }
Return


ExtractInteger(ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 4)
; pSource is a string (buffer) whose memory area contains a raw/binary integer at pOffset.
; The caller should pass true for pSigned to interpret the result as signed vs. unsigned.
; pSize is the size of PSource's integer in bytes (e.g. 4 bytes for a DWORD or Int).
; pSource must be ByRef to avoid corruption during the formal-to-actual copying process
; (since pSource might contain valid data beyond its first binary zero).
{
    Loop %pSize%  ; Build the integer by adding up its bytes.
        result += *(&pSource + pOffset + A_Index-1) << 8*(A_Index-1)
    if (!pIsSigned OR pSize > 4 OR result < 0x80000000)
        return result  ; Signed vs. unsigned doesn't matter in these cases.
    ; Otherwise, convert the value (now known to be 32-bit) to its signed counterpart:
    return -(0xFFFFFFFF - result + 1)
}

InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
; The caller must ensure that pDest has sufficient capacity.  To preserve any existing contents in pDest,
; only pSize number of bytes starting at pOffset are altered in it.
{
    Loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
        DllCall("RtlFillMemory", "UInt", &pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF)
}


INIREAD:
IfNotExist,%applicationname%.ini
{
ini=
(
[Settings]
buttonh=
buttonw=
imagew=16
imageh=16
)
FileAppend,%ini%,%applicationname%.ini
Gosub,HELP
}

IniRead,buttonw,%applicationname%.ini,Settings,buttonw
If (buttonw="" Or buttonw="Error")
  buttonw:=menuh
IniRead,buttonh,%applicationname%.ini,Settings,buttonh
If (buttonh="" Or buttonh="Error")
  buttonh:=menuh
IniRead,imagew,%applicationname%.ini,Settings,imagew
If (imagew="" Or imagew="Error")
  imagew:=16
IniRead,imageh,%applicationname%.ini,Settings,imageh
If (imageh="" Or imageh="Error")
  imageh:=16

Loop,Toolbars\*.ini
{
  toolbar:=A_Index
  filename=Toolbars\%A_LoopFileName%
  IniRead,%toolbar%class,%filename%,Settings,class
  IniRead,%toolbar%color,%filename%,Settings,color
  Loop
  {
    button:=A_Index
    IniRead,%toolbar%image%button%,%filename%,%button%,image
    If %toolbar%image%button%=Error
      Break
    IniRead,%toolbar%leftaction%button%,%filename%,%button%,leftaction
    IniRead,%toolbar%rightaction%button%,%filename%,%button%,rightaction
    IniRead,%toolbar%middleaction%button%,%filename%,%button%,middleaction
    IniRead,%toolbar%tip%button%,%filename%,%button%,tip
  }
  %toolbar%buttons:=button-1
}
toolbars:=toolbar
Return


TRAYMENU:
  Menu,Tray,NoStandard 
  Menu,Tray,DeleteAll
  Menu,Tray,Add,%applicationname%,ABOUT
  Menu,Tray,Add,
  Menu,Tray,Default,%applicationname%
  Menu,Tray,Add,Show &Info...,SHOWINFO 
  Menu,Tray,Add,&Settings...,SETTINGS 
  Menu,Tray,Add,&About...,ABOUT
  Menu,Tray,Add,&Help...,HELP
  Menu,Tray,Add,E&xit,EXIT
  Menu,Tray,Tip,%applicationname% 
Return 


SHOWINFO:
  If showinfo=1
    showinfo=0
  Else
    showinfo=1
Return


SETTINGS:
  Run,%A_ScriptDir%
Return


HELP:
  Run,Barnacle.rtf
Return


ABOUT:
  Gui,Destroy
  Gui,Margin,20,20
  Gui,Add,Picture,xm Icon1,%applicationname%.exe
  Gui,Font,Bold
  Gui,Add,Text,x+10 yp+10,%applicationname% v0.992
  Gui,Font
  Gui,Add,Text,y+10,Add toolbars to your favorite programs.
  Gui,Add,Text,y+10,- To find out more, choose Help in the tray menu.

  Gui,Add,Picture,xm y+20 Icon2,%applicationname%.exe
  Gui,Font,Bold
  Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
  Gui,Font
  Gui,Add,Text,y+10,For more tools, information and donations, please visit 
  Gui,Font,CBlue Underline
  Gui,Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
  Gui,Font

  Gui,Add,Picture,xm y+20 Icon7,%applicationname%.exe
  Gui,Font,Bold
  Gui,Add,Text,x+10 yp+10,DonationCoder
  Gui,Font
  Gui,Add,Text,y+10,Please support the contributors at
  Gui,Font,CBlue Underline
  Gui,Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
  Gui,Font

  Gui,Add,Picture,xm y+20 Icon6,%applicationname%.exe
  Gui,Font,Bold
  Gui,Add,Text,x+10 yp+10,AutoHotkey
  Gui,Font
  Gui,Add,Text,y+10,This tool was made using the powerful
  Gui,Font,CBlue Underline
  Gui,Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
  Gui,Font

  Gui,Show,,%applicationname% About
  
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
  Gui,Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static8,Static12,Static16
    DllCall("SetCursor","UInt",hCurs)
  Return
}


EXIT:
Gosub,STOP
ExitApp
