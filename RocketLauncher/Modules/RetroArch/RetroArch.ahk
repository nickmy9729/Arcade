MEmu = RetroArch
MEmuV =  v05-11-2015 Nightly
MURL = http://themaister.net/retroarch.html
MAuthor = djvj,zerojay
MVersion = 2.3.4
MCRC = B0095E81
iCRC = 42C3B552
MID = 635038268922229162
MSystem = "Acorn BBC Micro","AAE","Amstrad CPC","Amstrad GX4000","APF Imagination Machine","Applied Technology MicroBee","Apple IIGS","Atari 2600","Atari 5200","Atari 7800","Atari 8-Bit","Atari Classics","Atari Jaguar","Atari Lynx","Atari ST","Atari XEGS","Bally Astrocade","Bandai Gundam RX-78","Bandai Super Vision 8000","Bandai Wonderswan","Bandai Wonderswan Color","Canon X07","Capcom Classics","Capcom Play System","Capcom Play System 2","Capcom Play System 3","Casio PV-1000","Casio PV-2000","Cave","Coleco ADAM","ColecoVision","Commodore MAX Machine","Commodore Amiga","Creatronic Mega Duck","Data East Classics","Dragon Data Dragon","Emerson Arcadia 2001","Entex Adventure Vision","Elektronika BK","Epoch Game Pocket Computer","Epoch Super Cassette Vision","Exidy Sorcerer","Fairchild Channel F","Final Burn Alpha","Funtech Super Acan","GamePark 32","GCE Vectrex","Hartung Game Master","Interton VC 4000","Irem Classics","JungleTac Sport Vii","Konami Classics","MAME","Magnavox Odyssey 2","Microsoft MSX","Microsoft MSX2","Matra & Hachette Alice","Mattel Aquarius","Mattel Intellivision","Midway Classics","Namco Classics","Namco System 22","NEC PC Engine","NEC PC Engine-CD","NEC PC-FX","NEC TurboGrafx-16","NEC SuperGrafx","NEC TurboGrafx-CD","Nintendo 64","Nintendo 64DD","Nintendo Arcade Systems","Nintendo Classics","Nintendo DS","Nintendo Entertainment System","Nintendo Famicom","Nintendo Famicom Disk System","Nintendo Game Boy","Nintendo Game Boy Color","Nintendo Game Boy Japan","Nintendo Game Boy Advance","Nintendo Game & Watch","Nintendo Super Game Boy","Nintendo Pokemon Mini","Nintendo Virtual Boy","Nintendo Super Famicom","Nintendo Satellaview","Nintendo SuFami Turbo","Panasonic 3DO","Elektronska Industrija Pecom 64","Philips CD-i","Philips Videopac","RCA Studio II","Sega 32X","Sega Classics","Sega Mega Drive 32X","Sega Mark III","Sega SC-3000","Sega SG-1000","Sega CD","Sega Dreamcast","Sega Game Gear","Sega Genesis","Sega Master System","Sega Mega Drive","Sega Pico","Sega Saturn","Sega Saturn Japan","Sega VMU","Sega ST-V","Sharp X1","Sinclair ZX Spectrum","Sony PlayStation","Sony PlayStation Minis","Sony PocketStation","Sony PSP","Sord M5","SNK Classics","SNK Neo Geo","SNK Neo Geo AES","SNK Neo Geo MVS","SNK Neo Geo Pocket","SNK Neo Geo CD","SNK Neo Geo Pocket Color","Spectravideo","Super Nintendo Entertainment System","Taito Classics","Tandy TRS-80 Color Computer","Technos","Texas Instruments TI 99-4A","Thomson MO5","Thomson TO7","Tiger Game.com","Tiki-100","Tomy Tutor","VTech CreatiVision","Watara Supervision","Williams Classics"
;----------------------------------------------------------------------------
; Notes:
; If the emu doesn't load and you get no error, usually this means the LibRetro DLL is not working!
; Devs stated they will never add support for mounted images (like via DT)
; Fullscreen is controlled via the module setting in RocketLauncherUI
; This module uses the CLI version of RetroArch (retroarch.exe), not the GUI (retroarch-phoenix.exe).
; The emu may make a mouse cursor appear momentarily during launch, MouseMove and hide_cursor seem to have no effect
; Enable 7z support for archived roms
; Available CLI options: https://github.com/PyroFilmsFX/iOS/blob/master/docs/retroarch.1
;
; LibRetro DLLs:
; LibRetro DLLs come with the emu, but here is another source for them: http://forum.themaister.net/
; Whatever cores you decide to use, make sure they are extracted anywhere in your Emu_Path\cores folder. The module will find and load the default core unless you choose a custom one for each system.
; You can find supported cores that Retroarch supports simply by downloading them from the "retroarch-phoenix.exe" or by visiting here: https://github.com/libretro/libretro.github.com/wiki/Supported-cores
; Some good discussion on cores and filters: http://forum.themaister.net/viewtopic.php?id=270
;
; SRM files:
; srm are stored in a "srm" dir in the emu folder. Each system ran through retroarch gets its own folder inside srm
;
; Save states:
; Save states are stored in a "save" dir in the emu folder. Each system ran through retroarch gets its own folder inside save
;
; Config files:
; By default, the module looks for config files in a folder called config in the RetroArch folder. Example: C:\emus\RetroArch\config. You can change this folder to anything you like by changing the module's ConfigFolder setting in RocketLauncherUI.
; RetroArch's global config file is called "retroarch.cfg". RetroArch will use a system cfg file named to match your System Name (example: Nintendo Entertainment System.cfg).
; RetroArch will also load core config files named after the core name. Example: nestopia_libretro.cfg
; This allows different settings globally, for each system, and for each core. If you want all systems to use the same retroarch.cfg, do not have any system or core cfg files, only have the retroarch.cfg.
; If a core config exists, it takes precedence over the global config. And if a system config exists, it takes precedence over the core config.
;
; MultiGame:
; MultiGame support is currently only available for the Mednafen PSX core. Retroarch uses the same method as Mednafen to load multi-disc games. This method involves m3u playlists which are commonly used for music. The m3u files needed to load multi-disc games are generated for you by the module when you launch a multi-disc game and are saved to your corresponding rom directory. Due to m3u limitations, your multi-disc roms/images cannot be archived -- they must be unzipped. All single disc games can remain archived and you can still enable 7z under system settings. If you do not wish to use MultiGame support you can archive your roms/images and m3u generation will be skipped on launch. 
; The m3u files generated by the module contain a list of paths to all roms/images in the multi-disc set. Retroarch automatically loads the first path in the m3u so the first path will always be the disc you are loading. For example, Final Fantasy VII has 3 discs and if you load Disc 2 first, the order of the paths in the m3u will be disc 2, disc 3, disc 1. If you load Disc 3 first, the order will be disc 3, disc 1, disc 2. The module anticipates this and will load the correct disk, selected from the Pause/MultiDisk menus. However if you choose to manually use Retroarch's UI or disk swap keys to change discs, you will need to keep this in mind.
; In order for RocketLauncher's MultiGame UI to swap discs, you must define Eject_Toggle_Key, Next_Disk_Key, and Previous_Disk_Key under global settings for the emulator in RocketLauncher. Because AHK and Retroarch use different naming conventions for some keyboard keys, it is best to use a letter, a number, or F1-F12.
;
; MESS:
; MESS BIOS roms should be placed in the system\mess folder
;
; System Specific Notes:
; Microsoft MSX/MSX2: Launch an MSX game and in the core options, set the console to be an MSX2 and it will play both just fine.
; Nintendo Famicom Disk System - Requires disksys.rom be placed in the folder you define as system_directory in the RetroArch's cfg.
; Sega CD - Requires "bios_CD_E.bin", "bios_CD_J.bin", "bios_CD_U.bin" all be placed in the folder you define as system_directory in the RetroArch's cfg.
; Super Nintendo Entertainment System - requires split all 10 dsp# & st### roms all be placed in the folder you define as system_directory in the RetroArch's cfg. Many games, like Super Mario Kart require these.
; NEC TurboGrafx-CD - Requires "syscard3.pce" be placed in the folder you define as system_directory in the RetroArch's cfg.
; Nintendo Super Game Boy - Set the Module setting in RocketLauncherUI SuperGameBoy to true to enable a system or only a rom to use SGB mode. This is not needed if your systemName is set to the official name of "Nintendo Super Game Boy". Requires "sgb.boot.rom" and "Super Game Boy (World).sfc" to be placed in the folder you define as system_directory in the RetroArch's cfg. This is needed if you want to use Super game boy mode and color palettes. Also requires using the latest bsnes core. Not all games support SGB mode.
; MAME: The nag screen patch has been removed from the MAME core as of some point in March. We will be investigating our options for this. For MAME-based systems, make sure to set 7z use to false as MAME needs zip files.
; Sony PSP/PlayStation Minis: To avoid the dialog box complaining about ppge_atlas.zim, download it from https://github.com/libretro/libretro-ppsspp/blob/master/assets/ppge_atlas.zim and place it in your Retroarch/system/PPSSPP/ directory.
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

