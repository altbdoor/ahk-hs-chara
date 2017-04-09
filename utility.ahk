WriteSettings(Section, Key, Value) {
	global SettingsFile
	IniWrite, %Value%, %SettingsFile%, %Section%, %Key%
	Return
}

ReadSettings(Section, Key, DefaultValue) {
	global SettingsFile
	
	If (DefaultValue == "") {
		IniRead, Value, %SettingsFile%, %Section%, %Key%, %A_Space%
	}
	Else {
		IniRead, Value, %SettingsFile%, %Section%, %Key%, %DefaultValue%
	}
	
	Return Value
}

JoinArray(Arr, Glue) {
	FinalString := ""
	
	Loop % Arr.Length() {
		FinalString .= Arr[A_Index] . Glue
	}
	
	Return SubStr(FinalString, 1, StrLen(FinalString) - 1)
}

GetComboBoxChoice(TheList, TheCurrent) {
	TheValue := -1
	
	Loop % TheList.Length() {
		If (TheCurrent == TheList[A_Index]) {
			TheValue := A_Index
			Break
		}
	}
	TheList := JoinArray(TheList, "|")
	
	Return {"Index": TheValue, "Choices": TheList}
}

; https://autohotkey.com/board/topic/89793-set-height-of-listbox-rows/
LB_AdjustItemHeight(HListBox, Adjust) {
	Return LB_SetItemHeight(HListBox, LB_GetItemHeight(HListBox) + Adjust)
}

LB_GetItemHeight(HListBox) {
	Static LB_GETITEMHEIGHT := 0x01A1
	SendMessage, %LB_GETITEMHEIGHT%, 0, 0, , ahk_id %HListBox%
	Return ErrorLevel
}

LB_SetItemHeight(HListBox, NewHeight) {
	Static LB_SETITEMHEIGHT := 0x01A0
	SendMessage, %LB_SETITEMHEIGHT%, 0, %NewHeight%, , ahk_id %HListBox%
	WinSet, Redraw, , ahk_id %HListBox%
	Return ErrorLevel
}
