;@etofok 07/02/2021
;revision v2 02/06/2024

#NoEnv
#Persistent
#SingleInstance

#Include misc\VA.ahk
#Include Settings.ahk

SetWorkingDir %A_ScriptDir%
Global currentVersion 						:= 	"Toggle All Microphones `n`nby etofok"

Global b_Microphones
Global b_Sound
Global b_Tooltip

;--------------------------------
; Set Hotkeys and Tooltips
;--------------------------------

if (Hotkey_ToggleAllMicrophonesOnOff) {
	Hotkey, %Hotkey_ToggleAllMicrophonesOnOff%, 	ToggleAllMicrophonesOnOff, 		UseErrorLevel
	Tooltip_Hotkey_ToggleAllMicrophonesOnOff 		:= " (" . ReplaceModifiers(Hotkey_ToggleAllMicrophonesOnOff) . ")"
}

if (Hotkey_ScriptReload) {
	Hotkey, %Hotkey_ScriptReload%,					ScriptReload, 					UseErrorLevel	
	Tooltip_Hotkey_ScriptReload 					:= " (" . ReplaceModifiers(Hotkey_ScriptReload) . ")"
}

;--------------------------------
; Get user launch preferences from Settings.ahk
;--------------------------------

if (Start_with_All_Microphones_Enabled 	= True) {
	b_Microphones 	:= True
} else {
	b_Microphones 	:= False
}

if (Start_with_AlertSounds_Enabled 	= True) {
	b_Sound 	:= True
} else {
	b_Sound 	:= False
}

if (Start_with_Tooltips_Enabled 		= True) {
	b_Tooltip 	:= True
} else {
	b_Tooltip 	:= False
}

;--------------------------------
; Dynamic Tray Menu Labels
;--------------------------------

Global traymenu_Microphones_On 		:= "Double-Click to Turn On" . Tooltip_Hotkey_ToggleAllMicrophonesOnOff
Global traymenu_Microphones_Off		:= "Double-Click to Turn Off" . Tooltip_Hotkey_ToggleAllMicrophonesOnOff

Global traymenu_Beeps_On 			:= "Sound: On"
Global traymenu_Beeps_Off 			:= "Sound: Off"

Global traymenu_Tooltip_On 			:= "Tooltip: On"
Global traymenu_Tooltip_Off			:= "Tooltip: Off"

;--------------------------------
; Set Tray Menu
;--------------------------------

Menu, Tray, NoStandard
Menu, Tray, Tip, Toogle All Microphones by etofok

Menu, Tray, Insert, 1&, 	%currentVersion%,							ScriptHotkeys
Menu, Tray, Disable, 	 	%currentVersion%
Menu, Tray, Add, 			etofok Link Tree >>,						LinkTree
Menu, Tray, Default, 		etofok Link Tree >>
Menu, Tray, Add, 			

if (b_Microphones == True) {
	Menu, Tray, Add, 			%traymenu_Microphones_On%,				ToggleAllMicrophonesOnOff
	Menu, Tray, Default, 	 	%traymenu_Microphones_On%
}

if (b_Microphones == False) {
	Menu, Tray, Add, 			%traymenu_Microphones_Off%,				ToggleAllMicrophonesOnOff
	Menu, Tray, Default, 	 	%traymenu_Microphones_Off%
}

if (b_Sound == True) {
	Menu, Tray, Add, 			%traymenu_Beeps_On%,					Toggle_beepSound
	Menu, Tray, ToggleCheck, 	%traymenu_Beeps_On%
}

if (b_Sound == False) {
	Menu, Tray, Add, 			%traymenu_Beeps_Off%,					Toggle_beepSound
}

if (b_Tooltip == True) {
	Menu, Tray, Add, 			%traymenu_Tooltip_On%,					Toggle_showTooltip
	Menu, Tray, ToggleCheck, 	%traymenu_Tooltip_On%
}

if (b_Tooltip == False) {
	Menu, Tray, Add, 			%traymenu_Tooltip_Off%,					Toggle_showTooltip
}


Menu, Tray, Add, 			
Menu, Tray, Add, 			Settings,									ScriptHotkeys
Menu, Tray, Add, 			
Menu, Tray, Add, 			Open Folder, 								ScriptFolder
Menu, Tray, Add, 			Reload %Tooltip_Hotkey_ScriptReload%,		ScriptReload
Menu, Tray, Add, 			Exit, CloseApp




;--------------------------------
; Welcome Splash
;--------------------------------

SplashTextOn, 250, 90, , %currentVersion%
Sleep, 1000
SplashTextOff

;--------------------------------
; Autolaunch
;--------------------------------

if (b_Microphones == True) {
	TurnAllMicrophonesOn() 
	return
}

if (b_Microphones == False) {
	TurnAllMicrophonesOff()
	return
}


Return

