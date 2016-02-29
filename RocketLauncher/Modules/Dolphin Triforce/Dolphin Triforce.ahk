MEmu = Dolphin Triforce
MEmuV = v4.0-315
MURL = http://forums.dolphin-emu.org/Thread-triforce-mario-kart-arcade-gp2
MAuthor = djvj
MVersion = 2.0.2
MCRC = ED701371
iCRC = DB095374
MID = 635038268885018176
MSystem = "Sega Triforce"
;----------------------------------------------------------------------------
; Notes:
; Dolphin Triforce builds can be found here: https://dolphin-emu.org/download/list/Triforce/
; Go here for Mario Kart GP 2 setup: http://forums.dolphin-emulator.com/showthread.php?tid=23763
; To set fullscreen, set the variabe below
; If you get an error that you are missing a vcomp100.dll, install Visual C++ 2010: http://www.microsoft.com/download/en/details.aspx?id=14632
; Also make sure you are running latest directx: http://www.microsoft.com/downloads/details.aspx?FamilyID=2da43d38-db71-4c1b-bc6a-9b6652cd92a3
; Render to Main Window needs to be unchecked. This is done for you if you forget.
; If you get Unknown DVD Command errors, the game is not compatible with the emu. Try a different game.
;----------------------------------------------------------------------------
StartModule()
BezelGui()
FadeInStart()

settingsFile := modulePath . "\" . moduleName . ".ini"
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
HideMouse := IniReadCheck(settingsFile, "Settings", "HideMouse","true",,1)				; hides mouse cursor in emu

BezelStart()

dolphinINIPath := A_MyDocuments . "\Dolphin Emulator\Config\Dolphin.ini"	; location of Dolphin.ini for v4.0+
dolphinINIOldPath := emuPath . "\User\Config\Dolphin.ini"	; location of Dolphin.ini prior to v4.0
dolphinINI := CheckFile(If FileExist(dolphinINIOldPath) ? dolphinINIOldPath : dolphinINIPath, "Could not find your Dolphin.ini in either of these folders. Please run Dolphin manually first to create it.`n" . dolphinINIOldPath . "`n" . dolphinINIPath)
Fullscreen := If ( Fullscreen = "true" ) ? ("True") : ("False")

gcSerialPort := 6	; this puts the AM-Baseboard into the serial port. If previous launch was Gamecube or Wii, BBU would be set here and would result in Unknown DVD command errors

; Compare existing settings and if different than desired, write them to the emulator's ini
IniWrite(Fullscreen, dolphinINI, "Display", "Fullscreen", 1)
IniWrite(renderToMain, dolphinINI, "Display", "RenderToMain", 1)
IniWrite(HideMouse, dolphinINI, "Interface", "HideCursor", 1)
IniWrite(gcSerialPort, dolphinINI, "Core", "SerialPort1", 1)

7z(romPath, romName, romExtension, sevenZExtractPath)

Run(executable . " /b /e """ . romPath . "\" . romName . romExtension . """", emuPath)

WinWait("Dolphin ahk_class wxWindowNR")
WinWaitActive("Dolphin ahk_class wxWindowNR")
BezelDraw()

FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


CloseProcess:
	FadeOutStart()
	WinClose("FPS ahk_class wxWindowNR") ; this needs to close the window the game is running in otherwise dolphin crashes on exit
Return
