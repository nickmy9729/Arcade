MEmu = PCLauncher
MEmuV =  N/A
MURL = http://www.rlauncher.com/wiki/index.php?title=PCLauncher
MAuthor = djvj
MVersion = 2.2.0
MCRC = 3BF0E9C8
iCRC = 7B9616EE
mId = 635243126483565041
MSystem = "American Laser Games","Arcade PC","Doujin Soft","Examu eX-BOARD","Fan Remakes","Games for Windows","Konami e-Amusement","Konami Bemani","Microsoft Windows","PCLauncher","PC Games","Singstar","Steam","Steam Big Picture","Taito Type X","Taito Type X2","Touhou","Touhou Project","Ultrastar","Ultrastar Deluxe","Windows Games"
;----------------------------------------------------------------------------
; Notes:
; Use the examples in the ini, in your Modules\PCLauncher\ folder, to add more applications.
; PCLauncher supports per-System inis. Copy your PCLauncher ini in the same folder and rename it to match the System's Name. Use this if you have games with the same name across multiple systems.
; Read the comments at the top of ini for the definitions of each key.
; For informaion on how to use this module and what all the settings do, please see https://sites.google.com/site/RocketLauncher2/additional-features/pclauncher
;----------------------------------------------------------------------------
StartModule()

If (romExtensions != "")
	ScriptError("PCLauncher does not use extensions, but you have them set to: """ . romExtensions . """. Please remove all extensions from the PCLauncher emulator in RocketLauncherUI to continue using it.")

If FileExist(modulePath . "\" . systemName . ".ini")	; use a custom systemName ini if it exists
	settingsFile := modulePath . "\" . systemName . ".ini"
Else
	settingsFile := CheckFile(modulePath . "\" . moduleName . ".ini", "Could not find """ . modulePath . "\" . moduleName . ".ini"". RocketLauncherUI will create this file when you configure your first game to be used with this " . MEmu . " module.")

Application := IniReadCheck(settingsFile, dbName, "Application", "",,1)
AppWaitExe := IniReadCheck(settingsFile, dbName, "AppWaitExe", "",,1)
DiscImage := IniReadCheck(settingsFile, dbName, "DiscImage", "",,1)
DXWndGame := IniReadCheck(settingsFile, dbName, "DXWndGame", "",,1)
DXWndMaximizeWindow := IniReadCheck(settingsFile, dbName, "DXWndMaximizeWindow", "",,1)
ExitMethod := IniReadCheck(settingsFile, dbName, "ExitMethod", "",,1)
FadeTitle := IniReadCheck(settingsFile, dbName, "FadeTitle", "",,1)
FadeInExitSleep := IniReadCheck(settingsFile, dbName, "FadeInExitSleep", "",,1)
HideConsole := IniReadCheck(settingsFile, dbName, "HideConsole", "",,1)
OriginGame := IniReadCheck(settingsFile, dbName, "OriginGame", "",,1)
Parameters := IniReadCheck(settingsFile, dbName, "Parameters", "",,1)
PostLaunch := IniReadCheck(settingsFile, dbName, "PostLaunch", "",,1)
PostLaunchParameters := IniReadCheck(settingsFile, dbName, "PostLaunchParameters", "",,1)
PostLaunchSleep := IniReadCheck(settingsFile, dbName, "PostLaunchSleep", "",,1)
PostExit := IniReadCheck(settingsFile, dbName, "PostExit", "",,1)
PostExitParameters := IniReadCheck(settingsFile, dbName, "PostExitParameters", "",,1)
PostExitSleep := IniReadCheck(settingsFile, dbName, "PostExitSleep", "",,1)
PreLaunch := IniReadCheck(settingsFile, dbName, "PreLaunch", "",,1)
PreLaunchParameters := IniReadCheck(settingsFile, dbName, "PreLaunchParameters", "",,1)
PreLaunchMode := IniReadCheck(settingsFile, dbName, "PreLaunchMode", "",,1)
PreLaunchSleep := IniReadCheck(settingsFile, dbName, "PreLaunchSleep", "",,1)
SteamID := IniReadCheck(settingsFile, dbName, "SteamID", "",,1)
WorkingFolder := IniReadCheck(settingsFile, dbName, "WorkingFolder", "",,1)

If (!Application && !SteamID) { ; Create keys if they do not exist in the ini and this is not a steam game
	IniWrite(A_Space, SettingsFile, dbName, "Application")
	ScriptError("You have not set up " . dbName . " in RocketLauncherUI yet, so PCLauncher does not know what exe, FadeTitle, and/or SteamID to watch for.")
}

BezelGUI()
FadeInStart()
BezelStart()

; If Application needs a cd/dvd image in the drive, mount it in DT first
If DiscImage {
	Log("PCLauncher - Application is a Disc Image, mounting it in DT")
	appIsImage := 1
	DiscImage := GetFullName(DiscImage)	; convert a relative path defined in the PCLauncher ini to absolute
	CheckFile(DiscImage,"Cannot find this DiscImage for " . dbName . ":`n" . DiscImage)
	SplitPath,DiscImage,,ImagePath,ImageExt,ImageName
	If RegExMatch(ImageExt,"i)mds|mdx|b5t|b6t|bwt|ccd|cue|isz|nrg|cdi|iso|ape|flac")
	{	VirtualDrive("get")	; get the vdDriveLetter
		VirtualDrive("mount",ImagePath . "\" . ImageName . "." . ImageExt)
	} Else
		ScriptError("You defined a DiscImage, but it is not a supported format for this module and/or DT:`nccd,cdi,cue,iso,isz,nrg")
}

; Verify module's settings are set
CheckSettings()

If PreLaunch {
	Log("PCLauncher - PreLaunch set by user, running: " . PreLaunch)
	PreLaunchParameters := If (!PreLaunchParameters or PreLaunchParameters="ERROR") ? "" : PreLaunchParameters
	If (preLaunchMode = "run") {
		errLevel := Run(If preLSkip ? PreLaunch : """" . PreLaunchName . """ " . PreLaunchParameters, PreLaunchPath)
		If errLevel
			ScriptError("There was a problem launching your PreLaunch application. Please check it is a valid executable.")
		Sleep, %PreLaunchSleep%
	} Else {
		errLevel := RunWait(If preLSkip ? PreLaunch : """" . PreLaunchName . """ " . PreLaunchParameters, PreLaunchPath)
		If errLevel
			ScriptError("There was a problem launching your PreLaunch application. Please check it is a valid executable.")
	}
}

If (DXWndGame = "true")		; start dxwnd if needed
	DxwndRun()

If RegExMatch(mode,"i)steam|steambp")	; steam launch
	Steam(SteamID, Application, Parameters)
Else If (mode = "origin")		; origin launch
	Origin(ApplicationName, ApplicationPath, Parameters)
Else {
	If (mode = "url")
	{	Log("PCLauncher - Launching URL.")
		errLevel := Run(Application)
	} Else {	; standard launch
		Log("PCLauncher - Launching a standard application.")
		SplitPath, ApplicationName,,, AppExtension
		If (HideConsole = "true" and AppExtension = "bat") {
			Log("PCLauncher - Hiding DOS console for bat file.")
			objShell := ComObjCreate("WScript.Shell")
			objShell.CurrentDirectory := If WorkingFolder ? WorkingFolder : ApplicationPath
			errLevel := objShell.Run("""" . ApplicationName . """ " . Parameters, 0, false)
		}
		Else {
			errLevel := Run("""" . (If WorkingFolder ? ApplicationPath . "\" : "") . ApplicationName . """ " . Parameters, If WorkingFolder ? WorkingFolder : ApplicationPath,, AppPID)
		}
	}
	If errLevel
		ScriptError("There was a problem launching your " . (If appIsImage ? "ImageExe" : "Application") . ". Please check it is a valid executable.")
}

If PostLaunch {
	Log("PCLauncher - PostLaunch set by user, running: " . PostLaunch)
	PostLaunchParameters := If (!PostLaunchParameters or PostLaunchParameters="ERROR") ? "" : PostLaunchParameters
	errLevel := Run(If postLSkip ? PostLaunch : """" . PostLaunchName . """ " . PostLaunchParameters, PostLaunchPath)
	If errLevel
		ScriptError("There was a problem launching your PostLaunch application. Please check it is a valid executable.")
	Sleep, %PostLaunchSleep%
}

WinTitle := "A"
If FadeTitle {
	Log("PCLauncher - FadeTitle set by user, waiting for """ . FadeTitle . """")
	WinWait(FadeTitle)
	WinWaitActive(FadeTitle)
	WinTitle := FadeTitle
} Else If AppWaitExe {
	Log("PCLauncher - FadeTitle not set by user, but AppWaitExe is. Waiting for AppWaitExe: " . AppWaitExe)
	AppWaitPID := Process("Wait", AppWaitExe, 15)
	If (AppWaitPID = 0)
		ScriptError("PCLauncher - There was an error getting the Process ID from your AppWaitExe for """ . dbName . """. Please try setting a FadeTitle instead.")
} Else If SteamIDExe {
	Log("PCLauncher - FadeTitle and AppWaitExe not set by user, but SteamIDExe was found. Waiting for SteamIDExe: " . SteamIDExe)
	SteamIDPID := Process("Wait", SteamIDExe, 15)
	If (SteamIDPID = 0)
		ScriptError("PCLauncher - There was an error getting the Process ID from your SteamIDExe for """ . dbName . """. Please try setting a FadeTitle instead.")
} Else If AppPID {
	Log("PCLauncher - FadeTitle and AppWaitExe not set by user, but an AppPID was found. Waiting for AppPID: " . AppPID)
	WinWait("ahk_pid " . AppPID)
	WinWaitActive("ahk_pid " . AppPID)
	WinTitle := "ahk_pid " . AppPID
} Else
	Log("PCLauncher - FadeTitle and AppWaitExe not set by user and no AppPID found from an Application, PCLauncher has nothing to wait for",3)

If (DXWndGame = "true" and (DXWndMaximizeWindow = "aspect" or DXWndMaximizeWindow = "stretch"))
	MaximizeWindow(WinTitle, If (DXWndMaximizeWindow="aspect") ? "true" : "false")

BezelDraw()

Sleep, %FadeInExitSleep%	; PCLauncher setting for some stubborn games that keeps the fadeIn screen up a little longer
FadeInExit()

If AppWaitExe {
	SplitPath,AppWaitExe,AppWaitExe	; In case someone set this as a path accidentally, only want the filename from this key
	Log("PCLauncher - Waiting for AppWaitExe """ . AppWaitExe . """ to close.")
	Process("WaitClose", AppWaitExe)
} Else If FadeTitle {	; If fadeTitle is set and no appPID was created.
	Log("PCLauncher - Waiting for FadeTitle """ . FadeTitle . """ to close.")
	WinWaitClose(FadeTitle)
} Else If SteamIDExe {
	Log("PCLauncher - Waiting for SteamIDExe """ . SteamIDExe . """ to close.")
	Process("WaitClose", SteamIDExe)
} Else If AppPID {
	Log("PCLauncher - Waiting for AppPID """ . AppPID . """ to close.")
	Process("WaitClose", AppPID)
} Else
	ScriptError("Could not find a proper AppWaitExe`, FadeTitle`, or AppPID (from the launched Application). Try setting either an AppWaitExe or FadeTitle so the module has something to look for.")

If PostExit {
	Log("PCLauncher - PostExit set by user, running: " . PostExit)
	PostExitParameters := If (!PostExitParameters or PostExitParameters="ERROR") ? "" : PostExitParameters
	errLevel := Run(If postESkip ? PostExit : """" . PostExitName . """ " . PostExitParameters, PostExitPath)
	If errLevel
		ScriptError("There was a problem launching your PostExit application. Please check it is a valid executable.")
	Sleep, %PostExitSleep%
}

; If Application is a cd/dvd image, unmount it in DT
If appIsImage
	VirtualDrive("unmount")

; Close steam if it was not open prior to launch, not really needed anymore because module knows how to launch if steam already running now
; If AppPID = 0
	; Run, Steam.exe -shutdown, %SteamPath%	; close steam

If (DXWndGame = "true")
	DxwndClose()

BezelExit()
FadeOutExit()
ExitModule()

CheckSettings() {
	Global Application,ApplicationPath,ApplicationName,ApplicationExt
	Global PreLaunch,PreLaunchPath,PreLaunchName,PreLaunchExt
	Global PostLaunch,PostLaunchPath,PostLaunchName,PostLaunchExt
	Global PostExit,PostExitPath,PostExitName,PostExitExt
	Global moduleName,appIsImage,vdDriveLetter,SteamID,OriginGame,DXWndGame,DXWndMaximizeWindow,mode,preLSkip,postLSkip,postESkip,AppWaitExe,SteamIDExe,FadeTitle
	Global modulePath,fadeIn
	Log("CheckSettings - Started")

	; These checks allow you to run URL and Steam browser protocol commands. Without them ahk would error out that it can't find the file. This is different than setting a SteamID but either work
	If (SteamID) {
		mode := "steam"	; setting module to use steam mode
		Log("PCLauncher - SteamID is set, setting mode to: """ . mode . """")
	} Else If (SubStr(Application,1,3) = "ste") {
		mode := "steambp"	; setting module to use Steam Browser Protocol mode
		Log("PCLauncher - Application is a Steam Browser Protocol, setting mode to: """ . mode . """")
	} Else If (SubStr(Application,1,4) = "http") {
		mode := "url"	; setting module to use url mode
		Log("PCLauncher - Application is a URL, setting mode to: """ . mode . """")
	} Else If OriginGame {
		mode := "origin"	; setting module to use Origin mode
		Application := GetFullName(Application)	; convert a relative path defined in the PCLauncher ini to absolute
		SplitPath,Application,ApplicationName,ApplicationPath,ApplicationExt
		StringRight, ApplicationBackSlash, Application, 1
		Log("PCLauncher - Origin mode enabled. Will log in to Origin if required.")
	} Else If Application {
		mode := "standard"	; for standard launching
		Application := GetFullName(Application)	; convert a relative path defined in the PCLauncher ini to absolute
		SplitPath,Application,ApplicationName,ApplicationPath,ApplicationExt
		StringRight, ApplicationBackSlash, Application, 1
		Log("PCLauncher - Setting mode to: """ . mode . """")
	} Else	; error if no modes are used
		ScriptError("Please set an Application, SteamID, Steam Browser Protocol, or URL in " moduleName . ".ini for """ . dbName . """")

	If (SteamID && Application)	; do not allow 2 launching methods
		ScriptError("You are trying to use Steam and Application, you must choose one or the other.")

	If ((mode = "steam" || mode = "steambp") && !AppWaitExe && !FadeTitle) { ; && fadeIn = "true") {	; If AppWaitExe or FadeTitle are defined, that will take precedence over the automatic method using the SteamIDs.ini
		SteamIDFile := CheckFile(modulePath . "\SteamIDs.ini")
		If !SteamID
			SplitPath, Application,SteamID ; grab the 
		SteamIDExe := IniReadCheck(SteamIDFile, SteamID, "exe","",,1)
		If !SteamIDExe
			ScriptError("You are using launching a Steam game but no way for the module to know what window to wait for after launching. Please set a AppWaitExe, FadeTitle, or make sure your SteamID and the correct exe is defined in the SteamIDs.ini",10)
		Else
			Log("PCLauncher - Found an exe in the SteamIDs.ini for this game: """ . SteamIDExe . """")
	} Else If (mode = "url" && !AppWaitExe && !FadeTitle)
		ScriptError("You are using launching a URL but no way for the module to know what to window to wait for after launching. Please set a AppWaitExe or FadeTitle to your default application that gets launched when opening URLs.",10)
	
	preLSkip := If (SubStr(PreLaunch,1,4)="http" || SubStr(PreLaunch,1,3)="ste") ? 1:""
	If preLSkip
		Log("PCLauncher - PreLaunch is a URL or Steam Browser Protocol: " . PreLaunch)
	postLSkip := If (SubStr(PostLaunch,1,4)="http" || SubStr(PostLaunch,1,3)="ste") ? 1:""
	If postLSkip
		Log("PCLauncher - PostLaunch is a URL or Steam Browser Protocol: " . PostLaunch)
	postESkip := If (SubStr(PostExit,1,4)="http" || SubStr(PostExit,1,3)="ste") ? 1:""
	If postESkip
		Log("PCLauncher - PostExit is a URL or Steam Browser Protocol: " . PostExit)

	If (ApplicationBackSlash = "\")
		ScriptError("Please make sure your Application does not contain a backslash on the end:`n" . Application)
	If (appIsImage && !ApplicationPath)	; if user only defined an exe for Application with no path, assume it will be found on the root dir of the image when mounted
		ApplicationPath := vdDriveLetter . ":\"
	If (!ApplicationName && mode = "standard" && (mode != "steam" || mode != "steambp"))
		ScriptError("Missing filename on the end of your Application in " . moduleName . ".ini:`n" . Application)
	If (!ApplicationExt && mode = "standard" && (mode != "steam" || mode != "steambp"))
		ScriptError("Missing extension on your Application in " . moduleName . ".ini:`n" . Application)
	If (PreLaunch && !preLSkip) {
		PreLaunch := GetFullName(PreLaunch)
		SplitPath,PreLaunch,PreLaunchName,PreLaunchPath,PreLaunchExt
		StringRight, PreLaunchBackSlash, PreLaunch, 1
		CheckFile(PreLaunch,"Cannot find this PreLaunch application:`n" . PreLaunch)
		If (PreLaunchBackSlash = "\")
			ScriptError("Please make sure your PreLaunch does not contain a backslash on the end:`n" . PreLaunch)
	}
	If (PostLaunch && !postLSkip) {
		PostLaunch := GetFullName(PostLaunch)
		SplitPath,PostLaunch,PostLaunchName,PostLaunchPath,PostLaunchExt
		StringRight, PostLaunchBackSlash, PostLaunch, 1
		CheckFile(PostLaunch,"Cannot find this PostLaunch application:`n" . PostLaunch)
		If (PostLaunchBackSlash = "\")
			ScriptError("Please make sure your PostLaunch does not contain a backslash on the end:`n" . PostLaunch)
	}
	If (PostExit && !postESkip) {
		PostExit := GetFullName(PostExit)
		SplitPath,PostExit,PostExitName,PostExitPath,PostExitExt
		StringRight, PostExitBackSlash, PostExit, 1
		CheckFile(PostExit,"Cannot find this PostExit application:`n" . PostExit)
		If (PostExitBackSlash = "\")
			ScriptError("Please make sure your PostExit does not contain a backslash on the end:`n" . PostExit)
	}
	If (mode = "standard")
		CheckFile(ApplicationPath . "\" . ApplicationName,"Cannot find this Application:`n" . ApplicationPath . "\" . ApplicationName)	; keeping this last so more descriptive errors will trigger first
	Log("CheckSettings - Ended")
}

CloseProcess:
	If (ExitMethod != "InGame") {
		FadeOutStart()
		If (ExitMethod = "Process Close AppWaitExe" && AppWaitExe) {
			Log("CloseProcess - ExitMethod is ""Process Close AppWaitExe""")
			Process("Close", AppWaitExe)
		} Else If (ExitMethod = "WinClose AppWaitExe" && AppWaitExe) {
			Log("CloseProcess - ExitMethod is ""WinClose AppWaitExe""")
			AppWaitExePID := Process("Exist", AppWaitExe)
			WinClose("ahk_pid " . AppWaitExePID)
		} Else If (ExitMethod = "Process Close Application") {
			Log("CloseProcess - ExitMethod is ""Process Close Application""")
			Process("Close", ApplicationName)
		} Else If (ExitMethod = "WinClose Application" && FadeTitle) {
			Log("CloseProcess - ExitMethod is ""WinClose Close Application""")
			WinClose(FadeTitle)
		} Else If (ExitMethod = "Send Alt+F4") {
			Log("CloseProcess - ExitMethod is ""Send Alt+F4""")
			Send, !{F4}
		} Else {
			Log("CloseProcess - Default ExitMethod`, using ""WinClose""")
			WinClose(ApplicationName)
		}
	}
Return