; end of autolaunch
;--------------------------------


;--------------------------------
; Toggle Microphone On / Off
;--------------------------------

ToggleAllMicrophonesOnOff() {

	if (b_Microphones == False) {
		TurnAllMicrophonesOn()
		return
	}

	if (b_Microphones == True) {
		TurnAllMicrophonesOff()
		return
	}
}

TurnAllMicrophonesOn() {

	if (b_Sound == True) {
		SoundPlay,  %A_ScriptDir%\misc\sounds\On.wav
	}

	if (b_Tooltip == True) {
    	ShowTooltipAtCursor("Active!")
	}

	LoopDevices(0)

	Menu, Tray, Icon, %A_ScriptDir%\misc\icons\icon_On.ico
	Menu, Tray, Rename, %traymenu_Microphones_On%, %traymenu_Microphones_Off%
	Menu, Tray, Check, %traymenu_Microphones_Off%	

	b_Microphones := True

	RemoveTooltip(500)
}

TurnAllMicrophonesOff() {

	if (b_Sound == True) {
		SoundPlay,  %A_ScriptDir%\misc\sounds\Off.wav
	}

	if (b_Tooltip == True) {
    	ShowTooltipAtCursor("Muted!")
	}

	LoopDevices(1)

	Menu, Tray, Icon, %A_ScriptDir%\misc\icons\icon_Off.ico
	Menu, Tray, Rename, %traymenu_Microphones_Off%, %traymenu_Microphones_On%
	Menu, Tray, Uncheck, %traymenu_Microphones_On%

	b_Microphones := False

	RemoveTooltip(500)
}









LoopDevices(OnOff) {
    Loop {
	    mic_state := VA_GetMasterMute("capture:" A_Index)
	    if (mic_state = "")
	        break

	    VA_SetMasterMute(OnOff, "capture:" A_Index)
	    ObjRelease(device)
	}
}



ShowTooltipAtCursor(text) {
    MouseGetPos, xpos, ypos
    ToolTip, %text%, %xpos%, %ypos%
}


RemoveTooltip(ms) {
	Sleep, ms
	ToolTip
}

;--------------------------------
; Toggle Beep sounds On / Off
;--------------------------------

Toggle_beepSound() {

	if (b_Sound == True) {

		b_Sound := False

		Menu, Tray, Rename, %traymenu_Beeps_On%,%traymenu_Beeps_Off%
		Menu, Tray, Uncheck, %traymenu_Beeps_Off%

		SoundBeep(200, 100, 2)
		return
	} 


	if (b_Sound == False) {

		b_Sound := True

		Menu, Tray, Rename, %traymenu_Beeps_Off%,%traymenu_Beeps_On%
		Menu, Tray, Check, %traymenu_Beeps_On%

		SoundBeep(1500, 100, 2)
		return
	}
}

;--------------------------------
; Toggle Tooltips On / Off
;--------------------------------

Toggle_showTooltip() {

	if (b_Tooltip == True) {

		b_Tooltip := False

		Menu, Tray, Rename, %traymenu_Tooltip_On%,%traymenu_Tooltip_Off%
		Menu, Tray, Uncheck, %traymenu_Tooltip_Off%

		SoundBeep(200, 100, 2)
		return
	} 


	if (b_Tooltip == False) {

		b_Tooltip := True

		Menu, Tray, Rename, %traymenu_Tooltip_Off%,%traymenu_Tooltip_On%
		Menu, Tray, Check, %traymenu_Tooltip_On%

		SoundBeep(1500, 100, 2)
		return
	}
}


;---------------------------------
; Quick wrapper for sound beeps
;--------------------------------

SoundBeep(Frequency, Duration, Volume) { 
    SoundGet, MasterVolume
    SoundSet, Volume
    SoundBeep, Frequency, Duration
    SoundSet, MasterVolume
}


CloseApp:
    ExitApp


blank:
	return


;--------------------------------
; Translate Tooltip Hotkeys to Human Language
;--------------------------------

ReplaceModifiers(str) {
    ; Replace symbols with corresponding names
    str := StrReplace(str, "+", "SHIFT + ")		; start with the "+"!
    str := StrReplace(str, "!", "ALT + ")
    str := StrReplace(str, "^", "CTRL + ")
    str := StrReplace(str, "#", "WIN + ")
    return str
}

;--------------------------------
; LinkTree
;--------------------------------

LinkTree:
	Run, https://linktr.ee/etofok
return

;--------------------------------
; Hotkeys.ahk
;--------------------------------

ScriptHotkeys:
	Run, notepad.exe %A_ScriptDir%/Settings.ahk
return

;--------------------------------
; Locate This Script
;--------------------------------

ScriptFolder:
	Run, %a_scriptdir%
return

;--------------------------------
; Reload This Script
;--------------------------------

ScriptReload:
	Reload
return
