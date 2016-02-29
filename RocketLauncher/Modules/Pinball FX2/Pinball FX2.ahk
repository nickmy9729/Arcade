MEmu = Pinball FX2
MEmuV = N/A
MURL = http://www.pinballfx.com/
MAuthor = djvj,bleasby
MVersion = 2.1.2
MCRC = A7F6AB41
iCRC = 489E4B10
mId = 635244873683327779
MSystem = "Pinball FX2","Pinball"
;----------------------------------------------------------------------------
; Notes:
; If launching as a Steam game:
; When setting this up in RocketLauncherUI under the global emulators tab, make sure to select it as a Virtual Emulator. Also no rom extensions, executable, or rom paths need to be defined. You can put an extension of pxp if you want RLUI audit to work however. It will not affect launching.
; Set Skip Checks to "Rom and Emu" when using this module as roms do not exist.
;
; If not launching through Steam:
; Add this as any other standard emulator and define the PInball FX2.exe as your executable, but still select Virtual Emulator as you do not need rom extensions or rom paths
; Set Skip Checks to "Rom and Emu" when using this module as roms do not exist.
;
; When setting this up in RocketLauncherUI under the global emulators tab, make sure to set rom extensions to pxp
; Also make your rom path the Pinball FX2\data_steam folder if you want audit to show green
;
; DMD (Dot Matrix Display)
; The module will support and hide the window components of detached DMD
; To see it, you must have a 2nd monitor connected as an extension of your desktop, and placement will be on that monitor
; To Detach:
; Run Pinball FX2 manually, and goto Help & Options -> Settings -> Video
; Set Dot Matrix Size to Off, and close Pinball FX2
; The module will automatically create the dotmatrix.cfg file in the same folder of the "Pinball FX2.exe" (your installation folder) for you
; Edit the module's settings in RLUI to customize the DMD size and placement of this window
;----------------------------------------------------------------------------
StartModule()
BezelGUI()
FadeInStart()

settingsFile := modulePath . "\" . moduleName . ".ini"
pinballTitleClass := "Pinball FX2 ahk_class PxWindowClass"
fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
fullscreenWidth := IniReadCheck(settingsFile, "Settings", "Fullscreen_Width",A_ScreenWidth,,1)
fullscreenHeight := IniReadCheck(settingsFile, "Settings", "Fullscreen_Height",A_ScreenHeight,,1)
externalDMD := IniReadCheck(settingsFile, "Settings", "External_DMD","false",,1)
dmdX := IniReadCheck(settingsFile, "Settings", "DMD_X",A_ScreenWidth,,1)
dmdY := IniReadCheck(settingsFile, "Settings", "DMD_Y",0,,1)
dmdW := IniReadCheck(settingsFile, "Settings", "DMD_Width",0,,1)
dmdH := IniReadCheck(settingsFile, "Settings", "DMD_Height",0,,1)

BezelStart()

fullscreen := fullscreen = "true" ? " -fullscreen" : " -borderless"	; -window is also supported but not used in this module
resolution := " -resolution" . fullscreenWidth . "x" . fullscreenHeight

If (externalDMD = "true") {
	Log("Module - Updating external DMD window placement values",4)
	If !executable
		If !steamPath
			GetSteamPath()
	dotmatrixCFGFile := If executable ? emuPath . "\dotmatrix.cfg" : steamPath . "\SteamApps\common\Pinball FX2\dotmatrix.cfg"
	If !FileExist(dotmatrixCFGFile)
		FileAppend, %dotmatrixCFGFile%	; create a new blank file if one does not exist
	Log("Module - Using this dotmatrix.cfg: " . dotmatrixCFGFile,4)
	dotmatrixCFG := LoadProperties(dotmatrixCFGFile)
	WriteProperty(dotmatrixCFG, "x", dmdX, 1)
	WriteProperty(dotmatrixCFG, "y", dmdY, 1)
	WriteProperty(dotmatrixCFG, "width", dmdW, 1)
	WriteProperty(dotmatrixCFG, "height", dmdH, 1)
	SaveProperties(dotmatrixCFGFile, dotmatrixCFG)	
}

hideEmuObj := Object(pinballTitleClass,1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
HideEmuStart()

If executable {
	Log("Module - Running Pinball FX2 as a stand alone game and not through Steam as an executable was defined.")
	Run(executable . " " . romName . fullscreen . resolution, emuPath)
} Else {
	Log("Module - Running Pinball FX2 through Steam.")
	Steam(226980,,romName . fullscreen . resolution)
}

WinWait(pinballTitleClass)
WinWaitActive(pinballTitleClass)

; Attempt to hide window components of the detached DMD
If (externalDMD = "true") {
	Gui +LastFound
	hWnd := WinExist()
	DllCall("RegisterShellHookWindow", UInt,hWnd)
	MsgNum := DllCall("RegisterWindowMessage", Str,"SHELLHOOK")
	OnMessage(MsgNum, "ShellMessage")
}

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose", "Pinball FX2.exe")
BezelExit()
FadeOutExit()
ExitModule()
    

ShellMessage(wParam, lParam) {
	Log("Module - DMD external window - " . wParam,4)
	If (wParam = 1)
		If WinExist("Pinball FX2 DotMatrix ahk_class PxWindowClass")
		{
			WinSet, Style, -0xC00000 ; hide title bar
			WinSet, Style, -0x800000 ; hide thin-line border
			WinSet, Style, -0x400000 ; hide dialog frame
			WinSet, Style, -0x40000 ; hide thickframe/sizebox
			;WinMove, , , 0, 0, 1920, 1080
		} 
}

CloseProcess:
	FadeOutStart()
	WinClose(pinballTitleClass)
Return
