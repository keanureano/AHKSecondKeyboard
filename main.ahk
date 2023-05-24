#SingleInstance force
#Persistent
#Include Lib\AutoHotInterception.ahk
#Include Src\PremiereFunctions.ahk

SendMode, Input
SetWorkingDir, %A_ScriptDir%

AHI := new AutoHotInterception()
keyboardId := AHI.GetKeyboardId(0x0C45, 0x5004)
AHI.SubscribeKeyboard(keyboardId, true, Func("KeyEvent"))

KeyEvent(code, state) {
    key := GetKeyPress(code, state)

    ; set Premiere hotkeys here
    IfWinActive, ahk_exe Adobe Premiere Pro.exe
    {
        switch (key) {
        case "num1":
            applyPreset("jumpzoom105")
        case "num2":
            applyPreset("jumpzoom110")
        case "num3":
            applyPreset("jumpzoom120")
        case "num4":
            applyPreset("slowzoom105")
        case "num5":
            applyPreset("slowzoom110")
        case "num6":
            applyPreset("slowzoom120")
        case "num7":
            applyPreset("fastzoom105")
        case "num8":
            applyPreset("fastzoom110")
        case "num9":
            applyPreset("fastzoom120")
        case "num0":
            effectControls("selectMotion")
        case "enter":
            Send, {Space}
        }
    }
}

^Esc::
ExitApp