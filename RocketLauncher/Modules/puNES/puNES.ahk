MEmu = puNES
MEmuV =  v0.94
MURL = http://forums.nesdev.com/viewtopic.php?t=6928
MAuthor = djvj
MVersion = 2.0.2
MCRC = 822EA5D7
iCRC = 1E716C97
MID = 635038268920657843
MSystem = "Nintendo Entertainment System","Nintendo Famicom"
;----------------------------------------------------------------------------
; Notes:
; Portable mode no longer seems to work in 0.94
; Emu saves settings in C:\Users\USERNAME\Documents\puNES
; Emu seems a bit slow when responding to bezel support, leaving it disabled for now as it needs work
;----------------------------------------------------------------------------
StartModule()
; BezelGUI()
FadeInStart()

settingsFile := modulePath . "\" . moduleName . ".ini"
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)

hideEmuObj := Object("puNES ahk_class QWidget",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, 7zExtractPath)
; BezelStart("FixResMode")

fullscreen := If Fullscreen = "true" ? " -u yes " : " "

HideEmuStart()
Run(executable . fullscreen . """" . romPath . "\" . romName . romExtension . """", emuPath)

WinWait("puNES ahk_class QWidget")
WinWaitActive("puNES ahk_class QWidget")

; BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
; BezelExit()
FadeOutExit()
ExitModule()

CloseProcess:
	FadeOutStart()
	WinClose("puNES ahk_class QWidget")
Return
