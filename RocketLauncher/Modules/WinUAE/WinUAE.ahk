MEmu = WinUAE
MEmuV =  v3.0.0
MURL = http://www.winuae.net/
MAuthor = brolly,Turranius
MVersion = 2.2.1
MCRC = A36B5BEC
iCRC = 5974D94
mId = 635138307631183750
MSystem = "Commodore Amiga","Commodore Amiga CD32","Commodore CDTV","Commodore Amiga CD","Commodore Amiga Demos"
;----------------------------------------------------------------------------
; Notes:
; You can have specific configuration files inside a Configurations folder on WinUAE main dir.
; Just name them the same as the game name on the XML file.
; Make sure you create a host config files with these names:
; CD32 : cd32host.uae and cd32mousehost.uae;
; CDTV : cdtvhost.uae and cdtvmousehost.uae;
; Amiga : amigahost.uae;
; Amiga CD : amigacdhost.uae;
; cd32mouse and cdtvmouse are for mouse controlled games on these systems, you should configure 
; Windows Mouse on Port1 and a CD32 pad on Port2. For Amiga and Amiga CD make sure you set both 
; a joystick and a mouse on Port1 and only a joystick on Port2.
; Set all your other preferences like video display settings. And make sure you are saving a HOST 
; configuration file and not a general configuration file.
;
; If you want to configure an exit key through WinUAE:
; Host-Input-Configuration #1-RAW Keyboard and then remap the desired key to Quit Emulator.
; If you want to configure a key to toggle fullscreen/windowed mode:
; Host-Input-Configuration #1-RAW Keyboard and then remap the desired key to Toggle windowed/fullscreen.
;
; CD32 and CDTV:
; A settings file called System_Name.ini should be placed on your module dir. on that file you can define if a 
; game uses mouse or if it needs the special delay hack loading method amongst other things. Example of such a file:
;
; [Lemmings (Europe)]
; UseMouse=true
;
; [Project-X & F17 Challenge (Europe)]
; DelayHack=true
;
; Amiga:
; For MultiGame support make sure you don't change the default WinUAE diskswapper keys which are:
; END+1-0 (not numeric keypad) = insert image from swapper slot 1-10
; END+SHIFT+1-0 = insert image from swapper slot 11-20
; END+CTRL+1-4 = select drive
;
; To do that follow the same procedure as above for the exit 
; key, but on F11 set it to Toggle windowed/fullscreen. Make sure you save your configuration afterwards.
; Note : If you want to use Send commands to WinUAE for any keys that you configured through Input-Configuration panel make sure you 
; set those keys for Null Keyboard! This is a virtual keyboard that collects all input events that don't come from physical 
; keyboards. This applies to the exit or windowed/fullscreen keys mentioned above.
;
; If you are using WHDLoad games, but want to keep your default user-startup file after exiting then make a copy of it in the 
; WHDFolder\S (Set in PathToWHDFolder) and name it default-user-startup. This file will then be copied over S\user-startup on exit.
;
; Amiga CD:
; Several Amiga CD games require Hard drive installation, but will also require the game CD to be inserted in the CD drive.
; The module will take care of this automatically as long as you have the CD image alongside with HDD installed files (.hdf or .vhd).
; Amiga CD games will require a Workbench disk by default, for games that auto boot, make sure you go to the module settings and set 
; RequiresWB to false.
;
; To use the shader options you must first download and put in place the shader pack from the WinUAE website found here:
; http://www.winuae.net/ 
; Download the Direct3D Pixel Shader Filters and extract the zip file into your emulator directory
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

settingsFile := modulePath . "\" . systemName . ".ini"

; This object controls how the module reacts to different systems. WinUAE can play several systems, but needs to know what system you want to run, so this module has to adapt.
mType := Object("Commodore Amiga","a500","Commodore Amiga CD32","cd32","Commodore CDTV","cdtv","Commodore Amiga CD","amigacd","Commodore Amiga Demos","a500")
ident := mType[systemName]	; search object for the systemName identifier MESS uses
If !ident
	ScriptError("Your systemName is: " . systemName . "`nIt is not one of the known supported systems for this WinUAE module: " . moduleName)

