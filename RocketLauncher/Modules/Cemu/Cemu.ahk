MEmu = Cemu
MEmuV = v1.0.0
MURL = https://github.com/Exzap/Cemu
MAuthor = djvj
MVersion = 1.0
MCRC = E4E11E41
iCRC = 
mId = 635803743205902402
MSystem = "Nintendo Wii U"
;----------------------------------------------------------------------------
; Notes:
; Make sure the keys.txt in the emu root folder contains a Wii U common key.
; Do not ask where to get this, it's your job to figure this out.
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

dialogOpen := i18n("dialog.open")	; Looking up local translation
hideEmuObj := Object("Cemu ahk_class wxWindowNR",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, 7zExtractPath)

BezelStart("FixResMode")
HideEmuStart()

Run(executable . " """ . romPath . "\" . romName . romExtension, emuPath)

WinWait("Cemu ahk_class wxWindowNR")
WinWaitActive("Cemu ahk_class wxWindowNR")

; Load image
WinMenuSelectItem,Cemu ahk_class wxWindowNR,,File,Load
OpenROM("Open file to launch", romPath . "\" . romName . romExtension)
WinWaitActive("Cemu ahk_class wxWindowNR")

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
	WinClose("Cemu ahk_class wxWindowNR")
Return
