;功能：中、英、大小写输入状态提示
;环境：win10+搜狗输入法，输入法状态切换用默认的shift键。
;作者：傲慢与偏见zxc, 837449776@qq.com
;时间：20210407

; 按下 Shift 键切换输入法
; EN-英文, CN-中文, A-Caps On
~Shift::
ToolTip
If (IME_GET()=1)
{       
    If GetKeyState("CapsLock","T")
        ToolTip, A
    Else
        ToolTip, EN
}
else
{       
    If GetKeyState("CapsLock","T")
        ToolTip, A
    Else
        ToolTip, CN
}
return
 
 ; 鼠标左键按下，且为工形图标，判定为文本输入模式
 ; 显示 Tooltips
~LButton::
If  (A_Cursor = "IBeam" ) 
{
	Edit_Mode := 1
} 
Else if(A_Cursor = "Arrow" ) 
{
   Edit_Mode := 0
} 
MouseGetPos, , , WhichWindow, WhichControl
WinGetPos,winx,winy,,,%WhichWindow%
ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
if ( 0 = not_Edit_InFocus())
{
	If (IME_GET()=1)
    {       
        If GetKeyState("CapsLock","T")
            ToolTip, A
        Else
            ToolTip, CN
    }
	else
    {       
        If GetKeyState("CapsLock","T")
            ToolTip, A
        Else
            ToolTip, EN
    }
}
return

; 按下Ctrl键查询当前状态
~Ctrl::
if ( 0 = not_Edit_InFocus())
{
	If (IME_GET()=1)
    {       
        If GetKeyState("CapsLock","T")
            ToolTip, A
        Else
            ToolTip, CN
    }
	else
    {       
        If GetKeyState("CapsLock","T")
            ToolTip, A
        Else
            ToolTip, EN
    }
}
return
 
 ; 默认显示时间1.5s
~Shift up::
~Lbutton up::
~CapsLock up::
~Ctrl up::
Sleep,1500
ToolTip
return
 
not_Edit_InFocus(){
Global Edit_Mode
ControlGetFocus theFocus, A ; 
return  !(inStr(theFocus , "Edit") or  (theFocus = "Scintilla1")
or (theFocus ="DirectUIHWND1") or  (Edit_Mode = 1))
}
 
IME_GET(WinTitle="")
;-----------------------------------------------------------
; “获得 IutMethodEditor 的状态”
;-----------------------------------------------------------
{
    WinGet,hWnd,ID,%WinTitle%
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
 
    ;Message : WM_IME_CONTROL  wParam:IMC_GETOPENSTATUS
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, 0x005,0,,ahk_id %DefaultIMEWnd%
    DetectHiddenWindows,%DetectSave%
    Return ErrorLevel
}