specialcfg := emuPath . "\Configurations\" . romName . ".uae"

If romExtension in .hdf,.vhd
	DefaultRequireWB := "true"
Else
	DefaultRequireWB := "false"

If romExtension in .zip,.lha,.rar,.7z
{
	SlaveFile := RL_findByExtension(romPath . "\" . romName . romExtension, "slave")
	If (SlaveFile) {
		If romName contains (AGA)
		{
			defaultCycleExact := "false"
			defaultCpuSpeed := "max"
		} Else {
			defaultCycleExact := "true"
			defaultCpuSpeed := "real"
		}
		defaultImmediateBlittler := "false"
		defaultCpuCompatible := "false"
		defaultCacheSize := "0" ;8192
	}
}

If (ident = "amigacd") {
	DefaultRequireWB := "true" ;Most Amiga CD games require installation so better to default this to true
	defaultz3Ram := "128"
	isAmigaCd := "true"
}

; Settings
FS := IniReadCheck(settingsFile, "Settings" . "|" . romName, "ScreenMode","true",,1)
quickstartmode := IniReadCheck(settingsFile, "Settings" . "|" . romName, "QuickStartMode",A_Space,,1)
kickstart_rom_file := IniReadCheck(settingsFile, "Settings" . "|" . romName, "KickstartFile","",,1)
options := IniReadCheck(settingsFile, "Settings" . "|" . romName, "Options","",,1)
bezelTopOffset := IniReadCheck(settingsFile, "Settings" . "|" . romName, "Bezel_Top_Offset","0",,1)
bezelBottomOffset := IniReadCheck(settingsFile, "Settings" . "|" . romName, "Bezel_Bottom_Offset","0",,1)
bezelRightOffset := IniReadCheck(settingsFile, "Settings" . "|" . romName, "Bezel_Right_Offset","0",,1)
bezelLeftOffset := IniReadCheck(settingsFile, "Settings" . "|" . romName, "Bezel_Left_Offset","0",,1)
use_gui := IniReadCheck(settingsFile, "Settings" . "|" . romName, "UseGui","false",,1)
floppyspeed := IniReadCheck(settingsFile, "Settings" . "|" . romName, "FloppySpeed","turbo",,1)
PathToWorkBenchBase := IniReadCheck(settingsFile, "Settings" . "|" . romName, "PathToWorkBenchBase", EmuPath . "\HDD\Workbench31_Lite.vhd",,1)
PathToWorkBenchBase := AbsoluteFromRelative(EmuPath, PathToWorkBenchBase)
pathtoextradrive := IniReadCheck(settingsFile, "Settings" . "|" . romName, "PathToExtraDrive", "",,1)
If (pathtoextradrive)
	pathtoextradrive := AbsoluteFromRelative(EmuPath, pathtoextradrive)

usemouse := IniReadCheck(settingsFile, romName, "UseMouse","false",,1) ;Only needed for CDTV and CD32
delayhack := IniReadCheck(settingsFile, romName, "DelayHack","false",,1) ;Only needed for CDTV and CD32
requireswb := IniReadCheck(settingsFile, romName, "RequiresWB",DefaultRequireWB,,1)

; Display 
videomode := IniReadCheck(settingsFile, "Display" . "|" . romName, "VideoMode","PAL",,1)
gfx_width := IniReadCheck(settingsFile, "Display" . "|" . romName, "XResolution","native",,1)
gfx_height := IniReadCheck(settingsFile, "Display" . "|" . romName, "YResolution","native",,1)
gfx_blacker_than_black := IniReadCheck(settingsFile, "Display" . "|" . romName, "BlackerThanBlack","false",,1)
gfx_flickerfixer := IniReadCheck(settingsFile, "Display" . "|" . romName, "RemoveInterlaceArtifacts","false",,1)
gfx_linemode := IniReadCheck(settingsFile, "Display" . "|" . romName, "LineMode",,,1)
gfx_filter_autoscale := IniReadCheck(settingsFile, "Display" . "|" . romName, "AutoScale",,,1)
gfx_filter_mask := IniReadCheck(settingsFile, "Display" . "|" . romName, "ShaderMask",,,1)
gfx_filter := IniReadCheck(settingsFile, "Display" . "|" . romName, "FilterShader",,,1)
gfx_filter_mode := IniReadCheck(settingsFile, "Display" . "|" . romName, "FilterShaderScale",,,1)
gfx_lores_mode := IniReadCheck(settingsFile, "Display" . "|" . romName, "FilteredLowResolution",,,1)
gfx_resolution := IniReadCheck(settingsFile, "Display" . "|" . romName, "ResolutionMode","hires",,1)

; CPU 
cpu := IniReadCheck(settingsFile, "CPU" . "|" . romName, "CPU","",,1)
cpuspeed := IniReadCheck(settingsFile, "CPU" . "|" . romName, "CpuSpeed",defaultCpuSpeed,,1)
cpucycleexact := IniReadCheck(settingsFile, "CPU" . "|" . romName, "CpuCycleExact","",,1)
cpucompatible := IniReadCheck(settingsFile, "CPU" . "|" . romName, "CpuCompatible",defaultCpuCompatible,,1)
mmu_model := IniReadCheck(settingsFile, "CPU" . "|" . romName, "MMU","false",,1)
cpu_no_unimplemented := IniReadCheck(settingsFile, "CPU" . "|" . romName, "DisableUnimplementedCPU","true",,1)
fpu := IniReadCheck(settingsFile, "CPU" . "|" . romName, "FPU","",,1)
fpu_strict := IniReadCheck(settingsFile, "CPU" . "|" . romName, "MoreCompatibleFPU","false",,1)
fpu_no_unimplemented := IniReadCheck(settingsFile, "CPU" . "|" . romName, "DisableUnimplementedFPU","true",,1)
cachesize := IniReadCheck(settingsFile, "CPU" . "|" . romName, "CacheSize",defaultCacheSize,,1)
24bitaddressing := IniReadCheck(settingsFile, "CPU" . "|" . romName, "24-BitAddressing","true",,1)

; Chipset
cycleexact := IniReadCheck(settingsFile, "Chipset" . "|" . romName, "CycleExact",defaultCycleExact,,1)
immediateblitter := IniReadCheck(settingsFile, "Chipset" . "|" . romName, "ImmediateBlitter",defaultImmediateBlittler,,1)
blittercycleexact := IniReadCheck(settingsFile, "Chipset" . "|" . romName, "BlitterCycleExact","",,1)
collisionlevel := IniReadCheck(settingsFile, "Chipset" . "|" . romName, "CollisionLevel","",,1)

; RAM
chipmemory := IniReadCheck(settingsFile, "RAM" . "|" . romName, "ChipMemory","",,1)
fastmemory := IniReadCheck(settingsFile, "RAM" . "|" . romName, "FastMemory","",,1)
autoconfigfastmemory := IniReadCheck(settingsFile, "RAM" . "|" . romName, "AutoConfigFastMemory","",,1)
slowmemory := IniReadCheck(settingsFile, "RAM" . "|" . romName, "SlowMemory","",,1)
z3fastmemory := IniReadCheck(settingsFile, "RAM" . "|" . romName, "Z3FastMemory",defaultz3Ram,,1)
megachipmemory := IniReadCheck(settingsFile, "RAM" . "|" . romName, "MegaChipMemory","",,1)
processorslotfastmemory := IniReadCheck(settingsFile, "RAM" . "|" . romName, "ProcessorSlotFast","",,1)

; Expansions
rtgcardtype := IniReadCheck(settingsFile, "Expansions" . "|" . romName, "RTGCardType","",,1)
rtgvramsize := IniReadCheck(settingsFile, "Expansions" . "|" . romName, "RTGVRAMSize","",,1)
rtghardwaresprite := IniReadCheck(settingsFile, "Expansions" . "|" . romName, "RTGHardwareSprite","",,1)

; WHDLoad
PathToWHDFolder := IniReadCheck(settingsFile, "WHDLoad" . "|" . romName, "PathToWHDFolder", EmuPath . "\HDD\WHD",,1)
PathToWHDFolder := AbsoluteFromRelative(EmuPath, PathToWHDFolder)
whdloadoptions := IniReadCheck(settingsFile, "WHDLoad" . "|" . romName, "WHDLoadOptions","PRELOAD",,1)
neverextract := IniReadCheck(settingsFile, "WHDLoad" . "|" . romName, "NeverExtract","false",,1)

BezelStart()

; Force Full Screen Windowed and Autoscale if Bezels are enabled. This must be done here since window class name changes from windowed to fullscreen modes
If bezelPath {
	FS := "fullwindow"
	gfx_filter_autoscale := "scale"
}

windowClass = PCsuxRox ;Class name is different depending on if the game is being run windowed or fullscreen
If (FS = "true" or FS = "fullwindow")
	windowClass := "AmigaPowah"

If (cpucycleexact and blittercycleexact)
	cycleexact := "" ;No need to set cycle exact if both cpu and blitter are set as it could lead to inconsistent states

if (cpu != "68060" and cpu_no_unimplemented)
	cpu_no_unimplemented := "" ; cpu_no_unimplemented requires a 68060 CPU. Disable it if its true without a 68060 CPU.}

