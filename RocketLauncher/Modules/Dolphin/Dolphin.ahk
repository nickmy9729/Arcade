MEmu = Dolphin
MEmuV =  v4.0 r6928
MURL = https://dolphin-emu.org/
MAuthor = djvj & bleasby
MVersion = 2.1.5
MCRC = F58CF3FB
iCRC = F063B9AF
MID = 635038268884477733
MSystem = "Nintendo Gamecube","Nintendo Wii","Nintendo WiiWare"
;----------------------------------------------------------------------------
; Notes:
; Be sure you are running at least Dolphin v4.0 or greater.
; If you get an error that you are missing a vcomp100.dll, install Visual C++ 2010: http://www.microsoft.com/download/en/details.aspx?id=14632
; Also make sure you are running latest directx: http://www.microsoft.com/downloads/details.aspx?FamilyID=2da43d38-db71-4c1b-bc6a-9b6652cd92a3
; Dolphin will sometimes crash when connnecting a Wiimote, then going back to the game. After all Wiimotes are connected that you want to use, it shouldn't have anymore issues.
; Convert all your games to ciso using Wii Backup Manager to save alot of space by stripping everything but the game partition. http://www.wiibackupmanager.tk/
; If you want to keep your Dolphin.ini in the emu folder, create a "portable.txt" file in MyDocuments\Dolphin Emulator\
;
; Bezels:
; If the game does not fit the window, you can try setting stretch to window manually in dolphin.
;
; Setting up custom Wiimote or GCPad profiles:
; First set UseCustomWiimoteProfiles or UseCustomGCpadProfiles to true in RocketLauncherUI for this module
; Launch Dolphin manually and goto Options->(Wiimote or Gamecube Pad) Settings and configure all your controls how you want your default setup to look like. This will be used for all games that you don't set a custom profile for. No need to save any profiles.
; All your controls are stored in WiimoteNew.ini or GCPadNew.ini and get copied to a _Default_(WiimoteNew or GCPadNew).ini on first launch. This ini contains all the controls for all 4 controllers.
; Do not confuse this with Dolphin's built-in profiles as those only contain info for only one controller. The (WiimoteNew or GCPadNew).ini and all the profiles RocketLauncher uses contain info for all controllers in one file.
; This new profile now called _Default_(WiimoteNew or GCPadNew).ini will be found in Dolphins settings folder: \Config\Profiles\(Wiimote or GCPad) (RL)\Default.ini
; For each game or custom control sets you want to use, edit the controls for all the controllers to work for that game and exit Dolphin. Now copy the (WiimoteNew or GCPadNew).ini to the "(Wiimote or GCPad) (RL)" folder and name it whatever you like.
; In RocketLauncherUI's module settings for Dolphin, Click the Rom Settings tab and add each game from your xml you want to use a this custom profile for.
; Now for all those games you added, make sure the Profile setting it set to the custom profile you want to load when that game is launched.
; Any game not added will use the "_Default_(WiimoteNew or GCPadNew).ini" profile RocketLauncher makes on first launch.
;
; To Pair a Wiimote:
; Highly suggest getting a Mayflash DolphinBar as it makes pairing and using wiimotes as easy as with a real Wii: http://www.amazon.com/TOTALCONSOLE-W010-Wireless-Sensor-DolphinBar/dp/B00HZWEB74
; If using the DolphinBar, just make sure Dolphin is set to continuously scan for wiimotes and set controls to use real wiimotes for as many wiimotes you have.
; You do not need to pair the wiimote with the PC first as you would with a standard blueooth and wiimote.
; DolphinBar should be on Mode 4. Wiimotes don't get paired until after Dolphin is running, not before!!
; After Dolphin is running, press 1+2 on each wiimote and after a few moments, the wiimote will pair and vibrate and one led will lock solid. Do this for each wiimote. That's it!
;
; If using a standard LED Bar:
; Make sure all your wiimotes have already been paired with your PC's bluetooth adapter
; All 4 leds on the wiimote should be flashing
; Press your Refresh key (set in RocketLauncherUI for this module) or enable continuous scanning in Dolphin
; Press 1 + 2 on the wiimote and one led should go solid designating the player number
;
; MultiGame:
; Currently unable to get disc swapping to work. See MultiGame section below for additional details.
;
; Netplay:
; If you're using a GameCube game with saves, synchronize your memory cards, Wii NAND needs to be synchronized, and some settings (such as CPU Clock Override) must be either synchronized or disabled.
; Because netplay may require different settings than you would normally use with local play, the module will look for any inis in your Dolphin user config folder ending with "_netplay" and use those configs instead of your normal ones.
; So for example, after you tweak all your dolphin settings for netplay, copy your dolphin.ini to dolphin_netplay.ini in the same folder.
; When the module launches and you choose multiplayer from RocketLauncher on screen menu, the module will backup dolphin.ini and copy dolphin_network.ini to dolphin.IniDelete
; On exit, the module will restore your backed up dolphin.ini and any other ini files in this folder (and all subfolders) that had the "_netplay" in the name.
; Guide on tweaking performance for netplay: https://dolphin-emu.org/docs/guides/netplay-guide/
; Another guide: https://docs.google.com/document/d/1CIkBAGcf_-kBUa4urn4KUj2U4UA6y_2a7stXJz85yiE/
;
; Linking a GameCube game with VBA-M
; Game tested: Legend of Zelda, The - Four Swords Adventures (USA)
; VBA-M emulator tested: visualboyadvance-m2.0.0Beta1
; dolphin emulator tested: dolphin-master-4.0-6725-x64
; On RocketLaunchUI, dolphin, GameCube Module settings set your VBA-M executable and VBA Bios file path on the VBALink tab.
; On RocketLaunchUI, dolphin, GameCube, Game name Module Settings enable VBA Link
; If your Game Boy Advanced Windows appear frozen after the RocketLauncher fade screen loads, increase the value of the VBADelay on GameCube, VBALink settings. Default value is 500 milliseconds.
; A game with one VBA window will use a two screens bezel file, Bezel [2S].png, the first screen for the GameCube game and the second one for the VBA screen. Two VBAs = Bezel [3S].png, again first screen for the GameCube game and second and third for the VBA screens, and so on.
;----------------------------------------------------------------------------
StartModule()
BezelGui()
FadeInStart()
	