; Here we define all supported systems for this module. This object controls how the module reacts to different systems. RetroArch can play a lot of systems, but needs to know what system you want to run, so this module has to adapt.
; 1 - Official System Name in RocketLauncher
; 2 - Short name used only for easy referencing within module
; 3 - Default core
; 4 - The system ID MESS core recognizes
Log("Module - Started building the " . MEmu . " object",4)
mTypeVar:="
	( LTrim
	AAE|LibRetro_AAE|mame_libretro
	Acorn BBC Micro|LibRetro_BBCB|mess_libretro|bbcb
	Amstrad CPC|LibRetro_CPC|mess_libretro|cpc464
	Amstrad GX4000|LibRetro_GX4K|mess_libretro|gx4000
	APF Imagination Machine|LibRetro_APF|mess_libretro|apfimag
	Apple IIGS|LibRetro_AIIGS|mess_libretro|apple2gs
	Applied Technology MicroBee|LibRetro_MBEE|mess_libretro|mbeeic
	Atari 2600|LibRetro_2600|stella_libretro|a2600
	Atari 5200|LibRetro_5200|mess_libretro|a5200
	Atari 7800|LibRetro_7800|prosystem_libretro|a7800
	Atari 8-Bit|LibRetro_ATARI8|mess_libretro|a800
	Atari Classics|LibRetro_ACLS|mame_libretro
	Atari Jaguar|LibRetro_JAG|virtualjaguar_libretro|jaguar
	Atari Lynx|LibRetro_LYNX|handy_libretro|lynx
	Atari ST|LibRetro_ST|hatari_libretro
	Atari XEGS|LibRetro_XEGS|mess_libretro|xegs
	Bally Astrocade|LibRetro_BAST|mess_libretro|astrocde
	Bandai Gundam RX-78|LibRetro_BGRX|mess_libretro|rx78
	Bandai Super Vision 8000|LibRetro_SV8K|mess_libretro|sv8000
	Bandai Wonderswan|LibRetro_WSAN|mednafen_wswan_libretro|wswan
	Bandai Wonderswan Color|LibRetro_WSANC|mednafen_wswan_libretro|wscolor
	Canon X07|LibRetro_CX07|mess_libretro|x07
	Capcom Classics|LibRetro_CAPC|mame_libretro
	Capcom Play System|LibRetro_CPS1|fba_cores_cps1_libretro
	Capcom Play System 2|LibRetro_CPS2|fba_cores_cps2_libretro
	Capcom Play System 3|LibRetro_CPS3|mame_libretro
	Casio PV-1000|LibRetro_CAS1K|mess_libretro|pv1000
	Casio PV-2000|LibRetro_CAS2K|mess_libretro|pv2000
	Cave|LibRetro_CAVE|mame_libretro
	Coleco ADAM|LibRetro_ADAM|mess_libretro|adam
	ColecoVision|LibRetro_COLEC|mess_libretro|coleco
	Commodore Amiga|LibRetro_PUAE|puae_libretro
	Commodore Max Machine|LibRetro_CMAX|mess_libretro|vic10
	Creatronic Mega Duck|LibRetro_DUCK|mess_libretro|megaduck
	Data East Classics|LibRetro_DATA|mame_libretro
	Dragon Data Dragon|LibRetro_DRAG64|mess_libretro|dragon64
	Elektronika BK|LibRetro_EBK|mess_libretro|bk0010
	Elektronska Industrija Pecom 64|LibRetro_P64|mess_libretro|pecom64
	Emerson Arcadia 2001|LibRetro_A2001|mess_libretro|arcadia
	Entex Adventure Vision|LibRetro_AVISION|mess_libretro|advision
	Epoch Game Pocket Computer|LibRetro_GPCKET|mess_libretro|gamepock
	Epoch Super Cassette Vision|LibRetro_SCV|mess_libretro|scv
	Exidy Sorcerer|LibRetro_SORCR|mess_libretro|sorcerer
	Fairchild Channel F|LibRetro_CHANF|mess_libretro|channelf
	Final Burn Alpha|LibRetro_FBA|fb_alpha_libretro
	Funtech Super Acan|LibRetro_SACAN|mess_libretro|supracan
	GamePark 32|LibRetro_GP32|mess_libretro|gp32
	GCE Vectrex|LibRetro_VECTX|mess_libretro|vectrex
	Hartung Game Master|LibRetro_GMASTR|mess_libretro|gmaster
	Interton VC 4000|LibRetro_VC4K|mess_libretro|vc4000
	Irem Classics|LibRetro_IREM|mame_libretro
	JungleTac Sport Vii|LibRetro_SPORTV|mess_libretro|vii
	Konami Classics|LibRetro_KONC|mame_libretro
	Magnavox Odyssey 2|LibRetro_ODYS2|mess_libretro|odyssey2
	MAME|LibRetro_MAME|mame_libretro
	Matra & Hachette Alice|LibRetro_ALICE|mess_libretro|alice32
	Mattel Aquarius|LibRetro_AQUA|mess_libretro|aquarius
	Mattel Intellivision|LibRetro_INTV|mess_libretro|intv
	MGT Sam Coupe|LibRetro_SAMCP|mess_libretro|
	Microsoft MS-DOS|LibRetro_MSDOS|dosbox_libretro
	Microsoft MSX|LibRetro_MSX|bluemsx_libretro
	Microsoft MSX2|LibRetro_MSX2|bluemsx_libretro
	Microsoft Windows 3.x|LibRetro_WIN3X|dosbox_libretro
	Midway Classics|LibRetro_MIDC|mame_libretro
	Namco Classics|LibRetro_NAMC|mame_libretro
	Namco System 22|LibRetro_NAM2|mame_libretro
	NEC PC Engine|LibRetro_PCE|mednafen_pce_fast_libretro|pce
	NEC PC Engine-CD|LibRetro_PCECD|mednafen_pce_fast_libretro|pce
	NEC PC-FX|LibRetro_PCFX|mednafen_pcfx_libretro
	NEC SuperGrafx|LibRetro_SGFX|mednafen_supergrafx_libretro|sgx
	NEC TurboGrafx-16|LibRetro_TG16|mednafen_pce_fast_libretro|tg16
	NEC TurboGrafx-CD|LibRetro_TGCD|mednafen_pce_fast_libretro|tg16
	Nintendo 64|LibRetro_N64|mupen64plus_libretro|n64
	Nintendo 64DD|LibRetro_N64|mupen64plus_libretro
	Nintendo Arcade Systems|LibRetro_NINARC|mame_libretro
	Nintendo Classics|LibRetro_NINC|mame_libretro
	Nintendo DS|LibRetro_DS|desmume_libretro
	Nintendo Entertainment System|LibRetro_NES|nestopia_libretro|nes
	Nintendo Famicom|LibRetro_NFAM|nestopia_libretro
	Nintendo Famicom Disk System|LibRetro_NFDS|nestopia_libretro|famicom
	Nintendo Game Boy|LibRetro_GB|gambatte_libretro|gameboy
	Nintendo Game Boy Advance|LibRetro_GBA|vba_next_libretro|gba
	Nintendo Game Boy Color|LibRetro_GBC|gambatte_libretro|gbcolor
	Nintendo Game Boy Japan|LibRetro_GBJ|gambatte_libretro|gameboy
	Nintendo Game & Watch|LibRetro_GW|gw_libretro
	Nintendo Pokemon Mini|LibRetro_POKE|mess_libretro|pokemini
	Nintendo Satellaview|LibRetro_NSFS|snes9x_libretro
	Nintendo SuFami Turbo|LibRetro_NSFST|snes9x_libretro
	Nintendo Super Famicom|LibRetro_NSF|bsnes_balanced_libretro
	Nintendo Super Game Boy|LibRetro_SGB|bsnes_balanced_libretro
	Nintendo Virtual Boy|LibRetro_NVB|mednafen_vb_libretro|vboy
	Othello Multivision|LibRetro_OTHO|genesis_plus_gx_libretro
	Panasonic 3DO|LibRetro_3DO|4do_libretro
	Philips CD-i|LibRetro_CDI|mess_libretro|cdimono1
	Philips Videopac|LibRetro_PVID|mess_libretro|videopac
	RCA Studio II|LibRetro_STUD2|mess_libretro|studio2
	SCUMMVM|LibRetro_SCUMM|scummvm_libretro
	Sega 32X|LibRetro_32X|picodrive_libretro|32x
	Sega CD|LibRetro_SCD|genesis_plus_gx_libretro|segacd
	Sega Classics|LibRetro_SEGC|mame_libretro
	Sega Dreamcast|LibRetro_DCAST|reicast_libretro
	Sega Game Gear|LibRetro_GG|genesis_plus_gx_libretro|gamegear
	Sega Genesis|LibRetro_GEN|genesis_plus_gx_libretro|genesis
	Sega Mark III|Libretro_SM3|genesis_plus_gx_libretro
	Sega Master System|LibRetro_SMS|genesis_plus_gx_libretro|sms
	Sega Mega Drive|LibRetro_GEN|genesis_plus_gx_libretro|megadriv
	Sega Mega Drive 32X|LibRetro_MD32X|picodrive_libretro
	Sega Pico|LibRetro_PICO|picodrive_libretro
	Sega Saturn|LibRetro_SAT|yabause_libretro
	Sega Saturn Japan|LibRetro_SAT|yabause_libretro
	Sega SC-3000|LibRetro_SC3K|mess_libretro|sc3000
	Sega SG-1000|LibRetro_SG1K|genesis_plus_gx_libretro
	Sega ST-V|LibRetro_STV|mame_libretro
	Sega VMU|LibRetro_SVMU|mess_libretro|svmu
	Sharp X1|LibRetro_SX1|mess_libretro|x1
	Sinclair ZX Spectrum|LibRetro_SPECZX|mess_libretro|spectrum
	SNK Classics|LibRetro_SNKC|mame_libretro
	SNK Neo Geo|LibRetro_NEO|fb_alpha_libretro
	SNK Neo Geo AES|LibRetro_NEOAES|mame_libretro|aes
	SNK Neo Geo CD|LibRetro_NEOCD|mess_libretro|neocdz
	SNK Neo Geo MVS|LibRetro_NEOMVS|mame_libretro
	SNK Neo Geo Pocket|LibRetro_NGP|mednafen_ngp_libretro|ngp
	SNK Neo Geo Pocket Color|LibRetro_NGPC|mednafen_ngp_libretro|ngpc
	Sony PlayStation|LibRetro_PSX|mednafen_psx_libretro|psx
	Sony PlayStation Minis|LibRetro_PSXMIN|ppsspp_libretro
	Sony PocketStation|LibRetro_POCKS|mess_libretro|pockstat
	Sony PSP|LibRetro_PSP|ppsspp_libretro
	Sord M5|LibRetro_SORD|mess_libretro|m5
	Spectravideo|LibRetro_SV328|mess_libretro|svi328n
	Super Nintendo Entertainment System|LibRetro_SNES|bsnes_balanced_libretro|snes
	Taito Classics|LibRetro_TAIC|mame_libretro
	Tandy TRS-80 Color Computer|LibRetro_TRS80|mess_libretro|coco3
	Technos|LibRetro_TECHN|mame_libretro
	Texas Instruments TI 99-4A|LibRetro_TI99|mess_libretro|ti99_4a
	Thomson MO5|LibRetro_MO5|mess_libretro|mo5
	Thomson TO7|LibRetro_TO7|mess_libretro|to7
	Tiger Game.com|LibRetro_TCOM|mess_libretro|gamecom
	Tiki-100|LibRetro_TIKI|mess_libretro|kontiki
	Tomy Tutor|LibRetro_TOMY|mess_libretro|tutor
	VTech CreatiVision|LibRetro_VTECH|mess_libretro|crvision
	Watara Supervision|LibRetro_SUPRV|mess_libretro|svision
	Williams Classics|LibRetro_WILLS|mame_libretro
	)"
