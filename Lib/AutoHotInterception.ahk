#include %A_LineFile%\..\CLR.ahk

class AutoHotInterception {
	_contextManagers := {}

	__New() {
		bitness := A_PtrSize == 8 ? "x64" : "x86"
		dllName := "interception.dll"
		if (A_IsCompiled){
			dllFile := A_LineFile "\..\Lib\" bitness "\" dllName
			FileCreateDir, Lib
			FileInstall, Lib\AutoHotInterception.dll, Lib\AutoHotInterception.dll
			if (bitness == "x86"){
				FileCreateDir, Lib\x86
				FileInstall, Lib\x86\interception.dll, Lib\x86\interception.dll
			} else {
				FileCreateDir, Lib\x64
				FileInstall, Lib\x64\interception.dll, Lib\x64\interception.dll
			}
		} else {
			dllFile := A_LineFile "\..\" bitness "\" dllName
		}
		if (!FileExist(dllFile)) {
			MsgBox % "Unable to find " dllFile ", exiting...`nYou should extract both x86 and x64 folders from the library folder in interception.zip into AHI's lib folder."
			ExitApp
		}

		hModule := DllCall("LoadLibrary", "Str", dllFile, "Ptr")
		if (hModule == 0) {
			this_bitness := A_PtrSize == 8 ? "64-bit" : "32-bit"
			other_bitness := A_PtrSize == 4 ? "64-bit" : "32-bit"
			MsgBox % "Bitness of " dllName " does not match bitness of AHK.`nAHK is " this_bitness ", but " dllName " is " other_bitness "."
			ExitApp
		}
		DllCall("FreeLibrary", "Ptr", hModule)

		dllName := "AutoHotInterception.dll"
		if (A_IsCompiled){
			dllFile := A_LineFile "\..\Lib\" dllName
		} else {
			dllFile := A_LineFile "\..\" dllName
		}
		hintMessage := "Try right-clicking " dllFile ", select Properties, and if there is an 'Unblock' checkbox, tick it`nAlternatively, running Unblocker.ps1 in the lib folder (ideally as admin) can do this for you."
		if (!FileExist(dllFile)) {
			MsgBox % "Unable to find " dllFile ", exiting..."
			ExitApp
		}

		asm := CLR_LoadLibrary(dllFile)
		try {
			this.Instance := asm.CreateInstance("AutoHotInterception.Manager")
		}
		catch {
			MsgBox % dllName " failed to load`n`n" hintMessage
			ExitApp
		}
		if (this.Instance.OkCheck() != "OK") {
			MsgBox % dllName " loaded but check failed!`n`n" hintMessage
			ExitApp
		}
	}

	GetInstance() {
		return this.Instance
	}

	; --------------- Input Synthesis ----------------
	SendKeyEvent(id, code, state) {
		this.Instance.SendKeyEvent(id, code, state)
	}

	SendMouseButtonEvent(id, btn, state) {
		this.Instance.SendMouseButtonEvent(id, btn, state)
	}

	SendMouseButtonEventAbsolute(id, btn, state, x, y) {
		this.Instance.SendMouseButtonEventAbsolute(id, btn, state, x, y)
	}

	SendMouseMove(id, x, y) {
		this.Instance.SendMouseMove(id, x, y)
	}

	SendMouseMoveRelative(id, x, y) {
		this.Instance.SendMouseMoveRelative(id, x, y)
	}

	SendMouseMoveAbsolute(id, x, y) {
		this.Instance.SendMouseMoveAbsolute(id, x, y)
	}

	SetState(state){
		this.Instance.SetState(state)
	}
	
	MoveCursor(x, y, cm := "Screen", mouseId := -1){
		if (mouseId == -1)
			mouseId := 11 ; Use 1st found mouse
		oldMode := A_CoordModeMouse
		CoordMode, Mouse, % cm
		Loop {
			MouseGetPos, cx, cy
			dx := this.GetDirection(cx, x)
			dy := this.GetDirection(cy, y)
			if (dx == 0 && dy == 0)
				break
			this.SendMouseMove(mouseId, dx, dy)
		}
		CoordMode, Mouse, % oldMode
	}
	
	GetDirection(cp, dp){
		d := dp - cp
		if (d > 0)
			return 1
		if (d < 0)
			return -1
		return 0
	}

