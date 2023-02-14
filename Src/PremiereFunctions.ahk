applyPreset(preset) {
    BlockInput, On
    BlockInput, MouseMove
    Coordmode, Pixel, Window
    Coordmode, Mouse, Window
    Coordmode, Caret, Window
    SetKeyDelay, 5
    SetMouseDelay, 5

    ; saves starting mouse pos
    MouseGetPos, StartX, StartY

    ; stops timeline from playing
    SendInput, ^!+k
    SendInput, ^!+k
    SendInput, {mButton}

    ; selects searchbox from effects panel
    focusPanel("effects")
    SendInput, ^!+f

    ; waits for caret, max 1 second
    waitForCaret := 0
    while (A_CaretX == "")
    {
        waitForCaret++
        Sleep, 5
        if (waitForCaret > 200) {
            ExitApp
        }
    }

    ; moves mouse to caret, types preset
    SendInput, {BackSpace}
    MouseMove, %A_CaretX%, %A_CaretY%
    SendInput, %preset%

    ; moves mouse to preset icon, drags it to timeline
    MouseMove, 25, 75, , R
    MouseClickDrag, Left, , , %StartX%, %StartY%
    MouseClick, Middle

    ; reenable input
    BlockInput, Off
    BlockInput, MouseMoveOff
}

focusPanel(panel){
    SetKeyDelay, 5
    SendInput, ^!+7
    Switch panel
    {
    Case "effects":
        SendInput, ^!+7
    Case "controls":
        Sendinput, ^!+5
    Case "timeline":
        Sendinput, ^!+3
    Case "program":
        Sendinput, ^!+4
    Case "source":
        Sendinput, ^!+2
    Case "project":
        Sendinput, ^!+1
    }
}

effectControls(setting) {
    BlockInput, On
    BlockInput, MouseMove
    Coordmode, Pixel, Window
    Coordmode, Mouse, Window
    Coordmode, Caret, Window
    SetKeyDelay, 5
    SetMouseDelay, 5

    ; saves starting mouse pos
    MouseGetPos, StartX, StartY

    ; stops timeline from playing
    SendInput, ^!+k
    SendInput, ^!+k

    ; select effect controls
    focusPanel("controls")
    Send, {Tab}{Tab}{Left}

    ; waits for caret, max 1 second
    waitForCaret := 0
    while (A_CaretX == "")
    {
        waitForCaret++
        Sleep, 5
        if (waitForCaret > 200) {
            ExitApp
        }
    }
    MouseMove, %A_CaretX%, %A_CaretY%

    ; selectMotion
    if (setting = "selectMotion") {
        MouseClick, Left , -300, -10, , , , R
    }

    ; move back to starting mouse pos
    MouseMove, StartX, StartY

    ; reenable input
    BlockInput, Off
    BlockInput, MouseMoveOff
}