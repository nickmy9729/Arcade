MEmu = Pinball Arcade
MEmuV = v1.45.6
MURL = http://www.pinballarcade.com/
MAuthor = djvj,Metalzoic
MVersion = 2.0.9
MSystem = "Pinball Arcade","Pinball"
MCRC = FABA6303
iCRC = 424631F4
mId = 635860796513198675
;----------------------------------------------------------------------------
; Notes:
; Initial setup:
; Manually run Pinball Arcade. 
; If you own all the tables and they can all be found in the My Tables section in-game, simply enter My Tables from the main Pinball Arcade menu, browse to the first table (alphabetically) and exit Pinball Arcade.
; The module comes default with all the available tables (as of 12/18/2015) alphabetically sorted in the module setting My_Tables.
; It will parse this setting and assume you own all the tables. If you do not own all the tables, recreate this setting in the RocketLauncherUI module settings with only the tables you do own, and separate each one with a |
; If you do not own all the tables you also need to change the All_Tables module setting in RocketLauncherUI to "false" for the module to navigate the menu properly.
; The My_Tables names must match the names from your database.
;
; If launching as a Steam game:
; When setting this up in RocketLauncherUI under the global emulators tab, make sure to select it as a Virtual Emulator. Also no rom extensions, executable, or rom paths need to be defined.
; Under the Pinball Arcade system settings in RocketLauncherUI set Skip Checks to "Rom and Emu" when using this module as roms do not exist.
; The executable must be named PinballArcade.exe to work properly. Rename it if it does not match that exactly.
;
; If not launching through Steam:
; Add this as any other standard emulator and define the PinballArcade.exe as your executable, but still select Virtual Emulator as you do not need rom extensions or rom paths to be defined.
; Under the Pinball Arcade system settings in RocketLauncherUI set Skip Checks to "Rom and Emu" when using this module as roms do not exist.
; The executable must be named PinballArcade.exe to work properly. Rename it if it does not match that exactly.
;
; To use the DX11 version of Pinball Arcade you must select the DX11 option in the module settings.
; For the Steam version you must also rename the actual Steam DX11 exe file. Go to Programs (x86)/Steam/Steamapps/Common/PinballArcade and rename PinballArcade.exe to PinballArcadeDX9.exe (or whatever you want) to make a backup. 
; Then rename PinballArcade11.exe to just PinballArcade.exe. Changing the name does not cause issues with updating, but you'll have to do this renaming step every time they update the game with a new version. 
; If you are using a non-Steam version then you may or may not need to rename the exe and certain module setting may or may not work (such as no-nag), however your exe must be named PinballArcade.exe for it to work.
;
; This module requires BlockInput.exe to exist in your Module Extensions folder. It is used to prevent users from messing up the table selection routine.
; If BlockInput is not actually blocking input, it's due to not having admin credentials, which you will need to set this exe to run as admin.
; However, this also means RocketLauncher needs to be set to run as admin as well, keep this in mind.
;
; If you want bezel support set to the game be played in windowed mode
;
; How to run vertical games on a standard monitor:
; There are 3 methods supported by this module to rotate your desktop. Windows shortcuts, display.exe and irotate.exe. If one method does not work on your computer, try another.
;
; If the key sends are not working, make sure your RocketLauncher is set to run as administrator.
;
; Pinball Arcade stores some settings in your registry @ HKEY_CURRENT_USER\Software\PinballArcade\PinballArcade
;----------------------------------------------------------------------------
StartModule()

settingsFile := modulePath . "\" . moduleName . ".ini"
rotateMethod := IniReadCheck(settingsFile, "settings", "Rotate_Method", rotateMethod,,1) ; Shortcut, Display, iRotate 
rotateDisplay := IniReadCheck(settingsFile, "settings", "Rotate_Display", 0,,1) ; 0, 90, 180, 270
moduleDebugging := IniReadCheck(settingsFile, "settings", "Module_Debugging", "false",,1)
selectKey := IniReadCheck(settingsFile, "settings", "Select_Key", navSelectKey,,1)

If (RotateDisplay > 0) {
	Res := (A_ScreenWidth>A_ScreenWidth) ? A_ScreenWidth : A_ScreenWidth
	Gui 1: Color, 000000
	Gui 1: -Caption +ToolWindow
	Gui 1: Show, x0 y0 W%Res% H%Res%, BlackScreen	; experimental to hide entire desktop and windows
	Rotate(rotateMethod, rotateDisplay)
}

BezelGUI()
FadeInStart()

