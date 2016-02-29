MEmu = SSF
MEmuV =  v0.12 beta R4
MURL = http://www.geocities.jp/mj3kj8o5/ssf/index.html
MAuthor = djvj,brolly
MVersion = 2.1.5
MCRC = EEBE0718
iCRC = 918A4E4C
MID = 635038268924991452
MSystem = "Sega Saturn","Sega ST-V"
;------------------------------------------------------------------------
; Notes:
; Sega Saturn:
; This only works with DTLite, not DTPro
; Make sure your Virtual Drive Path in RocketLauncherUI is correct
; romExtension should be ccd|mds|cue|iso|cdi|nrg
; You MUST set the path to the 3 different region BIOS files in RocketLauncherUI module's settings.
; If you prefer a region-free bios, extract this bios and set all 3 bios paths to this one file: http://theisozone.com/downloads/other-consoles/sega-saturn/sega-saturn-region-free-bios/
; Make sure you have your CDDrive set to whatever number you use for your games. 0 may be your hardware drive, while 1 may be your virtual drive (depending on how many you have). If you get a black screen, try different numbers starting from 0.
; If you keep getting the CD Player BIOS screen, you have the CDDrive variable set wrong below
; If you keep getting the CD Player screen with the message "Game disc unsuitable for this system", you have the incorrect bios set for the region game you are playing and or region is set wrong in the emu options. Or you can just turn off the BIOS below :)
; If your game's region is (USA), you must use a USA bios and set SSF Area Code to "America, Canada Brazil". For (Japan) games, bios must be a Japan one and SSF Area Code set to Japan. Use the same logic for European games. You will only see a black screen if wrong.
; SSF will use your desktop res as the emu's res if Stretch and EnforceAspectRatioFullscreen are both true when in fullscreen mode. If you turn Stretch off, it forces 1024x768 in fullscreen mode if your GPU supports pixel shader 3.0, otherwise it forces 640x480 if it does not.
; If you are getting clipping, set the vSync variable to true below
; For faster MultiGame switching, keep the BIOS off, otherwise you have to "play" the disc each time you switch discs
; Module will attempt to auto-detect the region for your game by using the region tags in parenthesis on your rom file and set SSF to use the appropriate region settings that match.
;
; Shining Force III - Scenario 2 & 3 (Japan) (Translated En) games crash at chapter 4 and when you use Marki Proserpina spell or using the Abyss Wand. Fix may be to use a different bios if this occurs, but this is untested. Read more about it here: http://forums.shiningforcecentral.com/viewtopic.php?f=34&t=14858&start=80
; 
; Custom Config Files:
; You can use custom per game ini files. Just put them in a Configurations folder inside the emulator folder and name them after the rom name. Make sure you also put a file named Default.ini file in there with your default 
; settings so the module can revert back to use those.
;
; Data Cartridges:
; These 2 games used a hardware cart in order to play the games, so the module will mount them if found within the same folder as the cd image and named the same as the xml game name with a "rom" extension.
; Ultraman - Hikari no Kyojin Densetsu (Japan) and King of Fighters '95, The (Europe)
; So something like this must exist: "King of Fighters '95, The (Europe).rom"

; Sega ST-V:
; romExtension should be zip
; Extract the stv110.bin bios into the BIOS folder. Run SSF.exe and goto Option->Option and point ST-V BIOS to this file.
; Set fullscreen mode via the variable below
; If you are getting clipping, set the vSync variable to true below
;
; If it seems like it's taking a long time to load, it probably is. You are going to stare at the black screen while SSF is decoding the roms.
;------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

