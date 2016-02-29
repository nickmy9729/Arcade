MEmu = Demul
MEmuV =  v0.7a 221215
MURL = http://demul.emulation64.com/
MAuthor = djvj
MVersion = 2.1.2
MCRC = 5337A143
iCRC = A2662133
mId = 635742431913446797
MSystem = "Cave 3rd","Gaelco","Gaelco 3D","Sammy Atomiswave","Sega System SP","Sega Dreamcast","Sega Hikaru","Sega Naomi","Sega Naomi 2"
;----------------------------------------------------------------------------
; Notes:
; Required - control and nvram files setup for each game/control type
; Required - moduleName ini example can be found on GIT in the Demul module folder
; moduleName ini must be placed in same folder as this module if you use the provided example, just be sure to rename it to just Demul.ini first so it matches the module's name
; GDI images must match mame zip names and be extracted and have a .dat extension
; Rom_Extension should include 7z|zip|gdi|cue|cdi|chd|mds|ccd|nrg
; Module will automatically set your rom path for you on first launch
;
; Make sure the awbios, dc, hikaru, naomi, naomi2, saturn.zip bios archives are in any of your rom paths as they are needed to play all the games.
; Set your Video Plugin to gpuDX11 and set your desired resolution there
; In case your control codes do not match mine, set your desired control type in demul, then open the demul.ini and find section PORTB and look for the device key. Use this number instead of the one I provided
; gpuDX10 and gpuDX11 are the only supported plugins. You can define what plugin you want to use for each game in the module settings in RocketLauncherUI
; Read the tooltip for the Fullscreen module setting in RocketLauncherUI on how to control windowed fullscreen, true fullscreen, or windowed mode
; Windowed fullscreen will take effect the 2nd time you run the emu. It has to calculate your resolution on first run.
;
; Controls:
; Start a game of each control type (look in the RocketLauncherUI's module settings for these types, they all have their own tabs) and configure your controls to play the game. After configuring your controls manually in Demul, open padDemul.ini and Copy/paste the JAMMA0_0 and JAMMA0_1 (for naomi) or the ATOMISWAVE0_0 and ATOMISWAVE0_1 (for atomiswave) into RocketLauncherUI's module settings for each controls tab (standard, sfstyle, etc).
; Each pair of control tabs designates another real arcade control schema for a grouping of games. Demul does not handle this like MAME, so the module does instead.
;
; Gaelco:
; There is no known way to launch the desired Gaelco rom from CLI. You will always be presented with the rom selection window on launch.
; GPUDX11 does not yet support Gaelco in true fullscreen mode. Either use DX10 which does support fullscreen for Gaelco
; or if using DX11, choose fullscreen in the video options and then match the windows resolution to your desktop. This will give a pseudo fullscreen mode.
;
; Sega Hikaru:
; Windowed Fullscreen doesn't seem to work as demul does not allow stretching of its window
;
; Troubleshooting:
; For some reason demul's ini files can get corrupted and ahk can't read/write to them correctly.
; If your ini keys are not being read or not writing to their existing keys in the demul inis, create a new file and copy/paste everything from the old ini into the new one and save.
; If you use Fade_Out, the module will disable it. Demul crashes when Fade tries to draw on top of it in windowed and fullscreen modes.
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
ExtraFixedResBezelGUI()
FadeInStart()

; This object controls how the module reacts to different systems. Demul can play a few systems, but needs to know what system you want to run, so this module has to adapt.
mType := Object("Cave 3rd","cave3rd","Gaelco","gaelco","Gaelco 3D","gaelco","Sammy Atomiswave","awave","Sega System SP","naomi","Sega Dreamcast","dc","Sega Hikaru","hikaru","Sega Naomi","naomi","Sega Naomi 2","naomi2")
ident := mType[systemName]	; search object for the systemName identifier Demul uses
If !ident
	ScriptError("Your systemName is: " . systemName . "`nIt is not one of the known supported systems for this Demul module: " . moduleName)

settingsFile := modulePath . "\" . moduleName . ".ini"
demulFile := CheckFile(emuPath . "\Demul.ini", "Could not find Demul's ini. Please run Demul manually first and each of it's settings sections so the appropriate inis are created for you: " . emuPath . "\Demul.ini")
padFile := CheckFile(emuPath . "\padDemul.ini", "Could not find Demul's control ini. Please run Demul manually first and set up your controls so this file is created for you: " . emuPath . "\padDemul.ini")

demulFileEncoding := RL_getFileEncoding(demulFile)
If demulFileEncoding {
	Log("Module - Recreating " . demulFile . " as ANSI because UTF-8 format cannot be read")
	If RL_removeBOM(demulFile)
		Log("Module - Successfully converted " . demulFile . " to ANSI")
	Else
		Log("Module - Failed to convert " . demulFile . " to ANSI",3)
}

maxHideTaskbar := IniReadCheck(settingsFile, "Settings", "MaxHideTaskbar", "true",,1)
controllerCode := IniReadCheck(settingsFile, "Settings", "ControllerCode", "16777216",,1)
mouseCode := IniReadCheck(settingsFile, "Settings", "MouseCode", "131072",,1)
keyboardCode := IniReadCheck(settingsFile, "Settings", "KeyboardCode", "1073741824",,1)
lightgunCode := IniReadCheck(settingsFile, "Settings", "LightgunCode", "-2147483648",,1)
lastControlUsed := IniReadCheck(settingsFile, "Settings", "LastControlUsed",,,1)
hideDemulGUI := IniReadCheck(settingsFile, "Settings", "HideDemulGUI", "true",,1)
PerGameMemoryCards := IniReadCheck(settingsFile, "Settings", "PerGameMemoryCards", "true",,1)
memCardPath := IniReadCheck(settingsFile, "Settings", "MemCardPath", emuPath . "\memsaves",,1)
memCardPath := AbsoluteFromRelative(emuPath, memCardPath)

fullscreen := IniReadCheck(settingsFile, "Settings|" . romName, "Fullscreen", "windowedfullscreen",,1)
plugin := IniReadCheck(settingsFile, "Settings|" . romName, "Plugin", "gpuDX11",,1)
shaderUsePass1 := IniReadCheck(settingsFile, "Settings|" . romName, "ShaderUsePass1", "false",,1)
shaderUsePass2 := IniReadCheck(settingsFile, "Settings|" . romName, "ShaderUsePass2", "false",,1)
shaderNamePass1 := IniReadCheck(settingsFile, "Settings|" . romName, "ShaderNamePass1",,,1)
shaderNamePass2 := IniReadCheck(settingsFile, "Settings|" . romName, "ShaderNamePass2",,,1)
listSorting := IniReadCheck(settingsFile, "Settings|" . romName, "ListSorting", "true",,1)
OpaqueMod := IniReadCheck(settingsFile, "Settings|" . romName, "OModifier", "true",,1)
TransMod := IniReadCheck(settingsFile, "Settings|" . romName, "TModifier", "true",,1)
internalResolutionScale := IniReadCheck(settingsFile, "Settings|" . romName, "InternalResolutionScale", "1",,1)
videomode := IniReadCheck(settingsFile, "Settings|" . romName, "VideoMode", "0",,1)

displayVMU := IniReadCheck(settingsFile, "Settings", "DisplayVMU", "true",,1)
VMUPos := IniReadCheck(settingsFile, "Settings", "VMUPos", "topRight",,1) ; topRight, topCenter, topLeft, leftCenter, bottomLeft, bottomCenter, bottomRight, rightCenter 
VMUHideKey := IniReadCheck(settingsFile, "Settings", "VMUHideKey","F10",,1)

Bios := IniReadCheck(settingsFile, romName, "Bios",,,1)
LoadDecrypted := IniReadCheck(settingsFile, romName, "LoadDecrypted",,,1)	; not currently supported

; Read all the control values
controls := IniReadCheck(settingsFile, romname, "Controls", "standard",,1)	; have to read this first so the below ini reads work
push1_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push1",,,1)
push2_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push2",,,1)
push3_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push3",,,1)
push4_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push4",,,1)
push5_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push5",,,1)
push6_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push6",,,1)
push7_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push7",,,1)
push8_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "push8",,,1)
service_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "SERVICE",,,1)
start_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "START",,,1)
coin_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "COIN",,,1)
digitalup_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "DIGITALUP",,,1)
digitaldown_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "DIGITALDOWN",,,1)
digitalleft_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "DIGITALLEFT",,,1)
digitalright_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "DIGITALRIGHT",,,1)
analogup_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGUP",,,1)
analogdown_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGDOWN",,,1)
analogleft_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGLEFT",,,1)
analogright_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGRIGHT",,,1)
analogup2_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGUP2",,,1)
analogdown2_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGDOWN2",,,1)
analogleft2_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGLEFT2",,,1)
analogright2_0 := IniReadCheck(settingsFile, controls . "_JAMMA0_0", "ANALOGRIGHT2",,,1)
push1_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push1",,,1)
push2_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push2",,,1)
push3_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push3",,,1)
push4_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push4",,,1)
push5_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push5",,,1)
push6_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push6",,,1)
push7_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push7",,,1)
push8_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "push8",,,1)
service_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "SERVICE",,,1)
start_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "START",,,1)
coin_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "COIN",,,1)
digitalup_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "DIGITALUP",,,1)
digitaldown_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "DIGITALDOWN",,,1)
digitalleft_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "DIGITALLEFT",,,1)
digitalright_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "DIGITALRIGHT",,,1)
analogup_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGUP",,,1)
analogdown_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGDOWN",,,1)
analogleft_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGLEFT",,,1)
analogright_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGRIGHT",,,1)
analogup2_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGUP2",,,1)
analogdown2_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGDOWN2",,,1)
analogleft2_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGLEFT2",,,1)
analogright2_1 := IniReadCheck(settingsFile, controls . "_JAMMA0_1", "ANALOGRIGHT2",,,1)