fullscreen := IniReadCheck(settingsFile, "settings", "Fullscreen", "true",,1) ; 0, Shortcut, Display, iRotate 
startGame := IniReadCheck(settingsFile, "settings", "Start_Game","true",,1)
pinballVersion := IniReadCheck(settingsFile, "settings", "Pinball_Version", "DX11",,1)
allTables := IniReadCheck(settingsFile, "settings", "All_Tables","true",,1)
sleepLogo := IniReadCheck(settingsFile, "Settings", "Sleep_Until_Logo",7000,,1)
sleepBaseTime := IniReadCheck(settingsFile, "Settings", "Sleep_Base_Time",1,,1)
lastMyTable := "Addams Family, The (Bally)"	; Mytables always starts on The Addams Family
myTables := IniReadCheck(settingsFile, "Settings", "My_Tables","Addams Family, The (Bally)|Attack from Mars (Bally)|Big Shot (Gottlieb)|Black Hole (Gottlieb)|Black Knight 2000 (Williams)|Black Knight (Williams)|Black Rose (Bally)|Bram Stoker's Dracula (Williams)|Bride of Pin-Bot (Williams)|Cactus Canyon (Bally)|Centaur (Bally)|Central Park (Gottlieb)|Champion Pub, The (Bally)|Cirqus Voltaire (Bally)|Class of 1812 (Gottlieb)|Creature from the Black Lagoon (Bally)|Cue Ball Wizard (Gottlieb)|Cyclone (Williams)|Diner (Williams)|Dr. Dude & His Excellent Ray (Bally)|Earthshaker (Williams)|El Dorado - City Of Gold (Gottlieb)|Elvira and the Party Monsters (Bally)|F-14 Tomcat (Williams)|Firepower (Williams)|Fish Tales (Williams)|Flight 2000 (Stern)|FunHouse (Williams)|Genie (Gottlieb)|Getaway, The - High Speed II (Williams)|Goin' Nuts (Gottlieb)|Gorgar (Williams)|Harley-Davidson, 3rd Edition (Stern)|Haunted House (Gottlieb)|High Roller Casino (Stern)|High Speed (Williams)|Jack-Bot (Williams)|Judge Dredd (Bally)|Junk Yard (Williams)|Lights... Camera... Action! (Gottlieb)|Mary Shelley's Frankenstein (Sega)|Medieval Madness (Williams)|Monster Bash (Williams)|No Fear - Dangerous Sports (Williams)|No Good Gofers (Williams)|Party Zone (Bally)|Phantom of the Opera, The (Data East)|Pin-Bot (Williams)|Red & Ted's Roadshow (Williams)|Ripley's Believe It or Not! (Stern)|Safe Cracker (Bally)|Scared Stiff (Bally)|Space Shuttle (Williams)|Star Trek - The Next Generation (Williams)|Starship Troopers (Sega)|Tales of the Arabian Nights (Williams)|Taxi (Williams)|Tee'd Off (Gottlieb)|Terminator 2 - Judgment Day (Williams)|Theatre of Magic (Bally)|Twilight Zone (Bally)|Victory (Gottlieb)|Whirlwind (Williams)|White Water (Williams)|WHO Dunnit (Bally)|Xenon (Bally)",,1)	; | v1.45.6 separated list of the tables user owns

pinballTitleClass := "Pinball Arcade ahk_class " . (If pinballVersion = "DX11" ? "GameWindowClass" : "Pinball Arcade")

BezelStart()

; get user's save path
paUserPath := RegRead("HKCU", "Software\PinballArcade\PinballArcade", "SavePath", "Auto")
pinballArcadeDat := CheckFile(paUserPath . "settings.dat")

; Update fullscreen setting
res := BinRead(pinballArcadeDat,pinballArcadeDatData,1,8)	; read current fullscreen setting
Bin2Hex(hexData,pinballArcadeDatData,res)
If (fullscreen = "true" && hexData != "02") {
	Hex2Bin(binData,"02")
	res := BinWrite(pinballArcadeDat,binData,1,8)
} Else If (fullscreen != "true" && hexData != "00") {
	Hex2Bin(binData,"00")
	res := BinWrite(pinballArcadeDat,binData,1,8)
}

