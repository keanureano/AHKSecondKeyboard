applyPreset(preset) {
    Coordmode, Pixel, Window
    Coordmode, Mouse, Window
    Coordmode, Caret, Window
    BlockInput, On
    BlockInput, MouseMove
    SetKeyDelay, 0

    ; saves starting mouse pos
    MouseGetPos, StartX, StartY

    ; stops timeline from playing
    SendInput, ^!+k
    SendInput, ^!+k
    SendInput, {mButton}
    Sleep, 10

    ; selects searchbox from effects panel
    focusPanel("effects")
    SendInput, ^!+f
    Sleep, 5

    ; waits for caret, max 1 second
    waitForCaret := 0
    While (A_CaretX == "")
    {
        waitForCaret++
        Sleep, 10
        If (waitForCaret > 100) {
            ExitApp
        }
    }

    ; moves mouse to caret
    MouseMove, %A_CaretX%, %A_CaretY%, 0
    Sleep, 5

    ; gets CurrentX, CurrentY
    MouseGetPos, IconX, IconY, Window, ClassNN
    WinGetClass, Class, ahk_id %Window%
    ControlGetPos, CurrentX, CurrentY, CurrentWidth, CurrentHeight, %ClassNN%, ahk_class %Class%, SubWindow, SubWindow

    ; moves mouse to magnifying glass
    MouseMove, CurrentX-15, CurrentY+10, 0
    Sleep, 5

    ; types in preset
    SendInput, %preset%

    ; moves mouse to preset icon
    MouseGetPos, IconX, IconY, Window, ClassNN
    WinGetClass, Class, ahk_id%Window%
    MouseMove, 40, 60, 0, R
    Sleep, 5

    ; repositions mouse
    MouseGetPos, IconX, IconY, Window, ClassNN
    WinGetClass, Class, ahk_id %Window%
    ControlGetPos, CurrentX, CurrentY, CurrentWidth, CurrentHeight, %ClassNN%, ahk_class %Class%, SubWindow, SubWindow
    MouseMove, CurrentWidth/4, CurrentHeight/2, 0, R
    MouseClick, Left, , , 1
    MouseMove, IconX, IconY, 0
    Sleep, 5

    ; drags mouse from effect to starting pos
    MouseClickDrag, Left, , , %StartX%, %StartY%, 0
    Sleep, 5
    MouseClick, Middle, , , 10

    ; reenable input
    BlockInput, Off
    BlockInput, MouseMoveOff
}