settingsFile := modulePath . "\" . moduleName . ".ini"
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
UseBIOS := IniReadCheck(settingsFile, "Settings", "UseBIOS","false",,1)
BilinearFiltering := IniReadCheck(settingsFile, "Settings", "BilinearFiltering","true",,1)
WideScreen := IniReadCheck(settingsFile, "Settings", "WideScreen","false",,1)
Stretch := IniReadCheck(settingsFile, "Settings", "Stretch","true",,1)	; default true because SSF will use your desktop res in fullscreen mode as long as EnforceAspectRatioFullscreen is also true
AutoFieldSkip := IniReadCheck(settingsFile, "Settings", "AutoFieldSkip","true",,1)
EnforceAspectRatioWindow := IniReadCheck(settingsFile, "Settings", "EnforceAspectRatioWindow","true",,1)	; enforces aspect even when stretch is true
EnforceAspectRatioFullscreen := IniReadCheck(settingsFile, "Settings", "EnforceAspectRatioFullscreen","true",,1)	; enforces aspect even when stretch is true
FixedWindowResolution := IniReadCheck(settingsFile, "Settings", "FixedWindowResolution","true",,1)
FixedFullscreenResolution := IniReadCheck(settingsFile, "Settings", "FixedFullscreenResolution","false",,1)
VSynchWaitWindow := IniReadCheck(settingsFile, "Settings", "VSynchWaitWindow","true",,1)
VSynchWaitFullscreen := IniReadCheck(settingsFile, "Settings", "VSynchWaitFullscreen","true",,1)
CDDrive := IniReadCheck(settingsFile, "Settings", "CDDrive","1",,1)
defaultRegion := IniReadCheck(settingsFile, "Settings", "DefaultRegion","1",,1)
WindowSize := IniReadCheck(settingsFile, "Settings", "WindowSize","2",,1)
Scanlines := IniReadCheck(settingsFile, "Settings|" . romName, "Scanlines","false",,1)
ScanlineRatio := IniReadCheck(settingsFile, "Settings|" . romName, "ScanlineRatio","70",,1)
usBios := IniReadCheck(settingsFile, "Settings", "USBios","",,1)
euBios := IniReadCheck(settingsFile, "Settings", "EUBios","",,1)
jpBios := IniReadCheck(settingsFile, "Settings", "JPBios","",,1)
worldBios := IniReadCheck(settingsFile, "Settings", "WorldBios","",,1)
SH2enabled := IniReadCheck(settingsFile, romName, "SH2enabled","false",,1)
deleteCachedSettings := IniReadCheck(settingsFile, "Settings|" . romName, "DeleteCachedSettings","false",,1)
legacyMode := IniReadCheck(settingsFile, "Settings|" . romName, "LegacyMode","false",,1)
bezelTopOffset := IniReadCheck(settingsFile, "Settings|" . romName, "bezelTopOffset","0",,1)
bezelBottomOffset := IniReadCheck(settingsFile, "Settings|" . romName, "bezelBottomOffset","24",,1)
bezelLeftOffset := IniReadCheck(settingsFile, "Settings|" . romName, "bezelLeftOffset","0",,1)
bezelRightOffset := IniReadCheck(settingsFile, "Settings|" . romName, "bezelRightOffset","0",,1)
forceRegion := IniReadCheck(settingsFile, romName, "ForceRegion","",,1)
busWait := IniReadCheck(settingsFile, romName, "BusWait","false",,1)
usBios := GetFullName(usBios)	; convert relative to absolute path
euBios := GetFullName(euBios)
jpBios := GetFullName(jpBios)
worldBios := GetFullName(worldBios)

BezelStart("FixResMode")
hideEmuObj := Object("Decoding ahk_class #32770",0,"Select ROM file ahk_class #32770",0,"SSF",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, sevenZExtractPath)