mType := Object()
Loop, Parse, mTypeVar, `n, `r
{
	obj := {}
	Loop, Parse, A_LoopField, |
		If (A_Index = 1)
			obj.System := A_LoopField
		Else If (A_Index = 2)
			obj.ID := A_LoopField
		Else If (A_Index = 3)
			obj.Core := A_LoopField
		Else	; 4
			obj.MessID := A_LoopField
	mType.Insert(obj["System"], obj)
}
Log("Module - Finished building the " . MEmu . " object",4)
; For easier use throughout the module
retroSystem := mType[systemName].System
retroID := mType[systemName].ID
retroCore := mType[systemName].Core
retroMessID := mType[systemName].MessID

If !retroSystem
	ScriptError("Your systemName is: " . systemName . "`nIt is not one of the known supported systems for this " . MEmu . " module: " . moduleName)
If !retroCore
	ScriptError("Your Core ID is: " . retroID . "`nCould not find a default core to use. Please update the module with a default core.")

settingsFile := modulePath . "\" . moduleName . ".ini"
core := IniReadCheck(settingsFile, systemName, "LibRetro_Core",retroCore,,1)
Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
configFolder := IniReadCheck(settingsFile, "Settings", "ConfigFolder",emuPath . "\config",,1)
messRomPath := IniReadCheck(settingsFile, "Settings", "MESS_BIOS_Roms_Folder",,,1)
hideConsole := IniReadCheck(settingsFile, "Settings", "HideConsole","true",,1)
ejectToggleKey := IniReadCheck(settingsFile, "Settings", "Eject_Toggle_Key",,,1)
nextDiskKey := IniReadCheck(settingsFile, "Settings", "Next_Disk_Key",,,1)
prevDiskKey := IniReadCheck(settingsFile, "Settings", "Previous_Disk_Key",,,1)
superGB := IniReadCheck(settingsFile, systemName . "|" . romName, "SuperGameBoy","false",,1)
enableNetworkPlay := IniReadCheck(settingsFile, "Network|" . romName, "Enable_Network_Play","false",,1)
overlay := IniReadCheck(settingsFile, systemName . "|" . romName, "Overlay",,,1)
videoShader := IniReadCheck(settingsFile, systemName . "|" . romName, "VideoShader",,,1)
aspectRatioIndex := IniReadCheck(settingsFile, systemName . "|" . romName, "AspectRatioIndex",,,1)
customViewportWidth := IniReadCheck(settingsFile, systemName . "|" . romName, "CustomViewportWidth",,,1)
customViewportHeight := IniReadCheck(settingsFile, systemName . "|" . romName, "CustomViewportHeight",,,1)
customViewportX := IniReadCheck(settingsFile, systemName . "|" . romName, "CustomViewportX",,,1)
customViewportY := IniReadCheck(settingsFile, systemName . "|" . romName, "CustomViewportY",,,1)
stretchToFillBezel := IniReadCheck(settingsFile, systemName . "|" . romName, "StretchToFillBezel","false",,1)
rotation := IniReadCheck(settingsFile, systemName . "|" . romName, "Rotation",0,,1)
cropOverscan := IniReadCheck(settingsFile, systemName . "|" . romName, "CropOverscan",,,1)
threadedVideo := IniReadCheck(settingsFile, systemName . "|" . romName, "ThreadedVideo",,,1)
vSync := IniReadCheck(settingsFile, systemName . "|" . romName, "VSync",,,1)
integerScale := IniReadCheck(settingsFile, systemName . "|" . romName, "IntegerScale",,,1)
configurationPerCore := IniReadCheck(settingsFile, systemName . "|" . romName, "ConfigurationPerCore","false",,1)

