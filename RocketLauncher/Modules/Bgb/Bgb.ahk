MEmu = Bgb
MEmuV =  v1.4.3
MURL = http://bgb.bircd.org/
MAuthor = djvj,ghutch92
MVersion = 2.0.6
MCRC = B399DD36
iCRC = 6B31DD58
mId = 635637123510883144
MSystem = "Nintendo Game Boy","Nintendo Game Boy Color"
;----------------------------------------------------------------------------
; Notes:
; Place the "[BIOS] Nintendo Game Boy Color Boot ROM (World).gbc" rom in the bgb dir so you get correct colors
; Run the emu, right click and goto Options->System->GBC Bootrom and paste in the filename of the GBC boot rom
; Don't forget to check the "bootroms enabled" box
; Set fullscreen via the variable below
; You can set your fullscreen res by dragging the window to your desired size or selecting one of the Window sizes
;----------------------------------------------------------------------------
StartModule()
BezelGUI()

settingsFile := modulePath . "\" . systemName . ".ini"
IfNotExist, %settingsFile%
	settingsFile := modulePath . "\" . moduleName . ".ini"

SplitScreen2PlayersMode := IniReadCheck(settingsFile, "Settings", "SplitScreen_2_Players","Vertical",,1) ;horizontal or vertical
SplitScreen3PlayersMode := IniReadCheck(settingsFile, "Settings", "SplitScreen_3_Players","P1top",,1) ; For Player1 screen to be on left: P1left. For Player1 screen to be on top: P1top. For Player1 screen to be on bottom: P1bottom. For Player1 screen to be on right: P1right.

Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
FullscreenWidth := IniReadCheck(settingsFile, "Settings", "Fullscreen_Width",A_ScreenWidth,,1)
FullscreenHeight := IniReadCheck(settingsFile, "Settings", "Fullscreen_Height",A_ScreenHeight,,1)
SGBColorsEnabled := IniReadCheck(settingsFile, "Settings", "SGB_Colors_Enabled","false",,1) ; if enabled some game boy games will have color instead of being black and white
SGBBorderEnabled := IniReadCheck(settingsFile, "Settings", "SGB_Border_Enabled","false",,1) ; if enabled some game boy games will have the border that the SGB used for tv screens
multiplayerMenu := IniReadCheck(settingsFile, "Settings|" . romName, "Multiplayer_Menu","false",,1)

If (multiplayerMenu = "true")
	SelectedNumberofPlayers := NumberOfPlayersSelectionMenu(4)

FadeInStart()

If (SelectedNumberofPlayers > 1)
	BezelStart(SelectedNumberofPlayers)	
Else
	BezelStart()

; Using commandline -setting name=value to set emulator options

