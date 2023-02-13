focusPanel(panel){
    ; resets panel
    SendInput, ^!+7

    ; focus specific panel
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
    Sleep, 10
}