; Make sure 24bitaddressing is false if using Z3 memory.
If z3fastmemory 
	24bitaddressing := "false"
	
;Fill both z3 slots when amount of RAM requires it
If (z3fastmemory = 384) {
	z3fastmemory := 256
	z3fastmemoryb := 128
} Else If (z3fastmemory = 768) {
	z3fastmemory := 512
	z3fastmemoryb := 256
} Else If (z3fastmemory = 1536) {
	z3fastmemory := 1024
	z3fastmemoryb := 512
}	

videomode := If videomode = "NTSC" ? "-s ntsc=true" : ""

If (requireswb = "true") {
	ident := "a1200"
	CheckFile(PathToWorkBenchBase)
	wbDrive := "-s hardfile=rw,32,1,2,512," . """" . PathToWorkBenchBase . """"
}

If romExtension in .hdf,.vhd
{
	ident := "a1200"
	gameDrive := "-s hardfile=rw,32,1,2,512," . """" . romPath . "\" . romName . romExtension . """"
}

If (pathtoextradrive)
{
	CheckFile(pathtoextradrive,,,,,,1) ;allow folders
	If InStr(FileExist(pathtoextradrive), "D") ;it's a folder
		extraDrive := "-s filesystem=rw,Extra:" . """" . pathtoextradrive . """"
	Else ;it's a file
	{
		SplitPath, pathtoextradrive,,,extradriveExtension
		If extradriveExtension in .hdf,.vhd
			extraDrive := "-s hardfile=rw,32,1,2,512," . """" . pathtoextradrive . """"
		Else
			extraDrive := "-s filesystem=ro,Extra:" . """" . pathtoextradrive . """"
	}
}

