MEmu = PACMAME
MEmuV = 
MURL = 
MAuthor = spudgunjake
MVersion =
MCRC = 
iCRC =
MID = 
MSystem = "PACMAME"

;----------------------------------------------------------------------------
; need to fill this in
;----------------------------------------------------------------------------
StartModule()
;FadeInStart()

StringLower, romName, romName ; the rom's name must be passed lowercase to the emu otherwise it doesn't work

Run(executable . " " . romName, emuPath, "Hide") ; need Hide here otherwise the app pops into view over our GUI

; Sleep, 1000 ; small sleep required ottherwise Hyperspin flashes back into view

;FadeInExit()
Process("WaitClose", executable)

;FadeOutExit()
ExitModule()


CloseProcess:
	;FadeOutStart()
	;WinClose("ahk_class #32770")
	WinClose("pacmame ahk_class #32770")	
Return
