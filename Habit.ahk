;--------------------------------------Habit-2015 V1.1510
;~ 界面修改
;~ 支持定义老板键
;--------------------------------------脚本头设置
#Persistent
#SingleInstance force
#ErrorStdOut
Process, priority,,High
DetectHiddenWindows,on
Hotkey, Enter ,Ente
Hotkey, Enter ,off
D_update=http://habit-2015.54fe89771abc8.d01.nanoyun.com/Habit/updatee.txt?fakeParam=%A_Now%
版本 = 1513
D_bb = 1513
;--------------------------------------配置窗口热键
shuru = zuidaa`nzuixiaoo`nlinshii`njuzhongg`n
Loop,Parse,shuru,`n
{
    IniRead, winre, %A_ScriptDir%\窗口热键配置.ini,窗口配置,%A_Index%,%A_Space%
    if not winre
        continue
    Hotkey,%winre%,%A_LoopField%
}
;--------------------------------------获取输入法
Menu, MyContextMenu, Add,<<为程序配置老板键,laoban
HKLnum:=DllCall("GetKeyboardLayoutList","uint",0,"uint",0)
VarSetCapacity( HKLlist, HKLnum*4, 0 )
DllCall("GetKeyboardLayoutList","uint",HKLnum,"uint",&HKLlist)
Loop,%HKLnum%
{
    SetFormat, integer, hex
    HKL:=NumGet( HKLlist,(A_Index-1)*4 )
    StringTrimLeft,Layout,HKL,2
    Layout:= Layout=8040804 ? "00000804" : Layout
    Layout:= Layout=4090409 ? "00000409" : Layout
    RegRead,IMEName,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%Layout%,Layout Text
    RegRead,Tubiao,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%Layout%,Ime File
    SetFormat, integer, D
    if IMEName
    {
        编号列 = %IMEName%`r%Layout%`n%编号列%
        Menu, MyContextMenu, Add, %IMEName%,SubMenu
    }
}
Menu, MyContextMenu, Add,<<保存并刷新列表,bao
Menu, MyContextMenu, Add,<<窗口操作配置,chuang
;--------------------------------------Gui界面
Gui,Add,ListView, Checked -Hdr Multi Report AltSubmit xm ym h143 w350 vMyListView,进程ID|输入状态|热键|编号|路径
Gui,Add,StatusBar,,
SB_SetText("脚本信息:版本V1." . 版本 . "       系统:Win7 64位      AHK:L版1.1.15 ")
GuiControl, Focus,MyListView
Gui +HwndMyGuiHwnd
Gui,Add,Text,ym x+5  vwenzi Section,最大化`n`n`n最小化`n`n`n临时老板键`n`n`n缩小剧中
Gui,Add,Hotkey,xs y20 vzuida
Gui,Add,Hotkey,xs y+16 vzuixiao
Gui,Add,Hotkey,xs y+16 vlinshi
Gui,Add,Hotkey,xs y+16 vjuzhong w94 Section
Gui,Add,Button,ys x+5 h20 vqueque gqueque Default,确定
Gui,Add,Hotkey,xm y+5 h23 Section Limit1 vChosenHotkey
Gui,Add,Button,ys x+5 gChosenHotkey vsenHot Default,确定
Gui,Add,Button,ys x+5 gquxiao vquxiao,取消
Gui,Show,AutoSize,Habit-2015
Guiwen()
Guique()
Gui,Cancel
;--------------------------------------Menu界面
Menu, Tray, Click, 1
Menu, Tray, Tip, 版本:V1.%版本%`n脚本:AutoHotkey1.15`n系统:Win7 64位
Menu, Tray, Add, By，小死猛, Menu_显示窗口
Menu, Tray, Add, 联系作者, Menu_联系作者
Menu, Tray, Add, 支持作者, Menu_支持作者
Menu, Tray, Add,
Menu, Tray, Add, 开启脚本
Menu, Tray, Add, 回车切换
Menu, Tray, Add, 开机启动
Menu, Tray, Add,
Menu, Tray, Add, 停用热键
Menu, Tray, Add, 重启脚本, Menu_重启脚本
Menu, Tray, Add, 退出脚本, Menu_退出脚本
Menu, Tray, Default, By，小死猛
Menu, tray, NoStandard
GuiStart()
;--------------------------------------检查是否自动开启脚本
IfExist ,%A_Startup%\输入法.lnk
{
    TrayTip,,脚本已最小化至托盘, 10, 1
    Menu, Tray, ToggleCheck, 开机启动
    gosub,立即检查
    gosub,开启脚本
}
else
{
    Gui,Show,AutoSize,Habit-2015
}
return
;--------------------------------------Menu命令一
Menu_显示窗口:
    DetectHiddenWindows,off
    IfWinExist, ahk_id %MyGuiHwnd%
    {
        Gui,Cancel
        return
    }
    Gui,Show,AutoSize
