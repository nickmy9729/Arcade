#include <File.au3>
#Include <Array.au3>
#include <FileConstants.au3>


   ; Create a constant variable in Local scope of the filepath that will be read/written to.
   Local Const $sFilePath = @ScriptDir & "\cps.ini"
   Local Const $sFilePath2 = @ScriptDir & "\neo.ini"

   ; Open the files for reading and store the handle to variables.
   Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
   If $hFileOpen = -1 Then
	  MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the cps.ini file.")
	  Return False
   EndIf

   Local $hFileOpen2 = FileOpen($sFilePath2, $FO_READ)
   If $hFileOpen2 = -1 Then
	  MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the neo.ini file.")
	  Return False
   EndIf
   ; Read the contents of the file using the handle returned by FileOpen.
   Local $sFileRead = FileRead($hFileOpen)
   Local $sFileRead2 = FileRead($hFileOpen2)

   ; Close the handle returned by FileOpen.
   FileClose($hFileOpen)
   FileClose($hFileOpen2)


;CPS & Neo Arrays
Global $a, $Array1

$Array1 = "sfiii, jojo, jojon, jojoba, redearth, readearthn, sfiii2, sfiii2n, sfiii3, sfiii3n, sfiiin, sf2accp2, sf2cej, sf2ce, sf2ceua, sf2ceub, sf2ceuc, sf2eb, sf2hf, sf2ja, sf2jc, sf2j, sf2koryu, sf2m2, sf2m4, sf2m5, sf2m6, sf2m7, sf2rb2, sf2rb, sf2red, sf2, sf2tj, sf2t, sf2ua, sf2ub, sf2ud, sf2ue, sf2uf, sf2ui, sf2uk, sf2v004, sf2yyc, dstlka, dstlk, dstlku, dstlkur1, hsf2, hsf2j, msha, mshb, mshh, mshj, mshjr1, msh, mshu, mshvsfa1, mshvsfa, mshvsfb1, mshvsfb, mshvsfh, mshvsfj1, mshvsfj2, mshvsfj, mshvsf, mshvsfu1, mshvsfu, mvsca, mvscar1, mvscb, mvsch, mvscj, mvscjr1, mvsc, mvscu, nwarrb, nwarrh, nwarr, nwarru, sfa2, sfa3b, sfa3r1, sfa3, sfar1, sfar2, sfar3, sfa, sfau, sfz2aa, sfz2ab, sfz2ah, sfz2aj, sfz2a, sfz2br1, sfz2b, sfz2h, sfz2j, sfz2n, sfz3ar1, sfz3a, sfz3jr1, sfz3jr2, sfz3j, sfza, sfzbr1, sfzb, sfzh, sfzjr1, sfzjr2, sfzj, ssf2ar1, ssf2a, ssf2jr1, ssf2jr2, ssf2j, ssf2, ssf2ta, ssf2tbj, ssf2tbr1, ssf2tb, ssf2t, ssf2tur1, ssf2tu, ssf2u, ssf2xj, vampja, vampjr1, vampj, vhunt2r1, vhunt2, vhuntjr1, vhuntjr2, vhuntj, vsav2, vsava, vsavh, vsavj, vsavu, vsav, xmcotaa, xmcotah, xmcotaj1, xmcotajr, xmcotaj, xmcotau, xmcota, xmvsfar1, xmvsfa, xmvsfb, xmvsfh, xmvsfjr1, xmvsfjr2, xmvsfj, xmvsfr1, xmvsfur1, xmvsfu, xmvsf"
$Array2 = "2020bb, 2020bba, 2020bbh, 3countb, alpham2, androdun, aodk, aof2a, aof2, aof3, aof3k, aof, bakatono, bangbead, bjourney, blazstar, breakers, breakrev, bstars2, bstars, burningf, burningh, crsword, ct2k3sp, cthd2003, ctomaday, cyberlip, diggerma, doubledr, eightman, fatfursa, fatfursp, fatfury1, fatfury2, fatfury3, fbfrenzy, fightfev, fightfva, flipshot, fswords, galaxyfg, ganryu, garoubl, garou, garouo, garoup, ghostlop, goalx3, gowcaizr, gpilots, gururin, irrmaze, janshin, jockeygp, joyjoy, kabukikl, karnovr, kf10thep, kf2k2mp2, kf2k2mp, kf2k2pla, kf2k2pls, kf2k3bla, kf2k3bl, kf2k3pcb, kf2k3pl, kf2k3upl, kf2k5uni, kizuna, kof10th, kof2000n, kof2000, kof2001h, kof2001, kof2002, kof2003, kof2k4se, kof94, kof95a, kof95, kof96h, kof96, kof97a, kof97pls, kof97, kof98k, kof98n, kof98, kof99a, kof99e, kof99n, kof99p, kof99, kog, kotm2, kotmh, kotm, lans2004, lastblad, lastbld2, lastbldh, lastsold, lbowling, legendos, lresort, magdrop2, magdrop3, maglordh, maglord, mahretsu, marukodq, matrim, miexchng, minasan, mosyougi, ms4plus, ms5pcb, ms5plus, mslug2, mslug3b6, mslug3, mslug3n, mslug4, mslug5, mslug, mslugx, mutnat, nam1975, ncombata, ncombat, ncommand, neobombe, neocup98, neodrift, neogeo, neomrdo, ninjamas, nitd, overtop, panicbom, pbobbl2n, pbobblen, pbobblna, pgoal, pnyaa, popbounc, preisle2, pspikes2, pulstar, puzzldpr, puzzledp, quizdai2, quizdais, quizkof, ragnagrd, rbff1, rbff2h, rbff2k, rbff2, rbffspec, ridheroh, ridhero, roboarma, roboarmy, rotd, s1945p, samsh5sh, samsh5sn, samsh5sp, samsho2, samsho3a, samsho3, samsho4, samsho5b, samsho5h, samsho5, samsho, savagere, sdodgeb, sengokh, sengoku2, sengoku3, sengoku, shocktr2, shocktra, shocktro, socbrawl, sonicwi2, sonicwi3, spinmast, ssideki2, ssideki3, ssideki4, ssideki, stakwin2, stakwin, strhoop, superspy, svcboot, svcpcba, svcpcb, svcplusa, svcplus, svcsplus, svc, tophunta, tophuntr, tpgolf, trally, turfmast, twinspri, tws96, viewpoin, vlinero, vliner, wakuwak7, wh1h, wh1, wh2j, wh2, whp, wjammers, zedblade, zintrckb, zupapa"

$Array1 = StringSplit($Array1, ", ", 1)
$Array2 = StringSplit($Array2, ", ", 1)

;CPS create configs
For $a = 1 To $Array1[0]
	_FileCreate($Array1[$a] & ".ini")
Next

;CPS write to configs
For $a = 1 To $Array1[0]
	FileWrite($Array1[$a] & ".ini", $sFileRead)
Next

;Neo create configs
For $a = 1 To $Array2[0]
	_FileCreate($Array2[$a] & ".ini")
Next

;Neo write to configs
For $a = 1 To $Array2[0]
	FileWrite($Array2[$a] & ".ini", $sFileRead2)
Next