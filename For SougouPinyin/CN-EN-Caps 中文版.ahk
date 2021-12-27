;功能：中、英、大小写输入状态提示
;环境：win10+搜狗输入法正式版，输入法状态切换用默认的shift键。
;作者：傲慢与偏见zxc, 837449776@qq.com
;时间：20210407
 
; 按下 Shift 键切换输入法
; EN-英文, CN-中文, A-Caps On
CN := chr(20013)
EN := chr(33521)
 
~CapsLock::
{
    If GetKeyState("CapsLock","T")
        ToolTip, Caps_On
    Else
        ToolTip, Caps_Off
    SetTimer, RemoveToolTip, -1000
    return
}

Shift::
{
    mainAction("A", EN, CN)
    return
}
 
 ; 鼠标左键按下，且为工形图标，判定为文本输入模式
~LButton::
{
    mainAction("A", CN, EN)
    return
}

; 按下Ctrl键查询当前状态
~Ctrl::
{
    mainAction("A", CN, EN)
    return
}

mainAction(p_caps, p_status1, p_status2)
{
    If  (A_Cursor = "IBeam") 
    {
        If (IME_GET()=1)
        {       
            If GetKeyState("CapsLock","T")
                ToolTip, %p_caps%
            Else
                ToolTip, %p_status1%
        }
        else
        {       
            If GetKeyState("CapsLock","T")
                ToolTip, %p_caps%
            Else
                ToolTip, %p_status2%
        }
    }
    SetTimer, RemoveToolTip, -1000
}

RemoveToolTip:
ToolTip
return
 
IME_GET(WinTitle="")
;-----------------------------------------------------------
; “获得 Input Method Editors 的状态”
;-----------------------------------------------------------
{
    ifEqual WinTitle,,  SetEnv,WinTitle,A
    WinGet,hWnd,ID,%WinTitle%
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
 
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, 0x005,0,,ahk_id %DefaultIMEWnd%
    DetectHiddenWindows,%DetectSave%
    Return ErrorLevel
}