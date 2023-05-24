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
    Sleep, 5

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
            BlockInput, Off
            BlockInput, MouseMoveOff
            return
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
    SendInput, ^!+l

    ; reenable input
    BlockInput, Off
    BlockInput, MouseMoveOff
}

focusPanel(panel){
    SetKeyDelay, 5
    SendInput, ^!+7
    Switch panel
    {
    Case "project":
        Sendinput, ^!+1
    Case "source":
        Sendinput, ^!+2
    Case "timeline":
        Sendinput, ^!+3
    Case "monitor":
        Sendinput, ^!+4
    Case "controls":
        Sendinput, ^!+5
    Case "mixer":
        Sendinput, ^!+6
    Case "effects":
        SendInput, ^!+7
    Case "browser":
        Sendinput, ^!+8
    Case "graphics":
        Sendinput, ^!+9
    Case "captions":
        Sendinput, ^!+0
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
    SendInput, {Tab}{Tab}{Left}

    ; waits for caret, max 1 second
    waitForCaret := 0
    while (A_CaretX == "")
    {
        waitForCaret++
        Sleep, 5
        if (waitForCaret > 200) {
            BlockInput, Off
            BlockInput, MouseMoveOff
            return
        }
    }
    MouseMove, %A_CaretX%, %A_CaretY%

    ; selectMotion
    switch (setting) {
    case "selectMotion":
        MouseClick, Left , -300, -10, , , , R
    }

    ; move back to starting mouse pos
    MouseMove, StartX, StartY

    ; reenable input
    BlockInput, Off
    BlockInput, MouseMoveOff
}

muteProgram(program) {
    Run, nircmd muteappvolume %program% 2
    ToolTip, toggled volume %program%
}