	; --------------- Querying ------------------------
	GetDeviceId(IsMouse, VID, PID, instance := 1) {
		static devType := {0: "Keyboard", 1: "Mouse"}
		dev := this.Instance.GetDeviceId(IsMouse, VID, PID, instance)
		if (dev == 0) {
			MsgBox % "Could not get " devType[isMouse] " with VID " VID ", PID " PID ", Instance " instance
			ExitApp
		}
		return dev
	}

	GetDeviceIdFromHandle(isMouse, handle, instance := 1) {
		static devType := {0: "Keyboard", 1: "Mouse"}
		dev := this.Instance.GetDeviceIdFromHandle(IsMouse, handle, instance)
		if (dev == 0) {
			MsgBox % "Could not get " devType[isMouse] " with Handle " handle ", Instance " instance
			ExitApp
		}
		return dev
	}

	GetKeyboardId(VID, PID, instance := 1) {
		return this.GetDeviceId(false, VID, PID, instance)
	}

	GetMouseId(VID, PID, instance := 1) {
		return this.GetDeviceId(true, VID, PID, instance)
	}

	GetKeyboardIdFromHandle(handle, instance := 1) {
		return this.GetDeviceIdFromHandle(false, handle, instance)
	}

	GetMouseIdFromHandle(handle, instance := 1) {
		return this.GetDeviceIdFromHandle(true, handle, instance)
	}

	GetDeviceList() {
		DeviceList := {}
		arr := this.Instance.GetDeviceList()
		for v in arr {
			DeviceList[v.id] := { ID: v.id, VID: v.vid, PID: v.pid, IsMouse: v.IsMouse, Handle: v.Handle }
		}
		return DeviceList
	}

	; ---------------------- Subscription Mode ----------------------
	SubscribeKey(id, code, block, callback, concurrent := false) {
		this.Instance.SubscribeKey(id, code, block, callback, concurrent)
	}

	UnsubscribeKey(id, code){
		this.Instance.UnsubscribeKey(id, code)
	}

	SubscribeKeyboard(id, block, callback, concurrent := false) {
		this.Instance.SubscribeKeyboard(id, block, callback, concurrent)
	}
	
	UnsubscribeKeyboard(id){
		this.Instance.UnsubscribeKeyboard(id)
	}

	SubscribeMouseButton(id, btn, block, callback, concurrent := false) {
		this.Instance.SubscribeMouseButton(id, btn, block, callback, concurrent)
	}

	UnsubscribeMouseButton(id, btn){
		this.Instance.UnsubscribeMouseButton(id, btn)
	}

	SubscribeMouseButtons(id, block, callback, concurrent := false) {
		this.Instance.SubscribeMouseButtons(id, block, callback, concurrent)
	}
	
	UnsubscribeMouseButtons(id){
		this.Instance.UnsubscribeMouseButtons(id)
	}

	SubscribeMouseMove(id, block, callback, concurrent := false) {
		this.Instance.SubscribeMouseMove(id, block, callback, concurrent)
	}

	UnsubscribeMouseMove(id){
		this.Instance.UnsubscribeMouseMove(id)
	}

	SubscribeMouseMoveRelative(id, block, callback, concurrent := false) {
		this.Instance.SubscribeMouseMoveRelative(id, block, callback, concurrent)
	}

	UnsubscribeMouseMoveRelative(id){
		this.Instance.UnsubscribeMouseMoveRelative(id)
	}

	SubscribeMouseMoveAbsolute(id, block, callback, concurrent := false) {
		this.Instance.SubscribeMouseMoveAbsolute(id, block, callback, concurrent)
	}

	UnsubscribeMouseMoveAbsolute(id){
		this.Instance.UnsubscribeMouseMoveAbsolute(id)
	}

	; ------------- Context Mode ----------------
	; Creates a context class to make it easy to turn on/off the hotkeys
	CreateContextManager(id) {
		if (this._contextManagers.HasKey(id)) {
			Msgbox % "ID " id " already has a Context Manager"
			ExitApp
		}
		cm := new this.ContextManager(this, id)
		this._contextManagers[id] := cm
		return cm
	}

	RemoveContextManager(id) {
		if (!this._contextManagers.HasKey(id)) {
			Msgbox % "ID " id " does not have a Context Manager"
			ExitApp
		}
		this._contextManagers[id].Remove()
		this._contextManagers.Delete(id)
		return cm
	}