configFolder := GetFullName(configFolder)
messRomPath := GetFullName(messRomPath)
overlay := GetFullName(overlay)
videoShader := GetFullName(videoShader)
rotateBezel := false

If (retroID = "LibRetro_SGB" || superGB = "true")	; if system or rom is set to use Super Game Boy
{	superGB = true	; setting this just in case it's false and the system is Nintendo Super Game Boy
	sgbRomPath := CheckFile(emuPath . "\system\Super Game Boy (World).sfc","Could not find the rom required for Super Game Boy support. Make sure the rom ""Super Game Boy (World).sfc"" is located in: " . emuPath . "\system")
	CheckFile(emuPath . "\system\sgb.boot.rom","Could not find the bios required for Super Game Boy support. Make sure the bios ""sgb.boot.rom"" is located in: " . emuPath . "\system")
	retroID := "LibRetro_SGB"	; switching to Super Game Boy mode
	retroSystem := "Nintendo Super Game Boy"
}

; Find the dll for this system
libDll := CheckFile(emuPath . "\cores\" . core . ".dll", "Your " . retroID . " dll is set to " . core . " but could not locate this file:`n" . emuPath . "\cores\" . core . ".dll")

; Find the cfg file to use
If !FileExist(configFolder)
	ScriptError("You need to make sure ""ConfigFolder"" is pointing to your RetroArch config folder. By default it is looking here: """ . configFolder . """")
globalRetroCfg := emuPath . "\retroarch.cfg"
systemRetroCfg := configFolder . "\" . retroSystem . ".cfg"
coreRetroCfg := configFolder . "\" . core . ".dll.cfg"
Log("Module - Global cfg should be: " . globalRetroCfg,4)
Log("Module - System cfg should be: " . systemRetroCfg,4)
Log("Module - Core cfg should be: " . coreRetroCfg,4)
foundCfg := ""
If FileExist(systemRetroCfg) {	; check for system cfg first
	retroCFGFile := systemRetroCfg
	foundCfg := 1
	Log("Module - Found a System cfg!",4)
} Else If FileExist(coreRetroCfg) {	; 2nd option is a core config
	retroCFGFile := coreRetroCfg
	foundCfg := 1
	Log("Module - Found a Core cfg!",4)
} Else If FileExist(globalRetroCfg) {	; 3rd is global cfg
	retroCFGFile := globalRetroCfg
	foundCfg := 1
	Log("Module - Found a Global cfg!",4)
}
If !foundCfg
	Log("Module - Could not find a cfg file to update settings. RetroArch will make one for you.",2)
Else {
	Log("Module - " . MEmu . " is using " . retroCFGFile . " as its config file.")
	retroCFG := LoadProperties(retroCFGFile)
}

If rotation In 1,3 ; use vertical bezel if RA rotation is set to 90 or 270 degrees
	rotateBezel := true

If RegExMatch(retroID, "LibRetro_NFDS|LibRetro_SCD|LibRetro_TGCD|LibRetro_PCECD|LibRetro_PCFX") {		; these systems require the retroarch settings to be read
	retroSysDir := ReadProperty(retroCFG,"system_directory")	; read value
	retroSysDir := ConvertRetroCFGKey(retroSysDir)	; remove dbl quotes
	StringLeft, retroSysDirLeft, retroSysDir, 2
	If (retroSysDirLeft = ":\") {	; if retroarch is set to use a default folder
		StringTrimLeft, retroSysDir, retroSysDir, 1
		Log("Module - RetroArch is using a relative system path: """ . retroSysDir . """")
		retroSysDir := emuPath . retroSysDir
	}
	If !retroSysDir
		ScriptError("RetroArch requires you to set your system_directory and place bios rom(s) in there for """ . retroSystem . """ to function. Please do this first by running ""retroarch-phoenix.exe"" manually.")
	StringRight, checkForSlash, retroSysDir, 1
	If (checkForSlash = "\")	; check if a backslash is the last character. If it is, remove it, as this is non-standard method to define folders
		StringTrimRight, retroSysDir, retroSysDir, 1
}

If (RegExMatch(retroID, "LibRetro_N64|LibRetro_NES|LibRetro_LYNX|LibRetro_PSX") || RegExMatch(retroID, "LibRetro_NES") && (InStr(core, "nestopia_libretro"))) {	; these systems will use an ini to store game specific settings
	sysSettingsFile := CheckSysFile(modulePath . "\" . systemName . ".ini")	; create the ini if it does not exist
	coreOptionsCFGFile := CheckFile((If configurationPerCore = "true" ? configFolder . "\retroarch-core-options.cfg" : emuPath . "\retroarch-core-options.cfg"), "Could not find retroarch-core-options.cfg in retroarch directory: """ . (If configurationPerCore = "true" ? configFolder : emuPath) . """")
	coreOptionsCFG := LoadProperties(coreOptionsCFGFile)
	If InStr(retroID, "LibRetro_N64") {	; Nintendo 64
		mupenGfx := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Gfx_Plugin", "auto",,1)
		mupenRsp := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_RSP_Plugin", "auto",,1)
		mupenCpu := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_CPU_Core", "dynamic_recompiler",,1)
		mupenPak1 := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Pak_1", "memory",,1)
		mupenPak2 := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Pak_2", "memory",,1)
		mupenPak3 := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Pak_3", "memory",,1)
		mupenPak4 := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Pak_4", "memory",,1)
		mupenGfxAccur := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Gfx_Accuracy", "high",,1)
		mupenExpMem := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Disable_Exp_Memory", "no",,1)
		mupenTexturFilt := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Texture_Filtering", "nearest",,1)
		mupenViRefresh := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_VI_Refresh", "2200",,1)
		mupenFramerate := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Framerate", "fullspeed",,1)
		mupenResolution := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Resolution", "640x480",,1)
		mupenPolyOffstFctr := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Polygon_Offset_Factor", "-3.0",,1)
		mupenPolyOffstUnts := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Polygon_Offset_Units", "-3.0",,1)
		mupenViOverlay := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_VI_Overlay", "disabled",,1)
		mupenAnalogDzone := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Mupen_Analog_Deadzone", "15",,1)

		WriteProperty(coreOptionsCFG, "mupen64-gfxplugin", mupenGfx, 1)
		WriteProperty(coreOptionsCFG, "mupen64-rspplugin", mupenRsp, 1)
		WriteProperty(coreOptionsCFG, "mupen64-cpucore", mupenCpu, 1)
		WriteProperty(coreOptionsCFG, "mupen64-pak1", mupenPak1, 1)
		WriteProperty(coreOptionsCFG, "mupen64-pak2", mupenPak2, 1)
		WriteProperty(coreOptionsCFG, "mupen64-pak3", mupenPak3, 1)
		WriteProperty(coreOptionsCFG, "mupen64-pak4", mupenPak4, 1)
		WriteProperty(coreOptionsCFG, "mupen64-gfxplugin-accuracy", mupenGfxAccur, 1)
		WriteProperty(coreOptionsCFG, "mupen64-disableexpmem", mupenExpMem, 1)
		WriteProperty(coreOptionsCFG, "mupen64-filtering", mupenTexturFilt, 1)
		WriteProperty(coreOptionsCFG, "mupen64-virefresh", mupenViRefresh, 1)
		WriteProperty(coreOptionsCFG, "mupen64-framerate", mupenFramerate, 1)
		WriteProperty(coreOptionsCFG, "mupen64-screensize", mupenResolution, 1)
		WriteProperty(coreOptionsCFG, "mupen64-polyoffset-factor", mupenPolyOffstFctr, 1)
		WriteProperty(coreOptionsCFG, "mupen64-polyoffset-units", mupenPolyOffstUnts, 1)
		WriteProperty(coreOptionsCFG, "mupen64-angrylion-vioverlay", mupenViOverlay, 1)
		WriteProperty(coreOptionsCFG, "mupen64-astick-deadzone", mupenAnalogDzone, 1)
	} Else If InStr(retroID, "LibRetro_NES") {		; these systems will use an ini to store game specific settings
		If InStr(core, "nestopia_libretro") {	; Nestopia
			nestopiaBlargg := IniReadCheck(sysSettingsFile, "Nestopia" . "|" . romName, "Nestopia_Blargg_NTSC_Filter", "disabled",,1)
			nestopiaPalette := IniReadCheck(sysSettingsFile, "Nestopia" . "|" . romName, "Nestopia_Palette", "canonical",,1)
			nestopiaNoSprteLimit := IniReadCheck(sysSettingsFile, "Nestopia" . "|" . romName, "Nestopia_Remove_Sprites_Limit", "disabled",,1)
			
			WriteProperty(coreOptionsCFG, "nestopia_blargg_ntsc_filter", nestopiaBlargg, 1)
			WriteProperty(coreOptionsCFG, "nestopia_palette", nestopiaPalette, 1)
			WriteProperty(coreOptionsCFG, "nestopia_nospritelimit", nestopiaNoSprteLimit, 1)
		}
	} Else If InStr(retroID, "LibRetro_LYNX") {	; Atari Lynx
		If InStr(core, "handy_libretro") {   ; Handy
			handyRotate := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "Handy_Rotation", "None",,1)
			If InStr(handyRotate, "240") or InStr(handyRotate, "90")
				rotateBezel := true
			WriteProperty(coreOptionsCFG, "handy_rot", handyRotate, 1)
		}
	} Else If InStr(retroID, "LibRetro_PSX") {	; Sony PlayStation
		psxCdImageCache := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "PSX_CD_Image_Cache", """enabled""",,1)
		psxMemcardHandling := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "PSX_Memcard_Handling", """libretro""",,1)
		psxDualshockAnalogToggle := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "PSX_Dualshock_Analog_Toggle", """enabled""",,1)
		
		WriteProperty(coreOptionsCFG, "beetle_psx_cdimagecache", psxCdImageCache, 1)
		WriteProperty(coreOptionsCFG, "beetle_psx_use_mednafen_memcard0_method", psxMemcardHandling, 1)
		WriteProperty(coreOptionsCFG, "beetle_psx_analog_toggle", psxDualshockAnalogToggle, 1)
	}
	SaveProperties(coreOptionsCFGFile, coreOptionsCFG)	
}

hideEmuObj := Object("ahk_class ConsoleWindowClass",0,"RetroArch ahk_class RetroArch",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, 7zExtractPath)

mgM3UPath:= romPath . "\" . romTable[1,4] . ".m3u"

mgRomExtensions := "cue|iso|ccd"
mgValidExtension := false

Loop, Parse, mgRomExtensions, |
	If (romExtension = "." . A_LoopField)
		mgValidExtension := true

If (InStr(retroID, "LibRetro_PSX") && romTable.MaxIndex() && mgValidExtension) { ; See if MultiGame table is populated	
	m3uRomIndex := Object()
	mgType := romTable[1,6] . " "
	mgMaxIndex := romTable.MaxIndex()
	mgRomIndex := 0

	If FileExist(mgM3UPath)
		FileDelete, %mgM3UPath%

	Loop %mgMaxIndex% {
		If (romTable[A_Index, 3] = romName) {
			tempType := romTable[A_Index, 5]
			StringTrimLeft, mgRomIndex, tempType, StrLen(mgType)
			Log ("Found rom index in rom set in romTable: " . mgRomIndex)
			Break
		}
	}

	If (mgRomIndex > 0) {
		tempRomIndex := mgRomIndex
		Loop %mgMaxIndex% {
			mgTypeIndex := mgType . tempRomIndex
			m3uRomIndex.Insert(tempRomIndex)

			Loop %mgMaxIndex% {
				If (romTable[A_Index, 5] = mgTypeIndex) {
					tempRomPath := romTable[A_Index, 1]
					FileAppend, %tempRomPath%`n, %mgM3UPath%
					Log("Appending rom path to m3u: " . tempRomPath)
					Break
				}
			}

			If (tempRomIndex < mgMaxIndex)
				tempRomIndex++
			Else
				tempRomIndex := 1
		}
	}
}

