;功能：中、英、大小写输入状态提示
;环境：win10+微软拼音，输入法状态切换用默认的shift键。
;作者：傲慢与偏见zxc, 837449776@qq.com
;时间：20211227

; 按下 Shift 键切换输入法

 DetectHiddenWindows True
~CapsLock::
{
    If GetKeyState("CapsLock","T")
    {
        ToolTip "Caps_On"
    }     
    Else
    {
        ToolTip "Caps_Off"
    }  
    SetTimer () => ToolTip(), -1000
    return
}

Shift::
{
    ToolTip
    mainAction("A", "英", "中")
    return
}

 ; 鼠标左键按下，且为工形图标，判定为文本输入模式
~LButton::
{
    If  (A_Cursor = "IBeam") 
    {
        mainAction("A", "中", "英")
    } 
    return
}

; 按下Ctrl键查询当前状态(只在工形图标下生效，如果想全局生效，可以把判断条件去掉)
~Ctrl::
{
    If  (A_Cursor = "IBeam") 
    {
        mainAction("A", "中", "英")
    }
    return
}

mainAction(p_caps, p_status1, p_status2){
    If (!isEnglishMode())
    {       
        If GetKeyState("CapsLock","T")
        {
            ToolTip p_caps
        }           
        Else
        {
            ToolTip p_status1
        }          
    }
    else
    {       
        If GetKeyState("CapsLock","T")
            ToolTip p_caps
        Else
            ToolTip p_status2
    }
    SetTimer () => ToolTip(), -1000
}

; 可以用于判断微软拼音是否是英文模式
isEnglishMode(){
    hWnd := winGetID("A")
    result := SendMessage(
        0x283, ; Message : WM_IME_CONTROL
        0x001, ; wParam : IMC_GETCONVERSIONMODE
        0, ; lParam ： (NoArgs)
        , ; Control ： (Window)
        ; 获取当前输入法的模式
        ; Retrieves the default window handle to the IME class.
        "ahk_id " DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
    )
    ; DetectHiddenWindows Fasle
    ; 返回值是0表示是英文模式，其他值表明是中文模式
    return result == 0
}