return
Menu_联系作者:
    Run tencent://message/?uin=4845514
return
Menu_支持作者:
    SetTimer,ChangeButtonNames,50
    MsgBox,4,感谢支持本功能,感谢支持本功能
    IfMsgBox Yes
        MsgBox 支付宝帐号：skc2015@163.com`n户名：刘猛
return
ChangeButtonNames:
    IfWinNotExist,感谢支持本功能
        return
    SetTimer,ChangeButtonNames,off
    WinActivate
    ControlSetText,Button1,RMB支持
    ControlSetText,Button2,精神支持
return
;--------------------------------------Menu命令二段
开启脚本:
    Menu, Tray, ToggleCheck, 开启脚本
    winuu = 5
    if winoo = 6
    {
        winoo = 4
    }
    else
    {
        winoo = 6
    }
    gosub,kik
return
回车切换:
    Menu, Tray, ToggleCheck, 回车切换
    Hotkey, Enter,Toggle
return
开机启动:
    Menu, Tray, ToggleCheck, 开机启动
    IfExist ,%A_Startup%\输入法.lnk
    {
        FileDelete,%A_Startup%\输入法.lnk
    }
    else
    {
        FileCreateShortcut,%A_ScriptDir%\%A_ScriptName%,%A_Startup%\输入法.lnk
    }
return
;--------------------------------------Menu命令三段
停用热键:
    if NewName <> 启用热键
    {
        OldName = 停用热键
        NewName = 启用热键
        winrj =
    }
    else
    {
        OldName = 启用热键
        NewName = 停用热键
        winrj = 1
    }
    Menu, tray, rename, %OldName%, %NewName%
    Loop % LV_GetCount()
    {
        RowNumbe := LV_GetNext(RowNumbe,"Checked")
        if not RowNumbe
            continue
        LV_GetText(热键, RowNumbe,3)
        if not 热键
            continue
        if not winrj
        {
            Hotkey,%热键%,Off
        }
        else
        {
            Hotkey,%热键%,On
            Hotkey,%热键%,MyLabel
        }
    }
return
Menu_重启脚本:
    Reload
Menu_退出脚本:
    ExitApp
    ;--------------------------------------主要功能
kik:
    while winoo>winuu
    {
        WinGet, win_pc,ID,A ;避免QQ聊天窗口与界面窗口同在问题
        WinWaitNotActive,ahk_id %win_pc% ;只在出现新窗口时执行优化效率 同样也避免了与保存的冲突
        WinGet, win_pp,ProcessName,A
        Loop % LV_GetCount()
        {
            RowNum := LV_GetNext(RowNum,"Checked")
            if not RowNum
                break
            LV_GetText(进程, RowNum, 1)
            IfInString,win_pp, %进程%
            {
                LV_GetText(Layout, RowNum, 4)
                SwitchIME(Layout)
                break
            }
        }
    }
return
Ente:
    WinGet, win_cl, ProcessName, A
    Loop % LV_GetCount()
    {
        RowNumbe := LV_GetNext(RowNumbe,"Checked")
        if not RowNumbe
            continue
        LV_GetText(进程, RowNumbe, 1)
        IfInString,win_cl, %进程%
        {
            LV_GetText(Layout, RowNumbe, 4)
            SwitchIME(Layout)
            Send {Enter}
            return
        }
    }
    Send {Enter}
return
MyLabel:
    Loop % LV_GetCount()
    {
        RowNumbe := LV_GetNext(RowNumbe,"Checked")
        if not RowNumbe
            continue
        LV_GetText(热键, RowNumbe,3)
        if 热键 = %A_ThisHotkey%
        {
            LV_GetText(winexe, RowNumbe,1)
            LV_GetText(winlj, RowNumbe,5)
        }
    }
    DetectHiddenWindows,off
    IfWinActive ,ahk_exe %winexe%.exe
    {
        WinMinimize
        return
    }
    IfWinExist ,ahk_exe %winexe%.exe
    {
        WinActivate
    }
    else
    {
        Run,%winlj%
    }
    TrayTip,%winexe%,已经启动, 10, 1
return
;--------------------------------------右键菜单
GuiContextMenu:            ;只在MyListView中显示右键菜单
    win_xz := A_EventInfo
    if not win_xz
        return
    if A_GuiControl <> MyListView
        return
    Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return
laoban:                    ;为程序配置老板键
    热键列表 =
    Loop
    { ;添加配置文件中项目
        IniRead, win_dq, %A_ScriptDir%\输入法设定.ini, 选定项目,%A_Index%,%A_Space%
        if not win_dq
        {
            break
        }
        IniRead, 热键, %A_ScriptDir%\输入法设定.ini, %win_dq%, 中英,%A_Space%
        热键列表 = %热键%-%热键列表%
    }
    LV_GetText(winlj, win_xz,5)
    IfInString,winlj,WINDOWS
    {
        SB_SetText("系统目录程序不允许设置热键")
        return
    }
    Guique()
    GuiControl,,ChosenHotkey
    Gui,Show,AutoSize
    GuiControl,Focus,ChosenHotkey
    gosub,停用热键
    SB_SetText("已经停用所有热键请设置")
return
ChosenHotkey:
    Gui,Submit,NoHide
    IfInString,热键列表,%ChosenHotkey%
    {
        if not ChosenHotkey
        {
            LV_GetText(有无状态, win_xz,2)
            if not 有无状态
            {
                LV_Modify(win_xz,"-Check")
                SB_SetText("此次未配置任何选项 已取消选中")
            }
            else
            {
                LV_Modify(win_xz,,,,ChosenHotkey)
                SB_SetText("已停用此程序热键")
            }
        }
        else
        {
            SB_SetText("已经存在此热键  请制空此热键后重新设置")
        }
        Guique()
        Gui,Show,AutoSize
        gosub,停用热键
        gosub,bao
        return
    }
    LV_Modify(win_xz,,,,ChosenHotkey)
    Hotkey,%ChosenHotkey%, MyLabel
    热键列表 = %ChosenHotkey%`n%热键列表%
    LV_Modify(win_xz,"Check")
    GuiControl,Hide ,ChosenHotkey
    GuiControl,Hide ,senHot
    GuiControl,Hide,quxiao
    Gui,Show,AutoSize
    gosub,停用热键
    gosub,bao
    SB_SetText("所有热键以重新启用 此次设置成功")