; MESS core options
messParam1 := ""
messParam2 := ""
messParam3 := ""
If InStr(core, "mess") {	; if a mess core is used
	Log("Module - Retroarch MESS mode enabled")
	If !retroMessID
		ScriptError("Your systemName is: " . systemName . "`nIt is not one of the known supported systems for the MESS LibRetro core")
	Else
		Log("Module - MESS mode using a known ident: " . retroMessID)

	If !messRomPath
		ScriptError("Please set the RetroArch module setting ""MESS_BIOS_Roms_Folder"" to the folder that contains your MESS BIOS roms to use MESS with RetroArch.")
	
	messParam1 := ""
	messParam2 := " -rompath \" . """" . messRomPath . "\" . """"

	; Build a key/value object containing the different messParam3 choices
	messP3 := Object("alice32","cass1","gp32","memc","cpc464","cass","spectrum","cass","dragon64","cass","cdimono1","cdrom","bk0010","cass","neocd","cdrom","neocdz","cdrom","svi328n","cass","pecom64","cass","svmu","quik","gamecom","cart1","mbeeic","quik1")
	messParam3 := messP3[retroMessID]	; search object for the retroMessID pair
	messParam3 := " -" . (If messParam3 ? messParam3 : "cart") . " \" . """" . romPath . "\" . romName . romExtension . "\" . """"
	
	If (retroMessID = "mbeeic") ; Applied Technology MicroBee
	{	microbeeModel := IniReadCheck(messSysINI, romName, "MicroBee_Model","mbeeic",,1)
		If microbeeModel not in mbee,mbeeic,mbeepc,mbeepc85,mbee56
			ScriptError("This is not a known MicroBee model value: " . microbeeModel)
		Else If (microbeeModel != "mbeeic")
			retroMessID := microbeeModel
		If romExtension in .mwb,.com,.bee
			mediaDeviceType := "quik1"
		Else If romExtension in .wav,.tap
			mediaDeviceType := "cass"
		Else If romExtension in .rom
			mediaDeviceType := "cart"
		Else If romExtension in .dsk
			mediaDeviceType := "flop1"
		Else	; .bin format
			mediaDeviceType := "quik2"
		messParam3 := " -" . mediaDeviceType . " \" . """" . romPath . "\" . romName . romExtension . "\" . """"
	}
	
	fullRomPath := messParam1 . messParam2 . messParam3
} Else If (superGB = "true") {
	Log("Module - Retroarch Super Game Boy mode enabled")
	fullRomPath := " """ . sgbRomPath . """ --subsystem sgb """ . romPath . "\" . romName . romExtension . """"
} Else {
	Log("Module - Retroarch standard mode enabled")
	fullRomPath := " """ . romPath . "\" . romName . romExtension . """"
}

If (retroID = "LibRetro_NFDS")	; Nintendo Famicom Disk System
{	If !FileExist(retroSysDir . "\disksys.rom")
		ScriptError("RetroArch requires ""disksys.rom"" for " . retroSystem . " but could not find it in your system_directory: """ . retroSysDir . """")
} Else If (retroID = "LibRetro_SCD")	; Sega CD
{	If romExtension Not In .bin,.cue,.iso
		ScriptError("RetroArch only supports Sega CD games in bin|cue|iso format. It does not support:`n" . romExtension)
	If !FileExist(retroSysDir . "\bios_CD_E.bin")
		ScriptError("RetroArch requires ""bios_CD_E.bin"" for " . retroSystem . " but could not find it in your system_directory: """ . retroSysDir . """")
	If !FileExist(retroSysDir . "\bios_CD_U.bin")
		ScriptError("RetroArch requires ""bios_CD_U.bin"" for " . retroSystem . " but could not find it in your system_directory: """ . retroSysDir . """")
	If !FileExist(retroSysDir . "\bios_CD_J.bin")
		ScriptError("RetroArch requires ""bios_CD_J.bin"" for " . retroSystem . " but could not find it in your system_directory: """ . retroSysDir . """")
} Else If retroID in LibRetro_PCECD,LibRetro_TGCD	; NEC PC Engine-CD and NEC TurboGrafx-CD
{	If romExtension Not In .ccd,.cue
		ScriptError("RetroArch only supports " . retroSystem . " games in ccd or cue format. It does not support:`n" . romExtension)
	If !FileExist(retroSysDir . "\syscard3.pce")
		ScriptError("RetroArch requires ""syscard3.pce"" for " . retroSystem . " but could not find it in your system_directory: """ . retroSysDir . """")
} Else If (retroID = "LibRetro_PCFX")
{	If romExtension Not In .ccd,.cue
		ScriptError("RetroArch only supports " . retroSystem . " games in ccd or cue format. It does not support:`n" . romExtension)
	If !FileExist(retroSysDir . "\pcfx.bios")
		ScriptError("RetroArch requires ""pcfx.bios"" for " . retroSystem . " but could not find it in your system_directory: """ . retroSysDir . """")
}

networkSession := ""
If (enableNetworkPlay = "true") {
	Log("Module - Network Multi-Player is an available option for " . dbName,4)

	netplayNickname := IniReadCheck(settingsFile, "Network", "NetPlay_Nickname","Player",,1)
	getWANIP := IniReadCheck(settingsFile, "Network", "Get_WAN_IP","false",,1)

	If (getWANIP = "true")
		myPublicIP := GetPublicIP()

	Log("Module - CAREFUL WHEN POSTING THIS LOG PUBLICLY AS IT CONTAINS YOUR IP ON THE NEXT LINE",2)
	defaultServerIP := IniReadCheck(settingsFile, "Network", "Default_Server_IP", myPublicIP,,1)
	defaultServerPort := IniReadCheck(settingsFile, "Network", "Default_Server_Port",,,1)
	lastIP := IniReadCheck(settingsFile, "Network", "Last_IP", defaultServerIP,,1)	; does not need to be on the ISD
	lastPort := IniReadCheck(settingsFile, "Network", "Last_Port", defaultServerPort,,1)	; does not need to be on the ISD

	mpMenuStatus := MultiPlayerMenu(lastIP,lastPort,networkType,,0)
	If (mpMenuStatus = -1) {	; if user exited menu early
		Log("Module - Cancelled MultiPlayer Menu. Exiting module.",2)
		ExitModule()
	}
	If networkSession {
		Log("Module - Using a Network for " . dbName,4)
		IniWrite, %networkPort%, %settingsFile%, Network, Last_Port
		; msgbox lastIP: %lastIP%`nlastPort: %lastPort%`nnetworkIP: %networkIP%`nnetworkPort: %networkPort%
		If (networkType = "client") {
			IniWrite, %networkIP%, %settingsFile%, Network, Last_IP	; Save last used IP and Port for quicker launching next time
			netCommand := " -C " . networkIP . " --port " . networkPort . " --nick """ . netplayNickname . """"	; -C = connect as client
		} Else {	; server
			netCommand := " -H --port " . networkPort . " --nick """ . netplayNickname . """"	; -H = host as server
		}
		Log("Module - CAREFUL WHEN POSTING THIS LOG PUBLICLY AS IT CONTAINS YOUR IP ON THE NEXT LINE",2)
		Log("Module - Starting a network session using the IP """ . networkIP . """ and PORT """ . networkPort . """",4)
	} Else
		Log("Module - User chose Single Player mode for this session",4)
}

BezelStart(,,(If rotateBezel ? 1:""))

If foundCfg {
	If (stretchToFillBezel = "true" and bezelEnabled = "true" and bezelPath)
	{
		customViewportWidth := bezelScreenWidth
		customViewportHeight := bezelScreenHeight
		customViewportX := 0
		customViewportY := 0
		aspectRatioIndex := 22
		Log("Stretching viewport to fit bezel")
	}

	retroCFG := LoadProperties(retroCFGFile)	; load the config into memory
	raCfgHasChanges := ""
	WriteRetroProperty("input_overlay", overlay)
	WriteRetroProperty("video_shader", videoShader)
	WriteRetroProperty("aspect_ratio_index", aspectRatioIndex)
	WriteRetroProperty("custom_viewport_width", customViewportWidth)
	WriteRetroProperty("custom_viewport_height", customViewportHeight)
	WriteRetroProperty("custom_viewport_x", customViewportX)
	WriteRetroProperty("custom_viewport_y", customViewportY)
	WriteRetroProperty("video_rotation", rotation)
	WriteRetroProperty("video_crop_overscan", cropOverscan)
	WriteRetroProperty("video_threaded", threadedVideo)
	WriteRetroProperty("video_vsync", vSync)
	WriteRetroProperty("video_scale_integer", integerScale)
	WriteRetroProperty("input_disk_eject_toggle", ejectToggleKey)
	WriteRetroProperty("input_disk_next", nextDiskKey)
	WriteRetroProperty("input_disk_prev", prevDiskKey)
	If InStr(retroID, "LibRetro_PSX") {
		Loop, 8	; Loop 8 times for 8 controllers
		{	p%A_Index%ControllerType := IniReadCheck(sysSettingsFile, systemName . "|" . romName, "P" . A_Index . "_Controller_Type", 517,,1)
			WriteRetroProperty("input_libretro_device_p" . A_Index, p%A_Index%ControllerType)
		}
	}

	If raCfgHasChanges {
		Log("Module - Saving changed settings to: """ . retroCFGFile . """")
		SaveProperties(retroCFGFile, retroCFG)
	}
}

fullscreen := If fullscreen = "true" ? " -f" : ""
srmPath := emuPath . "\srm\" . retroSystem	; path for this system's srm files
saveStatePath := emuPath . "\save\" . retroSystem	; path for this system's save state files
retroCFGFile := If foundCfg ? " -c """ . retroCFGFile . """" : ""

If !FileExist(srmPath)
	FileCreateDir, %srmPath% ; creating srm dir if it doesn't exist
If !FileExist(saveStatePath)
	FileCreateDir, %saveStatePath% ; creating save dir if it doesn't exist

HideEmuStart()	; This fully ensures windows are completely hidden even faster than winwait

If InStr(core, "mess") {	; if a mess core is used
	Run(executable . " """ . (retroMessID ? retroMessID : "") . fullRomPath . """ " . fullscreen . retroCFGFile . " -L """ . libDll . """ -s """ . srmPath . "\" . romName . ".srm"" -S """ . saveStatePath . "\" . romName . ".state""" . netCommand, emuPath, "Hide")
} Else If (retroID = "LibRetro_SGB" || If superGB = "true") { ; For some reason, the order of our command line matters in this particular case.
	Run(executable . " " . fullscreen . retroCFGFile . " -L """ . libDll . """ -s """ . srmPath . "\" . romName . ".srm"" -S """ . saveStatePath . "\" . romName . ".state""" . fullRomPath . netCommand, emuPath, "Hide")
} Else If FileExist(mgM3UPath) {
	Run(executable . " " . """" . mgM3UPath . """" . fullscreen . retroCFGFile . " -L """ . libDll . """ -s """ . srmPath . "\" . romName . ".srm"" -S """ . saveStatePath . "\" . romName . ".state""" . netCommand, emuPath, "Hide")
} Else {
	Run(executable . " " . fullRomPath . fullscreen . retroCFGFile . " -L """ . libDll . """ -s """ . srmPath . "\" . romName . ".srm"" -S """ . saveStatePath . "\" . romName . ".state""" . netCommand, emuPath, "Hide")
}

