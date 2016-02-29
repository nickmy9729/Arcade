MEmu = Raine
MEmuV = v0.64.9
MURL = http://rainemu.swishparty.co.uk/
MAuthor = brolly
MVersion = 2.0.0
MCRC = 895120BF
iCRC = 4BF75BC8
MID = 635038268907767111
MSystem = "SNK Neo Geo CD","SNK Neo Geo","SNK Neo Geo MVS","SNK Neo Geo AES"
;-------------------------------------------------------------------------
; Notes:
; First time you run the emu, it will ask you to find the Neocd.bin bios, so place it in the folder with the emulator or a "bios" subfolder.
; If you get an error "Could not open IPL.TXT", then you have one of the below problems:
; Not using a real Neo-Geo CD game (which are cd images) that contain an IPL.TXT. Do not use MAME roms otherwise you will get this error.
;
; To play MVS/AES games you first need to set the rom paths on the emulator config file. By default Raine will look for roms in a sub-folder named roms
; If you want to use different or multiple rom paths you can do it by editing the config\raine32_sdl.cfg file and adding the paths under the Directories section
; Like for example to use 2 different rom paths:
; rom_dir_0 = E:\HyperSpin\Emulators\Raine\roms\
; rom_dir_1 = E:\HyperSpin\Games\SNK Neo Geo\
;
; If you don't add all your roms (both bios and games) to the cfg file then Raine will fail to load the games as it won't be able to find the rom files.
;
; The config file raine32_sdl.cfg should be in the config folder. If this file doesn't exist, start Raine change any setting and exit so it will create this file on exit
;
; Useful command line switches:
; raine32.exe -gamelist
; raine32.exe -listdsw
; raine32.exe -h
;-------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

IfExist, % modulePath . "\" . systemName . ".ini"	; use a custom systemName ini if it exists
	settingsFile := modulePath . "\" . systemName . ".ini"
Else
	settingsFile := modulePath . "\" . moduleName . ".ini"

If systemName contains AES
	DefaultBiosVersion := "22"

Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
ScreenWidth := IniReadCheck(settingsFile, "Settings", "ScreenWidth","",,1)
ScreenHeight := IniReadCheck(settingsFile, "Settings", "ScreenHeight","",,1)
BiosVersion := IniReadCheck(settingsFile, "Settings" . "|" . romName, "BiosVersion", DefaultBiosVersion,,1) ;AES should be 22 and 23

;Setting Region
If romName contains (Japan)
	DefaultRegion := "0"
Else If romName contains (Europe)
	DefaultRegion := "2"
Else If romName contains (Brazil)
	DefaultRegion := "3"
Else
	DefaultRegion := "1" ;USA

Region := IniReadCheck(settingsFile, "settings|" . romName, "Region",DefaultRegion,,1)

RaineIni := CheckFile(emuPath . "\config\raine32_sdl.cfg")

BezelStart()

7z(romPath, romName, romExtension, 7zExtractPath)

If romExtension in .7z,.rar
	ScriptError("NeoRaine only supports zip archives. Either enable 7z support, or extract your games first.")

cliOptions := " -nogui"
If ( Fullscreen = "true")
	cliOptions := cliOptions . " -fs 1"
Else
	cliOptions := cliOptions . " -fs 0"

If (ScreenWidth)
	cliOptions := cliOptions . " -screenx " . ScreenWidth
If (ScreenHeight)
	cliOptions := cliOptions . " -screeny " . ScreenHeight

If systemName contains AES
	cliOptions := cliOptions . " -cont" ;Enable continuous play

If (systemName = "SNK Neo Geo CD")
{
	cliOptions := cliOptions . " -region " . Region
	cliOptions := cliOptions . " """ . romPath . "\" . romName . romExtension . """"
}
Else
	cliOptions := cliOptions . " -g " . romName

If systemName not contains CD
{
	If (BiosVersion)
		IniWrite, %BiosVersion%, %RaineIni%, neogeo, bios
}

Run(executable . cliOptions, emuPath)

WinWait("ahk_class SDL_app")
WinWaitActive("ahk_class SDL_app")
BezelDraw()

FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
FadeOutExit()
FadeOutExit()
ExitModule()

RestoreEmu:
	Sleep, 500
	Send, {Tab}
	Sleep, 200
	Send, {Enter}
Return

CloseProcess:
	FadeOutStart()
	WinClose, ahk_class SDL_app
Return
