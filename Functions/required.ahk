; all keyboard names and codes, manually typed
global keyCodes := {82:"num0",79:"num1",80:"num2",81:"num3",75:"num4",76:"num5",77:"num6",71:"num7",72:"num8",73:"num9",325:"numlock",309:"num/",55:"num*",74:"num-",78:"num+",83:"num.",328:"up",336:"down",331:"left",333:"right",1:"esc",59:"f1",60:"f2",61:"f3",62:"f4",63:"f5",64:"f6",65:"f7",66:"f8",67:"f9",68:"f10",87:"f11",88:"f12",41:"~",2:"1",3:"2",4:"3",5:"4",6:"5",7:"6",8:"7",9:"8",10:"9",11:"0",12:"-",13:"=",14:"back",15:"tab",16:"q",17:"w",18:"e",19:"r",20:"t",21:"y",22:"u",23:"i",24:"o",25:"p",26:"[",27:"]",43:"\",58:"capslock",30:"a",31:"s",32:"d",33:"f",34:"g",35:"h",36:"j",37:"k",38:"l",39:";",40:"'",284:"enter",42:"lshift",44:"z",45:"x",46:"c",47:"v",48:"b",49:"n",50:"m",51:",",52:".",53:"/",310:"rshift",29:"lctrl",347:"lwin",56:"lalt",57:"space",312:"ralt",349:"rmenu",285:"rctrl",311:"printscreen",70:"scrollock",69:"pause",338:"insert",327:"home",329:"pageup",339:"delete",335:"end",337:"pagedown"}

; gets keyboard name using code
getKey(code, state) {
	if (state = 1) {
		key := keyCodes[code]
		ToolTip % key
		SetTimer, RemoveToolTip, -600
		return key
	}
	else {
		return ""
	}
}

; removes tooltip after x seconds
RemoveToolTip() {
	ToolTip
	return
}