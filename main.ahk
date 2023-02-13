#SingleInstance force
#Persistent
SendMode, Input
SetWorkingDir, %A_ScriptDir%
#Include Lib\AutoHotInterception.ahk
#Include Functions\required.ahk
#Include Functions\applyPreset.ahk
#Include Functions\focusPanel.ahk

AHI := new AutoHotInterception()
keyboardId := AHI.GetKeyboardId(0x0C45, 0x5004)
AHI.SubscribeKeyboard(keyboardId, true, Func("KeyEvent"))
return

KeyEvent(code, state)
{
    key := getKey(code, state)
    ; set Premiere hotkeys here
    IfWinActive, ahk_exe Adobe Premiere Pro.exe
    {
        Switch key
        {
        Case "num1":
            applyPreset("jumpzoom110")
        Case "num2":
            applyPreset("jumpzoom120")
        Case "num3":
            applyPreset("jumpzoom130")
        Case "num4":
            applyPreset("slowzoom110")
        Case "num5":
            applyPreset("slowzoom115")
        Case "num6":
            applyPreset("slowzoom120")
        Case "num7":
            applyPreset("fastzoom110")
        Case "num8":
            applyPreset("fastzoom120")
        Case "num9":
            applyPreset("fastzoom130")
        Case "num0":
            focusPanel("controls")
        }
    }
}

^Esc::
ExitApp