settingsFile := modulePath . "\" . moduleName . ".ini"
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
UseCustomWiimoteProfiles := IniReadCheck(settingsFile, "Settings", "UseCustomWiimoteProfiles","false",,1)	; set to true if you want to setup custom Wiimote profiles for games
UseCustomGCPadProfiles := IniReadCheck(settingsFile, "Settings", "UseCustomGCPadProfiles","false",,1)	; set to true if you want to setup custom GCPad profiles for games
HideMouse := IniReadCheck(settingsFile, "Settings", "HideMouse","true",,1)					; hides mouse cursor in the emu options
RefreshKey := IniReadCheck(settingsFile, "Settings", "RefreshKey","",,1)						; hotkey to "Refresh" Wiimotes, delete the key to disable it
Timeout := IniReadCheck(settingsFile, "Settings", "Timeout","5",,1)							; amount in seconds we should wait for the above hotkeys to timeout
renderToMain := IniReadCheck(settingsFile, "Settings", "Render_To_Main","false",,1)
enableNetworkPlay := IniReadCheck(settingsFile, "Network", "Enable_Network_Play","false",,1)

;options to Gamecube and VBA Link
enableVBALink := IniReadCheck(settingsFile, romName, "enableVBALink", "false",,1)
VBAExePath := IniReadCheck(settingsFile, "VBA Link", "VBAExePath", ,,1)
VBABiosPath := IniReadCheck(settingsFile, "VBA Link", "VBABiosPath", ,,1)
VBADelay := IniReadCheck(settingsFile, "VBA Link", "VBADelay", 500,,1)  

; Determine where Dolphin is storing its ini, this will act as the base folder for settings and profiles related to this emu
dolphinININewPath := A_MyDocuments . "\Dolphin Emulator\Config\Dolphin.ini"	; location of Dolphin.ini for v4.0+
dolphinINIOldPath := emuPath . "\User\Config\Dolphin.ini"	; location of Dolphin.ini prior to v4.0
portableTxtFile := emuPath . "\portable.txt"
If (!FileExist(portableTxtFile) && FileExist(dolphinININewPath))
{	dolphinBasePath := A_MyDocuments . "\Dolphin Emulator"
	Log("Module - Dolphin's base settings folder is not portable and found in: " . dolphinBasePath)
} Else If (FileExist(portableTxtFile) || FileExist(dolphinINIOldPath))
{	dolphinBasePath := emuPath . "\User"
	Log("Module - Dolphin's base settings folder is portable and found in: " . dolphinBasePath)
} Else
	ScriptError("Could not find your Dolphin.ini in either of these folders. Please run Dolphin manually first to create it.`n" . dolphinINIOldPath . "`n" . dolphinININewPath)
