MEmu = Snes9X (-sx2)
MEmuV =  v1.53 (v0.2)
MURL = http://www.snes9x.com/ (http://bsxproj.superfamicom.org/)
MAuthor = djvj, brolly
MVersion = 2.0.4
MCRC = E518EA07
iCRC = 398B012D
MID = 635038268923820476
MSystem = "Bandai Sufami Turbo","Nintendo Satellaview","Nintendo Super Famicom","Super Nintendo Entertainment System"
;----------------------------------------------------------------------------
; Notes:
; snes9x adjusts the windowed resolutions in the ini automatically based on the settings you choose in RocketLauncherUI.
; Bezels work, but if you notice a black bar along the bottom, change this option to false in snes9x.conf: ExtendHeight
;
; Bandai Sufami Turbo:
; Make sure you have the stbios.bin file inside the BIOS folder.
; If you are using hacked dumps that also include the bios in the game's rom make sure you enable hackedROM in the module 
; settings. You won't be able to combine roms by using the 2 cart slots though so using proper dumps is advisable.
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

; use a custom systemName ini If it exists
If FileExist(modulePath . "\" . systemName . ".ini")
	settingsFile := modulePath . "\" . systemName . ".ini"
Else
	settingsFile := modulePath . "\" . moduleName . ".ini"

ControlType := IniReadCheck(settingsFile, "Settings|" . romName, "ControlType",0,,1)
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
EmulateFullscreen := IniReadCheck(settingsFile, "Settings", "EmulateFullscreen","true",,1)		; This helps fading look better and work better on exit. You cannot use this with a normal fullscreen so one has to be false
WindowMaximized := IniReadCheck(settingsFile, "Settings", "WindowMaximized","true",,1)
Stretch := IniReadCheck(settingsFile, "Settings", "Stretch","true",,1)
MaintainAspectRatio := IniReadCheck(settingsFile, "Settings", "MaintainAspectRatio","true",,1)
HideMenu := IniReadCheck(settingsFile, "Settings", "HideMenu","true",,1)
FullScreenWidth := IniReadCheck(settingsFile, "Settings", "FullScreenWidth","1024",,1)
FullScreenHeight := IniReadCheck(settingsFile, "Settings", "FullScreenHeight","768",,1)
HackedROM := IniReadCheck(settingsFile, "Settings|" . romName, "HackedROM","false",,1)
CartBrom := IniReadCheck(settingsFile, romName, "CartBrom","",,1)

snes9xConf := CheckFile(emuPath . "\snes9x.conf")

If InStr(systemName,"Satellaview") {
	emuWinClass := "Snes9X-sx2 ahk_class Snes9X: WndClass"	; when booting Satellaview, the window's title changes slightly
	CheckFile(emuPath . "\BIOS\BS-X.bin", "Could not locate the BS-X.bin file that is required to launch Satellaview games. Place it in here: " . emuPath . "\BIOS\BS-X.bin")
} Else
	emuWinClass := "Snes9X ahk_class Snes9X: WndClass"

If (HideMenu = "false")
	disableHideToggleMenu := "true"	; disables Bezel's built-n menu hiding

; cType := Object(0,"Use SNES Joypad(s)",1,"Use SNES Mouse",2,"Use Super Scope",3,"Use Super Multitap (5-Player)",4,"Use Konami Justifier",5,"Use Mouse in alternate port",6,"Use Multitaps (8-Player)",7,"Use Dual Justifiers")
cType := Object(0,40137,1,40105,2,40106,3,40104,4,40109,5,40133,6,40135,7,40134)
snes9xControl := cType[ControlType]	; search object for the ControlType snes9x uses in its input menu
If !snes9xControl
	ScriptError("Your ControlType is set to: " . ControlType . "`nIt is not one of the supported control types. Please set a proper control type in RocketLauncherUI for this system or game.")

;Multicart Setup for Sufami Turbo

MultiCartA := ""
MultiCartB := ""
UseCliBoot := "true"

If InStr(systemName,"Sufami") {
	stBios := emuPath . "\BIOS\stbios.bin"
	CheckFile(stBios)

	If (HackedROM = "false") {
		UseCliBoot := "false"
		MultiCartA := romPath . "\" . romName . romExtension
		If (CartBrom) {
			CheckFile(romPath . "\" . CartBrom)
			MultiCartB := romPath . "\" . CartBrom
		}
		Else {
			MultiCartB := stBios
		}
	}
}

BezelStart()

; Compare existing settings and if different than desired, write them to the emulator's ini
IniWrite(Fullscreen, snes9xConf, "Display\Win", "Fullscreen:Enabled", 1)
IniWrite(EmulateFullscreen, snes9xConf, "Display\Win", "Fullscreen:EmulateFullscreen", 1)
IniWrite(WindowMaximized, snes9xConf, "Display\Win", "Window:Maximized", 1)
IniWrite(Stretch, snes9xConf, "Display\Win", "Stretch:Enabled", 1)
IniWrite(MaintainAspectRatio, snes9xConf, "Display\Win", "Stretch:MaintainAspectRatio", 1)
IniWrite(FullScreenWidth, snes9xConf, "Display\Win", "Fullscreen:Width", 1)
IniWrite(FullScreenHeight, snes9xConf, "Display\Win", "Fullscreen:Height", 1)
IniWrite(HideMenu, snes9xConf, "HideMenu", "HideMenu", 1)
IniWrite(MultiCartA, snes9xConf, "Settings\Win\Files", "Rom:MultiCartA", 1)
IniWrite(MultiCartB, snes9xConf, "Settings\Win\Files", "Rom:MultiCartB", 1)

hideEmuObj := Object(emuWinClass,1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, sevenZExtractPath)

HideEmuStart()
If (UseCliBoot = "true")
	Run(executable . " """ . romPath . "\" . romName . romExtension . """", emuPath)
Else
	Run(executable, emuPath)

WinWait(emuWinClass)
WinWaitActive(emuWinClass)

;Open MultiCart dialog and press OK, this workaround is needed otherwise Sufami games won't work. (Only applies to proper dumps not hacked ones)
If (UseCliBoot = "false") {
	PostMessage, 0x111, 40153,,,%emuWinClass%
	WinWait("Open MultiCart")
	;WinWaitActive("Open MultiCart")
	PostMessage, 0x111, 1,,,Open MultiCart
}

; Change the control type to what's required for this game
; WinMenuSelectItem, %emuWinClass%,, Input, %snes9xControl%
; msgbox 40%snes9xControl%`n%emuWinClass%
PostMessage, 0x111, %snes9xControl%,,,%emuWinClass%

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)
BezelExit()
7zCleanUp()
FadeOutExit()
ExitModule()


RestoreEmu:
	If (bezelEnabled = "true") ; checking if emulator window is on bezel defined coordinates and if not try to move the window (timeout = 3 seconds).
		If (bezelPath) { 
			X:="" , Y:="" , W:="" , H:=""
			timeout := A_TickCount
			Loop {
				WinGetPos, X, Y, W, H, ahk_id %emulatorID%
				If (X = bezelScreenX) and (Y = bezelScreenY) and (W = bezelScreenWidth) and (H = bezelScreenHeight)
					Break
				If (timeout < A_TickCount - 3000)
					Break
				Sleep, 50
				WinMove, ahk_id %emulatorID%,, %bezelScreenX%, %bezelScreenY%, %bezelScreenWidth%, %bezelScreenHeight%
				Sleep, 50
			}
		}
Return

CloseProcess:
	FadeOutStart()
	WinClose(emuWinClass)
Return