If (plugin = "gpuDX11ng")	; this is for legacy support. Original demul 0.7 used gpuDX11ng
	plugin := "gpuDX11old"

If (InStr(systemName, "Hikaru") && plugin != "gpuDX11")
	plugin := "gpuDX11"		; Hikaru does not work with gpuDX10 gpu plugin, setting it dumps an error

; Verify user set desired gpu plugin name correctly
If (plugin != "gpuDX11old" && plugin != "gpuDX11" && plugin != "gpuDX10" && plugin != "")
	ScriptError(plugin . " is not a supported gpu plugin.`nLeave the plugin blank to use the default ""gpuDX11"".`nValid options are gpuDX11old, gpuDX11 or gpuDX10.")

; Read and write videomode value for cable type
rvideomode := IniRead(demulFile, "main", "videomode")
Log("Module - Demul is reading the config with videomode = " . rvideomode)
IniWrite(videomode, demulFile, "main", "videomode")
Log("Module - Demul is updating the config with videomode = " . videomode)

; Handle Demul's rom paths so the user doesn't have to
romPathCount := IniRead(demulFile, "files", "romsPathsCount")
Log("Module - Demul is configured with " . romPathCount . " rom path(s). Scanning these for a romPath to this rom.")
Loop % romPathCount
{	demulRomPath := A_Index - 1	; rompaths in demul start with 0
	path%A_Index% := IniRead(demulFile, "files", "roms" . demulRomPath)
	Log("Module - Path" . demulRomPath . ": " . path%A_Index%)
	; msgbox % path%A_Index%
	If (path%A_Index% = romPath . "\")	; demul tacks on the backslash at the end
	{	romPathFound := 1	; flag that demul has this romPath in its config and no need to add it
		Log("Module - Stopping search because Demul is already configured with the correct romPath to this rom: " . path%A_Index%)
		Break	; stop looking for a correct romPath
	}
}
If !romPathFound	; if demul doesn't have the romPath in its ini, add it
{	Log("Module - Demul does not have this romPath in Demul.ini, adding it for you.",2)
	nextPath := romPathCount + 1	; add 1 to the romPathCount and write that to the ini
	IniWrite(nextPath, demulFile, "files", "romsPathsCount")
	IniWrite(romPath . "\", demulFile, "files", "roms" . romPathCount)	; write the rompath to the ini
}

BezelStart("FixResMode")

; Force Fade_Out to disabled as it causes demul to not close properly
; fadeOut = false
; Log("Module - Turning off Fade_Out because it doesn't let Demul exit properly.",2)

; check for the specified gpu plugin
gpuFile := CheckFile(emuPath . "\" . plugin . ".ini", "Please run Demul manually first and select the " . plugin . " gpu plugin so it creates this file for you: " . emuPath . "\" . plugin . ".ini")

demulFileEncoding := RL_getFileEncoding(gpuFile)
If demulFileEncoding {
	Log("Module - Recreating " . gpuFile . " as ANSI because UTF-8 format cannot be read")
	If RL_removeBOM(gpuFile)
		Log("Module - Successfully converted " . gpuFile . " to ANSI")
	Else
		Log("Module - Failed to convert " . gpuFile . " to ANSI",3)
}

; This updates the DX11gpu ini file to turn List Sorting on or off. Depending on the games, turning this on for some games may remedy missing graphics, having it off on other games may fix corrupted graphics. Untill they improve the DX11gpu, this is the best it's gonna get.
If (ListSorting = "true")
	IniWrite(0, gpuFile, "main", "AutoSort")
Else
	IniWrite(1, gpuFile, "main", "AutoSort")
	
; This will set the Opaque or Trans modifier for each game
If (OpaqueMod = "true")
	IniWrite(0, gpuFile, "main", "OModifier")
Else
	IniWrite(1, gpuFile, "main", "OModifier")

If (TransMod = "true")
	IniWrite(0, gpuFile, "main", "TModifier")
Else
	IniWrite(1, gpuFile, "main", "TModifier")

; This updates the DX10gpu or DX11gpu ini file to the scale you want to use for this game
IniWrite(InternalResolutionScale, gpuFile, "main", "scaling")

; This updates the demul.ini with your gpu plugin choice for the selected rom
IniWrite(plugin . ".dll", demulFile, "plugins", "gpu")

; This updates the demul.ini with your VMU display choice
VMUscreendisable := If (displayVMU = "true") ? "false" : "true"
IniWrite(VMUscreendisable, demulFile, "main", "VMUscreendisable")
 
 ; Shader Effects
Loop, 2 {
	shaderUsePass%A_Index% := If (ShaderUsePass%A_Index% != "" and ShaderUsePass%A_Index% != "ERROR" ? (ShaderUsePass%A_Index%) : (GlobalShaderUsePass%A_Index%))	; determine what shaderUsePass to use
	currentusePass%A_Index% := IniRead(gpuFile, "shaders", "usePass" . A_Index)
	If (shaderUsePass%A_Index% = "true")
	{
		shaderNamePass%A_Index% := If (ShaderNamePass%A_Index% != "" and ShaderNamePass%A_Index% != "ERROR" ? (ShaderNamePass%A_Index%) : (GlobalShaderNamePass%A_Index%))	; determine what shaderNamePass to use
		If !RegExMatch(shaderNamePass%A_Index%,"i)FXAA|HDR-TV|SCANLINES|CARTOON|RGB DOT\(MICRO\)|RGB DOT\(TINY\)|BLUR")
			ScriptError(shaderNamePass%A_Index% . " is not a valid choice for a shader. Your options are FXAA, HDR-TV, SCANLINES, CARTOON, RGB DOT(MICRO), RGB DOT(TINY), or BLUR.")
		If (currentusePass%A_Index% = 0)
			IniWrite(1, gpuFile, "shaders", "usePass" . A_Index)	; turn shader on in gpuDX11 ini
		IniWrite(shaderNamePass%A_Index%, gpuFile, "shaders", "shaderPass" . A_Index)	; update gpuDX11 ini with the shader name to use
	}Else If (shaderUsePass%A_Index% != "true" and currentusePass%A_Index% = 1)
		IniWrite(0, gpuFile, "shaders", "usePass" . A_Index)	; turn shader off in gpuDX11 ini
}

If (ident = "dc")
{
	7z(romPath, romName, romExtension, sevenZExtractPath)
	If (romExtension = ".cdi" || romExtension = ".mds" || romExtension = ".ccd" || romExtension = ".nrg" || romExtension = ".gdi" || romExtension = ".cue") {
		gdrImageFile := CreateDefaultGDROMIni("image")
		FileDelete, %gdrImageFile%
		Sleep, 500
		IniWrite("gdrImage.dll", demulFile, "plugins", "gdr")
		IniWrite("false", gdrImageFile, "Main", "openDialog")
		IniWrite(romPath . "\" . romName . romExtension, gdrImageFile, "Main", "imagefilename")
	} Else If (romExtension = ".chd")
	{
		gdrCHDFile := CreateDefaultGDROMIni("chd")
		FileDelete, %gdrCHDFile%
		Sleep, 500
		IniWrite("false", gdrCHDFile, "Main", "openDialog")
		IniWrite("gdrCHD.dll", demulFile, "plugins", "gdr")
		IniWrite(romPath . "\" . romName . romExtension, gdrCHDFile, "Main", "imagefilename")
	} Else
		ScriptError(romExtension . " is not a supported file type for this " . moduleName . " module.")

	IniWrite(1, demulFile, "main", "region")	; Set BIOS to Auto Region
} Else {	; all other systems, Naomi and Atomiswave
	; This updates the demul.ini with your Bios choice for the selected rom
	If (Bios != "" && Bios != "ERROR") {
		Bios := RegExReplace(Bios,"\s.*")	; Cleans off the added text from the key's value so only the number is left
		IniWrite("false", demulFile, "main", "naomiBiosAuto")	; turning auto bios off so we can use a specific one instead
		IniWrite(Bios, demulFile, "main", "naomiBios")		; setting specific bios user has set from the moduleName ini
	} Else
		IniWrite("true", demulFile, "main", "naomiBiosAuto")	; turning auto bios on if user did not specify a specific one
}

; This section writes your custom keys to the padDemul.ini. Naomi games had many control panel layouts. The only way we can accomodate these differing controls, is to keep track of them all and write them to the ini at the launch of each game.
; First we check if the last controls used are the same as the game we want to play, so we don't waste time updating the ini if it is not necessary. For example playing 2 sfstyle type games in a row, we wouldn't need to write to the ini.

; This section tells demul what arcade control type should be connected to the game. Options are standard (aka controller), mouse, lightgun, or keyboard
If (controls = "lightgun" || controls = "mouse") {
	Log("Module - This game uses a Mouse or Lightgun control type.")
	IniWrite(MouseCode, demulFile, "PORTB", "device")
} Else If (controls = "keyboard") {
	Log("Module - This game uses a Keyboard control type.")
	IniWrite(KeyboardCode, demulFile, "PORTB", "device")
} Else { ; accounts for all other control types
	Log("Module - This game uses a standard (controller) control type.")
	IniWrite(ControllerCode, demulFile, "PORTB", "device")
}

Log("Module - Last control scheme used was """ . lastControlUsed . """ and this game requires """ . controls . """")
If (LastControlUsed != controls) {	; find out last controls used for the system we are launching
	WriteControls(padFile, 0,push1_0,push2_0,push3_0,push4_0,push5_0,push6_0,push7_0,push8_0,SERVICE_0,START_0,COIN_0,DIGITALUP_0,DIGITALDOWN_0,DIGITALLEFT_0,DIGITALRIGHT_0,ANALOGUP_0,ANALOGDOWN_0,ANALOGLEFT_0,ANALOGRIGHT_0,ANALOGUP2_0,ANALOGDOWN2_0,ANALOGLEFT2_0,ANALOGRIGHT2_0)
	WriteControls(padFile, 1,push1_1,push2_1,push3_1,push4_1,push5_1,push6_1,push7_1,push8_1,SERVICE_1,START_1,COIN_1,DIGITALUP_1,DIGITALDOWN_1,DIGITALLEFT_1,DIGITALRIGHT_1,ANALOGUP_1,ANALOGDOWN_1,ANALOGLEFT_1,ANALOGRIGHT_1,ANALOGUP2_1,ANALOGDOWN2_1,ANALOGLEFT2_1,ANALOGRIGHT2_1)
	IniWrite(controls, settingsFile, "Settings", "LastControlUsed")
	Log("Module - Wrote " . controls . " controls to padDemul.ini.")
} Else
	Log("Module - Not changing controls because the currently configured controls are the same for this game.")

; This will check the save game files and create per game ones if enabled.
If (PerGameMemoryCards = "true")
{
	If !FileExist(memCardPath)
		FileCreateDir, %memCardPath%	; create memcard folder if it doesn't exist
	defaultMemCard := memCardPath . "\default_vms.bin"	; defining default blank VMU file
	If FileExist(defaultMemCard)
	{
		Log("VMU - Default VMU file location - " . defaultMemCard,4)
		Loop, 4
		{
			outerLoop := A_Index
			If (A_Index = 1)
				contrPort := "A"
			Else If (A_Index = 2)
				contrPort := "B"
			Else If (A_Index = 3)
				contrPort := "C"
			Else If (A_Index = 4)
				contrPort := "D"
			controllerPort%contrPort% := IniRead(demulFile, "PORT" . contrPort, "device")
			Log("VMU - Config for controller PORT" . contrPort . " = " . controllerPort%contrPort%,4)
			If (controllerPort%contrPort% = -1)
				Continue
			Loop, 2
			{
				SubCount := A_Index - 1
				VMUPort%SubCount% := IniRead(demulFile, "PORT" . contrPort, "port" . SubCount)
				Log("VMU - Config Plugin VMUPort" . contrPort . SubCount . " for controller PORT" . contrPort . " = " . VMUPort%SubCount%,4)
				If (VMUPort%SubCount% <> -1)
				{
					VMUPortFile%SubCount% := IniRead(demulFile, "VMS", "VMS" . contrPort . SubCount)
					Log("VMU - VMUPortFile" . contrPort . SubCount . " controllerVMU" . contrPort .	SubCount . " " . "VMS" . contrPort . SubCount . " = " . VMUPortFile%SubCount%,4)
					memCardName := If romTable[1,5] ? romTable[1,4] : romName	; defining rom name for multi disc rom
					PerGameVMUIn := memCardPath . "\" . memCardName . "_vms_" . contrPort . SubCount . ".bin"
					Log("VMU - PerGameVMUIn = " . PerGameVMUIn,4)
					If FileExist(PerGameVMUIn)
					{
						Log("VMU - PerGameVMU file exists at " . PerGameVMUIn,4)
					} Else {
						Log("VMU - PerGameVMU file does not exist. So we will create one at " . PerGameVMUIn)
						FileCopy, %defaultMemCard%, %PerGameVMUIn%
					}
					IniWrite(PerGameVMUIn, demulFile, "VMS", "VMS" . contrPort . SubCount)
					Log("VMU - PerGameVMU file written to " . demulFile . " at section VMS to variable VMS" . contrPort . SubCount . " as " . PerGameVMUIn,4)
				} Else {
					Log("VMU - No VMU Plugged In.",4)
				}
			}
		}
	} Else {
		Log("VMU - No default VMU file at " . defaultMemCard,4)
	}
}

; Setting demul to use true fullscreen if defined in settings.ini, otherwise sets demul to run windowed. This is for gpuDX11 plugin only
If (plugin = "gpuDX11" || plugin = "gpuDX11old")
	If (fullscreen = "truefullscreen")
		IniWrite(1, gpuFile, "main", "UseFullscreen")
	Else
		IniWrite(0, gpuFile, "main", "UseFullscreen")

If (fullscreen = "windowedfullscreen")
{
	If (maxHideTaskbar = "true")
	{
		Log("Module - Hiding Taskbar and Start Button.")
		WinHide, ahk_class Shell_TrayWnd
		WinHide, Start ahk_class Button
	}
	; Create black background to give the emu the fullscreen look
	Log("Module - Creating black background to simulate a fullscreen look.")
	Gui demulGUI: -Caption +ToolWindow +0x08000000
	Gui demulGUI: Color, Black
	Gui demulGUI: Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%
}

Sleep, 250

;  Construct the CLI for demul and send romName if naomi or atomiswave. Dreamcast needs a full path and romName.
If (LoadDecrypted = "true")		; decrypted naomi rom
	romCLI := "-customrom=" . """" . romPath . "\" . romName . ".bin"""
Else If (ident = "dc")	; dreamcast game
	romCLI := " -image=" . """" . romPath . "\" . romName . romExtension . """"
Else	; standard naomi rom
	romCLI := "-rom=" . romName

hideEmuObj := Object("LCD 0 ahk_class LCD 0",1,"ahk_class window",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
HideEmuStart()

; Run(executable .  " -run=" . ident . " " . romCLI, emuPath,, emuPID)
Run(executable .  " -run=" . ident . " " . romCLI, emuPath, (If hideDemulGUI = "true" ? "min" : ""), emuPID)	; launching minimized, then restoring later hides the launch completely
Sleep, 1000 ; Need a second for demul to launch, increase if yours takes longer and the emu is NOT appearing and staying minimized. This is required otherwise bezel backgrounds do not appear

DetectHiddenWindows, On
If (hideDemulGUI = "true")
{	WinRestore, ahk_class window
	WinActivate, ahk_class window
}

Log("Module - Waiting for Demul to finish loading game.")
Loop {	; looping until demul is done loading rom and gpu starts showing frames
	Sleep, 200
	WinGetTitle, winTitle, ahk_class window
	StringSplit, winTextSplit, winTitle, %A_Space%
	If (winTextSplit5 = "gpu:" And winTextSplit6 != "0" And winTextSplit6 != "1")
		Break
}
Log("Module - Demul finished loading game.")

If (InStr(systemName, "Gaelco") && fullscreen = "truefullscreen")
	Send !{Enter}	; Automatic fullscreen seems to be broken in the Gaelco driver, must alt+Enter to get fullscreen

; This is where we calculate and maximize demul's window using our pseudo fullscreen code
If (fullscreen = "windowedfullscreen")
{
	MaximizeWindow("ahk_class window") ; this will take effect after you run demul once because we cannot stretch demul's screen while it is running.
	If (plugin = "gpuDX11" || plugin = "gpuDX11old") {
		IniWrite(appWidthNew, gpuFile, "resolution", "Width")
		IniWrite(appHeightNew, gpuFile, "resolution", "Height")
	} Else {
		IniWrite(appWidthNew, gpuFile, "resolution", "wWidth")
		IniWrite(appHeightNew, gpuFile, "resolution", "wHeight")
	}
}

BezelDraw()

If (displayVMU = "true"){
	WinGet VMUWindowID, ID, LCD 0 ahk_class LCD 0
	ExtraFixedResBezelDraw(VMUWindowID, "VMU", VMUPos, 144, 96, 8, 8, 28, 8)
	VMUHideKey := xHotKeyVarEdit(VMUHideKey,"VMUHideKey","~","Add")
	xHotKeywrapper(VMUHideKey,"VMUHide")
}

HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)

If (fullscreen = "windowedfullscreen")
{	Gui demulGUI: Destroy
	Log("Module - Destroyed black gui background.")
}

If (ident = "dc")
	7zCleanUp()

BezelExit()
ExtraFixedResBezelExit()
FadeOutExit()

If (fullscreen = "windowedfullscreen" && maxHideTaskbar = "true") {
	Log("Module - Showing Taskbar and Start Button.")
	WinShow,ahk_class Shell_TrayWnd
	WinShow,Start ahk_class Button
}

ExitModule()


 ; Write new controls to padDemul.ini
WriteControls(file, player,push1,push2,push3,push4,push5,push6,push7,push8,service,start,coin,digitalup,digitaldown,digitalleft,digitalright,analogup,analogdown,analogleft,analogright,analogup2,analogdown2,analogleft2,analogright2) {
	IniWrite(push1, file, "JAMMA0_" . player, "PUSH1")
	IniWrite(push2, file, "JAMMA0_" . player, "PUSH2")
	IniWrite(push3, file, "JAMMA0_" . player, "PUSH3")
	IniWrite(push4, file, "JAMMA0_" . player, "PUSH4")
	IniWrite(push5, file, "JAMMA0_" . player, "PUSH5")
	IniWrite(push6, file, "JAMMA0_" . player, "PUSH6")
	IniWrite(push7, file, "JAMMA0_" . player, "PUSH7")
	IniWrite(push8, file, "JAMMA0_" . player, "PUSH8")
	IniWrite(service, file, "JAMMA0_" . player, "SERVICE")
	IniWrite(start, file, "JAMMA0_" . player, "START")
	IniWrite(coin, file, "JAMMA0_" . player, "COIN")
	IniWrite(digitalup, file, "JAMMA0_" . player, "DIGITALUP")
	IniWrite(digitaldown, file, "JAMMA0_" . player, "DIGITALDOWN")
	IniWrite(digitalleft, file, "JAMMA0_" . player, "DIGITALLEFT")
	IniWrite(digitalright, file, "JAMMA0_" . player, "DIGITALRIGHT")
	IniWrite(analogup, file, "JAMMA0_" . player, "ANALOGUP")
	IniWrite(analogdown, file, "JAMMA0_" . player, "ANALOGDOWN")
	IniWrite(analogleft, file, "JAMMA0_" . player, "ANALOGLEFT")
	IniWrite(analogright, file, "JAMMA0_" . player, "ANALOGRIGHT")
	IniWrite(analogup2, file, "JAMMA0_" . player, "ANALOGUP2")
	IniWrite(analogdown2, file, "JAMMA0_" . player, "ANALOGDOWN2")
	IniWrite(analogleft2, file, "JAMMA0_" . player, "ANALOGLEFT2")
	IniWrite(analogright2, file, "JAMMA0_" . player, "ANALOGRIGHT2")
}

; Creates a default gdrCHD.ini or gdrImage.ini in your emu folder if one does not exist already.
CreateDefaultGDROMIni(type) {
	Global emuPath
	defaultIni := "[main]`r`nimageFileName = `r`nopenDialog = false"
	IniType := If type = "chd" ? "gdrCHD.ini" : "gdrImage.ini"
	FileAppend, %defaultIni%, % emuPath . "\" . IniType
	Return emuPath . "\" . IniType
}

HaltEmu:
	If (fullscreen = "truefullscreen")
		Send !{Enter}
	If VMUHideKey
		XHotKeywrapper(VMUHideKey,"VMUHide","OFF")
Return
RestoreEmu:
	If (fullscreen = "truefullscreen")
		Send !{Enter}
	If (displayVMU = "true")
	{	WinSet, Transparent, 0, ahk_ID %VMUWindowID%
		WinSet, AlwaysOnTop, On, ahk_ID %VMUWindowID%
		WinShow, ahk_ID %VMUWindowID%
		WinSet, AlwaysOnTop, On, ahk_ID %VMUWindowID%
		WinSet, AlwaysOnTop, On, ahk_ID %extraFixedRes_Bezel_hwnd%
		WinShow, ahk_ID %extraFixedRes_Bezel_hwnd%
		If !(VMUHidden)
			WinSet, Transparent, off, ahk_ID %VMUWindowID%
	}
	If VMUHideKey
		XHotKeywrapper(VMUHideKey,"VMUHide","ON")
Return

HideGUIWindow:
	WinSet, Transparent, On, ahk_class window
	WinActivate ahk_class window	; once activated, demul starts loading the rom
Return

VMUHide:
	If (VMUHidden) {
		Loop, 4
			WinSet, Transparent, off, ahk_ID %VMUWindowID%
		UpdateLayeredWindow(extraFixedRes_Bezel_hwnd, extraFixedRes_Bezel_hdc,0,0, A_ScreenWidth, A_ScreenHeight,255)
		VMUHidden := false
	} Else {
		Loop, 4
			WinSet, Transparent, 0, ahk_ID %VMUWindowID%
		UpdateLayeredWindow(extraFixedRes_Bezel_hwnd, extraFixedRes_Bezel_hdc,0,0, A_ScreenWidth, A_ScreenHeight,0)
		VMUHidden := true
	}
Return

CloseProcess:
	FadeOutStart()
	PostMessage, 0x111, 40085,,,ahk_class window	; Stop emulation first for a clean exit
	Sleep, 5	; just like to give a little time before closing
	PostMessage, 0x111, 40080,,,ahk_class window	; Exit
Return