return
quxiao:
    Guique()
    Gui,Show,AutoSize
    gosub,停用热键
    SB_SetText("所有热键以重新启用 取消本次设置")
return
Submenu:                         ;输入法配置菜单
    if not win_xz
        return
    Loop, Parse, 编号列, `n
    {
        IfInString, A_LoopField, %A_ThisMenuItem%
        {
            win_sw = %A_LoopField%
            break
        }
    }
    Loop, Parse, win_sw, `r
    {
        if A_Index = 1
        {
            LV_Modify(win_xz,,,A_LoopField)
        }
        if A_Index = 2
        {
            LV_Modify(win_xz,,,,,A_LoopField)
        }
    }
    LV_Modify(win_xz,"Check")
    GuiControl, Focus,MyListView
    SB_SetText("保存成功,如未刷新出隐藏至托盘的程序,请换出窗口刷新。")
return
;--------------------------------------窗口操作设置
chuang:
    Guiwen()
    Gui,Show,AutoSize
    shur = zuida`nzuixiao`nlinshi`njuzhong`n
    Loop,Parse,shur,`n
    {
        IniRead, winre, %A_ScriptDir%\窗口热键配置.ini,窗口配置,%A_Index%,%A_Space%
        if not winre
            continue
        GuiControl,,%A_LoopField%,%winre%
        Hotkey,%winre%,Off
    }
return
queque:
    Gui, Submit,NoHide
    IniWrite, %zuida%, %A_ScriptDir%\窗口热键配置.ini,窗口配置,1
    IniWrite, %zuixiao%, %A_ScriptDir%\窗口热键配置.ini,窗口配置,2
    IniWrite, %linshi%, %A_ScriptDir%\窗口热键配置.ini,窗口配置,3
    IniWrite, %juzhong%, %A_ScriptDir%\窗口热键配置.ini,窗口配置,4
    Loop,Parse,shuru,`n
    {
        IniRead, winer, %A_ScriptDir%\窗口热键配置.ini,窗口配置,%A_Index%,%A_Space%
        if not winer
            continue
        Hotkey,%winer%,%A_LoopField%
        Hotkey,%winer%,On
    }
    Guiwen()
    Gui,Show,AutoSize
