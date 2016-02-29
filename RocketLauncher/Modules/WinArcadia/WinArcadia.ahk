iCRC = 3B297FBA
MEmu = WinArcadia
MEmuV =  v24.3
MURL = http://amigan.1emu.net/releases/
MAuthor = brolly
MVersion = 2.0.2
MCRC = A906E9F2
MID = 635038268934589449
MSystem = "Emerson Arcadia 2001","Interton VC 4000"
;----------------------------------------------------------------------------
; Notes:
; The settings are saved by default on a file named WinArcadia.ini inside the Configs folder.
; You can also create different config files per game in that folder 
; and name them to match the roms and those will be used instead of the default WA.CFG one.
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

settingsFile := modulePath . "\" . moduleName . ".ini"

Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
DefaultCfgFile := IniReadCheck(settingsFile, "Settings", "DefaultCfgFile","WinArcadia.ini",,1)
ShowDebugger := IniReadCheck(settingsFile, "Settings", "ShowDebugger","false",,1)
ShowSidebar := IniReadCheck(settingsFile, "Settings", "ShowSidebar","false",,1)
ShowMenuBar := IniReadCheck(settingsFile, "Settings", "ShowMenuBar","false",,1)
ShowMousePointer := IniReadCheck(settingsFile, "Settings", "ShowMousePointer","true",,1)
ShowStatusBar := IniReadCheck(settingsFile, "Settings", "ShowStatusBar","false",,1)
ShowTitleBar := IniReadCheck(settingsFile, "Settings", "ShowTitleBar","true",,1)
ShowToolBar := IniReadCheck(settingsFile, "Settings", "ShowToolBar","false",,1)
ShowScanlines := IniReadCheck(settingsFile, "Settings", "ShowScanlines","false",,1)
WindowedZoomLevel := IniReadCheck(settingsFile, "Settings", "WindowedZoomLevel","3",,1)

romNameCfgFile := emuPath . "\Configs\" . romName . ".ini"
cfgFile := If FileExist(romNameCfgFile) ? (romName . ".ini") : DefaultCfgFile

waFile := CheckFile(emuPath . "\Configs\" . cfgFile)
waIni := LoadProperties(waFile)	; load the config into memory

7z(romPath, romName, romExtension, 7zExtractPath)
BezelStart("fixResMode")

fsPrefix := If Fullscreen = "true" ? "fullscreen_" : "windowed_"

;WriteProperty(waIni, "fullscreen", Fullscreen)
WriteProperty(waIni, fsPrefix . "debugger", If Fullscreen = "true" ? "false" : ShowDebugger)
WriteProperty(waIni, fsPrefix . "sidebar", If Fullscreen = "true" ? "false" : ShowSidebar)
WriteProperty(waIni, fsPrefix . "menubar", If Fullscreen = "true" ? "false" : ShowMenuBar)
WriteProperty(waIni, fsPrefix . "pointer", If Fullscreen = "true" ? "false" : ShowMousePointer)
WriteProperty(waIni, fsPrefix . "statusbar", If Fullscreen = "true" ? "false" : ShowStatusBar)
WriteProperty(waIni, fsPrefix . "titlebar", If Fullscreen = "true" ? "false" : ShowTitleBar)
WriteProperty(waIni, fsPrefix . "toolbar", If Fullscreen = "true" ? "false" : ShowToolBar)
WriteProperty(waIni, "scanlines", ShowScanlines)
WriteProperty(waIni, "size", WindowedZoomLevel)
SaveProperties(waFile,waIni)

fs := If Fullscreen = "true" ? " FULLSCREEN=ON" : " FULLSCREEN=OFF"

Run(executable . " SETTINGS=""" . cfgFile . """" . fs . " FILE=""" . romPath . "\" . romName . romExtension . """", emuPath)

WinWait("ahk_class WinArcadia")
WinWaitActive("ahk_class WinArcadia")

FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()

CloseProcess:
	FadeOutStart()
	WinClose("ahk_class WinArcadia")
Return