mpMenuStatus := ""
If networkSession {
	canceledServerWait := false
	multiplayerMenuExit := false
	SetTimer, NetworkConnectedCheck, 500

	If (networkType = "server") {
		Log("Module - Waiting for a client to connect to your server")
		mpMenuStatus := MultiPlayerMenu(,,,,,,,,"You are the server. Please wait for your client to connect.")
	} Else {	; client
		Log("Module - Trying to contact the server to establish a connection.")
		mpMenuStatus := MultiPlayerMenu(,,,,,,,,"Attempting to connect to the server...")
	}

	If (mpMenuStatus = -1) {	; if user exited menu early before a client connected
		Log("Module - Cancelled waiting for the " . If (networkType = "server") ? "client to connect" : "server to respond" . ". Exiting module.",2)
		If Process("Exist", executable)
			Process("Close", executable)	; must close process as the exe is waiting for a client to connect and no window was drawn yet
		ExitModule()
	} Else {	; blank response from MultiPlayerMenu, exited properly
		Log("Module - " . If (networkType = "server") ? "Client has connected" : "Connected to the server")
		WinWait("RetroArch ahk_class RetroArch")
		WinWaitActive("RetroArch ahk_class RetroArch")
	}
	SetTimer, NetworkConnectedCheck, Off
} Else {	; single player
	WinWait("RetroArch ahk_class RetroArch")
	WinWaitActive("RetroArch ahk_class RetroArch")
}