return
;--------------------------------------窗口操作的一些标签
zuixiaoo:               ;窗口最小化
    WinMinimize A
return
zuidaa:               ;窗口最大化N
    WinMaximize A
return

linshii:
    if win_cs > 0
    {  ;记录次数
        win_cs += 1
        return
    }
    win_cs = 1
    SetTimer, KeyAlt, 300 ;300毫秒内等待更多键击
return
KeyAlt:
    SetTimer, KeyAlt, off
    if win_cs = 1
    {  ;一次则激活或最小化
        IfWinActive ,ahk_id %win_id%
        {
            WinMinimize
            win_cs = 0
            return
        }
        else
        {
            WinActivate ,ahk_id %win_id%
            win_cs = 0
            return
        }
    }
    if win_cs = 2
    {  ;两次则新定义
        WinGet,win_id,id,A
        WinMinimize A
    }
    else if win_cs > 2
    {  ;超次则清空
        WinClose,ahk_id %win_id%
        win_id =
    }
    win_cs = 0
return
juzhongg: ;把当前窗口还原后移到屏幕正中间!
    WinRestore,A
    WinGetPos,,, Width, Height, A
    WinMove, A,, (A_ScreenWidth/2)-430, (A_ScreenHeight/2)-300, 863, 569
return
GuiClose:
    Gui,Cancel
return
;--------------------------------------加载与保存
bao:
    FileSetAttrib, -R, %A_ScriptDir%\输入法设定.ini ;取消配置文件只读选项
    FileDelete,%A_ScriptDir%\输入法设定.ini
    Loop % LV_GetCount()
    {
        RowNumber := LV_GetNext(RowNumber,"Checked")
        if not RowNumber
            break
        LV_GetText(进程, RowNumber, 1)
        LV_GetText(状态, RowNumber, 2)
        LV_GetText(热键, RowNumber, 3)
        LV_GetText(编号, RowNumber, 4)
        LV_GetText(路径, RowNumber, 5)
        IniWrite, %进程%, %A_ScriptDir%\输入法设定.ini, 选定项目,%A_Index%
        IniWrite, %进程%, %A_ScriptDir%\输入法设定.ini, %进程%, 进程
        IniWrite, %状态%, %A_ScriptDir%\输入法设定.ini, %进程%, 状态
        IniWrite, %热键%, %A_ScriptDir%\输入法设定.ini, %进程%, 热键
        IniWrite, %编号%, %A_ScriptDir%\输入法设定.ini, %进程%, 编号
        IniWrite, %路径%, %A_ScriptDir%\输入法设定.ini, %进程%, 路径
    }
    GuiStart()
    LV_ModifyCol(2,"SortDesc")