options := options . " " . videomode

If (ident = "a500" or ident = "a1200") {
	If romName contains (AGA),(LW)
		ident := "a1200"

	If (SlaveFile) {
		CheckFolder(PathToWHDFolder)

		ident := "a1200"

		;Create the user-startup file to launch the game
		WHDUserStartupFile := PathToWHDFolder . "\S\user-startup"
		SplitPath, SlaveFile, SlaveName, SlaveFolder

		FileDelete, %WHDUserStartupFile%
		FileAppend, echo "";`n, %WHDUserStartupFile%
		FileAppend, echo "Running: %SlaveName%";`n, %WHDUserStartupFile%
		FileAppend, echo "";`n, %WHDUserStartupFile%
		FileAppend, cd dh1:%SlaveFolder%;`n, %WHDUserStartupFile%
		FileAppend, whdload %SlaveName% %whdloadoptions%;`n, %WHDUserStartupFile%
	}
}

hideEmuObj := Object("ahk_class " . windowClass,1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, sevenZExtractPath)

;--- Detecting what Configuration File to use (Or Quick Start Mode) ---

If FileExist(specialcfg) {
	;Game specific configuration file exists
	configFile := romName . ".uae"
} Else {
	;Game specific configuration file doesn't exist
	If (ident = "cd32" or ident = "cdtv") {
		configFile := If (usemouse = "true") ? ("host\" . ident . "mousehost.uae") : ("host\" . ident . "host.uae")
		quickcfg := If (ident = "cd32") ? ("-s quickstart=" . ident . "`,0 -s chipmem_size=8") : ("-s quickstart=" . ident . "`,0")
	} Else {
		;Amiga or Amiga CD game

		configFile := If systemName = "Commodore Amiga CD" ? "host\amigacdhost.uae" : "host\amigahost.uae"
		If quickstartmode
			quickcfg := "-s quickstart=" . quickstartmode
		Else
			quickcfg := If (ident = "a500") ? "-s quickstart=a500`,1" : (If (isAmigaCd = "true") ? "-s quickstart=a4000`,1" : "-s quickstart=a1200`,1")
	}
}