If InStr(systemName, "Saturn")
	If !RegExMatch(romExtension,"i)|\.ccd|\.mds|\.cue|\.iso|\.cdi|\.nrg")
		ScriptError("For Sega Saturn, SSF only supports extensions ""mds|cue|iso|cdi|nrg"" and you are trying to use """ . romExtension . """")

specialcfg := emuPath . "\Configurations\" . romName . ".ini"
defaultcfg := emuPath . "\Configurations\Default.ini"
If FileExist(specialcfg)
	Filecopy, %specialcfg%, %emuPath%\SSF.ini, 1
Else If FileExist(defaultcfg)
	Filecopy, %specialcfg%, %emuPath%\SSF.ini, 1

SSFINI := CheckFile(emuPath . "\SSF.ini")
mySW := A_ScreenWidth
mySH := A_ScreenHeight

; Now let's update all our keys if they differ in the ini
Fullscreen := If Fullscreen = "true" ? "1" : "0"
UseBIOS := If UseBIOS = "true" ? "0" : "1"
BilinearFiltering := If BilinearFiltering = "true" ? "1" : "0"
WideScreen := If WideScreen = "true" ? "1" : "0"
Stretch := If Stretch = "true" ? "0" : "1"	; this setting uses 0 for stretch and 1 for not
AutoFieldSkip := If AutoFieldSkip = "true" ? "1" : "0"
EnforceAspectRatioWindow := If EnforceAspectRatioWindow = "true" ? "1" : "0"
EnforceAspectRatioFullscreen := If EnforceAspectRatioFullscreen = "true" ? "1" : "0"
FixedWindowResolution := If FixedWindowResolution = "true" ? "1" : "0"
FixedFullscreenResolution := If FixedFullscreenResolution = "true" ? "1" : "0"
VSynchWaitWindow := If VSynchWaitWindow = "true" ? "1" : "0"
VSynchWaitFullscreen := If VSynchWaitFullscreen = "true" ? "1" : "0"
Scanlines := If Scanlines = "true" ? "1" : "0"
SH2enabled := If SH2enabled = "true" ? "1" : "0"
busWait := If busWait = "true" ? "1" : "0"

If InStr(systemName, "Saturn")
{
	regionName := romName
	If (forceRegion)
		regionName := If forceRegion = "1" ? "(USA)" : (If forceRegion = "2" ? "(Japan)" : (If forceRegion = "3" ? "(Europe)" : "(World)"))	; translating for easier use later

	If RegExMatch(regionName, "\(U\)|\(USA\)|\(Braz")
	{	Log("Module - This is an American rom. Setting SSF's settings to this region.")
		Areacode := "4"	; 1 = Japan, 2 = Taiwan/Korea/Philippines. 4 = America/Canada/Brazil, c = Europe/Australia/South Africa
		SaturnBIOS := usBios
	} Else If RegExMatch(regionName, "JP|\(J\)|\(Jap")
	{	Log("Module - This is a Japanese rom. Setting SSF's settings to this region.")
		Areacode := "1"
		SaturnBIOS := jpBios
	} Else If RegExMatch(regionName, "\(Eu\)|\(Eur|\(German")
	{	Log("Module - This is a European rom. Setting SSF's settings to this region.")
		Areacode := "c"
		SaturnBIOS := euBios
	} Else If RegExMatch(regionName, "\(Kore")
	{	Log("Module - This is a Korean rom. Setting SSF's settings to this region.")
		Areacode := "2"
		SaturnBIOS := jpBios	; don't see a bios for this region, assuming it uses japanese one
	} Else If RegExMatch(regionName, "\(World")
	{	Log("Module - This is a rom without region. Setting SSF's settings to this region.")
		Areacode := "4"
		SaturnBIOS := worldBios
	} Else
	{	Log("Module - This rom has an UNKNOWN region. Reverting to use your default region. If you get a black screen, please rename your rom to add a proper (Region) tag.",2)
		Areacode := If defaultRegion = "1" ? "4" : If defaultRegion = "2" ? "1" : "c"
		SaturnBIOS := If defaultRegion = "1" ? usBios : If defaultRegion = "2" ? jpBios : euBios
	}
	CheckFile(SaturnBIOS)

	DataCartridge := romPath . "\" . romName . ".rom"
	If FileExist(DataCartridge) {		; Only 2 known games need this, Ultraman - Hikari no Kyojin Densetsu (Japan) and King of Fighters '95, The (Europe).
		Log("Module - This game requires a data cart in order to play. Trying to mount the cart: """ . DataCartridge . """")
		If !FileExist(DataCartridge)
			ScriptError("Could not locate the Data Cart for this game. Please make sure one exists inside the archive of this game or in the folder this game resides and it is called: """ . romName . ".rom""")
		CartridgeID := "21"
		DataCartridgeEnable := "1"
	} Else {	; all other games
		Log("Module - This game does not require a data cart in order to play.")
		CartridgeID := "5c"
		DataCartridgeEnable := "0"
		DataCartridge := ""
	}
}