return
Guiwen(){
GuiControlGet, OutputVar, Visible,wenzi
if OutputVar
{
GuiControl,Hide,wenzi
GuiControl,Hide,zuida
GuiControl,Hide,zuixiao
GuiControl,Hide,linshi
GuiControl,Hide,juzhong
GuiControl,Hide,queque
}
else
{
GuiControl,Show,wenzi
GuiControl,Show,zuida
GuiControl,Show,zuixiao
GuiControl,Show,linshi
GuiControl,Show,juzhong
GuiControl,Show,queque
}
}
Guique(){
GuiControlGet, OutputVar, Visible,quxiao
if OutputVar
{
GuiControl,Hide,quxiao
GuiControl,Hide,ChosenHotkey
GuiControl,Hide,senHot
}
else
{
GuiControl,Show,quxiao
GuiControl,Show,ChosenHotkey
GuiControl,Show,senHot
}
}
GuiStart() {
    热键列表 =
    LV_Delete()
    WinGet,WinList,List
    WinAll:= Object()
    ImageListID := IL_Create(WinAll)
    LV_SetImageList(ImageListID)
    WinListPN:=
    Loop,%WinList% {
        id:=WinList%A_Index%
        WinGet,win_ll,ProcessName,ahk_id %id%
        StringReplace, win_ll, win_ll,.exe
        WinListPN:=WinListPN win_ll "`n"
    }
    Sort,WinListPN,U ;排除类似IE 或文本文件编辑
    Loop
    { ;排除配置文件中的项目
        IniRead, 排除, %A_ScriptDir%\输入法设定.ini, 选定项目,%A_Index%,%A_Space%
        if not 排除
        {
            break
        }
        StringReplace, WinListPN, WinListPN, %排除% ,UseErrorLevel ,
    }
    Sort,WinListPN,U ;继续避免重复
    WinList_Array:=StrSplit(RTrim(WinListPN,"`n"),"`n")
    win_A_Index = 1
    For index, 进程 in WinList_Array {
        WinGet,路径,ProcessPath,ahk_exe %进程%.exe
    IfNotExist ,%路径%
    { ;路径不存在则不添加
        continue
    }
    if (GetIconCount(路径)>0)
        IL_Add(ImageListID, 路径,1)
    else ;图标为空则不添加
        continue
    LV_Add("Icon" . win_A_Index,进程,,,,路径)
    win_A_Index++
}
RowNumber := LV_GetCount()
Loop
{ ;添加配置文件中项目
    IniRead, win_dq, %A_ScriptDir%\输入法设定.ini, 选定项目,%A_Index%,%A_Space%
    if not win_dq
    {
        break
    }
    IniRead, 进程, %A_ScriptDir%\输入法设定.ini, %win_dq%, 进程,%A_Space%
    IniRead, 状态, %A_ScriptDir%\输入法设定.ini, %win_dq%, 状态,%A_Space%
    IniRead, 热键, %A_ScriptDir%\输入法设定.ini, %win_dq%, 热键,%A_Space%
    IniRead, 编号, %A_ScriptDir%\输入法设定.ini, %win_dq%, 编号,%A_Space%
    IniRead, 路径, %A_ScriptDir%\输入法设定.ini, %win_dq%, 路径,%A_Space%%A_Space%
    IfNotExist ,%路径%
    {
        continue
    }
    RowNumber++
    if 热键
    {
        Hotkey,%热键%, MyLabel
    }
    IL_Add(ImageListID, 路径,1)
    LV_Add("Icon" . RowNumber,进程,状态,热键,编号,路径)
    LV_Modify(RowNumber,"Check")
}
LV_ModifyCol(1,110)
LV_ModifyCol(2,159)
LV_ModifyCol(3,50)
LV_ModifyCol(3,"SortDesc")
LV_ModifyCol(2,"SortDesc")
LV_ModifyCol(4,0)
LV_ModifyCol(5,0)
}
return
;--------------------------------------更新
立即检查:
    SetTimer,立即检查,Off
    SplitPath,D_update,,,,,OutDrive
    update:=W_InternetCheckConnection(OutDrive)
    if not update
        return
    D_Array := StrSplit(DownloadToString(D_update,"cp936"),"`n")
    D_Edit := D_Array[1] ;读取第一行版本号
    D_link := D_Array[2] ;读取第二行下载文件连接
    D_Name := D_Array[3] ;新文件名
    D_xing := D_Array[4] ;更新信息
    if D_Edit is not number
    {
        TrayTip,,获取更新失败,10, 1
        return
    }
    if (D_Edit > D_bb)
    {
        MsgBox,4,检测到新版本,是否更新至:%D_Edit%`n%D_xing%
        IfMsgBox Yes
            gosub,D_Label
    }
return
D_Label:
    D_kb := InternetFileGetSize(D_link)
    Progress,1,%S_kb%/%D_kb%,正在更新...,AHK更新
    FileDelete,%A_Temp%\%D_Name%
    SetTimer,S_Label,500
    URLDownloadToFile,%D_link%,%A_Temp%\%D_Name%
    SetTimer,S_Label,Off
    if ErrorLevel{
        TrayTip,,更新文件下载出错,10, 1
        return
    }
    else{
        Progress,100
        gosub,ExitSub
    }
return
S_Label: ;获取下载临时文件的大小更新进度
    FileGetSize,S_kb,%A_Temp%\%D_Name%
    D_xz := S_kb/D_kb
    D_xz := D_xz*100
    StringLeft,D_xz,D_xz,2
    Progress,%D_xz%,%S_kb%/%D_kb%,正在更新...,AHK更新
return
ExitSub:
    if (A_IsCompiled) ;自杀并打开更新后的程序
    {
        bat=
        (LTrim
:start
    ping 127.0.0.1 -n 2>nul
    del `%1
    if exist `%1 goto start
    copy %A_Temp%\%D_Name% %A_ScriptDir%
    start %D_Name%
    del `%0
    )
    batfilename=Delete.bat
    IfExist %batfilename%
        FileDelete %batfilename%
    FileAppend, %bat%, %batfilename%
    Run,%batfilename% "%A_ScriptFullPath%", , Hide
    ExitApp
    }