;--- Setting up command line arguments to use ---

; Global command line arguments.
If use_gui
	options := options . " -s use_gui=" . use_gui

If (FS = "true") {
	options := options . " -s gfx_width_fullscreen=" . gfx_width
	options := options . " -s gfx_height_fullscreen=" . gfx_height
} Else If (FS = "false") {
	If (gfx_width != "native" and gfx_height != "native") {
		options := options . " -s gfx_width_windowed=" . gfx_width
		options := options . " -s gfx_height_windowed=" . gfx_height
	}
}

If gfx_linemode
	options := options . " -s gfx_linemode=" . gfx_linemode
If gfx_filter_autoscale
	options := options . " -s gfx_filter_autoscale=" . gfx_filter_autoscale
If gfx_blacker_than_black
	options := options . " -s gfx_blacker_than_black=" . gfx_blacker_than_black
If gfx_flickerfixer
	options := options . " -s gfx_flickerfixer=" . gfx_flickerfixer
If gfx_filter_mode
	options := options . " -s gfx_filter_mode=" . gfx_filter_mode

If (gfx_lores_mode = "true")
	options := options . " -s gfx_lores_mode=filtered"
Else If (gfx_lores_mode = "false")
	options := options . " -s gfx_lores_mode=normal"

If gfx_resolution {
	options := options . " -s gfx_resolution=" . gfx_resolution
	If (gfx_resolution = "lores") {
		options := options . " -s gfx_autoresolution_vga=false"
		options := options . " -s gfx_lores=true"
	}
	Else {
		options := options . " -s gfx_lores=false"
	}
}

If gfx_filter_mask {
	gfx_filter_mask_path := emuPath . "\Plugins\masks\" . gfx_filter_mask
	LOG("Filter - gfx_filter_mask_path = " . gfx_filter_mask_path       ,5)
	If FileExist(gfx_filter_mask_path)
		options := options . " -s gfx_filter_mask=" . gfx_filter_mask
}

If gfx_filter {
	If (SubStr(gfx_filter, 1, 4) = "D3D:") {
		StringTrimLeft, FilterFileName, gfx_filter, 4
		FilterFile := EmuPath . "\Plugins\filtershaders\direct3d\" . FilterFileName
		If FileExist(FilterFile)
			options := options . " -s gfx_filter=" . gfx_filter
	} Else {
		options := options . " -s gfx_filter=" . gfx_filter
	}
}

