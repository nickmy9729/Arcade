
;Set the Splash image and load all programs
SplashImage = M:\Arcade\HyperSpin\Loading.png
OutputVarPID:=SplashImageGUI(SplashImage, "Center", "Center", false)

CloseGUI(OutputVarPID)

;Shutdown,5
Exitapp




;================================= Subroutines and Keyremapping=================================
CloseGUI(PID)
{
	WinWaitClose, ahk_pid %PID%

	;Shutdown Programs when Hyperspin ends
	Process,Close,steam.exe
	Process,Close,HyperSearch.exe
	WinMinimizeAll
	;run LedBlinky.exe 2, M:\Arcade\Program Files\LEDBlinky
	;sleep, 10000
	
}
 
SplashImageGUI(Picture, X, Y, Transparent = false)
{
	WinMinimizeAll
	Process,Close,HyperSearch.exe
	Process,Close,HyperSearch.exe
	;Process,Close,HyperSearch.exe
	;Gui, XPT99:Margin , 0, 0
	;Gui, XPT99:Add, Picture,, %Picture%
	;Gui, XPT99:Color, ECE9D8
	;Gui, XPT99:+LastFound -Caption +AlwaysOnTop +ToolWindow -Border
	;If Transparent
	;{
	;	Winset, TransColor, ECE9D8
	;}
	;Gui, XPT99:Show, x%X% y%Y% NoActivate

	; Run Arcade startup programs 
	run HyperSearch.exe, M:\Arcade\HyperSpin\HyperSearch
	Process, Wait, HyperSearch.exe, 5
	;run steam.exe -bigpicture -login "Arcade" "Lisms2007.", d:\arcadebliss\Emulators\PC\Steam
	;WinWait, Steam ahk_class CUIEngineWin32
	;sleep, 4000

	; Steam Loaded, Remove GUI and start Hyperspin
	;run LedBlinky.exe 1, M:\Arcade\Program Files\LEDBlinky
	run HyperSpin.exe, M:\Arcade\HyperSpin,,OutputVarPID
	WinWait, HyperSpin
	WinActivate, HyperSpin
	;SetTimer, DestroySplashGUI

	;ensure Hyperspin is active
	WinActivate, ahk_pid %OutputVarPID%
	WinActivate, HyperSpin
	return %OutputVarPID%


	DestroySplashGUI:
		Gui, XPT99:Destroy
		return
}