If (hideConsole = "true")
	WinSet, Transparent, On, ahk_class ConsoleWindowClass	; makes the console window transparent so you don't see it on exit

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


; Writes new properties into the retroCFG if defined by user
WriteRetroProperty(key,value="") {
	If (value != "") {
		Global retroCFG,raCfgHasChanges
		WriteProperty(retroCFG, key, value,1,1)
		raCfgHasChanges := 1
	}
}

; Used to convert between RetroArch keys and usable data
ConvertRetroCFGKey(txt,direction="read"){
	Global emuPath
	If (direction = "read")
	{	StringTrimLeft,newtxt,txt,1	; removes the " from the left of the txt
		StringTrimRight,newtxt,newtxt,1	; removes the " from the right of the txt
		relativeCheck := SubStr(newtxt, 1, 1)
		If InStr(relativeCheck,":") {	; if the path contains a ":" then it is a relative path
			Log("ConvertRetroCFGKey - " . newtxt . " is a relative path",4)
			StringTrimLeft,newtxt,newtxt,1	; removes the : from the left of the txt
			newtxt := AbsoluteFromRelative(emuPath, "." . newtxt)	; convert relative to absolute
		}
		If InStr(newtxt,"/")
			StringReplace,newtxt,newtxt,/,\,1	; replaces all forward slashes with backslashes
	} Else If (direction = "write")
	{	newtxt := """" . txt . """"	; wraps the txt with ""
		If InStr(newtxt,"\")
			StringReplace,newtxt,newtxt,\,/,1	; replaces all backslashes with forward slashes
	} Else
		ScriptError("Not a valid use of ConvertRetroCFGKey. Only ""read"" or ""write"" are supported.")
	Log("ConvertRetroCFGKey - Converted " . txt . " to " . newtxt,4)
	Return newtxt
}

; This will simply create a new blank ini if one does not exist
CheckSysFile(file){
	If !FileExist(file)
		FileAppend,, %file%
	Return file
}

MultiGame:
	SetKeyDelay(100)
	WinActivate, ahk_class RetroArch
	Send, {%ejectToggleKey% down}{%ejectToggleKey% up}	; eject disc in Retroarch
	If (!mgLastRomIndex) {
		mgLastRomIndex := mgRomIndex
	}
	selectedRomIndex := 0
	StringTrimLeft, selectedRomIndex, selectedRomNum, StrLen(mgType)
	
	Loop %mgMaxIndex% {
		If (m3uRomIndex[A_index] = mgLastRomIndex) {
			tempLastRomIndex := A_index
			Log("Temp last index: " . tempLastRomIndex)
		}
		If (m3uRomIndex[A_index] = selectedRomIndex) {
			tempSelectedRomIndex := A_index
			Log("temp selected index: " . tempSelectedRomIndex)
		}
	}
	
	mgNewIndex := tempLastRomIndex - tempSelectedRomIndex
	
	If (mgNewIndex < 0) {
		mgNewIndex := mgNewIndex * -1
		Loop %mgNewIndex% {
			Log("Sending the next disk key: " . nextDiskKey)
			Send, {%nextDiskKey% down}{%nextDiskKey% up}
		}
	} Else If (mgNewIndex > 0) {
		Loop %mgNewIndex% {
			Log("Sending the previous disk key: " . mgNewIndex)
			Send, {%prevDiskKey% down}{%prevDiskKey% up}
		}
	}
	
	Send, {%ejectToggleKey% down}{%ejectToggleKey% up}	; close disc in Retroarch
	mgLastRomIndex := selectedRomIndex
Return

NetworkConnectedCheck:
	If clientConnected
		multiplayerMenuExit := true
	Else If WinExist("RetroArch ahk_class RetroArch") {
		Log("Module - RetroArch session started, closing the MultiPlayer menu",4)
		multiplayerMenuExit := true
	}
Return

CloseProcess:
	FadeOutStart()
	WinClose("RetroArch ahk_class RetroArch")
Return
