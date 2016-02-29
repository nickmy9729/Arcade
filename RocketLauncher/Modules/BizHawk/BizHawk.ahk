MEmu = BizHawk
MEmuV =  v1.9.4
MURL = http://tasvideos.org/Bizhawk.html
MAuthor = djvj
MVersion = 2.0.7
MCRC = 76935CA1
iCRC = 12C7D203
MID = 635146140449648195
MSystem = "Atari 2600","Atari 7800","Atari Lynx","Bandai Wonderswan","Bandai Wonderswan Color","ColecoVision","NEC PC Engine","NEC PC Engine-CD","NEC SuperGrafx","NEC TurboGrafx-16","NEC TurboGrafx-CD","Nintendo 64","Nintendo Entertainment System","Nintendo Famicom","Nintendo Famicom Disk System","Nintendo Game Boy","Nintendo Game Boy Advance","Nintendo Game Boy Color","Nintendo Super Game Boy","Samsung Gam Boy","Sega CD","Sega Game Gear","Sega Genesis","Sega SG-1000","Sega Master System","Sega Saturn","Super Nintendo Entertainment System","Texas Instruments TI-83"
;----------------------------------------------------------------------------
; Notes:
; When not using bezels, in order for Fullscreen to resume from Pause, Bizhawk must be set to its default fullscreen key of Alt+Enter
; Available CLI commands can be found @ http://tasvideos.org/Bizhawk/CommandLine.html
; Many systems require the firmware to exist in the emu's Firmware subfolder. If one of these system's cannot find the firmware, Bizhawk will error out telling you so.
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

; This object controls how the module reacts to different systems. BizHawk can play a lot of systems, and each system changes the window title. Without knowing this title, the module doesn't know when the emu finished loading
mType := Object("Atari 2600","Atari 2600","Atari 7800","Atari 7800","Atari Lynx","Lynx","Bandai Wonderswan","WonderSwan","Bandai Wonderswan Color","WonderSwan","ColecoVision","ColecoVision","NEC PC Engine","TurboGrafx-16","NEC PC Engine-CD","TurboGrafx-16 (CD)","NEC SuperGrafx","SuperGrafx","NEC TurboGrafx-16","TurboGrafx-16","NEC TurboGrafx-CD","TurboGrafx-16 (CD)","Nintendo 64","Nintendo 64","Nintendo Entertainment System","NES","Nintendo Famicom","NES","Nintendo Famicom Disk System","NES","Nintendo Game Boy","Gameboy","Nintendo Game Boy Advance","Gameboy Advance","Nintendo Game Boy Color","Gameboy Color","Nintendo Super Game Boy","Gameboy","Samsung Gam Boy","Sega Master System","Sega CD","Genesis","Sega Game Gear","Game Gear","Sega Genesis","Genesis","Sega Master System","Sega Master System","Sega Mega Drive","Genesis","Sega Saturn","Saturn","Sega SG-1000","SG-1000","Super Nintendo Entertainment System","SNES","Texas Instruments TI-83","TI-83")
ident := mType[systemName]	; search object for the systemName identifier MESS uses
If !ident
	ScriptError("Your systemName is: " . systemName . "`nIt is not one of the known supported systems for this " . moduleName . " module")

hideEmuObj := Object(ident,1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, sevenZExtractPath)

