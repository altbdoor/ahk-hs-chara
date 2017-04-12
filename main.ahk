#NoEnv
#NoTrayIcon
SendMode Input
SetWorkingDir %A_ScriptDir%

#SingleInstance force
; #MaxThreadsPerHotkey 2

#Include utility.ahk
#Include message.ahk

SettingsFile := A_ScriptDir . "/settings.ini"

CharaFolderValue := ReadSettings("settings", "charafolder", "C:\illusion\HoneySelect\UserData\chara\female")
SavedInfoValue := ReadSettings("settings", "savedinfo", 0)
UnsortedFolderName := "__unsorted__"
ActiveFolderValue := ReadSettings("settings", "activefolder", UnsortedFolderName)

; ========================================

GUI:
	Gui, Font, s10, Arial
	
	Gui, Add, Tab3, x1 y1 w460 h280 hwndHTabs, Main||Help|About
	SendMessage, TCM_SETMINTABWIDTH := 0x1331, 0, 100, , ahk_id %HTabs%
	
	Gui, Add, Text, x10 y30, Character Folder:
	Gui, Add, Edit, w370 h24 x10 yp+20 vCharaFolder, %CharaFolderValue%
	Gui, Add, Button, w70 h24 xp+370 gBrowseCharaFolder, Browse
	Gui, Add, Button, Default Center w160 h30 x150 yp+30 gScanCharaFolder, Scan Folder
	
	Gui, Add, Text, w440 x10 yp+40 0x10
	
	Gui, Add, Text, x10 yp+10, Available Folders:
	Gui, Add, ListBox, w290 h120 x10 yp+18 hwndHFolderChoice vFolderChoice +0x0100
	Gui, Add, Text, w130 xp+310 yp-18, Active Folder:
	Gui, Add, Text, w130 r1 xp+0 yp+18 vActiveFolder +0x4000, %ActiveFolderValue%
	
	If (ActiveFolderValue == UnsortedFolderName) {
		GuiControl, , ActiveFolder, No folder activated
	}
	LB_AdjustItemHeight(HFolderChoice, 15)
	
	Gui, Add, Button, w130 h30 xp+0 yp+30 gActivateFolder, Activate
	Gui, Add, Button, w130 h30 xp+0 yp+35 gRevertFolder, Revert
	
	Gui, Tab, Help
	Gui, Add, Edit, x10 y30 w440 h240 -E0x200 ReadOnly VScroll, %HelpMessage%
	
	Gui, Tab, About
	Gui, Add, Edit, x10 y30 w440 h240 -E0x200 ReadOnly VScroll, %AboutMessage%
	
	Gui, Margin, 0, 0
	Gui, Show, Center w460, AHK HS Chara v%AppVersion%
	
	If (SavedInfoValue == 1) {
		Gosub, ScanCharaFolder
	}
Return

BrowseCharaFolder:
	FileSelectFile, SelectCharaFolder, , C:\, Please select a card in the character folder
	SelectCharaFolder := RegExReplace(SelectCharaFolder, "\\[^\\]+?$", "")
	
	If (SelectCharaFolder != "") {
		GuiControl, , CharaFolder, %SelectCharaFolder%
	}
Return

ScanCharaFolder:
	Gui, Submit, NoHide
	If (!FileExist(CharaFolder)) {
		MsgBox, 0x30, Error, The character folder does not exist!
	}
	Else {
		WriteSettings("settings", "savedinfo", 1)
		WriteSettings("settings", "charafolder", CharaFolder)
		
		UnsortedFolder := CharaFolder . "\" . UnsortedFolderName
		If (!FileExist(UnsortedFolder)) {
			FileCreateDir, %UnsortedFolder%
		}
		
		CharaFolderList := []
		Loop, Files, %CharaFolder%\*, D
		{
			If (A_LoopFileName != UnsortedFolderName) {
				CharaFolderList.Insert(A_LoopFileName)
			}
		}
		
		Temp := GetComboBoxChoice(CharaFolderList, ActiveFolderValue)
		GuiControl, , FolderChoice, % "|" . Temp["Choices"]
		
		If (Temp["Index"] != -1) {
			GuiControl, Choose, FolderChoice, % Temp["Index"]
		}
		Else If (Temp["Index"] == -1 && ActiveFolderValue != UnsortedFolderName) {
			MsgBox, 0x30, Error, The active folder ("%ActiveFolderValue%") has been renamed or deleted! Please proceed with caution!
			WriteSettings("settings", "activefolder", UnsortedFolderName)
			GuiControl, , ActiveFolder, No folder activated
			ActiveFolderValue := UnsortedFolderName
		}
	}
Return

MoveFolderContent(CharaFolder, OldActivatedFolder, NewActivatedFolder) {
	global UnsortedFolderName, ActiveFolderValue
	
	If (!FileExist(CharaFolder . "\" . OldActivatedFolder) || !FileExist(CharaFolder . "\" . NewActivatedFolder)) {
		MsgBox, 0x30, Error, Directory structure has changed! Please rescan the folder.
	}
	Else {
		FileMove, %CharaFolder%\*.png, %CharaFolder%\%OldActivatedFolder%
		FileMove, %CharaFolder%\*.txt, %CharaFolder%\%OldActivatedFolder%
		
		FileMove, %CharaFolder%\%NewActivatedFolder%\*.png, %CharaFolder%
		FileMove, %CharaFolder%\%NewActivatedFolder%\*.txt, %CharaFolder%
		
		WriteSettings("settings", "activefolder", NewActivatedFolder)
		If (NewActivatedFolder == UnsortedFolderName) {
			GuiControl, , ActiveFolder, No folder activated
		}
		Else {
			GuiControl, , ActiveFolder, %NewActivatedFolder%
		}
		
		ActiveFolderValue := NewActivatedFolder
	}
}

ActivateFolder:
	Gui, Submit, NoHide
	If (FolderChoice == "") {
		MsgBox, 0x30, Error, Please select a folder to activate!
	}
	Else If (ActiveFolderValue != FolderChoice) {
		MoveFolderContent(CharaFolder, ActiveFolderValue, FolderChoice)
	}
Return

RevertFolder:
	Gui, Submit, NoHide
	If (ActiveFolderValue != UnsortedFolderName) {
		MoveFolderContent(CharaFolder, ActiveFolderValue, UnsortedFolderName)
	}
	Else {
		MsgBox, 0x30, Error, There is nothing to revert!
	}
Return

F11::Reload

GuiClose:
	ExitApp
Return