If (legacyMode = "false")
{
	; Compare existing settings and if different then desired, write them to the SSF.ini
	; Note: On older emulator versions NoBIOS is under Program3 instead of Program4 so we set it on both
	IniWrite("""" . Fullscreen . """", SSFINI, "Screen", "FullSize", 1)
	IniWrite("""" . BilinearFiltering . """", SSFINI, "Screen", "BilinearFiltering", 1)
	IniWrite("""" . WideScreen . """", SSFINI, "Screen", "WideScreen", 1)
	IniWrite("""" . Stretch . """", SSFINI, "Screen", "StretchScreen", 1)
	IniWrite("""" . AutoFieldSkip . """", SSFINI, "Screen", "AutoFieldSkip", 1)
	IniWrite("""" . EnforceAspectRatioWindow . """", SSFINI, "Screen", "EnforceAspectRatioWindow", 1)
	IniWrite("""" . EnforceAspectRatioFullscreen . """", SSFINI, "Screen", "EnforceAspectRatioFullscreen", 1)
	IniWrite("""" . FixedWindowResolution . """", SSFINI, "Screen", "FixedWindowResolution", 1)
	IniWrite("""" . FixedFullscreenResolution . """", SSFINI, "Screen", "FixedFullscreenResolution", 1)
	IniWrite("""" . VSynchWaitWindow . """", SSFINI, "Screen", "VSynchWaitWindow", 1)
	IniWrite("""" . VSynchWaitFullscreen . """", SSFINI, "Screen", "VSynchWaitFullscreen", 1)
	IniWrite("""" . Scanlines . """", SSFINI, "Screen", "Scanline", 1)
	IniWrite("""" . ScanlineRatio . """", SSFINI, "Screen", "ScanlineRatio", 1)
	IniWrite("""" . SaturnBIOS . """", SSFINI, "Screen", "SaturnBIOS", 1)
	IniWrite("""" . CDDrive . """", SSFINI, "Peripheral", "CDDrive", 1)
	IniWrite("""" . Areacode . """", SSFINI, "Peripheral", "Areacode", 1)
	IniWrite("""" . CartridgeID . """", SSFINI, "Peripheral", "CartridgeID", 1)
	IniWrite("""" . DataCartridgeEnable . """", SSFINI, "Peripheral", "DataCartridgeEnable", 1)
	IniWrite("""" . SH2enabled . """", SSFINI, "Program3", "SH2Cache", 1)
	IniWrite("""" . 0 . """", SSFINI, "Program3", "EnableInstructionCache", 1)
	IniWrite("""" . busWait . """", SSFINI, "Program3", "SCUDMADelayInterrupt", 1)
	IniWrite("""" . busWait . """", SSFINI, "Program3", "busWait", 1)
	IniWrite("""" . UseBIOS . """", SSFINI, "Program3", "NoBIOS", 1)
	IniWrite("""" . ShowBIOS . """", SSFINI, "Program4", "NoBIOS", 1)
	IniWrite("""" . Fullscreen . """", SSFINI, "Other", "ScreenMode", 1)
	IniWrite("""" . WindowSize . """", SSFINI, "Other", "WindowSize", 1)
}

If InStr(systemName, "Saturn") {
	;Delete cached settings if needed
	If (deleteCachedSettings = "true")
	{
		If (romExtension = ".iso" || romExtension = ".bin")
		{
			imagetoCheck := romPath . "\" . romName . romExtension
		}
		Else If (romExtension = ".mds")
		{
			imagetoCheck := romPath . "\" . romName . ".mdf"
		}
		Else If (romExtension = ".ccd")
		{
			imagetoCheck := romPath . "\" . romName . ".img"
		}
		Else If (romExtension = ".cue") {
			datatrack := RL_listCUEFiles(romPath . "\" . romName . romExtension,1)
			imagetoCheck := romPath . "\" . datatrack
		}
		If (imagetoCheck) {
			gameID := RL_readFileData(imagetoCheck,48,10,"UTF8")
			gameCode := RL_readFileData(imagetoCheck,112,16,"UTF8")
			gameID := gameID ;To trim leading spaces
			gameCode := gameCode
			cachedSettings := emuPath . "\Setting\Saturn\" . gameID . "_" . gameCode . ".ini"
			Log("Deleting cached settings file at '" . cachedSettings . "'")
			If FileExist(cachedSettings)
				FileDelete, %cachedSettings%
		}
	}

	;Setup Virtual Drive
	If (vdEnabled = "false")
		ScriptError("Virtual Drive must be enabled to use this SSF module")
	usedVD := 1
	VirtualDrive("mount",romPath . "\" . romName . romExtension)
}

HideEmuStart()	; This fully ensures windows are completely hidden even faster than winwait

; Run(executable,emuPath,(If Fullscreen = 1 ? ("Hide" ): ("")), ssfPID)	; Worked in R3, not in R4
Run(executable,emuPath,, ssfPID)

If (systemName = "Sega ST-V")
{	Send, {SHIFTDOWN} ; this tells SSF we want to boot in ST-V mode
	WinWait("Select ROM file ahk_class #32770",,8) ; times out after 8 Seconds
	If ErrorLevel
	{	Send, {SHIFTUP}
		WinClose, SSF
		ScriptError("Module timed out waiting for Select ROM file window. This probably means you did not set your ST-V bios or have an invalid ST-V bios file.")
	}
	If !WinActive("Select ROM file ahk_class #32770")
		WinActivate, Select ROM file
	WinWaitActive("Select ROM file ahk_class #32770")
	Send, {SHIFTUP}
	OpenROM("Select ROM file ahk_class #32770", romPath . "\" . romName . romExtension)
	WinWait("Decoding ahk_class #32770")
}

WinWait("SSF")
WinWaitActive("SSF")

If (bezelEnabled = "true")
{	timeout := A_TickCount
	Loop
	{	Sleep, 20
		WinGetPos, , , , H, SSF
		If (H > 400)
			Break
		If (timeout < A_TickCount - 5000)
			Break
	}
	BezelDraw()
} Else
	Sleep, 1000 ; SSF flashes in real fast before going fullscreen if this is not here

HideEmuEnd()
FadeInExit()

; WinMove,SSF,,0,0 ; uncomment me if you turned off fullscreen mode and cannot see the emu, but hear it in the background

Process("WaitClose", executable)

If usedVD
	VirtualDrive("unmount")

7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


HaltEmu:
	disableActivateBlackScreen := "true"
	If (Fullscreen = 1) ; only have to take the emu out of fullscreen we are using it
	{		; SSF cannot swap discs in fullscreen mode, so we have to go windowed first, swap, and restore fullscreen
		WinGet, ssfPID, ID, A
		WinGetPos,,,ssfW,ssfH,ahk_id %ssfPID%
		SetKeyDelay(,10)	; change only pressDuration
		Send, !{Enter}
		WinSet, Transparent, 0, ahk_id %ssfPID%
		If (mySW != ssfW || mySH != ssfH) { ; if our screen not the same size as SSF uses for it's fullscreen, we can detect when it changes
			While % ssfH = ssfHn
			{	WinGetPos,,,,ssfHn,ahk_id %ssfPID%
				Sleep, 100
			}
		} Else ; if our screen is the same size as SSF uses for it's fullscreen, use a sleep instead
			Sleep, 3000 ; increase me if MG GUI is showing tiny instead of the full screen size
		tempgui()
	}
Return

MultiGame:
	WinMenuSelectItem,ahk_id %ssfID%,,Hardware,CD Open
	VirtualDrive("unmount")
	Sleep, 200	; just in case script moves too fast for DT
	VirtualDrive("mount",selectedRom)
	WinMenuSelectItem,ahk_id %ssfID%,,Hardware,CD Close
	If (Fullscreen = 1)
	{
		Loop { ; looping until SSF is done loading the new disc
			Sleep, 200
			WinGetTitle, winTitle, ahk_id %ssfID%
			StringSplit, T, winTitle, %A_Space%:
			; ToolTip, %A_Index%`nT10=%T10%,0,0
			If !oldT10	; get the current T10 as soon as it exists and store it
				oldT10:=T10
			If (T10 > oldT10)	; If T10 starts incrementing, we know SSF has a game loaded and can continue the script
				Break
		}
		WinActivate, ahk_id %ssfID%
		SetKeyDelay(,10)	; change only pressDuration
		Send, !{Enter}
		Sleep, 500
		Gui, 69: Destroy
		WinSet, Transparent, 255, ahk_id %ssfID%
		WinSet, Transparent, Off, ahk_id %ssfID%
	}
Return

RestoreEmu:
	WinActivate, ahk_id %ssfID%
	Sleep, 500
	SetKeyDelay(,100)	; change only pressDuration
	Send, !{Enter}
Return

BezelLabel:
	disableHideToggleMenuScreen := "true"
Return

tempgui(){
	Gui, 69:Color, 000000 
	Gui, 69:-Caption +ToolWindow 
	Gui, 69:Show, x0 y0 W%A_ScreenWidth% H%A_ScreenHeight%, BlackScreen
}

CloseProcess:
	FadeOutStart()
	WinClose("SSF")
Return
