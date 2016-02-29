MEmu = Citra
MEmuV = 2015-08-01
MURL = http://citra-emu.org/
MAuthor = djvj
MVersion = 1.0
MCRC = C433D6FB
iCRC = 
mId = 635740704032217117
MSystem = "Nintendo 3DS"
;------------------------------------------------------------------------
; Notes:
; Roms must be decrypted to run in the emu
; See here for a guide on decrypting games you own: https://gbatemp.net/threads/tutorial-how-to-decrypt-extract-rebuild-3ds-roms-run-xy-oras-without-update.383055/
;------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

; settingsFile := modulePath . "\" . moduleName . ".ini"
; Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)	

BezelStart()
hideEmuObj := Object("Select ahk_class ConsoleWindowClass",0,"Citra ahk_class GLFW30",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, 7zExtractPath)

HideEmuStart()
Run(executable . " """ . romPath . "\" . romName . romExtension . " """, emuPath)

WinWait("Citra ahk_class GLFW30")
WinWaitActive("Citra ahk_class GLFW30")

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


CloseProcess:
	FadeOutStart()
	WinClose("Citra ahk_class GLFW30")
Return