ExitApp
W_InternetCheckConnection(lpszUrl){ ;检查FTP服务是否可连接
    FLAG_ICC_FORCE_CONNECTION := 0x1
    dwReserved := 0x0
    return, DllCall("Wininet.dll\InternetCheckConnection", "Ptr", &lpszUrl, "UInt", FLAG_ICC_FORCE_CONNECTION, "UInt", dwReserved, "Int")
}
InternetFileGetSize(URL:=""){  ;获取网络文件大小
    Static LIB="WININET\", CL="00000000000000", N=""
    QRL := 16
    if ! DllCall( "GetModuleHandle", Str,"wininet.dll" )
        DllCall( "LoadLibrary", Str,"wininet.dll" )
    if ! hIO:=DllCall( LIB "InternetOpenA", Str,N, UInt,4, Str,N, Str,N, UInt,0 )
        return -1
    if ! (( hIU:=DllCall( LIB "InternetOpenUrlA", UInt,hIO, Str,URL, Str,N, Int,0, UInt,F, UInt,0 ) ) || ErrorLevel )
        return "",0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 2
    if ! ( RB  )
        if ( SubStr(URL,1,4) = "ftp:" )
            CL := DllCall( LIB "FtpGetFileSize", UInt,hIU, UIntP,0 )
        else if ! DllCall( LIB "HttpQueryInfoA", UInt,hIU, Int,5, Str,CL, UIntP,QRL, UInt,0 )
            return "",0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIU ) )-( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 4
    return CL
}
DownloadToString(URL, encoding="utf-8")
{
    static a := "AutoHotkey/" A_AhkVersion
    if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen","str",a,"uint",1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
        return 0
    c:=s:=0,o:=""
    if(f:=DllCall("wininet\InternetOpenUrl","ptr",h,"str",url,"ptr",0,"uint",0,"uint",0x80003000,"ptr",0,"ptr"))
    {
        while (DllCall("wininet\InternetQueryDataAvailable","ptr",f,"uint*",s,"uint",0,"ptr",0) &&s>0)
        {
            VarSetCapacity(b,s,0)
            DllCall("wininet\InternetReadFile","ptr",f,"ptr",&b,"uint",s,"uint*",r)
            o.= StrGet(&b,r>>(encoding="utf-16"||encoding="cp1200"),encoding)
        }
        DllCall("wininet\InternetCloseHandle","ptr", f)
}
DllCall("wininet\InternetCloseHandle","ptr",h)
return o
}
;--------------------------------------调用与获取
GetIconCount(file){ ;排除没有图标的程序
    Menu, test, add, test, handle
    Loop
    {
        try {
            id++
        Menu, test, Icon, test, % file, % id
    } catch error {
    break
}
}
return id-1
}
handle:
return
SwitchIME(dwLayout){ ;修改当前窗口输入法
    HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus,ctl,A
    SendMessage,0x50,0,HKL,%ctl%,A
}
;--------------------------------------脚本结束