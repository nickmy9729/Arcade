MEmu = Meka
MEmuV =  v0.73
MURL = http://www.smspower.org/meka/|http://www.smspower.org/forums/13019
MAuthor = djvj
MVersion = 2.0.2
MCRC = CF82161E
iCRC = D7EB06D1
MID = 635038268904964785
MSystem = "Samsung Gam Boy","Sega Game Gear","Sega Master System","Othello Multivision"
;----------------------------------------------------------------------------
; Notes:
; Use Meka Configurator 0.73 to configure Meka, it has options that you cannot access in Meka itself
; In Meka Configurator, set these options:
; Input->General, check "Cabinet Mode" (this makes ESC exit the emu instead of F10)
; GUI, uncheck "Start in GUI" so we don't see this when the rom loads
; Blitter->MekaW, fullscreen, check "Stretch" to make the use your entire screen (aspect stays correct on widescreen monitors). Set your Resolution and your Blitter mode while you are here
; Blitter->MekaW, windowed, check "Stretch" to make the emulator use your entire windowed screen (required when using a bezel)
; Emulation, uncheck "Show BIOS logo" if you don't want to see the BIOS everytime
; Messages, uncheck "Show messages in fullscreen mode" if you don't want to see the game's name when you launch a rom
; Emu requires msvcr71.dll to be installed or at least exist in the emu's folder. It is part of the Microsoft C Runtime library
;
; Note: Sound is slightly broken up compared to Fusion
;
; This module also works with the latest v0.80 beta versions.
; Latest MEKA v0.80 Beta versions had the window title changed, so if you are using those you should change the WindowTitle setting in RLUI to "MEKA - In Pixels We Trust!"
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

settingsFile := modulePath . "\" . moduleName . ".ini"
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
bezelBottomOffset := IniReadCheck(settingsFile, "Settings", "bezelBottomOffset","28",,1)
bezelRightOffset := IniReadCheck(settingsFile, "Settings", "bezelRightOffset","6",,1)
WindowTitle := IniReadCheck(settingsFile, "Settings" . "|" . romName, "WindowTitle","MEKA ahk_class AllegroWindow",,1)

BezelStart("fixResMode")
7z(romPath, romName, romExtension, 7zExtractPath)

mekaFile := CheckFile(emuPath . "\mekaW.cfg")
FileRead, mekaCfg, %mekaFile%

mekaCfg := regexreplace(mekaCfg,"video_game_blitter.*","video_game_blitter = " . (If Fullscreen = "true" ? "Fullscreen" : "Windowed")) ; setting fullscreen or windowed resolution
SaveFile(mekaCfg, mekaFile)

Run(executable . " """ . romPath . "\" . romName . romExtension . """", emuPath, "Hide")

WinWait(WindowTitle)
WinWaitActive(WindowTitle)

BezelDraw()
FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


SaveFile(text,file) {
	FileDelete, %file%
	FileAppend, %text%, %file%
}
	
CloseProcess:
	FadeOutStart()
	WinClose(WindowTitle)
Return