; This disables Esc from bringing up the debug window (bgb's default behavior). If it's on, pressing Esc brings up debug, rather then closing the emu
parameters := " -setting DebugEsc=0"
;disables or enables Super Game Boy Colors for the Game Boy (DMG)
parameters := (SGBColorsEnabled = "true") ? (parameters . " -setting SGBnocolors=0") : (parameters . " -setting SGBnocolors=1")
;disables or enables Super Game Boy Border for the Game Boy (DMG)
parameters := (SGBBorderEnabled = "true") ? (parameters . " -setting Border=1") : (parameters . " -setting Border=0")

hideEmuObj := Object("ahk_class OS95",1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
7z(romPath, romName, romExtension, 7zExtractPath)


HideEmuStart()
If ((SelectedNumberofPlayers = 1) OR (multiplayerMenu = "false")) {
	;setting fullscreen or windowed
	If (Fullscreen = "true")
		parameters .= " -setting Windowmode=3 -setting DDrawFSWidth=" . FullscreenWidth . " -setting DDrawFSHeight=" . FullscreenHeight
	Else
		parameters .= " -setting Windowmode=1"

	Run(executable . parameters . " """ . romPath . "\" . romName . romExtension . """",emuPath)
	WinWait("bgb ahk_class Tfgb")
	WinWaitActive("bgb ahk_class Tfgb")
} Else 
{
	;screen positions
	If (SelectedNumberofPlayers = 2)
		If (SplitScreen2PlayersMode = "Vertical")
			X1 := 0 , Y1 := 0 ,	W1 := A_ScreenWidth//2 , H1 := A_ScreenHeight , X2 := A_ScreenWidth//2 , Y2 := 0 ,	W2 := A_ScreenWidth//2 , H2 := A_ScreenHeight
		Else
			X1 := 0 , Y1 := 0 ,	W1 := A_ScreenWidth , H1 := A_ScreenHeight//2 , X2 := 0 , Y2 := A_ScreenHeight//2 ,	W2 := A_ScreenWidth , H2 := A_ScreenHeight//2
	Else If (SelectedNumberofPlayers = 3)
		If (SplitScreen3PlayersMode = "P1left")
			X1 := 0 , Y1 := 0 ,	W1 := A_ScreenWidth//2 , H1 := A_ScreenHeight , X2 := A_ScreenWidth//2 , Y2 := 0 ,	W2 := A_ScreenWidth//2 , H2 := A_ScreenHeight//2 , X3 := A_ScreenWidth//2 , Y3 := A_ScreenHeight//2 ,	W3 := A_ScreenWidth//2 , H3 := A_ScreenHeight//2
		Else If (SplitScreen3PlayersMode = "P1bottom")
			X1 := 0 , Y1 := A_ScreenHeight//2 ,	W1 := A_ScreenWidth , H1 := A_ScreenHeight//2 , X2 := 0 , Y2 := 0 ,	W2 := A_ScreenWidth//2 , H2 := A_ScreenHeight//2 , X3 := A_ScreenWidth//2 , Y3 := 0 ,	W3 := A_ScreenWidth//2 , H3 := A_ScreenHeight//2
		Else If (SplitScreen3PlayersMode = "P1right")
			X1 := A_ScreenWidth//2 , Y1 := 0 ,	W1 := A_ScreenWidth//2 , H1 := A_ScreenHeight ,	X2 := 0 , Y2 := 0 ,	W2 := A_ScreenWidth//2 , H2 := A_ScreenHeight//2 , X3 := 0 , Y3 := A_ScreenHeight//2 ,	W3 := A_ScreenWidth//2 , H3 := A_ScreenHeight//2
		Else	; top
			X1 := 0 , Y1 := 0 ,	W1 := A_ScreenWidth , H1 := A_ScreenHeight//2, X2 := 0 , Y2 := A_ScreenHeight//2 ,	W2 := A_ScreenWidth//2 , H2 := A_ScreenHeight//2, X3 := A_ScreenWidth//2 , Y3 := A_ScreenHeight//2 , W3 := A_ScreenWidth//2 , H3 := A_ScreenHeight//2
	Else
		X1 := 0 , Y1 := 0 ,	W1 := A_ScreenWidth//2 , H1 := A_ScreenHeight//2 , X2 := A_ScreenWidth//2 , Y2 := 0 ,	W2 := A_ScreenWidth//2 , H2 := A_ScreenHeight//2 , X3 := 0 , Y3 := A_ScreenHeight//2 ,	W3 := A_ScreenWidth//2 , H3 := A_ScreenHeight//2 , X4 := A_ScreenWidth//2 , Y4 := A_ScreenHeight//2 ,	W4 := A_ScreenWidth//2 , H4 := A_ScreenHeight//2

	;removing fullscreen ## only app with focus receives input. This means player 1 can't control player 2's game. ## Turning on remotejoy so player 2 can actually play
	parameters .= " -setting Windowmode=1 -setting JoyFocus=1 -setting RemoteJoy=1"
	
	Address := "127.0.0.1"		;local address
	Port    := 8765				;default port
		
	Loop, %SelectedNumberofPlayers%
	{
		
		parameters .= " " . (If (A_Index = 1) ? "-listen" : "-connect") . " " . address . ":" . port
		
		multi_romName := gamesSelectedArray[A_Index]
		If !multi_romName
			multi_romName := romName
		
		Run(executable . parameters . " """ . romPath . "\" . multi_romName . romExtension . """",emuPath,, Screen%A_Index%PID)
		WinWait("ahk_pid " . Screen%A_Index%PID)
		WinGet, Screen%A_Index%ID, ID, % "ahk_pid " . Screen%A_Index%PID
		If Fullscreen = true
		{	WinSet, Style, -0xC00000, % "ahk_id " . Screen%A_Index%ID
			ToggleMenu(Screen%A_Index%ID)
			WinSet, Style, -0xC40000, % "ahk_id " . Screen%A_Index%ID
			currentScreen := a_index
			WinMove,  % "ahk_id " . Screen%currentScreen%ID, , % X%currentScreen%, % Y%currentScreen%, % W%currentScreen%, % H%currentScreen%
			;check If window moved
			timeout := A_TickCount
			Loop
			{	WinGetPos, X, Y, W, H, % "ahk_id " . Screen%currentScreen%ID
				If (X=X%currentScreen%) and (Y=Y%currentScreen%) and (W=W%currentScreen%) and (H=H%currentScreen%)
					break
				If (timeout<A_TickCount-2000)
					Break
				Sleep, 50
				WinMove, % "ahk_id " . Screen%currentScreen%ID, , % X%currentScreen%, % Y%currentScreen%, % W%currentScreen%, % H%currentScreen%
			}
		}
		Sleep, 50
	}	
}	

BezelDraw()
HideEmuEnd()
FadeInExit()
Process("WaitClose", executable)
7zCleanUp()
BezelExit()
FadeOutExit()
ExitModule()


CloseProcess:
	FadeOutStart()
	If (SelectedNumberofPlayers>1) {
		Loop, %SelectedNumberofPlayers%
		{	WinClose("ahk_id " . Screen%a_index%ID)
			WinWaitClose("ahk_id " . Screen%a_index%ID)
		}
	} Else
		WinClose("ahk_class Tfgb")
Return