dolphinINI := dolphinBasePath . "\Config\Dolphin.ini"

If (enableVBALink = "true"){
	VBAExePath := AbsoluteFromRelative(EmuPath, VBAExePath)
	VBABiosPath := AbsoluteFromRelative(EmuPath, VBABiosPath)
	SplitPath, VBAExePath, VBAFile, VBAPath
	SelectedNumberofPlayers := NumberOfPlayersSelectionMenu(4)
	If (SelectedNumberofPlayers = 1) {
		enableVBALink := "false"
	} Else {
		; backup original ini
		FileCopy, %dolphinINI%, %dolphinINIBackup% 
		dolphinINIBackup := dolphinBasePath . "\Config\Dolphin_Backup.ini" 
		Loop, % SelectedNumberofPlayers
		{ 	tempCount := A_Index-1
			IniWrite(5, dolphinINI, "Controls", PadType%tempCount%)
		}
	}
}

; Win titles used throughout module
dolphinTitle := "Dolphin ahk_class wxWindowNR"
dolphinGameTitle := If renderToMain = "true" ? dolphinTitle : "FPS ahk_class wxWindowNR"
dolphinScanningTitle := "Scanning for ISOs ahk_class #32770"
dolphinNetPlaySetupTitle := "Dolphin NetPlay Setup ahk_class wxWindowNR"
dolphinNetPlayTitle := "Dolphin NetPlay ahk_class wxWindowNR"
dolphinErrorTitle1 := "Warning ahk_class #32770"
dolphinErrorTitle2 := "Error ahk_class #32770"

If (enableVBALink = "true")
	BezelStart(SelectedNumberofPlayers+1)	
Else
	BezelStart()

If (enableVBALink = "true" and !bezelPath)   ; disabling fullscreen if VBA Link mode
	Fullscreen := "false"

If (renderToMain = "true" && (enableVBALink = "true" || bezelEnabled = "true")) {   ; disabling toolbar and statusbar if bezels or vba link is used as it will show when rendering to the main window
	IniWrite("False", dolphinINI, "Interface", "ShowToolbar")
	IniWrite("False", dolphinINI, "Interface", "ShowStatusbar")
}

hideEmuObj := Object(dolphinScanningTitle,0,dolphinNetPlayTitle,0,dolphinNetPlaySetupTitle,0,dolphinErrorTitle1,0,dolphinErrorTitle2,0,dolphinTitle,0,dolphinGameTitle,1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, sevenZExtractPath)

If RegExMatch(romExtension,"i)\.zip|\.7z|\.rar")
	ScriptError(MEmu . " does not support compressed roms. Please enable 7z support in RocketLauncherUI to use this module/emu.")

If RefreshKey {
	RefreshKey := xHotKeyVarEdit(RefreshKey,"RefreshKey","~","Add")
	xHotKeywrapper(RefreshKey,"RefreshWiimote")
}

Fullscreen := If Fullscreen = "true" ? "True" : "False"
HideMouse := If HideMouse = "true" ? "True" : "False"