; Convert myTables into a real array
myTablesArray := []
Loop, Parse, myTables, |
{
	myTablesArray[A_Index] := A_Loopfield
	If (romName = A_Loopfield) {
		thisTablePos := A_Index ; store the position (in the array) this table was found
		thisTableArray := "myTablesArray"       ; save the array this table was found in
		lastTable := lastMyTable        ; store the last table loaded for the same array as this table
		Log("Module -  Found """ . romName . """ at position " . thisTablePos . " in MyTables")
	}
}

CheckFile(moduleExtensionsPath . "\BlockInput.exe")

If !thisTableArray
	ScriptError("This table """ . romName . """ was not found in My Tables folder. Please check its name that it matches what the module recognizes.")
Log("Module - Table """ . romName . """ was found in array """ . thisTableArray . """ at position " . thisTablePos)
Log("Module - Last Table of array """ . thisTableArray . """ left off at """ . lastTable . """ which was found at position " . lastTablePos)

; Calculate the shortest distance to this table from the lastTable
max := %thisTableArray%.MaxIndex()
a := 1
b := thisTablePos
If (a > b) {
	moveDown := a - b
	moveUp := (max - a) + b
} Else If (b > a) {
	moveDown := b - a
	moveUp := (max - b) + a
} Else {	; a=b
	moveDown := 0
	moveUp := 0
}
moveDirection := If moveUp < moveDown ? "moveUp" : "moveDown"
Log("Module - The array """ . thisTableArray . """ has " . max . " tables in it and shortest distance to this table is " . %moveDirection% . " in direction " . moveDirection)

hideEmuObj := Object(pinballTitleClass,1)	; Hide_Emu will hide these windows. 0 = will never unhide, 1 = will unhide later
HideEmuStart()

If executable {
	Log("Module - Running Pinball Arcade as a stand alone game and not through Steam as an executable was defined.")
	Run(executable . " skipwhatsnew", emuPath)
} Else {
	If !steamPath
		GetSteamPath()
	Log("Module - Running Pinball Arcade through Steam.")
	Steam(238260,,"skipwhatsnew")
}

WinWait(pinballTitleClass)
WinWaitActive(pinballTitleClass)

BezelDraw()
Run("BlockInput.exe 30", moduleExtensionsPath)        ; start the tool that blocks all input so user cannot interrupt the launch process for 30 seconds
If (moduleDebugging = "true")
	Tooltip, waiting %sleepLogo% seconds for logo
SetKeyDelay(80*sleepBaseTime)
Sleep % sleepLogo      ; sleep till Pinball FX2 logo appears

If (moduleDebugging = "true")
	Tooltip, sending %selectKey% to get to the main menu
Send, {%selectKey% Down}{%selectKey% Up}        ; Presses select to enter Main Menu
If (allTables = "false") {
	Send, 300{Down Down}{Down Up}      ; Moves selection cursor down to My Tables if all tables aren't owned
}
Send, 300{%selectKey% Down}{%selectKey% Up}        ; Selects My Tables folder

If (moduleDebugging = "true")
	Tooltip, entering MyTable folder
Sleep % 2000*sleepBaseTime     ; wait for folder to load

If (moduleDebugging = "true")
	Tooltip, navigating to %romName%
SetKeyDelay(80*sleepBaseTime)
If (moveDirection = "moveUp") {
	Loop % %moveDirection%
	{	If (moduleDebugging = "true")
			Tooltip % "Index: " . A_Index . " | Game: " . %thisTableArray%[A_Index]
		Send, {Up Down}{Up Up}
		Sleep % 100*sleepBaseTime
	}
} Else {        ; moveDown
	Loop % %moveDirection%
	{	If (moduleDebugging = "true")
			Tooltip % "Index: " . A_Index . " | Game: " . %thisTableArray%[A_Index]
		Send, {Down Down}{Down Up}
		Sleep % 100*sleepBaseTime
	}
}
Send, {%selectKey% Down}{%selectKey% Up}    ; select game
Sleep % 500*sleepBaseTime

If (moduleDebugging = "true")
	Tooltip, waiting for game to load
Send, {%selectKey% Down}{%selectKey% Up}80{%selectKey% Down}{%selectKey% Up}      ; select game
If (startGame = "true") {
	Sleep % 4800*sleepBaseTime     ; waiting for table to load
	Send, {%selectKey% Down}{%selectKey% Up}80{%selectKey% Down}{%selectKey% Up}      ; start game
}
If (moduleDebugging = "true")
	Tooltip, Finished

Process("Close", "BlockInput.exe")    ; end script that blocks all input

HideEmuEnd()
FadeInExit()
Process("WaitClose", "PinballArcade.exe")
BezelExit()
FadeOutExit()

If (RotateDisplay > 0) {
	Gui 1: Show
	Rotate(rotateMethod, 0)
	Sleep % 200*sleepBaseTime
	Gui 1: Destroy
}

ExitModule()


HaltEmu:
	disableSuspendEmu := true
	Send, {ESC down}{ESC up}
Return
RestoreEmu:
	Send, {ESC down}{ESC up}
Return

CloseProcess:
	FadeOutStart()
	WinClose(pinballTitleClass)
Return