If (ident = "cd32" or ident = "cdtv") {
	If (delayhack = "true")
		options := options . " -s cdimage0=" . """" . romPath . "\" . romName . romExtension . """" . "`,delay"
	Else
		options := options . " -cdimage=" . """" . romPath . "\" . romName . romExtension . """"
} Else {
	If floppyspeed
		options := options . " -s floppy_speed=" . floppyspeed
	If kickstart_rom_file
		options := options . " -s kickstart_rom_file=" . """" . kickstart_rom_file . """"
	If (cachesize || cachesize = "0")
		options := options . " -s cachesize=" . cachesize
	If immediateblitter
		options := options . " -s immediate_blits=" . immediateblitter
	If cycleexact
		options := options . " -s cycle_exact=" . cycleexact
	If cpucycleexact
		options := options . " -s cpu_cycle_exact=" . cpucycleexact
	If blittercycleexact
		options := options . " -s blitter_cycle_exact=" . blittercycleexact
	If cpucompatible
		options := options . " -s cpu_compatible=" . cpucompatible
	If cpuspeed
		options := options . " -s cpu_speed=" . cpuspeed
	If cpu
		options := options . " -s cpu_model=" . cpu
	If cpu_no_unimplemented
		options := options . " -s cpu_no_unimplemented=" . cpu_no_unimplemented		
	If (mmu_model = "true")	
		options := options . " -s mmu_model=" . cpu ; not a typo. Actually needs the same value as CPU.
	If 24bitaddressing
		options := options . " -s cpu_24bit_addressing=" . 24bitaddressing	
	If fpu
		options := options . " -s fpu_model=" . fpu
	If fpu_strict
		options := options . " -s fpu_strict=" . fpu_strict	
	If fpu_no_unimplemented
		options := options . " -s fpu_no_unimplemented=" . fpu_no_unimplemented
	If collisionlevel
		options := options . " -s collision_level=" . collisionlevel
	If chipmemory
		options := options . " -s chipmem_size=" . chipmemory
	If fastmemory
		options := options . " -s fastmem_size=" . fastmemory
	If autoconfigfastmemory
		options := options . " -s fastmem_autoconfig=" . autoconfigfastmemory
	If slowmemory
		options := options . " -s bogomem_size=" . slowmemory
	If z3fastmemory
		options := options . " -s z3mem_size=" . z3fastmemory
	If z3fastmemoryb
		options := options . " -s z3mem2_size=" . z3fastmemoryb
	If megachipmemory
		options := options . " -s megachipmem_size=" . megachipmemory
	If processorslotfastmemory
		options := options . " -s mbresmem_size=" . processorslotfastmemory
	If rtgcardtype
		options := options . " -s gfxcard_type=" . rtgcardtype
	If rtgvramsize
		options := options . " -s gfxcard_size=" . rtgvramsize
	If rtghardwaresprite
		options := options . " -s gfxcard_hardware_sprite=" . rtghardwaresprite

	If (SlaveFile) {
		;WHDLoad Game
		options := options . " -s filesystem=rw,WHD:" . """" . PathToWHDFolder . """" . " -s filesystem=ro,Games:" . """" . romPath . "\" . romName . romExtension . """"
	}
	Else If (gameDrive) {
		;HDD Game
		options := options . " " . wbDrive . " " . gameDrive
		
		;Check if there's also a CD to load
		If FileExist(romPath . "\" . romName . ".cue")
			cdDrive := romPath . "\" . romName . ".cue"
		If FileExist(romPath . "\" . romName . ".iso")
			cdDrive := romPath . "\" . romName . ".iso"
		If FileExist(romPath . "\" . romName . ".mds")
			cdDrive := romPath . "\" . romName . ".mds"

		If extraDrive
			options := options . " " . extraDrive
		If cdDrive
			options := options . " -cdimage=" . """" . cdDrive . """" . " -s win32.map_cd_drives=true -s scsi=true"
	} Else If romExtension in .cue,.iso,.mds
	{
		;Amiga CD game

		;Check if game has a HDD installation
		If FileExist(romPath . "\" . romName . ".hdf")
			installedHdd := " -s hardfile=rw,32,1,2,512," . """" . romPath . "\" . romName . ".hdf" . """"
		If FileExist(romPath . "\" . romName . ".vhd")
			installedHdd := " -s hardfile=rw,32,1,2,512," . """" . romPath . "\" . romName . ".vhd" . """"

		options := options . " " . wbDrive . installedHdd
		
		If extraDrive
			options := options . " " . extraDrive

		options := options . " -cdimage=" . """" . romPath . "\" . romName . romExtension . """" . " -s win32.map_cd_drives=true -s scsi=true"
	} Else {
		;Floppy Game

		;MultiDisk loading, this will load the first 2 disks into drives 0 and 1 since some games can read from both drives and therefore 
		;the user won't need to change disks through the MG menu. We can have up to 4 drives, but most of the games will only support 2 drives 
		;so disks are only loaded into the first 2 for better compatibility. Remaining drives will be loaded into quick disk slots.
		
		romCount := romTable.MaxIndex()
		If romName contains (Disk 1)
		{
			;If the user boots any disk rather than the first one, multi disk support must be done through RocketLauncher MG menu
			If romCount > 1
			{
				options := options . " -s nr_floppies=2"
				mgoptions := " -s floppy1=" . """" . romTable[2,1] . """"
			}
		}
		options := options . " " . floppyspeed . " -s floppy0=" . """" . romPath . "\" . romName . romExtension . """" . mgoptions
		
		If romCount > 1
		{
			;DiskSwapper
			;diskswapper := " -diskswapper "
			Loop % romTable.MaxIndex() ; loop each item in our array
			{
				;diskswapper := diskswapper . """" . romTable[A_Index,1] . ""","
				diskswapper := diskswapper . " -s diskimage" . (A_Index-1) . "=" . """" . romTable[A_Index,1] . """"
			}
			options := options . diskswapper
		}
	}
}

configFileFullPath := EmuPath . "\Configurations\" . configFile

;param1 := "-f " . """" . configFileFullPath . """" . " " . quickcfg
If FileExist(configFileFullPath)
	param1 := "-f " . """" . configFileFullPath . """"
param1 := param1 . " " . quickcfg

param2 := "-s gfx_fullscreen_amiga=" . FS
param3 := options

HideEmuStart()
Run(Executable . A_Space . param1 . A_Space . param2 . A_Space . param3 . A_Space . " -portable", emuPath)

If (use_gui = "true") {
	WinWait("WinUAE Properties",,60)
	FadeInExit()
	WinWaitClose("WinUAE Properties")
	Sleep, 100
	errLvl := Process("Exist",executable)
	If (errLvl = 0) {
		7zCleanUp()
		ExitModule()
	}
}

WinWait("ahk_class " . windowClass)
WinWaitActive("ahk_class " . windowClass)

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose",executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


MultiGame:
	If (currentButton = 10)
		diskslot := 0
	Else If (currentButton > 10)
		diskslot := currentButton - 10
	Else
		diskslot := currentButton

	If (currentButton > 10)
		Send, {End Down}{Shift Down}%diskslot%{Shift Up}{End Up}
	Else
		Send, {End Down}%diskslot%{End Up}
Return

CloseProcess:
	If (ident = "a500" or ident = "a1200") {
		If (SlaveFile) {
			CheckFolder(PathToWHDFolder)
			;Copy default-user-startup to user-startup if file exists
			If FileExist(PathToWHDFolder . "\S\default-user-startup")
				FileCopy,%PathToWHDFolder%\S\default-user-startup, %PathToWHDFolder%\S\user-startup, 1
		}
	}
	FadeOutStart()
	WinClose, ahk_class %windowClass%
Return