If (romExtension != ".cue" && (systemName = "Sega Saturn" || systemName = "NEC PC Engine-CD" || systemName = "NEC PC Engine-CD"))
	ScriptError("You are trying to send a """ . romExtension . """ to " . MEmu . " when it only supports ""cue"" extensions")

defaultsgbMode := If SystemName = "Nintendo Super Game Boy" ? "true" : "false"

settingsFile := modulePath . "\" . moduleName . ".ini"
fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
bezelTopOffset := IniReadCheck(settingsFile, "Settings", "bezelTopOffset",54,,1)
bezelBottomOffset := IniReadCheck(settingsFile, "Settings", "bezelBottomOffset",8,,1)
bezelLeftOffset := IniReadCheck(settingsFile, "Settings", "bezelLeftOffset",8,,1)
bezelRightOffset := IniReadCheck(settingsFile, "Settings", "bezelRightOffset",8,,1)
sgbMode := IniReadCheck(settingsFile, systemName . "|" . romName, "SuperGameBoyMode",defaultsgbMode,,1)
BarcodeReaderHotkey := IniReadCheck(settingsFile, systemName, "BarcodeReaderHotkey","",,1)

If (ident = "NES" && BarcodeReaderHotkey) {
	BarcodeReaderHotkey := xHotKeyVarEdit(BarcodeReaderHotkey,"BarcodeReaderHotkey","~","Add")
	xHotKeywrapper(BarcodeReaderHotkey,"BarcodeReader")
}

BezelStart()

bizFullscreen := If fullscreen = "true" ? " --fullscreen" : "" ;" --chromeless"		; chromeless makes it impossible for ahk to detect a title from the emu and therefore cannot be used

bizhawkFile := CheckFile(emuPath . "\config.ini")
bizHawkCfg := LoadProperties(bizhawkFile)
currentDisplayStatusBar := ReadProperty(bizHawkCfg,"""DisplayStatusBar""",":")
If (bezelEnabled = "true" && currentDisplayStatusBar = "true,") {
	WriteProperty(bizHawkCfg,"""DisplayStatusBar""","false,",,,":")	; turn status bar off, this only covers the bottom bar though
	saveBizhawkCfg := 1
}

If (systemName = "Nintendo Super Game Boy" || systemName = "Nintendo Game Boy")
{	currentSGBMode := ReadProperty(bizHawkCfg,"""GB_AsSGB""",":")
	If (sgbMode != "true" And currentSGBMode = "true,") {
		WriteProperty(bizHawkCfg,"""GB_AsSGB""","false,",,,":")	; turn SGBMode off
		saveBizhawkCfg := 1
	} Else If (sgbMode = "true" And currentSGBMode = "false,") {
		WriteProperty(bizHawkCfg,"""GB_AsSGB""","true,",,,":")		; turn SGBMode on
		saveBizhawkCfg := 1
	}
	If (sgbMode = "true")	; When SGB is enabled, BizHawk uses "SNES" in the win title instead of "Game Boy"
		ident := "SNES"
}

If saveBizhawkCfg
	SaveProperties(bizhawkFile,bizHawkCfg)

HideEmuStart()
Run(executable . " """ . romPath . "\" . romName . romExtension . """" . bizFullscreen, emuPath)

WinWait(ident)

If (systemName := "Nintendo 64")	; for some reason this system doesn't activate correctly and causes Fade to get hung up, forcing activation prevents this
	WinActivate % ident

WinWaitActive(ident)

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


SaveBizHawkFile(text,file) {
	FileDelete, %file%
	FileAppend, %text%, %file%
}

BarcodeReader:
	Log("Module - Enabling Barcode Reader Dialog")
	;WinMenuSelectItem, %ident%,, NES, Barcode Reader ;This doesn't seem to work
	SendCommand("{Alt Down}n{Alt Up}b")
Return

BezelLabel:
	disableHideTitleBar := "true"
	disableHideToggleMenu := "true"
	disableHideBorder := "true"
Return

HaltEmu:
	If BarcodeReaderHotkey
		XHotKeywrapper(BarcodeReaderHotkey,"BarcodeReader","OFF")
Return

RestoreEmu:
	; WinMenuSelectItem does not work and & Winspector Spy msgs do not give any sign of WM_COMMAND used in this emu
	WinSet, Transparent, On, %ident%	; helps eliminate flashing of emu window when resuming, not 100% of the time though, but good enough
	WinActivate, %ident%
	If (Fullscreen = "true")
	{	Send, !{Enter}
		Sleep, 100
		Send, !{Enter}
	}
	WinSet, Transparent, Off, %ident%
	If BarcodeReaderHotkey
		XHotKeywrapper(BarcodeReaderHotkey,"BarcodeReader","ON")
Return

CloseProcess:
	FadeOutStart()
	WinClose(ident)
Return