networkSession := ""
If (enableNetworkPlay = "true") {
	Log("Module - Network Multi-Player is an available option for " . dbName,4)
	dolphinNickname := IniRead(dolphinINI, "NetPlay", "Nickname")
	dolphinAddress := IniRead(dolphinINI, "NetPlay", "Address")
	dolphinCPort := IniRead(dolphinINI, "NetPlay", "ConnectPort")
	dolphinHPort := IniRead(dolphinINI, "NetPlay", "HostPort")
	netplayNickname := IniReadCheck(settingsFile, "Network", "NetPlay_Nickname","Player",,1)
	getWANIP := IniReadCheck(settingsFile, "Network", "Get_WAN_IP","false",,1)
	networkPlayers := 4	; Max amount of networkable players

	If (getWANIP = "true")
		myPublicIP := GetPublicIP()

	defaultServerIP := IniReadCheck(settingsFile, "Network", "Default_Server_IP", myPublicIP,,1)
	defaultServerPort := IniReadCheck(settingsFile, "Network", "Default_Server_Port",,,1)
	lastIP := IniReadCheck(settingsFile, "Network", "Last_IP", defaultServerIP,,1)	; does not need to be on the ISD
	lastPort := IniReadCheck(settingsFile, "Network", "Last_Port", defaultServerPort,,1)	; does not need to be on the ISD

	If (netplayNickname != dolphinNickname)
		IniWrite(netplayNickname, dolphinINI, "NetPlay", "Nickname")

	MultiplayerMenu(lastIP,lastPort,networkType,networkPlayers,0)
	If networkSession {
		Log("Module - Using a Network for " . dbName,4)

		restoreIniObject := Object()	; initialize object
		currentObj :=
		dolphinConfigPath := dolphinBasePath . "\Config"
		Loop, % dolphinConfigPath . "\*.ini"
		{
			If InStr(A_LoopFileName, "_netplay.ini") {
				Log("Module - Found a network specific ini: " . A_LoopFileFullPath,4)
				networkIni := A_LoopFileFullPath
				originalIni := RegExReplace(A_LoopFileFullPath, "_netplay","","",-1,15)
				backupIni := originalIni . ".backup"
				FileMove, %originalIni%, %backupIni%,1	; backup original ini
				FileCopy, %networkIni%, %originalIni%	; copy network ini to original name
				currentObj++
				restoreIniObject[currentObj,"originalIni"] := originalIni
				restoreIniObject[currentObj,"backupIni"] := backupIni
			}
		}
		
		IniWrite(lastPort, settingsFile, "Network", "Last_Port")

		If (networkType = "client") {
			IniWrite(lastIP, settingsFile, "Network", "Last_IP")	; Save last used IP and Port for quicker launching next time
			IniWrite(lastIP, dolphinINI, "Network", "Address")
			IniWrite(lastPort, dolphinINI, "Network", "ConnectPort")
		} Else	; server
			IniWrite(lastPort, dolphinINI, "Network", "HostPort")

		IniWrite(romPath, dolphinINI, "Network", "ISOPath0")	; makes browser only show the one game we want to play
		IniWrite(1, dolphinINI, "General", "ISOPaths")	; makes browser only show the first path set
		IniWrite(romPath . "\" . romName . romExtension, dolphinINI, "General", "LastFilename")
		Log("Module - Starting a network session using the IP """ . networkIP . """ and PORT """ . networkPort . """",4)
	} Else
		Log("Module - User chose Single Player mode for this session",4)
}

gcSerialPort := 5	; this puts the BBA network adapter into the serial port. If previous launch was Triforce, AM-Baseboard would be set here and would result in Unknown DVD command errors

; Compare existing settings and if different than desired, write them to the emulator's ini
IniWrite(Fullscreen, dolphinINI, "Display", "Fullscreen", 1)
IniWrite(renderToMain, dolphinINI, "Display", "RenderToMain", 1)
IniWrite(HideMouse, dolphinINI, "Interface", "HideCursor", 1)
IniWrite("False", dolphinINI, "Interface", "ConfirmStop", 1)
IniWrite("False", dolphinINI, "Interface", "UsePanicHandlers", 1)
IniWrite(gcSerialPort, dolphinINI, "Core", "SerialPort1", 1)

 ; Load default or user specified Wiimote or GCPad profiles for launching
If (InStr(systemName, "wii") && UseCustomWiimoteProfiles = "true")
	ChangeDolphinProfile("Wiimote")
If (UseCustomGCPadProfiles = "true")
	ChangeDolphinProfile("GCPad")

HideEmuStart()

If networkSession
	Run(executable, emuPath)	; must be launched w/o /b for browser list to work
Else
	Run(executable . " /b /e """ . romPath . "\" . romName . romExtension . """", emuPath)	; /b = batch (exit dolphin with emu), /e = load file

Prev_TitleMatchMode := A_TitleMatchMode
SetTitleMatchMode RegEx
If (renderToMain = "false") {
	WinWait("(Dolphin.*\|)")
	WinGet, dolphinID, ID
	dolphinTitle := "ahk_ID " . dolphinID
	WinWaitActive(dolphinTitle)
} Else {
	WinWait(dolphinTitle)
	WinGet, dolphinID, ID
}
SetTitleMatchMode %Prev_TitleMatchMode%        

If networkSession {
	Log("Module - Opening NetPlay window")

	; Get the 6-letter ID of the game
	If (romExtension = ".wbfs")
		gameID := RL_readFileData(romPath . "\" . romName . romExtension,512,6,"UTF8")
	Else If (romExtension = ".iso")
		gameID := RL_readFileData(romPath . "\" . romName . romExtension,0,6,"UTF8")
	Else If (romExtension = ".ciso")
		gameID := RL_readFileData(romPath . "\" . romName . romExtension,32768,6,"UTF8")

	; Must wait for Dolphin to finish scanning isos before netplay window can be opened so the game list is populated. Opening too early and the game list will be blank or partially filled.
	If WinExist(dolphinScanningTitle)
		WinWaitClose(dolphinScanningTitle,,60)	; wait 60 seconds max. hopefully doesn't take longer than that to scan your isos...
	Else {
		errlvl := WinWait(dolphinScanningTitle,,5)	; wait 5 seconds max to appear
		If errlvl
			Log("Module - Timed out waiting for ""Scanning for ISOs"" window to appear. It may have finished before it could be detected, moving on.")
		Else
			Log("Module - ""Scanning for ISOs"" window found.")
	}
	WinMenuSelectItem, %dolphinTitle%,, Tools, Start NetPlay
	matchMode := A_TitleMatchMode	; store for restoration later
	SetTitleMatchMode, 3	; changes match mode so title must match exactly
	WinWait(dolphinNetPlaySetupTitle)
	WinWaitActive(dolphinNetPlaySetupTitle)
	If (networkType = "client") {
		Log("Module - Clicking Connect button")
		While !breakLoops {
			ControlClick, Button1, %dolphinNetPlaySetupTitle%	; click connect button
			Log("Module - Waiting for Host to start game")
			errlvl := WinWait(dolphinNetPlayTitle,,2,dolphinNetPlaySetupTitle)	; waits 2 seconds
			If errlvl {	; 1 if timed out, now check for any error windows and close them
				Loop, 2		; loop through both error windows
					If WinExist(dolphinErrorTitle%A_Index%)	; error windows that can appear when host is not running yet
						ControlClick, Button1, % dolphinErrorTitle%A_Index%	; click ok to clear error
				Log("Module - Host not running yet, trying again")
				Continue
			} Else {	; window exists
				Log("Module - Connected to host, waiting for host to start game")
				Break
			}
		}
	} Else {	; server
		ControlGet, List, List,, ListBox1, %dolphinNetPlaySetupTitle%	; get list of selectable games
		Loop, Parse, List, `n
			If InStr(A_Loopfield, gameID) {
				idLocation := A_Index	; record the location in the ListBox of our game
				Log("Module - Game list shows """ . A_LoopField . """ as item " . A_Index)	; logging each items in ListBox
			}
		If !idLocation {	; game was not found in list
			ScriptError("Could not find your """ . romName . """ in the game selection window for netplay. Possibly the gameID could not be found in your game. Please check your the RocketLauncher log and report this error.",,,,,1)
			Gosub, CloseProcess
			FadeInExit()
			Goto, CloseDolphin
		}
		Control, Choose, %idLocation%, ListBox1, %dolphinNetPlaySetupTitle%	; selects our game in the ListBox
		Log("Module - Clicking Host button")
		ControlClick, Button2, %dolphinNetPlaySetupTitle%	; click host button
		WinWait(dolphinNetPlayTitle,,,dolphinNetPlaySetupTitle)	; this window should now appear when hosted correctly
		Log("Module - Waiting for " . networkPlayers . " players until the game is started")
		While !breakLoops {
			ControlGet, List, List,, ListBox1, %dolphinNetPlayTitle%
			If InStr(List,"[" . networkPlayers . "]") {
				Log("Module - All players have joined, starting game")
				Break
			}
			Sleep, 100
		}
		ControlClick, Button8, %dolphinNetPlayTitle%,,,,,dolphinNetPlaySetupTitle	; click start button
	}
	SetTitleMatchMode, %matchMode%	; restore old match mode
}


If (enableVBALink = "true") {
	Screen1ID := dolphinID
	vbaINI := CheckFile(VBAPath . "\vbam.ini")
	vbaINIBackup := VBAPath . "\vbam_Backup.ini"
	FileCopy, %vbaINI%, %vbaINIBackup% 
	;removing fullscreen from VBA-M
	IniWrite(0, vbaINI, "preferences", "fullScreen")
	;setting other VBA-M ini options
	StringReplace, VBABiosPathDoubleSlash,VBABiosPath, \, \\, all
	IniWrite(0, vbaINI, "preferences", "pauseWhenInactive")
	IniWrite(VBABiosPathDoubleSlash, vbaINI, "GBA", "BiosFile")
	IniWrite(1, vbaINI, "GBA", "LinkAuto")
	IniWrite(127.0.0.1, vbaINI, "GBA", "LinkHost")
	IniWrite(3, vbaINI, "GBA", "LinkType")
	IniWrite(SelectedNumberofPlayers, vbaINI, "preferences", "LinkNumPlayers")
	IniWrite(1, vbaINI, "preferences", "useBiosGBA")
	IniWrite(1, vbaINI, "Display", "Stretch")
	IniWrite(1, vbaINI, "Display", "Scale")
	
	;running VBA-M
	Loop % SelectedNumberofPlayers
	{	currentScreen := A_Index + 1
		Run(VBAFile . " " . """" . VBABiosPath . """",VBAPath,, Screen%currentScreen%PID)
		WinWait("ahk_pid " . Screen%currentScreen%PID)
		Sleep, %VBADelay%
		bezelBottomOffsetScreen%currentScreen% := 24 ; to hide emu bottom bar
	}
	;waiting for VBA-M windows bios loading
	timeout := A_TickCount
	Loop
	{	WinGet, id, list, gba_bios - VisualBoyAdvance-M
		If (id = SelectedNumberofPlayers){
			Loop % id
			{	currentScreen := A_Index + 1
				Screen%currentScreen%ID := id%A_Index%
			}
			Break
		}
		If (timeout<A_TickCount-10000)
			Break
		Sleep, 100
	}
	;Resizing Windows to fill screen if no bezel file is found
	If !(bezelPath) {
		Loop, % (SelectedNumberofPlayers+1)
		{	If (A_Index=1) {
				X1 := 0 , Y1 := 0 ,	W1 := A_ScreenWidth//2 , H1 := A_ScreenHeight
			} Else {
				X%A_Index% := A_ScreenWidth//2 , Y%A_Index% := (A_Index-2)*(A_ScreenHeight//SelectedNumberofPlayers) ,	W%A_Index% := A_ScreenWidth//2 , H%A_Index% := (A_ScreenHeight//SelectedNumberofPlayers)+bezelBottomOffsetScreen%A_Index%
			}
			WinSet, Style, -0xC00000, % "ahk_id " . Screen%A_Index%ID
			ToggleMenu(Screen%A_Index%ID)
			WinSet, Style, -0xC40000, % "ahk_id " . Screen%A_Index%ID
			MoveWindow("ahk_id " . Screen%A_Index%ID,X%A_Index%,Y%A_Index%,W%A_Index%,H%A_Index%)
		}
		Sleep, 50
		Loop, % (SelectedNumberofPlayers){
			currentScreen := (A_Index+1)
			WinActivate, % "ahk_id " . Screen%currentScreen%ID
		}
		WinActivate, % "ahk_id " . Screen1ID	
	}
}

BezelDraw()

WinActivate % dolphinGameTitle

HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)

CloseDolphin:
If (networkSession && restoreIniObject.MaxIndex()) {
	Loop % restoreIniObject.MaxIndex()
	{	Log("Module - Restoring the original ini: " . restoreIniObject[A_Index,"backupIni"] . " to " . restoreIniObject[A_Index,"originalIni"],4)
		FileMove, % restoreIniObject[A_Index,"backupIni"], % restoreIniObject[A_Index,"originalIni"],1		; restore all backed up inis
	}
}

7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


ChangeDolphinProfile(profileType) {
	Global settingsFile,romName,dolphinBasePath
	profile := IniReadCheck(settingsFile, romName, "profile", "Default",,1)
	RLProfilePath := dolphinBasePath . "\Config\Profiles\" . profileType . " (RL)"
	currentProfile := dolphinBasePath . "\Config\" . profileType . "New.ini"
	defaultProfile := RLProfilePath . "\_Default_" . profileType . "New.ini"
	customProfile := RLProfilePath . "\" . profile . ".ini"
	If !FileExist(currentProfile) {
		Log("Module - You have custom " . profileType . " profiles enabled, but could not locate " . currentProfile . ". This file stores all your current controls in Dolphin. Please setup your controls in Dolphin first.",2)
		Return
	}
	If !FileExist(defaultProfile) {
		Log("Module - Creating initial Default " . profileType . " profile by copying " . profileType . ".ini to " . defaultProfile, 2)
		FileCreateDir % RLProfilePath
		FileCopy, %currentProfile%, %defaultProfile%	; create the initial default profile on first launch
	}
	If (profile != "Default" && !FileExist(customProfile))
		Log("Module - " . romName . " is set to load a custom " . profileType . " profile`, but it could not be found: " . customProfile,2)
	FileRead, cProfile, %currentProfile%	; read current profile into memory
	FileRead, nProfile, %customProfile%	; read custom profile into memory
	If (cProfile != nProfile) {	; if both profiles do not match exactly
		Log("Module - Current " . profileType . " profile does not match the one this game should use.")
		If (profile != "Default") {	; if user set to use a custom profile
			Log("Module - Copying this defined " . profileType . " profile to replace the current one: " . customProfile)
			FileCopy, %customProfile%, %currentProfile%, 1
		} Else {	; load default profile
			Log("Module - Copying the default " . profileType . " profile to replace the current one: " . defaultProfile)
			FileCopy, %defaultProfile%, %currentProfile%, 1
		}
	} Else
		Log("Module - Current " . profileType . " profile is already the correct one for this game, not touching it.")
}

ConnectWiimote(key) {
	Global Timeout
	wiimoteClass := "Dolphin Controller Configuration ahk_class #32770"
	If !WinExist(wiimoteClass)
	{
		DetectHiddenWindows, OFF ; this needs to be off otherwise WinMenuSelectItem doesn't work for some odd reason
		WinActivate, Dolphin ahk_class wxWindowNR,,,FPS
		WinMenuSelectItem, ahk_class wxWindowNR,, Options, Controller Settings,,,,,,FPS
		WinWait(wiimoteClass)
		WinWaitActive(wiimoteClass)
	}
	;WinActivate, %wiimoteClass% ; test if window needs to be active
	ControlClick, %key%, %wiimoteClass%
	ControlClick, OK, %wiimoteClass%
	; WinActivate, FPS ahk_class wxWindowClassNR ; for older dolphins
	WinActivate % dolphinGameTitle
}

PairWiimote:
	ConnectWiimote("Pair Up")
Return

RefreshWiimote:
	ConnectWiimote("Refresh")
Return

HaltEmu:
	If RefreshKey
		XHotKeywrapper(RefreshKey,"RefreshWiimote","OFF")
Return

MultiGame:
	; MultiGame doesn't work with Dolphin currently because Dolphin hides itself from Winspector Spy and cannot send any commands to the emulator through scripts.
	If (fullscreen = "True")
	{	SetKeyDelay(50)
		Send, {Alt Down}{Enter Down}{Enter Up}{Alt Up}	; go windowed to get the menubar
	}
	If bezelEnabled
		ToggleMenu(dolphinID)	; put the menubar back
	; WinMenuSelectItem,Dolphin ahk_class wxWindowNR,,File,Change Disc...
	PostMessage, 0x111, 00288,,,Dolphin ahk_class wxWindowNR	; Change Disc
	OpenROM("Select ahk_class #32770", selectedRom)
	WinWaitActive("Dolphin ahk_class wxWindowNR")
	If bezelEnabled
		ToggleMenu(dolphinID)	; remove the menubar again
	If (fullscreen = "True")
		Send, {Alt Down}{Enter Down}{Enter Up}{Alt Up}	; restore fullscreen
Return

RestoreEmu:
	If RefreshKey
		XHotKeywrapper(RefreshKey,"RefreshWiimote","ON")
Return

CloseProcess:
	breakLoops := 1
	FadeOutStart()
	If (enableVBALink = "true") {
		Loop, %SelectedNumberofPlayers%
		{	currentScreen := A_Index + 1
			;WinActivate, % "ahk_pid " . Screen%currentScreen%PID
			WinClose("ahk_id " . Screen%currentScreen%ID)
			Sleep, 100
		}
		FileMove, %dolphinINIBackup%, %dolphinINI% 
		FileMove, %vbaINIBackup%, %vbaINI%,1 
	}
	If networkSession {
		If WinExist(dolphinNetPlaySetupTitle)
			WinClose(dolphinNetPlaySetupTitle)
		If WinExist(dolphinNetPlayTitle)
			WinClose(dolphinNetPlayTitle)
		If !WinExist(dolphinGameTitle)	; if game never launched, close the main emu window
			WinClose(dolphinTitle)
	}
	If WinExist(dolphinGameTitle)
		WinClose(dolphinGameTitle) ; this needs to close the window the game is running in otherwise dolphin crashes on exit
Return

; Unused messages for reference from Dolphin v4.0 build 6980 x64:
; PostMessage, 0x111, 0261,,,Dolphin ahk_class wxWindowNR	; Toggle Fullscreen
; PostMessage, 0x111, 0258,,,Dolphin ahk_class wxWindowNR	; Toggle Play/Pause
; PostMessage, 0x111, 0259,,,Dolphin ahk_class wxWindowNR	; Stop
; PostMessage, 0x111, 0260,,,Dolphin ahk_class wxWindowNR	; Reset
; PostMessage, 0x111, 00539,,,Dolphin ahk_class wxWindowNR	; Show Toolbar
; PostMessage, 0x111, 00540,,,Dolphin ahk_class wxWindowNR	; Show Statusbar
; PostMessage, 0x111, 05123,,,Dolphin ahk_class wxWindowNR	; Refresh List
; PostMessage, 0x111, 0305,,,Dolphin ahk_class wxWindowNR	; Change Disc
; PostMessage, 0x111, 00218,,,Dolphin ahk_class wxWindowNR	; Load State Slot 1
; PostMessage, 0x111, 00227,,,Dolphin ahk_class wxWindowNR	; Load State Slot 10
; PostMessage, 0x111, 00208,,,Dolphin ahk_class wxWindowNR	; Save State Slot 1
; PostMessage, 0x111, 00217,,,Dolphin ahk_class wxWindowNR	; Save State Slot 10
; PostMessage, 0x111, 00303,,,Dolphin ahk_class wxWindowNR	; Start Netplay
; PostMessage, 0x111, 05000,,,Dolphin ahk_class wxWindowNR	; Open

; Unused messages for reference from Dolphin v4.0.2 x86:
; PostMessage, 0x111, 00248,,,Dolphin ahk_class wxWindowNR	; Toggle Fullscreen
; PostMessage, 0x111, 00245,,,Dolphin ahk_class wxWindowNR	; Toggle Play/Pause
; PostMessage, 0x111, 00246,,,Dolphin ahk_class wxWindowNR	; Stop
; PostMessage, 0x111, 00247,,,Dolphin ahk_class wxWindowNR	; Reset
; PostMessage, 0x111, 00501,,,Dolphin ahk_class wxWindowNR	; Show Toolbar
; PostMessage, 0x111, 00502,,,Dolphin ahk_class wxWindowNR	; Show Statusbar
; PostMessage, 0x111, 00217,,,Dolphin ahk_class wxWindowNR	; Load State Slot 1
; PostMessage, 0x111, 00226,,,Dolphin ahk_class wxWindowNR	; Load State Slot 10
; PostMessage, 0x111, 00207,,,Dolphin ahk_class wxWindowNR	; Save State Slot 1
; PostMessage, 0x111, 00216,,,Dolphin ahk_class wxWindowNR	; Save State Slot 10
; PostMessage, 0x111, 00286,,,Dolphin ahk_class wxWindowNR	; Start Netplay
; PostMessage, 0x111, 05000,,,Dolphin ahk_class wxWindowNR	; Open
; PostMessage, 0x111, 05006,,,Dolphin ahk_class wxWindowNR	; Exit
