MEmu = UNZ
MEmuV = v0.5L30
MURL = http://townsemu.world.coocan.jp/
MAuthor = djvj
MVersion = 2.0.3
MCRC = 7FE13B92
iCRC = 1E716C97
MID = 635038268929715384
MSystem = "Fujitsu FM Towns"
;----------------------------------------------------------------------------
; Notes:
; Make sure your Virtual_Drive_Path in RocketLauncherUI General Settings is correct as it is required.
; Run UNZ manually and in Settings->Property->CD-ROM1->Emulation Type->Select drive, set your virtual drive letter
; There is no way of launching the game automatically from the FM-Towns OS window.
; To launch the game, double click the game's name once you are in the FM-Towns OS
; View->Fullscreen to enable fullscreen
; If a game requires a boot disk or user disk, just put it on the same folder as your game and name it
; with the rom name with an hdm extension.
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

settingsFile := modulePath . "\" . moduleName . ".ini"
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)

hideEmuObj := Object("Open diskimage ahk_class #32770",0,"UNZ ahk_class Unz",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, 7zExtractPath)

BezelStart("fixResMode")

fullscreen := If (Fullscreen = "true")?" -fs":""

diskFile := romPath "\" . romName . ".hdm"

VirtualDrive("mount",romPath . "\" . romName . romExtension)

HideEmuStart()
Run(executable . fullscreen,emuPath)

WinWait("UNZ ahk_class Unz")
WinWaitActive("UNZ ahk_class Unz")

If FileExist(diskFile)
{
	Sleep,500
	PostMessage, 0x111, 40005,,,UNZ ahk_class Unz
	OpenROM("Open diskimage ahk_class #32770", diskFile)
}

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose",executable)
VirtualDrive("unmount")
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


HaltEmu: 
	Send, {F11} 
	Sleep, 200 
Return 

RestoreEmu: 
	WinRestore, ahk_ID %emulatorID% 
	IfWinNotActive, ahk_class %EmulatorClass%,,%frontendWinTitle%
		Loop {
			Sleep, 50 
			WinActivate, ahk_class %EmulatorClass%,,%frontendWinTitle% 
			IfWinActive, ahk_class %EmulatorClass%,,%frontendWinTitle% 
			Break 
		} 
	Send, {F11} 
Return

CloseProcess:
	FadeOutStart()
	WinClose("UNZ ahk_class Unz")
Return