	; Helper class for dealing with context mode
	class ContextManager {
		IsActive := 0
		__New(parent, id) {
			this.parent := parent
			this.id := id
			result := this.parent.Instance.SetContextCallback(id, this.OnContextCallback.Bind(this))
		}
		
		OnContextCallback(state) {
			Sleep 0
			this.IsActive := state
		}
		
		Remove(){
			this.parent.Instance.RemoveContextCallback(this.id)
		}
	}
}

GetKeyPress(code, state) {
	if (state = 0) {
		return ""
	}
	switch (code) {
	case 82:
		key := "num0"
	case 79:
		key := "num1"
	case 80:
		key := "num2"
	case 81:
		key := "num3"
	case 75:
		key := "num4"
	case 76:
		key := "num5"
	case 77:
		key := "num6"
	case 71:
		key := "num7"
	case 72:
		key := "num8"
	case 73:
		key := "num9"
	case 325:
		key := "numlock"
	case 309:
		key := "num/"
	case 55:
		key := "num*"
	case 74:
		key := "num-"
	case 78:
		key := "num+"
	case 83:
		key := "num."
	case 328:
		key := "up"
	case 336:
		key := "down"
	case 331:
		key := "left"
	case 333:
		key := "right"
	case 1:
		key := "esc"
	case 59:
		key := "f1"
	case 60:
		key := "f2"
	case 61:
		key := "f3"
	case 62:
		key := "f4"
	case 63:
		key := "f5"
	case 64:
		key := "f6"
	case 65:
		key := "f7"
	case 66:
		key := "f8"
	case 67:
		key := "f9"
	case 68:
		key := "f10"
	case 87:
		key := "f11"
	case 88:
		key := "f12"
	case 41:
		key := "~"
	case 2:
		key := "1"
	case 3:
		key := "2"
	case 4:
		key := "3"
	case 5:
		key := "4"
	case 6:
		key := "5"
	case 7:
		key := "6"
	case 8:
		key := "7"
	case 9:
		key := "8"
	case 10:
		key := "9"
	case 11:
		key := "0"
	case 12:
		key := "-"
	case 13:
		key := "="
	case 14:
		key := "back"
	case 15:
		key := "tab"
	case 16:
		key := "q"
	case 17:
		key := "w"
	case 18:
		key := "e"
	case 19:
		key := "r"
	case 20:
		key := "t"
	case 21:
		key := "y"
	case 22:
		key := "u"
	case 23:
		key := "i"
	case 24:
		key := "o"
	case 25:
		key := "p"
	case 26:
		key := "["
	case 27:
		key := "]"
	case 28:
		key := "\"
	case 29:
		key := "lctrl"
	case 30:
		key := "a"
	case 31:
		key := "s"
	case 32:
		key := "d"
	case 33:
		key := "f"
	case 34:
		key := "g"
	case 35:
		key := "h"
	case 36:
		key := "j"
	case 37:
		key := "k"
	case 38:
		key := "l"
	case 39:
		key := ";"
	case 40:
		key := "'"
	case 284:
		key := "enter"
	case 42:
		key := "lshift"
	case 44:
		key := "z"
	case 45:
		key := "x"
	case 46:
		key := "c"
	case 47:
		key := "v"
	case 48:
		key := "b"
	case 49:
		key := "n"
	case 50:
		key := "m"
	case 51:
		key := ","
	case 52:
		key := "."
	case 53:
		key := "/"
	case 310:
		key := "rshift"
	case 29:
		key := "lctrl"
	case 347:
		key := "lwin"
	case 56:
		key := "lalt"
	case 57:
		key := "space"
	case 312:
		key := "ralt"
	case 349:
		key := "rmenu"
	case 285:
		key := "rctrl"
	case 311:
		key := "printscreen"
	case 70:
		key := "scrollock"
	case 69:
		key := "pause"
	case 338:
		key := "insert"
	case 327:
		key := "home"
	case 329:
		key := "pageup"
	case 339:
		key := "delete"
	case 335:
		key := "end"
	case 337:
		key := "pagedown"
	}
	ToolTip % key
	SetTimer, RemoveToolTip, -600
	return key
}

RemoveToolTip:
	ToolTip

