#SingleInstance force
#NoTrayIcon
SetWorkingDir %A_ScriptDir%

if FileExist("puttyCluster.ico")
	Menu, Tray, Icon, puttyCluster.ico

; ***** icon source: https://commons.wikimedia.org/wiki/File:PuTTY_icon_128px.png
; ***** icon copyright message:

;Copyright © Simon Tatham
;
;Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
;
;The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
;

inifilename = puttyCluster.ini
if (%0% > 0)
	inifilename = %1%

global windowname = "Mingbo's cluster Putty"
SysGet, ScreenWidth, 0
SysGet, ScreenHeight, 1
global ScreenWidth := ScreenWidth
global ScreenHeight := ScreenHeight - 40
xstep := 50
ystep := 40
global id_array := Object()
global id_array_count
global wmargin := 1
global width
global height
global fwidth
global fheight
global miniheight := 0
global miniwidth := 50
global sidepanelwidth := 200
global AlwaysOnTop
global SidePanelOpen := 0
global FoundWindowsFiltered2 := 11
global FoundWindowsFiltered3 := 22
global FoundWindowsFiltered4 := 33
global TimerPeriod := 1000
global sendstrdata
global enableGuiUpdates := 1
global MatchBits1
global MatchBits2
global currentwindow := 0
global titleMatchRegexp
global positionMatchStr = ""

; ***** Title Row
Iniread, currentTitleMatchini, %inifilename%, TitleMatches, CurrentIni, 1
nextini := currentTitleMatchini
nextininame := % "Ini" . nextini
while (nextininame != 0) {
	maxTitleMatchini := nextini
	nextini := nextini + 1
	nextininame := % "Ini" . nextini
	Iniread, nextininame, %inifilename%, TitleMatches, %nextininame%, 0
}
InitIni := % "Ini" . currentTitleMatchini
Iniread, inifilenametitlematch, %inifilename%, TitleMatches, %InitIni%, WindowTitleMatch1.ini
xpos := 10
ypos := 1
Gui, Add, button, x%xpos% y%ypos% vbtnWindowTitle gWindowTitleClick HwndbtnWindowTitleID w28 -default,  % currentTitleMatchini . "/" . maxTitleMatchini
xpos += 30
ypos += 9
Gui, Add, Text, x%xpos% y%ypos% HwndtxtWindowTitleID, Window title filter:                   En     Inv

; ***** Title matching text boxes
xpos := 10
ypos := 25
ewidth := 160
Loop, 5 {
	Gui, Add, Edit, x%xpos% y%ypos% Hwndedit%A_Index%ID vtitle%A_Index% w%ewidth%,
	ypos += 27
}

; ***** Enable checkboxes
xpos := 180
ypos := 30
Loop, 5 {
	Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheck" . A_Index . "ID gtitleDoSingle vcheck" . A_Index
	ypos += 27                               
}
check1_TT := "Enable title match regex (Win-Alt-1..5)"

; ***** Invert checkboxes
xpos += 30
ypos := 30
Loop, 5 {
	Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheckinv" . A_Index . "ID gFocusInput vcheckinv" . A_Index
	ypos += 27
}
checkinv1_TT := "Invert regex"

; ***** Found n windows, Single Match Mode, Invert All Mode, Locate Windows buttons
xpos := 10
ypos := 165
Gui, Add, Text, x%xpos% y%ypos% HwndFoundCountID, Found 0 window(s)
xpos += 170
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " HwndSingleMatchID vSingleMatch", 1
SingleMatch_TT := "Single Match Mode: Selecting any regex enable box disables the other regexs (Win-Alt-S)"
xpos += 30
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " HwndInvertMatchID vInvertMatch", !(..)
InvertMatch_TT := "Invert Match Mode: Combine the individual Tile Match (*** IGNORE individual invert flags ***), then invert the result"
xpos := 120
ypos -= 5
Gui, Add, button, x%xpos% y%ypos% gLocate -default, Locate
Locate_TT := "Win-Alt-O"
GoSub, LoadTitleMatches

; ***** Found filter radio buttons
Iniread, currentPositionMatchini, %inifilename%, PositionMatches, CurrentIni, 1
nextini := currentPositionMatchini
nextininame := % "Ini" . nextini
while (nextininame != 0) {
	maxPositionMatchini := nextini
	nextini := nextini + 1
	nextininame := % "Ini" . nextini
	Iniread, nextininame, %inifilename%, PositionMatches, %nextininame%, 0
}
InitIni := % "Ini" . currentPositionMatchini
Iniread, inifilenamepositionmatch, %inifilename%, PositionMatches, %InitIni%, WindowPositionMatch1.ini
xpos := 10
ypos := 192
Gui, Add, button, x%xpos% y%ypos% vbtnWindowPosition gWindowPositionClick HwndbtnWindowPositionID w28 -default,  % currentPositionMatchini . "/" . maxPositionMatchini
xpos += 30
ypos += 8
Gui, Add, Text,  x%xpos% y%ypos% vFoundFilterTitle, Window position filter:
xpos -= 10
ypos += 20
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " w23" . " gFocusInput HwndFilterGroup1ID vFilterGroup Checked"
FilterGroup_TT := "This section lets you filter windows based on the order in which they were found. Regex title matches are applied first, then these are applied"
xpos += 0
ypos += 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " gFocusInput HwndFilterGroup2ID w23"
xpos += 90
ypos -= 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " HwndFilterGroup3ID w23"
xpos -= 90
ypos += 60
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " gFocusInput HwndFilterGroup4ID w23"
xpos += 23
ypos -= 60
Gui, Add, Text,  x%xpos% y%ypos%, All
xpos += 90
ypos -= 3
Gui, Add, Edit,  x%xpos% y%ypos% vFindFilterTxt HwndFindFilterID gFindFilterClick w33, FFFF
xpos += 50
ypos += 5
Gui, Add, Text,  x%xpos% y%ypos% w30 HwndFilterGroup3InfoID vFilterGroup3InfoVal, % "(0/0)"

; ***** Found filter bit selection buttons 1
xpos := 52
ypos := 247
Loop, 8 {
	Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit1%A_Index%ID gbit1toggle vbit1%A_Index%state -default
	xpos += 16
}
xpos += 14
ypos += 5
Gui, Add, Text,  x%xpos% y%ypos% w30 HwndFilterGroup2InfoID vFilterGroup2InfoVal, % "(0/0)"

; ***** Found filter bit selection buttons 2
xpos := 52
ypos := 277
Loop, 8 {
	Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit2%A_Index%ID gbit2toggle vbit2%A_Index%state -default
	xpos += 16
}
xpos += 14
ypos += 5
Gui, Add, Text,  x%xpos% y%ypos% w30 HwndFilterGroup4InfoID vFilterGroup4InfoVal, % "(0/0)"
GoSub, LoadPositionMatches

; ***** Window transparency slider
yposslider := 310
xpos := 10
ypos := yposslider
swidth := 230
Gui, Add, Text, x%xpos% y%ypos%, Window transparency:
ypos += 18
GUI, Add, Slider, x%xpos% y%ypos% Range100-255 w%swidth% gFind, 255

; ***** Cluster Input, Paste, CrLf checkbox, Always on top checkbox
IniRead, OnTopVal, %inifilename%, Options, AlwaysOnTop, 0
IniRead, CrLfVal, %inifilename%, Options, AddCrLf, 0
yposcluster := yposslider + 60
xpos := 10
ypos := yposcluster
Gui, Add, Text, x%xpos% y%ypos% vignore w100, cluster input:
xpos += 113
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " HwndOnTopID vOnTopVal gOnTopCheck" .  ( OnTopVal ? " Checked" : "" ), Always On Top
xpos -= 113
ypos += 20
Gui, Add, Edit, x%xpos% y%ypos% w80 vInputBox HwndInputBoxID WantTab ReadOnly, 
xpos += 83
Gui, Add, button, x%xpos% y%ypos% gGoPaste -default, Paste Clipboard
Paste_Clipboard_TT := "_clipboard_ (Win-Alt-V)"
xpos += 90
ypos += 7
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " HwndCrLfID vCrLfVal gCrLfCheck" .  ( CrLfVal ? " Checked" : "" ),  +CrLf
CrLfVal_TT := "Toggle add crlf to Paste Clipboard and Putty Commands (Win-Alt-L)"

; ***** Window command buttons Tile, Cascade, ToFront etc
xpos := 10
ypos := yposcluster + 45
Gui, Add, button, x%xpos% y%ypos% HwndbtnTileID gTile -default, Tile
Tile_TT := "LClick: Tile Putty Windows,   RClick: Tile on other monitor (set R-Click monitors in puttyCluster.ini) (Win-Alt-T)"
xpos += 30
Gui, Add, button, x%xpos% y%ypos% gCascade -default, Cascade
xpos += 55
Gui, Add, button, x%xpos% y%ypos% gToBack -default, ToBack
ToBack_TT := "Win-Alt-B"
xpos += 52
Gui, Add, button, x%xpos% y%ypos% gToFront -default, ToFront
ToFront_TT := "Win-Alt-F"
xpos += 52
Gui, Add, button, x%xpos% y%ypos% gCloseWin -default, Close

; ***** Window size radio buttons
IniRead, winsize, %inifilename%, WindowSize, Selected, 7
xbase := 5
ybase := yposcluster + 85

xpos := xbase
ypos1 := ybase + 5
ypos2 := ybase + 32
ypos3 := ybase + 59
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " HwndRadioCheck1  gRadioCheck" . " vRadioGroup" .  ( (winsize == 1) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " HwndRadioCheck2  gRadioCheck" . ( (winsize == 2) ? " Checked" : "" )
xpos += 115                                                
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " HwndRadioCheck3  gRadioCheck" . ( (winsize == 3) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " HwndRadioCheck4  gRadioCheck" . ( (winsize == 4) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " HwndRadioCheck5  gRadioCheck" . ( (winsize == 5) ? " Checked" : "" )
xpos += 60                                                 
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " HwndRadioCheck6  gRadioCheck" . ( (winsize == 6) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " HwndRadioCheck7  gRadioCheck" . ( (winsize == 7) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " HwndRadioCheck8  gRadioCheck" . ( (winsize == 8) ? " Checked" : "" )

; ***** Window size radio button text boxes
IniRead, xsize1, %inifilename%, XYSize, x1, 400
IniRead, ysize1, %inifilename%, XYSize, y1, 500
IniRead, xsize2, %inifilename%, XYSize, x2, 400
IniRead, ysize2, %inifilename%, XYSize, y2, 600
xpos := xbase + 54
Gui, Add, Text,  x%xpos% y%ypos1%, X
Gui, Add, Text,  x%xpos% y%ypos2%, X
xpos += 84
Gui, Add, Text,  x%xpos% y%ypos1%, 1x1
Gui, Add, Text,  x%xpos% y%ypos2%, 1x2
Gui, Add, Text,  x%xpos% y%ypos3%, 1x3
xpos += 60
Gui, Add, Text,  x%xpos% y%ypos1%, 2x2
Gui, Add, Text,  x%xpos% y%ypos2%, 2x3
Gui, Add, Text,  x%xpos% y%ypos3%, 3x3

; ***** Window size radio button edit boxes
xpos1 := xbase + 23
xpos2 := xbase + 63
ypos1 := ybase
ypos2 := ybase + 27
ypos3 := ybase + 54
Gui, Add, Edit,  x%xpos1% y%ypos1% gwhFocusRadioButton Hwndwidth1ID vwidth1 w30 Number, %xsize1%
Gui, Add, Edit,  x%xpos2% y%ypos1% gwhFocusRadioButton Hwndheight1ID vheight1 w30 Number, %ysize1%
Gui, Add, Edit,  x%xpos1% y%ypos2% gwhFocusRadioButton Hwndwidth2ID vwidth2 w30 Number, %xsize2%
Gui, Add, Edit,  x%xpos2% y%ypos2% gwhFocusRadioButton Hwndheight2ID vheight2 w30 Number, %ysize2%

; ***** Monitor selector
IniRead, monitorsel, %inifilename%, Options, MonitorSelect, 1
IniRead, edtMonitor3, %inifilename%, Options, Monitor3, 3
IniRead, RightClickMonitor1, %inifilename%, Options, RightClickMonitor1, 1
IniRead, RightClickMonitor2, %inifilename%, Options, RightClickMonitor2, 1
xpos := xbase
ypos3 += 5
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gFocusInput HwndMonitor1 vMonitorGroup" . ( (monitorsel == 1) ? " Checked" : "" ), 1
MonitorGroup_TT := "Use monitor 1"
xpos += 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gFocusInput HwndMonitor2" . ( (monitorsel == 2) ? " Checked" : "" ), 2
xpos += 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gFocusInput HwndMonitor3" . ( (monitorsel == 3) ? " Checked" : "" )
xpos += 23
Gui, Add, Text,  x%xpos% y%ypos3% w24 h16, %edtMonitor3%
Gui, Add, UpDown, gedtMonitorClick3 vedtMonitor3 HwndedtMonitor3ID Range1-8, %edtMonitor3%
edtMonitor3_TT := "Enter a monitor number here.  Default 3"

fheight := yposcluster + 165
fwidth := 250
xpos_default := (ScreenWidth / 2) - (fwidth / 2)
ypos_default := (ScreenHeight / 2) - (fheight / 2)
Iniread, xpos, %inifilename%, Autosave, xpos, %xpos_default%
Iniread, ypos, %inifilename%, Autosave, ypos, %ypos_default%

; ***** Sidepanel toggle button
xsidepanelbutton := fwidth - 20
ysidepanelbutton := 0
Gui, Add, button, x%xsidepanelbutton% y%ysidepanelbutton% gSidePanelToggle HwndbtnToggleSidebarID -default, >>
GTGT_TT := "Show launcher sidedar (Win-Alt-D)"
LTLT_TT := "Hide launcher sidedar (Win-Alt-D)"

; ***** minimode toggle button
xminibutton := fwidth - 30
yminibutton := 195
Gui, Add, button, x%xminibutton% y%yminibutton% vMiniMode gMiniModeToggle HwndbtnMiniModeID -default, mini
MiniMode_TT := "Enable Mini Mode (Win-Alt-I)"

; ***** Sidepanel about button
xsidepanel := xsidepanelbutton + 175
ysidepanel := 6
Gui, Add, text, x%xsidepanel% y%ysidepanel% gAboutBox, About

; ***** Sidepanel application launchers
Iniread, currentAppLauncher, %inifilename%, ApplicationLaunchers, CurrentLauncher, 1
nextLauncher := currentApplauncher
nextini := % "Ini" . nextLauncher
while (nextini != 0) {
	maxAppLauncher := nextLauncher
	nextLauncher := nextLauncher + 1
	nextini := % "Ini" . nextLauncher
	Iniread, nextini, %inifilename%, ApplicationLaunchers, %nextini%, 0
}
InitIni := % "Ini" . currentAppLauncher
Iniread, inifilenameAppLaunchers, %inifilename%, ApplicationLaunchers, %InitIni%, AppLaunchers1.ini
xsidepanel := xsidepanelbutton + 30
ysidepanel := 20
Gui, Add, button, x%xsidepanel% y%ysidepanel% vbtnAppLaunchers gAppLaunchersClick HwndbtnAppLaunchersID w28 -default, % currentAppLauncher . "/" . maxAppLauncher
xsidepanel += 30
ysidepanel += 5
Gui, Add, Text, x%xsidepanel% y%ysidepanel% HwndtxtAppLaunchersID, Application launchers:
ysidepanel -= 10
Index := 1
Loop, 2 {
	row := A_Index
	xsidepanel := xsidepanelbutton + 30
	ysidepanel += 30
	Loop, 3 {
		Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnLauncher%Index% gbtnLauncher HwndbtnLauncher%Index%ID -default, Launcher%Index%
		xsidepanel += 65
		Index += 1
	}
}
GoSub, LoadLaunchers

; ***** Sidepanel putty session launchers
Iniread, currentPSLauncher, %inifilename%, PuttySessionLaunchers, CurrentLauncher, 1
nextLauncher := currentPSlauncher
nextini := % "Ini" . nextLauncher
while (nextini != 0) {
	maxPSLauncher := nextLauncher
	nextLauncher := nextLauncher + 1
	nextini := % "Ini" . nextLauncher
	Iniread, nextini, %inifilename%, PuttySessionLaunchers, %nextini%, 0
}
InitIni := % "Ini" . currentPSLauncher
Iniread, inifilenamePSLaunchers, %inifilename%, PuttySessionLaunchers, %InitIni%, PuttySessions1.ini
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% vbtnPSLaunchers gPSLaunchersClick HwndbtnPSLaunchersID w28 -default, % currentPSLauncher . "/" . maxPSLauncher
xsidepanel := xsidepanel + 30
ysidepanel += 5
Gui, Add, Text, x%xsidepanel% y%ysidepanel%, Putty session launchers:
ysidepanel -= 10
Loop, 6 {
	row := A_Index
	xsidepanel := xsidepanelbutton + 30
	ysidepanel += 30
	Gui, Add, button, x%xsidepanel% y%ysidepanel% w65 vbtnPutty%row% gbtnPutty HwndbtnPutty%row%ID -default, Putty%row%
	xsidepanel += 67
	Loop, 3 {
		Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty%row%%A_Index% HwndedtPutty%row%%A_Index%ID w37
		Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty%row%%A_Index%UpDown Range0-10, 0
		xsidepanel += 40
	}
}

xsidepanel := xsidepanelbutton + 97
ysidepanel += 30
Loop, 3 {
	Gui, Add, button, x%xsidepanel% y%ysidepanel% w30 vbtnCol%A_Index% gbtnCol HwndbtnCol%A_Index%ID -default, Col
	xsidepanel += 40
}
btnCol1_TT := "Launch the 1st column of sessions"
GoSub, LoadPSLaunchers

; ***** Sidepanel Putty commands
Iniread, currentCmdLauncher, %inifilename%, CommandLaunchers, CurrentLauncher, 1
nextLauncher := currentCmdlauncher
nextini := % "Ini" . nextLauncher
while (nextini != 0) {
	maxCmdLauncher := nextLauncher
	nextLauncher := nextLauncher + 1
	nextini := % "Ini" . nextLauncher
	Iniread, nextini, %inifilename%, CommandLaunchers, %nextini%, 0
}
InitIni := % "Ini" . currentCmdLauncher
Iniread, inifilenameCmdLaunchers, %inifilename%, CommandLaunchers, %InitIni%, Commands1.ini
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
;yautofocus := ysidepanel + 10
Gui, Add, button, x%xsidepanel% y%ysidepanel% vbtnCmdLaunchers gCmdLaunchersClick HwndbtnCmdLaunchersID w28 -default, % currentCmdLauncher . "/" . maxCmdLauncher
xsidepanel := xsidepanel + 30
ysidepanel += 5
Gui, Add, Text, x%xsidepanel% y%ysidepanel%, Putty commands:
Index := 1
Loop, 6 {
	xsidepanel := xsidepanelbutton + 30
	ysidepanel += 25
	Loop, 3 {
		Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand%Index% gbtnCommand HwndbtnCommand%Index%ID -default, Cmd%Index%
		xsidepanel += 65
		Index += 1
	}
}
GoSub, LoadCmdLaunchers

; Autofocus checkbox
Iniread, autofocusflag, %inifilenameCmdLaunchers%, Options, AutoFocus, 0
xautofocus := xsidepanelbutton + 95
yautofocus := ysidepanel + 25
Gui, Add, Checkbox, % "x" . xautofocus . " y" . yautofocus . " HwndAutoFocusID vAutoFocusVal gAutoFocusCheck" .  ( autofocusflag ? " Checked" : "" ),  AutoFocus
AutoFocusVal_TT := "Autofocus - Clicking on command button activates puttyCluster and sends to all Putty windows even when puttyCluster is not the active window"


Gui, Show, h%fheight% w%fwidth% x%xpos% y%ypos%, %windowname%
ControlFocus, , ahk_id %InputBoxID%
WinActivate, %windowname%
	
onMessage(0x100,"key")  ; key down
onMessage(0x101,"key")  ; key up
onMessage(0x104,"key")  ; alt key down
onMessage(0x105,"key")  ; alt key down
OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x53, "WM_HELP")
OnMessage(0x204, "WM_RBUTTONDOWN")

GoSub, RadioCheck
GoSub, OnTopCheck

SetTimer, Find , %TimerPeriod%
SetTitleMatchMode, RegEx 
#WinActivateForce

WM_RBUTTONDOWN()
{
	Global btnLauncher1ID
	Global btnLauncher2ID
	Global btnLauncher3ID
	Global btnLauncher4ID
	Global btnLauncher5ID
	Global btnLauncher6ID
	Global btnPutty1ID
	Global btnPutty2ID
	Global btnPutty3ID
	Global btnPutty4ID
	Global btnPutty5ID
	Global btnPutty6ID
	Global btnCommand1ID
	Global btnCommand2ID
	Global btnCommand3ID
	Global btnCommand4ID
	Global btnCommand5ID
	Global btnCommand6ID
	Global btnCommand7ID
	Global btnCommand8ID
	Global btnCommand9ID
	Global btnCommand10ID
	Global btnCommand11ID
	Global btnCommand12ID
	Global btnCommand13ID
	Global btnCommand14ID
	Global btnCommand15ID
	Global btnCommand16ID
	Global btnCommand17ID
	Global btnCommand18ID
	Global EditControlName
	Global btnTileID
	Global RightClickMonitor1
	Global RightClickMonitor2
	Global MonitorGroup
	Global Monitor1
	Global Monitor2
	Global Monitor3
	MouseGetPos,,,,EditControlHwnd,2
	Loop, 6 {
		If (EditControlHwnd == ahk_id btnLauncher%A_Index%ID) {
			EditControlName = % "Launcher " . A_Index
			GoSub, DisableTimers
			GoSub, EditBoxAppLauncher
			Return
		}
		If (EditControlHwnd == ahk_id btnPutty%A_Index%ID) {
			EditControlName = % "Putty Session " . A_Index
			GoSub, DisableTimers
			GoSub, EditBoxPSLauncher
			Return
		}
	}
	Loop, 18 {
		If (EditControlHwnd == ahk_id btnCommand%A_Index%ID) {
			EditControlName = % "Putty Command " . A_Index
			GoSub, DisableTimers
			GoSub, EditBoxCmdLauncher
			Return
		}
	}
	If (EditControlHwnd == ahk_id btnTileID) {
		currmonitor := MonitorGroup
		If (MonitorGroup != RightClickMonitor1) {
			pcontrolID = % "Monitor" . RightClickMonitor1
			controlID := %pcontrolID%
			ControlSend, , {Space}, ahk_id %controlID%
		} else {
			pcontrolID = % "Monitor" . RightClickMonitor2
			controlID := %pcontrolID%
			ControlSend, , {Space}, ahk_id %controlID%
		}
		GoSub, RadioCheck
		GoSub, Tile
		MonitorGroup := currmonitor
		pcontrolID = % "Monitor" . currmonitor
		controlID := %pcontrolID%
		ControlSend, , {Space}, ahk_id %controlID%
		GoSub, RadioCheck
	}
}

WM_HELP()
{
	GoSub, AboutBox
}

WM_MOUSEMOVE()
{
	static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl)
	{
		ToolTip  ; Turn off any previous tooltip.
		SetTimer, DisplayToolTip, 1000
		PrevControl := CurrControl
	}
	return

	DisplayToolTip:
		SetTimer, DisplayToolTip, Off
		CurrControlTT := CurrControl . "_TT"
		StringReplace, CurrControlTT, CurrControlTT, <<, LTLT, ,A
		StringReplace, CurrControlTT, CurrControlTT, >>, GTGT, ,A
		StringReplace, CurrControlTT, CurrControlTT, %A_Space%, _, ,A
		CurrControlTT := RegExReplace(CurrControlTT, "[^a-zA-Z0-9_]+")
		If (CurrControlTT == "Paste_Clipboard_TT") {
			currentclip=%clipboard%
			StringLen, currlen, currentclip
			if (currlen > 25) {
				currentclip := Substr(currentclip, 1, 25)
				currentclip = % currentclip . "..."
			}
			ToolTip % " [" . currentclip . "]"
		} else {
			ToolTip % %CurrControlTT%
		}
		SetTimer, RemoveToolTip, 3000
	return

	RemoveToolTip:
		SetTimer, RemoveToolTip, Off
		ToolTip
	return
}

key(wParam, lParam, msg, hwnd)
{ 
  global paste
  if (paste ==1) {
	return
  }
  GuiControlGet, currentInput, FocusV  
  if(currentInput="InputBox"){

	global id_array_count
	global FilterGroup
	global FindFilterTxt
	global MatchBits1
	global MatchBits2

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
			}
			titlematchbit *= 2
		}
	}

	ControlSetText, , , ahk_id %InputBoxID% 
   }
}
return 

; ******************************************************************************************
EditBoxAppLauncher:
	editboxwidth := 800
	editboxheight := 180
	Gui, 3:+LastFoundExist
	IfWinExist
	{
		Gui, 3:+AlwaysOnTop
		Gui, 3:-AlwaysOnTop
		Return
	}
	StringReplace, inisection, EditControlName, %A_Space%, , ,A
	Iniread, ControlLabel, %inifilenameAppLaunchers%, %inisection%, Label, Label
	xedt := 5
	yedt := 20
	Gui, 3:Add, Text, x%xedt% y%yedt%, Label:
	xedt += 55
	yedt -= 3
	Gui, 3:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 90 . " r1 HwndedtControlLabelID", %ControlLabel%
	Gui, 3:Add, Button, % "x" . (xedt + editboxwidth - 90) . " y" . (yedt - 1) . "w30 g3LaunchSelectClick v3LaunchSelect", ...
	3LaunchSelect_TT := "Select an existing file for the launcher"

	Iniread, ControlTT, %inifilenameAppLaunchers%, %inisection%, Tooltip, Tooltip
	xedt := 5
	yedt += 35
	Gui, 3:Add, Text, x%xedt% y%yedt%, Tooltip:
	xedt += 55
	yedt -= 3
	Gui, 3:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlTTID", %ControlTT%

	Iniread, ControlCmd, %inifilenameAppLaunchers%, %inisection%, Command, Command
	xedt := 5
	yedt += 35
	Gui, 3:Add, Text, x%xedt% y%yedt%, Command:
	xedt += 55
	yedt -= 3
	Gui, 3:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlCmdID", %ControlCmd%

	Iniread, ControlDir, %inifilenameAppLaunchers%, %inisection%, Dir, Directory
	xedt := 5
	yedt += 35
	Gui, 3:Add, Text, x%xedt% y%yedt%, Directory:
	xedt += 55
	yedt -= 3
	Gui, 3:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlDirID", %ControlDir%
	
	Gui, 3:Add, Button, % "x" . (editboxwidth /2) - 60 - 20 . " y" . (editboxheight - 30) . " w40 h25 g3btnSave", Save
	Gui, 3:Add, Button, % "x" . (editboxwidth /2) - 20 . " y" . (editboxheight - 30) . " w40 h25 g3btnCancel", Cancel
	Gui, 3:Add, Button, % "x" . (editboxwidth /2) + 60 - 20 . " y" . (editboxheight - 30) . " w40 h25 g3btnClear", Clear
	xposEditBox := (ScreenWidth - editboxwidth ) / 2
	yposEditBox := (ScreenHeight - editboxheight ) / 2
	editTitle := % "Edit " . EditControlName
	Gui, 3:Show, x%xposEditBox% y%yposEditBox% h%editboxheight% w%editboxwidth%, %editTitle%
	Gui, 1:-AlwaysOnTop	; temporarily remove OnTopFlag so this Window can be on top
	Gui, 3:+AlwaysOnTop
	Gui, 3:-AlwaysOnTop
Return
 3btnClear:
 		ControlSetText, , , ahk_id %edtControlLabelID%
 		ControlSetText, , , ahk_id %edtControlTTID%
 		ControlSetText, , , ahk_id %edtControlCmdID%
 		ControlSetText, , , ahk_id %edtControlDirID%
 Return
 3btnSave:
 	ControlGetText, newlabel, , ahk_id %edtControlLabelID%
 	IniWrite, %newlabel%, %inifilenameAppLaunchers%, %inisection%, Label
 	ControlGetText, newTT, , ahk_id %edtControlTTID%
 	IniWrite, %newTT%, %inifilenameAppLaunchers%, %inisection%, Tooltip
 	ControlGetText, newCmd, , ahk_id %edtControlCmdID%
 	IniWrite, %newCmd%, %inifilenameAppLaunchers%, %inisection%, Command
 	ControlGetText, newDir, , ahk_id %edtControlDirID%
 	IniWrite, %newDir%, %inifilenameAppLaunchers%, %inisection%, Dir
 	GoSub, LoadLaunchers
 3btnCancel:
 3GuiClose:
 3GuiEscape:
 	Gui, 3:Destroy
 	GoSub, OnTopCheck	; restore user selected setting for AlwaysOnTop
	GoSub, EnableTimers
 Return
 3LaunchSelectClick:
 	Iniread, tooltipprefix, %inifilename%, ApplicationLaunchers, DefaultTooltipPrefix, Run:
 	Iniread, clipregex1search, %inifilename%, ApplicationLaunchers, LabelClipRegex1search, _[^_]+$
 	Iniread, clipregex1replace, %inifilename%, ApplicationLaunchers, LabelClipRegex1replace,
 	Iniread, clipregex2search, %inifilename%, ApplicationLaunchers, LabelClipRegex2search, ^ccimx6
 	Iniread, clipregex2replace, %inifilename%, ApplicationLaunchers, LabelClipRegex2replace,
 	Iniread, clipregex3search, %inifilename%, ApplicationLaunchers, LabelClipRegex3search, %A_Space%
 	Iniread, clipregex3replace, %inifilename%, ApplicationLaunchers, LabelClipRegex3replace,
 	Iniread, clipregex4search, %inifilename%, ApplicationLaunchers, LabelClipRegex4search, [-_]+
 	Iniread, clipregex4replace, %inifilename%, ApplicationLaunchers, LabelClipRegex4replace,
 	Iniread, clipregex5search, %inifilename%, ApplicationLaunchers, LabelClipRegex5search, _.*$
 	Iniread, clipregex5replace, %inifilename%, ApplicationLaunchers, LabelClipRegex5replace,
 	FileSelectFile, selectedfilename, 1
 	if (selectedfilename != "") {
 		SplitPath, selectedfilename, selectedfile, selecteddir
 		newlabel := selectedfile
 		; if the filename is too long (for the button to display), take a guess as to how to shorten it. 
 		; This is particular for how I name my putty sessions
 		StringUpper, newlabel, newlabel, T
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex1search, clipregex1replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex2search, clipregex2replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex3search, clipregex3replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex4search, clipregex4replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex5search, clipregex5replace)
 		ControlSetText, , %newlabel%, ahk_id %edtControlLabelID%
 		ControlSetText, , % tooltipprefix . " " . selectedfile, ahk_id %edtControlTTID%
 		ControlSetText, , %selectedfilename%, ahk_id %edtControlCmdID%
 		ControlSetText, , %selecteddir%, ahk_id %edtControlDirID%
 	}
 Return

EditBoxPSLauncher:
	editboxwidth := 800
	editboxheight := 180
	Gui, 4:+LastFoundExist
	IfWinExist
	{
		Gui, 4:+AlwaysOnTop
		Gui, 4:-AlwaysOnTop
		Return
	}
	StringReplace, inisection, EditControlName, %A_Space%, , ,A
	Iniread, ControlLabel, %inifilenamePSLaunchers%, %inisection%, Label, Label
	xedt := 5
	yedt := 20
	Gui, 4:Add, Text, x%xedt% y%yedt%, Label:
	xedt += 55
	yedt -= 3
	Gui, 4:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 90 . " r1 HwndedtControlLabelID", %ControlLabel%
	Gui, 4:Add, Button, % "x" . (xedt + editboxwidth - 90) . " y" . (yedt - 1) . "w30 g4LaunchSelectClick v4LaunchSelect", ...
	4LaunchSelect_TT := "Select an existing session from the Putty sessions folder"

	Iniread, ControlTT, %inifilenamePSLaunchers%, %inisection%, Tooltip, Tooltip
	xedt := 5
	yedt += 35
	Gui, 4:Add, Text, x%xedt% y%yedt%, Tooltip:
	xedt += 55
	yedt -= 3
	Gui, 4:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlTTID", %ControlTT%

	Iniread, ControlCmd, %inifilenamePSLaunchers%, %inisection%, Command, Command
	xedt := 5
	yedt += 35
	Gui, 4:Add, Text, x%xedt% y%yedt%, Command:
	xedt += 55
	yedt -= 3
	Gui, 4:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlCmdID", %ControlCmd%

	Iniread, ControlDir, %inifilenamePSLaunchers%, %inisection%, Dir, Directory
	xedt := 5
	yedt += 35
	Gui, 4:Add, Text, x%xedt% y%yedt%, Directory:
	xedt += 55
	yedt -= 3
	Gui, 4:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlDirID", %ControlDir%
	
	Gui, 4:Add, Button, % "x" . (editboxwidth /2) - 60 - 20 . " y" . (editboxheight - 30) . " w40 h25 g4btnSave", Save
	Gui, 4:Add, Button, % "x" . (editboxwidth /2) - 20 . " y" . (editboxheight - 30) . " w40 h25 g4btnCancel", Cancel
	Gui, 4:Add, Button, % "x" . (editboxwidth /2) + 60 - 20 . " y" . (editboxheight - 30) . " w40 h25 g4btnClear", Clear
	xposEditBox := (ScreenWidth - editboxwidth ) / 2
	yposEditBox := (ScreenHeight - editboxheight ) / 2
	Gui, 4:Show, x%xposEditBox% y%yposEditBox% h%editboxheight% w%editboxwidth%, Edit %EditControlName%
	Gui, 1:-AlwaysOnTop	; temporarily remove OnTopFlag so this Window can be on top
	Gui, 4:+AlwaysOnTop
	Gui, 4:-AlwaysOnTop
	if (ControlLabel == "")
		GoSub, 4LaunchSelectClick
Return
 4btnClear:
 		ControlSetText, , , ahk_id %edtControlLabelID%
 		ControlSetText, , , ahk_id %edtControlTTID%
 		ControlSetText, , , ahk_id %edtControlCmdID%
 		ControlSetText, , , ahk_id %edtControlDirID%
 Return
 4btnSave:
 	ControlGetText, newlabel, , ahk_id %edtControlLabelID%
 	IniWrite, %newlabel%, %inifilenamePSLaunchers%, %inisection%, Label
 	ControlGetText, newTT, , ahk_id %edtControlTTID%
 	IniWrite, %newTT%, %inifilenamePSLaunchers%, %inisection%, Tooltip
 	ControlGetText, newCmd, , ahk_id %edtControlCmdID%
 	IniWrite, %newCmd%, %inifilenamePSLaunchers%, %inisection%, Command
 	ControlGetText, newDir, , ahk_id %edtControlDirID%
 	IniWrite, %newDir%, %inifilenamePSLaunchers%, %inisection%, Dir
 	GoSub, LoadPSLaunchers
 4btnCancel:
 4GuiClose:
 4GuiEscape:
 	Gui, 4:Destroy
 	GoSub, OnTopCheck	; restore user selected setting for AlwaysOnTop
	GoSub, EnableTimers
 Return
 4LaunchSelectClick:
 	Iniread, tooltipprefix, %inifilename%, PuttySessionLaunchers, DefaultTooltipPrefix, Launch putty session:
 	Iniread, commandprefix, %inifilename%, PuttySessionLaunchers, DefaultPuttyCommandPrefix, C:\_Portable\_Putty\_ExtraPuTTY\putty.exe -load
 	Iniread, puttydir, %inifilename%, PuttySessionLaunchers, DefaultPuttyDir, C:\_Portable\_Putty\_ExtraPuTTY\
 	Iniread, sessiondir, %inifilename%, PuttySessionLaunchers, DefaultPuttySessionDir, C:\_Portable\_Putty\_ExtraPuTTY\Sessions
 	Iniread, clipregex1search, %inifilename%, PuttySessionLaunchers, LabelClipRegex1search, _[^_]+$
 	Iniread, clipregex1replace, %inifilename%, PuttySessionLaunchers, LabelClipRegex1replace,
 	Iniread, clipregex2search, %inifilename%, PuttySessionLaunchers, LabelClipRegex2search, ^ccimx6
 	Iniread, clipregex2replace, %inifilename%, PuttySessionLaunchers, LabelClipRegex2replace,
 	Iniread, clipregex3search, %inifilename%, PuttySessionLaunchers, LabelClipRegex3search, %A_Space%
 	Iniread, clipregex3replace, %inifilename%, PuttySessionLaunchers, LabelClipRegex3replace,
 	Iniread, clipregex4search, %inifilename%, PuttySessionLaunchers, LabelClipRegex4search, [-_]+
 	Iniread, clipregex4replace, %inifilename%, PuttySessionLaunchers, LabelClipRegex4replace,
 	Iniread, clipregex5search, %inifilename%, PuttySessionLaunchers, LabelClipRegex5search, _.*$
 	Iniread, clipregex5replace, %inifilename%, PuttySessionLaunchers, LabelClipRegex5replace,
 	FileSelectFile, selectedsession, 1, %sessiondir%
 	if (selectedsession != "") {
 		SplitPath, selectedsession, selectedsession, selecteddir
 		newlabel := selectedsession
 		; if the filename is too long (for the button to display), take a guess as to how to shorten it. 
 		; This is particular for how I name my putty sessions
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex1search, clipregex1replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex2search, clipregex2replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex3search, clipregex3replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex4search, clipregex4replace)
 		if (StrLen(newlabel) > 9)
 			newlabel := RegExReplace(newlabel, clipregex5search, clipregex5replace)
 		if (StrLen(newlabel) > 10)
 			StringLower, newlabel, newlabel
 		ControlSetText, , %newlabel%, ahk_id %edtControlLabelID%
 		ControlSetText, , % tooltipprefix . " " . selectedsession, ahk_id %edtControlTTID%
 		ControlSetText, , % commandprefix . " """ . selectedsession . """", ahk_id %edtControlCmdID%
 		ControlSetText, , %selecteddir%, ahk_id %edtControlDirID%
 	}
 Return

EditBoxCmdLauncher:
	editboxwidth := 800
	editboxheight := 180
	Gui, 5:+LastFoundExist
	IfWinExist
	{
		Gui, 5:+AlwaysOnTop
		Gui, 5:-AlwaysOnTop
		Return
	}
	StringReplace, inisection, EditControlName, %A_Space%, , ,A

	Iniread, ControlCmd, %inifilenameCmdLaunchers%, %inisection%, Command, Command
	xedt := 5
	yedt := 20
	Gui, 5:Add, Text, x%xedt% y%yedt%, Command:
	xedt += 55
	yedt -= 3
	Gui, 5:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlCmdID", %ControlCmd%

	Iniread, ControlLabel, %inifilenameCmdLaunchers%, %inisection%, Label, %ControlCmd%
	xedt := 5
	yedt += 35
	Gui, 5:Add, Text, x%xedt% y%yedt%, Label:
	xedt += 55
	yedt -= 3
	Gui, 5:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlLabelID", %ControlLabel%

	Iniread, ControlTT, %inifilenameCmdLaunchers%, %inisection%, Tooltip, %ControlCmd%
	xedt := 5
	yedt += 35
	Gui, 5:Add, Text, x%xedt% y%yedt%, Tooltip:
	xedt += 55
	yedt -= 3
	Gui, 5:Add, Edit, % "x" . xedt . " y" . yedt . " w" . editboxwidth - 70 . " r1 HwndedtControlTTID", %ControlTT%

	Gui, 5:Add, Button, % "x" . (editboxwidth /2) - 60 - 20 . " y" . (editboxheight - 30) . " w40 h25 g5btnSave", Save
	Gui, 5:Add, Button, % "x" . (editboxwidth /2) - 20 . " y" . (editboxheight - 30) . " w40 h25 g5btnCancel", Cancel
	Gui, 5:Add, Button, % "x" . (editboxwidth /2) + 60 - 20 . " y" . (editboxheight - 30) . " w40 h25 g5btnClear", Clear
	xposEditBox := (ScreenWidth - editboxwidth ) / 2
	yposEditBox := (ScreenHeight - editboxheight ) / 2
	Gui, 5:Show, x%xposEditBox% y%yposEditBox% h%editboxheight% w%editboxwidth%, Edit %EditControlName%
	Gui, 1:-AlwaysOnTop	; temporarily remove OnTopFlag so this Window can be on top
	Gui, 5:+AlwaysOnTop
	Gui, 5:-AlwaysOnTop
Return
 5btnClear:
 		ControlSetText, , , ahk_id %edtControlLabelID%
 		ControlSetText, , , ahk_id %edtControlTTID%
 		ControlSetText, , , ahk_id %edtControlCmdID%
 Return
 5btnSave:
 	ControlGetText, newlabel, , ahk_id %edtControlLabelID%
 	IniWrite, %newlabel%, %inifilenameCmdLaunchers%, %inisection%, Label
 	ControlGetText, newTT, , ahk_id %edtControlTTID%
 	IniWrite, %newTT%, %inifilenameCmdLaunchers%, %inisection%, Tooltip
 	ControlGetText, newCmd, , ahk_id %edtControlCmdID%
 	IniWrite, %newCmd%, %inifilenameCmdLaunchers%, %inisection%, Command
 	GoSub, LoadCmdLaunchers
 5btnCancel:
 5GuiClose:
 5GuiEscape:
 	Gui, 5:Destroy
 	GoSub, OnTopCheck	; restore user selected setting for AlwaysOnTop
	GoSub, EnableTimers
 Return

WindowTitleClick:
	gui, submit, nohide
	GoSub, SaveTitleMatches
	nextini := currentTitleMatchini + 1
	nextininame := % "Ini" . nextini
	Iniread, newini, %inifilename%, TitleMatches, %nextininame%, 0
	if (newini == 0) {
		currentTitleMatchini := 1
		Iniread, inifilenametitlematch, %inifilename%, TitleMatches, Ini1, WindowTitleMatch1.ini
		ControlSetText, , % currentTitleMatchini . "/" . maxTitleMatchini, ahk_id %btnWindowTitleID% 
	} else {
		currentTitleMatchini := nextini
		Iniread, inifilenametitlematch, %inifilename%, TitleMatches, %nextininame%, WindowTitleMatch1.ini
		ControlSetText, , % currentTitleMatchini . "/" . maxTitleMatchini, ahk_id %btnWindowTitleID% 
	}
	GoSub, LoadTitleMatches
Return

WindowPositionClick:
	gui, submit, nohide
	GoSub, SavePositionMatches
	nextini := currentPositionMatchini + 1
	nextininame := % "Ini" . nextini
	Iniread, newini, %inifilename%, PositionMatches, %nextininame%, 0
	if (newini == 0) {
		currentPositionMatchini := 1
		Iniread, inifilenamepositionmatch, %inifilename%, PositionMatches, Ini1, WindowPositionMatch1.ini
		ControlSetText, , % currentPositionMatchini . "/" . maxPositionMatchini, ahk_id %btnWindowPositionID% 
	} else {
		currentPositionMatchini := nextini
		Iniread, inifilenamepositionmatch, %inifilename%, PositionMatches, %nextininame%, WindowPositionMatch1.ini
		ControlSetText, , % currentPositionMatchini . "/" . maxPositionMatchini, ahk_id %btnWindowPositionID% 
	}
	GoSub, LoadPositionMatches
Return

AppLaunchersClick:
	gui, submit, nohide
	nextLauncher := currentAppLauncher + 1
	nextini := % "Ini" . nextLauncher
	Iniread, newini, %inifilename%, ApplicationLaunchers, %nextini%, 0
	if (newini == 0) {
		currentApplauncher := 1
		Iniread, inifilenameAppLaunchers, %inifilename%, ApplicationLaunchers, Ini1, AppLaunchers1.ini
		ControlSetText, , % currentApplauncher . "/" . maxAppLauncher, ahk_id %btnAppLaunchersID% 
	} else {
		currentApplauncher := nextLauncher
		Iniread, inifilenameAppLaunchers, %inifilename%, ApplicationLaunchers, %nextini%, AppLaunchers1.ini
		ControlSetText, , % currentAppLauncher . "/" . maxAppLauncher, ahk_id %btnAppLaunchersID% 
	}
	GoSub, LoadLaunchers
Return

AutoFocusCheck:
	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	IniWrite, %autofocusflag%, %inifilenameCmdLaunchers%, Options, AutoFocus
	if (autofocusflag == 1)
		currentwindow := 0
Return

PSLaunchersClick:
	gui, submit, nohide
	GoSub, SavePSCounts
	nextLauncher := currentPSLauncher + 1
	nextini := % "Ini" . nextLauncher
	Iniread, newini, %inifilename%, PuttySessionLaunchers, %nextini%, 0
	if (newini == 0) {
		currentPSlauncher := 1
		Iniread, inifilenamePSLaunchers, %inifilename%, PuttySessionLaunchers, Ini1, PuttySessions1.ini
		ControlSetText, , % currentPSlauncher . "/" . maxPSLauncher, ahk_id %btnPSLaunchersID% 
	} else {
		currentPSlauncher := nextLauncher
		Iniread, inifilenamePSLaunchers, %inifilename%, PuttySessionLaunchers, %nextini%, PuttySessions1.ini
		ControlSetText, , % currentPSlauncher . "/" . maxPSLauncher, ahk_id %btnPSLaunchersID% 
	}
	GoSub, LoadPSLaunchers
Return

CmdLaunchersClick:
	nextLauncher := currentCmdLauncher + 1
	nextini := % "Ini" . nextLauncher
	Iniread, newini, %inifilename%, CommandLaunchers, %nextini%, 0
	if (newini == 0) {
		currentCmdlauncher := 1
		Iniread, inifilenameCmdLaunchers, %inifilename%, CommandLaunchers, Ini1, Commands1.ini
		ControlSetText, , % currentCmdlauncher . "/" . maxCmdLauncher, ahk_id %btnCmdLaunchersID% 
	} else {
		currentCmdlauncher := nextLauncher
		Iniread, inifilenameCmdLaunchers, %inifilename%, CommandLaunchers, %nextini%, Commands1.ini
		ControlSetText, , % currentCmdlauncher . "/" . maxCmdLauncher, ahk_id %btnCmdLaunchersID% 
	}
	GoSub, LoadCmdLaunchers
Return

LoadTitleMatches:
	Loop, 5 {
		ptmvar = Title%A_Index%
		tmvar = %ptmvar%
		IniRead, tmval, %inifilenametitlematch%, TitleMatch, %tmvar%, .*
		pidvar = edit%A_Index%ID
		idvar := %pidvar%
		ControlSetText, , %tmval%, ahk_id %idvar%
		
		ptmvar = TitleMatch%A_Index%
		tmvar = %ptmvar%
		IniRead, tmval, %inifilenametitlematch%, TitleMatchEnabled, %tmvar%, 0
		pidvar = check%A_Index%ID
		idvar := %pidvar%
		Control, % (tmval ? "check" : "uncheck"), , , ahk_id %idvar%
		
		ptmvar = TitleMatchInv%A_Index%
		tmvar = %ptmvar%
		IniRead, tmval, %inifilenametitlematch%, TitleMatchEnabled, %tmvar%, 0
		pidvar = checkinv%A_Index%ID
		idvar := %pidvar%
		Control, % (tmval ? "check" : "uncheck"), , , ahk_id %idvar%
	}
	IniRead, SingleMatch, %inifilenametitlematch%, Options, SingleMatch, 0
	Control, % (SingleMatch ? "check" : "uncheck"), , , ahk_id %SingleMatchID%
	IniRead, InvertMatch, %inifilenametitlematch%, Options, InvertMatch, 0
	Control, % (InvertMatch ? "check" : "uncheck"), , , ahk_id %InvertMatchID%
	Iniread, btnWindowTitle_TT, %inifilenametitlematch%, Options, Tooltip, %inifilenametitlematch%
Return

LoadPositionMatches:
	enableGuiUpdates = 0
	IniRead, MatchBits1, %inifilenamepositionmatch%, Options, MatchBits1, 0
	bit := 1
	Loop, 8 {
		btnid := "btnBit1" . A_Index . "ID"
		biten := bit & MatchBits1
		GuiControl,, % %btnid% , % ( (biten > 0) ? A_Index : "" )
		bit *= 2
	}
	bit := 1
	IniRead, MatchBits2, %inifilenamepositionmatch%, Options, MatchBits2, 0
	Loop, 8 {
		btnid := "btnBit2" . A_Index . "ID"
		biten := bit & MatchBits2
		GuiControl,, % %btnid% , % ( (biten > 0) ? A_Index : "" )
		bit *= 2
	}
	enableGuiUpdates = 1
	GoSub, UpdateFoundWindowsFilteredGui
	IniRead, matchbyte, %inifilenamepositionmatch%, Options, MatchByte, FFFF
	enableGuiUpdates = 0
	ControlSetText, , %matchbyte%, ahk_id %FindFilterID%

	IniRead, matchtype, %inifilenamepositionmatch%, Options, MatchType, 1
	Loop, 4 {
		pidvar = FilterGroup%A_Index%ID
		idvar := %pidvar%
		Control, % ((A_Index == matchtype) ? "check" : "uncheck" ), , , ahk_id %idvar%
	}
	Iniread, btnWindowPosition_TT, %inifilenamepositionmatch%, Options, Tooltip, %inifilenamepositionmatch%
	enableGuiUpdates = 1
Return

LoadLaunchers:
	Loop, 6 {
		inisection = Launcher%A_Index%
		pcmdvar = launcher%A_Index%command
		pttvar = btnLauncher%A_Index%_TT
		pidvar = btnLauncher%A_Index%ID
		pdirvar = launcher%A_Index%dir
		
		cmdvar = %pcmdvar%
		ttvar = %pttvar%
		idvar := %pidvar%
		dirvar = %pdirvar%
	
		IniRead, %cmdvar%, %inifilenameAppLaunchers%, %inisection%, Command, notepad.exe
		IniRead, %ttvar%, %inifilenameAppLaunchers%, %inisection%, Tooltip,Configure launcher by editing %inifilenameAppLaunchers% file
		IniRead, cmdlbl, %inifilenameAppLaunchers%, %inisection%, Label, NoINI
		IniRead, %dirvar%, %inifilenameAppLaunchers%, %inisection%, Dir, C:\
		ControlSetText, , %cmdlbl%, ahk_id %idvar%
	}
	Iniread, btnAppLaunchers_TT, %inifilenameAppLaunchers%, Options, Tooltip, %inifilenameAppLaunchers%
Return

LoadPSLaunchers:
	Loop, 6 {
		inisection = PuttySession%A_Index%
		pcmdvar = btnputty%A_Index%command
		pttvar = btnPutty%A_Index%_TT
		pidvar = btnPutty%A_Index%ID
		pcountini1 = Putty%A_Index%1Count
		pcountini2 = Putty%A_Index%2Count
		pcountini3 = Putty%A_Index%3Count
		pcountID1 = edtPutty%A_Index%1ID
		pcountID2 = edtPutty%A_Index%2ID
		pcountID3 = edtPutty%A_Index%3ID
		pdirvar = btnputty%A_Index%dir
		
		cmdvar = %pcmdvar%
		ttvar = %pttvar%
		idvar := %pidvar%
		countini1 = %pcountini1%
		countini2 = %pcountini2%
		countini3 = %pcountini3%
		countID1 := %pcountID1%
		countID2 := %pcountID2%
		countID3 := %pcountID3%
		dirvar = %pdirvar%

		IniRead, %cmdvar%, %inifilenamePSLaunchers%, %inisection%, Command, Default
		IniRead, %ttvar%, %inifilenamePSLaunchers%, %inisection%, Tooltip, Configure launcher by editing %inifilenamePSLaunchers% file
		IniRead, cmdlbl, %inifilenamePSLaunchers%, %inisection%, Label, NoINI
		IniRead, %dirvar%, %inifilenamePSLaunchers%, %inisection%, Dir, C:\
		ControlSetText, , %cmdlbl%, ahk_id %idvar%
		IniRead, edtPutty, %inifilenamePSLaunchers%, %inisection%, %countini1%, 0
		ControlSetText, , %edtPutty%, ahk_id %countID1%
		IniRead, edtPutty, %inifilenamePSLaunchers%, %inisection%, %countini2%, 0
		ControlSetText, , %edtPutty%, ahk_id %countID2%
		IniRead, edtPutty, %inifilenamePSLaunchers%, %inisection%, %countini3%, 0
		ControlSetText, , %edtPutty%, ahk_id %countID3%
	}
	Iniread, btnPSLaunchers_TT, %inifilenamePSLaunchers%, Options, Tooltip, %inifilenamePSLaunchers%
Return

LoadCmdLaunchers:
	Loop, 18 {
		inisection = PuttyCommand%A_Index%
		pcmdvar = command%A_Index%
		pttvar = btnCommand%A_Index%_TT
		pidvar = btnCommand%A_Index%ID
		
		cmdvar = %pcmdvar%
		ttvar = %pttvar%
		idvar := %pidvar%

		IniRead, %cmdvar%, %inifilenameCmdLaunchers%, %inisection%, Command, Cmd
		IniRead, %ttvar%, %inifilenameCmdLaunchers%, %inisection%, Tooltip, % %cmdvar%
		IniRead, cmdlbl, %inifilenameCmdLaunchers%, %inisection%, Label, % %cmdvar%
		ControlSetText, , %cmdlbl%, ahk_id %idvar%
	}
	Iniread, btnCmdLaunchers_TT, %inifilenameCmdLaunchers%, Options, Tooltip, %inifilenameCmdLaunchers%
Return

EnableTimers:
	OnMessage(0x200, "WM_MOUSEMOVE")
	SetTimer, Find , %TimerPeriod%
Return
DisableTimers:
	OnMessage(0x200, "")
	SetTimer, Find , Off
Return

; https://autohotkey.com/board/topic/39686-how-to-set-multiline-text-to-a-variable/
; https://autohotkey.com/board/topic/62812-url-link-in-msgbox/
; https://autohotkey.com/board/topic/58797-solved-gui-confusion-multiple-gui-problems/
AboutBox:
	Gui, 2:+LastFoundExist
	IfWinExist
	{
		Gui, 2:+AlwaysOnTop
		Gui, 2:-AlwaysOnTop
		Return
	}
	homepage = https://github.com/SpiroCx/puttyCluster
	MajorVersion = 1.0rc
	AboutMessage1 = % "Version: " . MajorVersion
	FileGetTime, FileTime, %A_ScriptFullPath%
	FormatTime, FileTime, %FileTime%
	; Include the scriptname also to remind us which is running for when both exe and ahk are in the folder
	AboutMessage2 = % "`r" . "Last modification date:`r" . A_ScriptName . ": " . FileTime
	AboutMessage3 = % "`r" . "Script/exe path:`r" . A_ScriptFullPath
	AboutMessage4 = % "`r" . "INI file in use: " . inifilename . "`r"
	AboutMessage5 = % "`r" . "Win-Alt-C 	 Bring ClusterPutty window to the top"
	AboutMessage6 = Win-Alt-D 	 Toggle the launcher sidebar (+ bring to top)
	AboutMessage7 = Win-Alt-T 	 Tile Putty windows
	AboutMessage8 = Win-Alt-F 	 Bring Putty windows to the top of the desktop
	AboutMessage9 = Win-Alt-B 	 Push Putty windows to the back of the desktop (hide them)
	AboutMessage10 = Win-Alt-V 	 Paste current clipboard to all windows
	AboutMessage11 = Win-Alt-L 	 Toggle 'Append CrLf' flag
	AboutMessage12 = Win-Alt-O 	 Locate Putty windows
	AboutMessage13 = Win-Alt-S 	 Toggle 'Single Regex Match' flag
	AboutMessage14 = Win-Alt-1..5 	 Toggle Enable 1..5 flag
	AboutMessage15 = Win-Alt-I 	 Toggle Mini mode
	AboutMessage16 = Win-Alt-N 	 Toggle Invert Match flag
	AboutMessage17 = Win-Alt-Left 	 Focus previous Title/Position matched window
	AboutMessage18 = Win-Alt-Right 	 Focus next Title/Position matched window
	AboutMessage=
	(
		%AboutMessage1%
		%AboutMessage2%
		%AboutMessage3%`r%AboutMessage4%
		%AboutMessage5%`r%AboutMessage6%`r%AboutMessage7%`r%AboutMessage8%`r%AboutMessage9%`r%AboutMessage10%`r%AboutMessage11%`r%AboutMessage12%`r%AboutMessage13%`r%AboutMessage14%`r%AboutMessage15%`r%AboutMessage16%`r%AboutMessage17%`r%AboutMessage18%
	)

	Gui, 2:Font, cBlue
	Gui, 2:Add, Text, vAboutLink gGotoSite, %homepage%
	AboutLink_TT := "Launch link in defaut browser"
	Gui, 2:Font, cBlack
	Gui, 2:Add, Text, vAboutText, %AboutMessage%
	Gui, 2:Add, Button, x210 y365 w40 h25 gbtnOk, Ok
	xposabout := ScreenWidth / 2 - 230
	yposabout := ScreenHeight / 2 - 200
	Gui, 2:Show, x%xposabout% y%yposabout% h400 w460, About
	Gui, 1:-AlwaysOnTop	; temporarily remove OnTopFlag so About box can be on top
	Gui, 2:+AlwaysOnTop
	Gui, 2:-AlwaysOnTop
Return
 btnOk:
 2GuiClose:
 	Gui, 2:Destroy
 	GoSub, OnTopCheck	; restore user selected setting for AlwaysOnTop
 Return
 GotoSite:
 	Run, %homepage%
 Return

edtMonitorClick3:
	ControlSend, , {Space}, ahk_id %Monitor3%
Return

whFocusRadioButton:
	FoundPos := RegExMatch(A_GuiControl, "[12]")
	pcontrolID = % "RadioCheck" . SubStr(A_GuiControl, FoundPos, 1)
	contrlID := %pcontrolID%
	pfocuslID = % A_GuiControl . "ID"
	focusID := %pfocuslID%
	ControlSend, , {Space}, ahk_id %contrlID%
	ControlFocus, , ahk_id %focusID%
Return

titleDoSingle:
	gui, submit, nohide	
	if (SingleMatch != 1)
		Return
	Index := SubStr(A_GuiControl, 6, 1)
	controlVal := check%Index%
	if (controlVal != 1)
		Return
	Loop, 5 {
		If (Index == A_Index)
			Continue
		controlVal := check%A_Index%
		If (controlVal == 1) {
			pControlID = check%A_Index%ID
			ControlID := %pControlID%
			ControlSend, , {Space}, ahk_id %ControlID%
		}
	}
	ControlFocus, , ahk_id %InputBoxID%
Return

FocusInput:
	ControlFocus, , ahk_id %InputBoxID%
Return

btnLauncher:
	Index := SubStr(A_GuiControl, 12, 1)
	pCmd := "launcher" . Index . "command"
	Cmd := %pCmd%
	pDir := "launcher" . Index . "dir"
	Dir := %pDir%
	Run, %Cmd%, %Dir%
Return

btnPutty:
	Index := SubStr(A_GuiControl, 9, 1)
	pCmd := "btnputty" . Index . "command"
	Cmd := %pCmd%
	pDir := "btnputty" . Index . "dir"
	Dir := %pDir%
	Run, %Cmd%, %Dir%
Return

btnCol:
	col := SubStr(A_GuiControl, 7, 1)
	Loop, 6 {
		row := A_Index
		pControlID = edtPutty%A_Index%%col%ID
		ControlID := %pControlID%
		ControlGetText, loopn, , ahk_id %ControlID%
		Loop, %loopn% {
			pCmd := "btnputty" . row . "command"
			Cmd := %pCmd%
			pDir := "btnputty" . row . "dir"
			Dir := %pDir%
			Run, %Cmd%, %Dir%
		}
	}
Return

btnCommand:
	pCmd := "command" . SubStr(A_GuiControl, 11, 1)
	pCmd2 := RegExMatch(A_GuiControl, "[\d]+", 12)
	If (pCmd2 > 0)
		pCmd .= SubStr(A_GuiControl, 12, 1)
	Cmd := %pCmd%
	sendstrdata=% Cmd . (CrLfVal ? "`r" : "")
	GoSub, SendString
Return

MiniModeToggle:
	ControlGetText, ToggleSidebarTxt, , ahk_id %btnToggleSidebarID%
	if ( ToggleSidebarTxt == "<<" )
		GoSub, SidePanelToggle
	ControlGetText, MiniModeTxt, , ahk_id %btnMiniModeID%
	if ( MiniModeTxt == "mini" ) {
		ControlSetText, , full, ahk_id %btnMiniModeID%
		MiniMode_TT := "Disable Mini Mode"
		WinGetPos, xpos, ypos
		xpospremini := xpos
		ypospremini := ypos
		Iniread, xposmini, %inifilename%, Autosave, xposmini, 65535
		Iniread, yposmini, %inifilename%, Autosave, yposmini, 65535
		if ((xposmini == 65535) || (yposmini == 65535)) {
			xposmini := xpos + fwidth - miniwidth
			yposmini := ypos + fheight - miniheight
		}
		Gui, Show, h%miniheight% w%miniwidth%  x%xposmini% y%yposmini%
		xminimodeminibutton := miniwidth - 25
		GuiControl, Move, %btnMiniModeID%, x%xminimodeminibutton% y%0%
		ywidth := miniwidth - 25
		GuiControl, Move, %InputBoxID%, w%ywidth% x0 y%5%
		Gui, 1:Hide
		Gui, 1:+ToolWindow
		Control, Hide, , , ahk_id %btnMiniModeID%
		Control, Hide, , , ahk_id %InputBoxID%
		Gui, 1:Show
		WinSet, Style, -0xC00000, %windowname%
		Control, Show, , , ahk_id %btnMiniModeID%
		Control, Show, , , ahk_id %InputBoxID%
		
		Control, Hide, , , ahk_id %btnToggleSidebarID%
		Control, Hide, , , ahk_id %btnWindowTitleID%
		Control, Hide, , , ahk_id %txtWindowTitleID%
		Control, Hide, , , ahk_id %edit1ID%
		Control, Hide, , , ahk_id %check1ID%
		Control, Hide, , , ahk_id %checkinv1ID%
		Control, Hide, , , ahk_id %edit2ID%
		Control, Hide, , , ahk_id %check2ID%
		Control, Hide, , , ahk_id %checkinv2ID%
		Control, Hide, , , ahk_id %btnAppLaunchersID%
		Control, Hide, , , ahk_id %txtAppLaunchersID%
		Control, Hide, , , ahk_id %btnLauncher1ID%
		ControlFocus, , ahk_id %InputBoxID%
	} else {
		WinGetPos, xpos, ypos
		IniWrite, %xpos%, %inifilename%, Autosave, xposmini
		IniWrite, %ypos%, %inifilename%, Autosave, yposmini
		Gui, 1:Hide
		Gui, 1:-ToolWindow
		;;  2018-05-02 sc note. Don't delete double "Gui, Show".  Fow whatever reason, showing the titlebar
		;; doesn't work unless I show the gui before WinSet, but fheight comes up short once I enable the 
		;; titlebar.  The second hide/show basically recalculates the form height.  Note also with the
		;; double show, I didn't need the +10 fudge on the width (restorewidth).  Again no idea why.
		fwidthrestore := fwidth + 10
		Gui, Show, h%fheight% w%fwidthrestore%  x%xpospremini% y%ypospremini%
		WinSet, Style, +0xC00000, %windowname%
		Gui, 1:Hide
		Gui, Show, h%fheight% w%fwidth%  x%xpospremini% y%ypospremini%
		ControlSetText, , mini, ahk_id %btnMiniModeID%
		MiniMode_TT := "Enable Mini Mode"
		GuiControl, Move, %btnMiniModeID%, x%xminibutton% y%yminibutton%
		yinput := yposcluster + 20
		GuiControl, Move, %InputBoxID%, w50 x10 y%yinput%
		
		Control, Show, , , ahk_id %btnToggleSidebarID%
		Control, Show, , , ahk_id %btnWindowTitleID%
		Control, Show, , , ahk_id %txtWindowTitleID%
		Control, Show, , , ahk_id %edit1ID%
		Control, Show, , , ahk_id %check1ID%
		Control, Show, , , ahk_id %checkinv1ID%
		Control, Show, , , ahk_id %edit2ID%
		Control, Show, , , ahk_id %check2ID%
		Control, Show, , , ahk_id %checkinv2ID%
		Control, Show, , , ahk_id %btnAppLaunchersID%
		Control, Show, , , ahk_id %txtAppLaunchersID%
		Control, Show, , , ahk_id %btnLauncher1ID%
	}
Return

SidePanelToggle:
	ControlGetText, ToggleSidebarTxt, , ahk_id %btnToggleSidebarID%
	WinGetPos, xpos, ypos, , ,%windowname%
	fheightfudge := fheight - 10
	if ( ToggleSidebarTxt == ">>" ) {
		SidePanelOpen := 1
		ControlSetText, , <<, ahk_id %btnToggleSidebarID%
		widewidth := fwidth + sidepanelwidth
		widexpos := xpos - sidepanelwidth - 10 ; 10 may be a fudge.  Wouldn't line up without it
		gui +resize
		Gui, Show, h%fheightfudge% w%widewidth%  x%widexpos% y%ypos%
		xbutton := widewidth - 10
		GuiControl, Move, %btnToggleSidebarID%, x%xbutton%
		gui -resize
	} else {
		SidePanelOpen := 0
		ControlSetText, , >>, ahk_id %btnToggleSidebarID%
		gui +resize
		narrowwidth := fwidth - 10 ; 2018-04-18 This may be a fudge.  The resize doesn't come back to the same width as the original Gui Show did
		narrowxpos := xpos + sidepanelwidth + 10
		Gui, Show, h%fheightfudge% w%narrowwidth% x%narrowxpos% y%ypos%
		GuiControl, Move, %btnToggleSidebarID%, x%xsidepanelbutton%
		gui -resize
	}
Return

OnTopCheck:
	gui, submit, nohide
	WinSet, AlwaysOnTop, % (OnTopVal ? "on" : "off"), %windowname%
Return

CrLfCheck:
	gui, submit, nohide
	CrLfVal = !CrLfVal
Return

FindFilterClick:
	If (enableGuiUpdates == 1) {
		ControlSend, , {Space}, ahk_id %FilterGroup3ID%
		ControlFocus, , ahk_id %FindFilterID%
		GoSub, UpdateFoundWindowsFilteredGui
	}
Return

bit1toggle:
	Index := SubStr(A_GuiControl, 5, 1)
	mask := 2**(Index-1)
	Matchbits1 ^= mask
	test := Matchbits1 & mask
	btnid := "btnBit1" . Index . "ID"
	GuiControl,, % %btnid% , % ((test > 0) ? Index : "" )
	If (enableGuiUpdates == 1) {
		ControlSend, , {Space}, ahk_id %FilterGroup2ID%
		GoSub, UpdateFoundWindowsFilteredGui
	}
Return

bit2toggle:
	Index := SubStr(A_GuiControl, 5, 1)
	mask := 2**(Index-1)
	Matchbits2 ^= mask
	test := Matchbits2 & mask
	btnid := "btnBit2" . Index . "ID"
	GuiControl,, % %btnid% , % ((test > 0) ? Index : "" )
	If (enableGuiUpdates == 1) {
		ControlSend, , {Space}, ahk_id %FilterGroup4ID%
		GoSub, UpdateFoundWindowsFilteredGui
	}
Return

SetScreenWidthHeight:
	if (MonitorGroup == 1) {
		monitorSelected := 1
	} else if (MonitorGroup == 2) {
		monitorSelected := 2
	} else {
		monitorSelected := % edtMonitor3
	}
	SysGet, Mon, Monitor, %monitorSelected%
	if (MonLeft == "")
		SysGet, Mon, Monitor, 1
	ScreenWidth := MonRight - MonLeft
	ScrenHeight := MonBottom - MonTop
Return

RadioCheck:
GoSub, SetScreenWidthHeight
gui, submit, nohide
if (RadioGroup = 1) {
	width := width1
	height := height1
}
else if (RadioGroup = 2) {
	width := width2
	height := height2
}
else if (RadioGroup = 3) {
	width := ScreenWidth
	height := ScreenHeight
	ControlFocus, , ahk_id %InputBoxID%
}
else if (RadioGroup = 4) {
	width := ScreenWidth / 2 - wmargin
	height := ScreenHeight
	ControlFocus, , ahk_id %InputBoxID%
}
else if (RadioGroup = 5) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight
	ControlFocus, , ahk_id %InputBoxID%
}
else if (RadioGroup = 6) {
	width := ScreenWidth / 2 - wmargin
	height := ScreenHeight / 2
	ControlFocus, , ahk_id %InputBoxID%
}
else if (RadioGroup = 7) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight / 2
	ControlFocus, , ahk_id %InputBoxID%
}
else if (RadioGroup = 8) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight / 3
	ControlFocus, , ahk_id %InputBoxID%
}
Return


GuiClose:
	WinGetPos, xpos, ypos
	if (SidePanelOpen == 1)
		xpos += sidepanelwidth + 10
	ControlGetText, MiniModeTxt, , ahk_id %btnMiniModeID%
	if  ( MiniModeTxt == "full" ) {
		xpos := xpos - fwidth + miniwidth
		ypos := ypos -fheight + miniheight
	}
	ControlGetText, xsize1, , ahk_id %width1ID%
	ControlGetText, ysize1, , ahk_id %height1ID%
	ControlGetText, xsize2, , ahk_id %width2ID%
	ControlGetText, ysize2, , ahk_id %height2ID%
	ControlGet, AlwaysOnTop, Checked, , , ahk_id %OnTopID%
	ControlGet, AddCrLf, Checked, , , ahk_id %CrLfID%
	
	IniWrite, %xpos%, %inifilename%, Autosave, xpos
	IniWrite, %ypos%, %inifilename%, Autosave, ypos
	IniWrite, %RadioGroup%, %inifilename%, WindowSize, Selected
	IniWrite, %xsize1%, %inifilename%, XYSize, x1
	IniWrite, %ysize1%, %inifilename%, XYSize, y1
	IniWrite, %xsize2%, %inifilename%, XYSize, x2
	IniWrite, %ysize2%, %inifilename%, XYSize, y2
	IniWrite, %AlwaysOnTop%, %inifilename%, Options, AlwaysOnTop
	IniWrite, %AddCrLf%, %inifilename%, Options, AddCrLf
	IniWrite, %MonitorGroup%, %inifilename%, Options, MonitorSelect
	IniWrite, %edtMonitor3%, %inifilename%, Options, Monitor3
	IniWrite, %currentTitleMatchini%, %inifilename%, TitleMatches, CurrentIni
	IniWrite, %currentPositionMatchini%, %inifilename%, PositionMatches, CurrentIni
	IniWrite, %currentApplauncher%, %inifilename%, ApplicationLaunchers, CurrentLauncher
	IniWrite, %currentPSlauncher%, %inifilename%, PuttySessionLaunchers, CurrentLauncher
	IniWrite, %currentCmdlauncher%, %inifilename%, CommandLaunchers, CurrentLauncher
	
	GoSub, SaveTitleMatches
	GoSub, SavePositionMatches
	GoSub, SavePSCounts
ExitApp

SaveTitleMatches:
	Loop, 5 {
		pControlID = edit%A_Index%ID
		ControlID := %pControlID%
		ControlGetText, saveval, , ahk_id %ControlID%
		IniWrite, %saveval%, %inifilenametitlematch%, TitleMatch, % "Title" . A_Index
		pControlID = check%A_Index%ID
		ControlID := %pControlID%
		ControlGet, saveval, Checked, , , ahk_id %ControlID%
		IniWrite, %saveval%, %inifilenametitlematch%, TitleMatchEnabled, % "TitleMatch" . A_Index
		pControlID = checkinv%A_Index%ID
		ControlID := %pControlID%
		ControlGet, saveval, Checked, , , ahk_id %ControlID%
		IniWrite, %saveval%, %inifilenametitlematch%, TitleMatchEnabled, % "TitleMatchInv" . A_Index
	}
	ControlGet, SingleMatch, Checked, , , ahk_id %SingleMatchID%
	IniWrite, %SingleMatch%, %inifilenametitlematch%, Options, SingleMatch
	ControlGet, InvertMatch, Checked, , , ahk_id %InvertMatchID%
	IniWrite, %InvertMatch%, %inifilenametitlematch%, Options, InvertMatch
Return

SavePositionMatches:
	ControlGetText, edit6, , ahk_id %FindFilterID%

	IniWrite, %MatchBits1%, %inifilenamepositionmatch%, Options, MatchBits1
	IniWrite, %MatchBits2%, %inifilenamepositionmatch%, Options, MatchBits2
	IniWrite, %edit6%, %inifilenamepositionmatch%, Options, MatchByte
	IniWrite, %FilterGroup%, %inifilenamepositionmatch%, Options, MatchType
Return

SavePSCounts:
	Loop, 6 {
		row := A_Index
		Loop, 3 {
			pControlID = edtPutty%row%%A_Index%ID
			ControlID := %pControlID%
			ControlGetText, saveval, , ahk_id %ControlID%
			IniWrite, %saveval%, %inifilenamePSLaunchers%, % "PuttySession" . row, % "Putty" . row . A_Index . "Count"
		}
	}
Return

UpdateFoundWindowsFilteredGui:
	titlematchbit := 1
	matchcount := 0
	filt2str = 
	Loop, %id_array_count%
	{
		if ( ( titlematchbit & MatchBits1 ) > 0 ) {
			matchcount += 1
			filt2str .= A_Index
		}
		titlematchbit *= 2
	}
	FoundWindowsFiltered2 := matchcount

	titlematchbit := 1
	matchcount := 0
	filt4str =
	Loop, %id_array_count%
	{
		if ( ( titlematchbit & MatchBits2 ) > 0 ) {
			matchcount += 1
			filt4str .= A_Index
		}
		titlematchbit *= 2
	}
	FoundWindowsFiltered4 := matchcount

	VarSetCapacity(windowfilter, 66, 0)
	, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
	, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
	titlematchbit := 1
	matchcount := 0
	Loop, %id_array_count%
	{
		if ( ( titlematchbit & windowfilter ) > 0 ) {
			matchcount += 1
		}
		titlematchbit *= 2
	}
	FoundWindowsFiltered3 := matchcount

	GuiControl, , %FilterGroup2InfoID%,  % "(" FoundWindowsFiltered2 "/" id_array_count ")"
	GuiControl, , %FilterGroup3InfoID%,  % "(" FoundWindowsFiltered3 "/" id_array_count ")"
	GuiControl, , %FilterGroup4InfoID%,  % "(" FoundWindowsFiltered4 "/" id_array_count ")"
	
	if ( FilterGroup == 1 ){
		positionMatchStr = % "All " . id_array_count " window(s)"
	} else if ( FilterGroup == 2 ){
		positionMatchStr = % "Pattern: " . filt2str . "`rMatches: " FoundWindowsFiltered2 "/" id_array_count
	} else if ( FilterGroup == 3 ){
		positionMatchStr = % "Pattern: 0x" . FindFilterTxt . "`rMatches" FoundWindowsFiltered3 "/" id_array_count
	} else if ( FilterGroup == 4 ){
		positionMatchStr = % "Pattern: " . filt4str . "`rMatches:" FoundWindowsFiltered4 "/" id_array_count
	}
	InputBox_TT = %titleMatchRegexp%`r%positionMatchStr%
Return

Tile:
	SetWinDelay, -1
	Gosub, Find 
	GoSub, DisableTimers
	GoSub, RadioCheck
	x := MonLeft
	y := MonTop

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			;WinActivate, ahk_id %this_id_tile%,				
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinMove, ahk_id %this_id%,, x,y,width,height
			x:=x+width
			if( (x+width) >= MonRight){
				x:=MonLeft
				y:=y+height
			}
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				;WinActivate, ahk_id %this_id_tile%,				
				WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
				WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
				WinMove, ahk_id %this_id%,, x,y,width,height
				x:=x+width
				if( (x+width) >= MonRight){
					x:=MonLeft
					y:=y+height
				}
			}
			titlematchbit *= 2
		}
	}
	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
return
	
ToFront:
	Gosub, Find 
	GoSub, DisableTimers

	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if ((autofocusflag == 0) && (currentwindow > 0)) {
		this_id := id_array[currentwindow]
		WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
		WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
	} else if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
				WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			}
			titlematchbit *= 2
		}
	}

	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
return
	
ToBack:
	Gosub, Find 
	GoSub, DisableTimers

	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if ((autofocusflag == 0) && (currentwindow > 0)) {
		this_id := id_array[currentwindow]
		;WinMinimize, ahk_id %this_id_toback%,			
		WinSet, Bottom, , ahk_id %this_id%
	} else if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			;WinMinimize, ahk_id %this_id_toback%,			
			WinSet, Bottom, , ahk_id %this_id%
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				;WinMinimize, ahk_id %this_id_toback%,			
				WinSet, Bottom, , ahk_id %this_id%
			}
			titlematchbit *= 2
		}
	}
	
	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
return
	
CloseWin:
	Gosub, Find 
	GoSub, DisableTimers
	x:=0
	y:=0

	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if ((autofocusflag == 0) && (currentwindow > 0)) {
		this_id := id_array[currentwindow]
		WinClose, ahk_id %this_id%,
	} else if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinClose, ahk_id %this_id%,
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinClose, ahk_id %this_id%,
			}
			titlematchbit *= 2
		}
	}
	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
return
	
Cascade:
	SetWinDelay, -1
	Gosub, Find 
	GoSub, DisableTimers
	GoSub, RadioCheck
	x := MonLeft
	y := MonTop

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinMove, ahk_id %this_id%, , x,y,width,height				
			x:=x+xstep
			y:=y+ystep
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinMove, ahk_id %this_id%, , x,y,width,height				
				x:=x+xstep
				y:=y+ystep
			}
			titlematchbit *= 2
		}
	}
	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
return
	
GoPaste:
	GoSub, DisableTimers
	ControlSetText, , no input while pasting...., ahk_id %InputBoxID%
	paste=1
	currentclip=%clipboard%
	if (CrLfVal) {
		currentclip=%clipboard%`r
	}
	Loop, Parse, currentclip
	{
		sendstrdata := A_Loopfield
		GoSub, SendString_LeaveTimers
	}
	paste=0
	;ControlSetText, , , ahk_id %InputBoxID% 
	;ControlFocus, , ahk_id %InputBoxID%
	;WinActivate, %windowname%
	GoSub, EnableTimers
Return

SendString:
    ;Gosub, Find 
	GoSub, DisableTimers
	ControlSetText, , no input while pasting...., ahk_id %InputBoxID%
	paste=1
	fullstring := sendstrdata
	Loop, Parse, fullstring
	{
		sendstrdata := A_Loopfield
		GoSub, SendString_LeaveTimers
	}
	paste=0
	ControlSetText, , , ahk_id %InputBoxID% 
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
	GoSub, EnableTimers
Return

SendString_LeaveTimers:
	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if ((autofocusflag == 0) && (currentwindow > 0)) {
		this_id := id_array[currentwindow]
		PostMessage, 0x102, % Asc(sendstrdata), 1, ,ahk_id %this_id%,
	} else if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			PostMessage, 0x102, % Asc(sendstrdata), 1, ,ahk_id %this_id%,
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				PostMessage, 0x102, % Asc(sendstrdata), 1, ,ahk_id %this_id%,
			}
			titlematchbit *= 2
		}
	}
return

Locate:  
    Gosub, Find 
	GoSub, DisableTimers

	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if ((autofocusflag == 0) && (currentwindow > 0)) {
		this_id := id_array[currentwindow]
		WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
		WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
		WinSet, Transparent, 30, ahk_id %this_id%
		Sleep, 200
		WinSet, Transparent, %alpha%, ahk_id %this_id%
		; PostMessage, 0x112, 0xF020,,, ahk_id %this_id%,
		; PostMessage, 0x112, 0xF120,,, ahk_id %this_id%,
	} else if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinSet, Transparent, 30, ahk_id %this_id%
			Sleep, 200
			WinSet, Transparent, %alpha%, ahk_id %this_id%
			; PostMessage, 0x112, 0xF020,,, ahk_id %this_id%,
			; PostMessage, 0x112, 0xF120,,, ahk_id %this_id%,
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
				WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
				WinSet, Transparent, 30, ahk_id %this_id%
				Sleep, 200
				WinSet, Transparent, %alpha%, ahk_id %this_id%
				; PostMessage, 0x112, 0xF020,,, ahk_id %this_id%,
				; PostMessage, 0x112, 0xF120,,, ahk_id %this_id%,
			}
			titlematchbit *= 2
		}
	}

	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
return 

FocusNextWindow:  
    Gosub, Find 
	GoSub, DisableTimers

	if ( FilterGroup == 1 ){
		if (id_array_count > 0)
		{
			currentwindow += 1
			if (currentwindow > id_array_count)
				currentwindow := 1
			this_id := id_array[currentwindow]
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinActivate, ahk_id %this_id%
			WinSet, Transparent, 30, ahk_id %this_id%
			Sleep, 50
			WinSet, Transparent, %alpha%, ahk_id %this_id%
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		matchcount := 0
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				matchcount += 1
				if (matchcount > currentwindow) {
					currentwindow += 1
					this_id := id_array[A_Index]
					WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
					WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
					WinActivate, ahk_id %this_id%
					WinSet, Transparent, 30, ahk_id %this_id%
					Sleep, 50
					WinSet, Transparent, %alpha%, ahk_id %this_id%
					return
				}
			}
			titlematchbit *= 2
		}
		if (matchcount > 0) {
			titlematchbit := 1
			Loop, %id_array_count%
			{
				if ( ( titlematchbit & windowfilter ) > 0 ) {
					currentwindow := 1
					this_id := id_array[A_Index]
					WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
					WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
					WinActivate, ahk_id %this_id%
					WinSet, Transparent, 30, ahk_id %this_id%
					Sleep, 50
					WinSet, Transparent, %alpha%, ahk_id %this_id%
					return
				}
				titlematchbit *= 2
			}
		}
	}

	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
return 

FocusPrevWindow:  
    Gosub, Find 
	GoSub, DisableTimers

	if ( FilterGroup == 1 ){
		if (id_array_count > 0)
		{
			currentwindow -= 1
			if (currentwindow <= 0)
				currentwindow := id_array_count
			this_id := id_array[currentwindow]
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
			WinActivate, ahk_id %this_id%
			WinSet, Transparent, 30, ahk_id %this_id%
			Sleep, 50
			WinSet, Transparent, %alpha%, ahk_id %this_id%
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		matchcount := 0
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				matchcount += 1
			}
			titlematchbit *= 2
		}
		currentwindow -= 1
		if (currentwindow <= 0)
			currentwindow := matchcount
		matchcount := 0
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				matchcount += 1
				if (matchcount == currentwindow) {
					this_id := id_array[A_Index]
					WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
					WinSet, AlwaysOnTop, Toggle, ahk_id %this_id%
					WinActivate, ahk_id %this_id%
					WinSet, Transparent, 30, ahk_id %this_id%
					Sleep, 50
					WinSet, Transparent, %alpha%, ahk_id %this_id%
					return
				}
			}
			titlematchbit *= 2
		}
	}

	GoSub, EnableTimers
	ControlFocus, , ahk_id %InputBoxID%
return 

Find:
  gui, Submit, nohide
  titletmp := ""
  if (InvertMatch == 1) {
	  if( check1 && title1 != "" )
		titletmp = % "(" . title1 . ")"
	  if( check2 && title2 != "" ) {
		titletmp = % titletmp . "|(" . title2 . ")"
	  }
	  if( check3 && title3 != "" ) {
		titletmp = % titletmp . "|(" . title3 . ")"
	  }
	  if( check4 && title4 != "" ) {
		titletmp = % titletmp . "|(" . title4 . ")"
	  }
	  if( check5 && title5 != "" ) {
		titletmp = % titletmp . "|(" . title5 . ")"
	  }
	  titletmp := LTrim(titletmp, "|")
	  titleMatchRegexp := % "^((?!" . titletmp . ").)*$"
  } else {
	  if( check1 && title1 != "" )
		titletmp = % (checkinv1 ? "^((?!" : "(") . title1 . (checkinv1 ? ").)*$" : ")")
	  if( check2 && title2 != "" ) {
		titletmp = % titletmp . (checkinv2 ? "|^((?!" : "|(") . title2 . (checkinv2 ? ").)*$" : ")")
	  }
	  if( check3 && title3 != "" ) {
		titletmp = % titletmp . (checkinv3 ? "|^((?!" : "|(") . title3 . (checkinv3 ? ").)*$" : ")")
	  }
	  if( check4 && title4 != "" ) {
		titletmp = % titletmp . (checkinv4 ? "|^((?!" : "|(") . title4 . (checkinv4 ? ").)*$" : ")")
	  }
	  if( check5 && title5 != "" ) {
		titletmp = % titletmp . (checkinv5 ? "|^((?!" : "|(") . title5 . (checkinv5 ? ").)*$" : ")")
	  }
	  titleMatchRegexp := LTrim(titletmp, "|")
  }
  if( titleMatchRegexp != "")
  {
	id_array_count := id_array._MaxIndex()
	if (id_array_count > 0)
		id_array.Delete(1, id_array_count)
	id_array_count := 0
	 
	WinGet, puttyids, list, ahk_exe putty.exe
	Loop, %puttyids%
	{
		this_id_find := puttyids%A_Index%
		WinGetTitle, thistitle, ahk_id  %this_id_find%
		if (RegExMatch(thistitle, titleMatchRegexp) > 0) {
			id_array.Push(this_id_find)
		}
	}
	
	WinGet, kittyids, list, ahk_exe kitty.exe
	Loop, %kittyids%
	{
		this_id_find := kittyids%A_Index%
		WinGetTitle, thistitle, ahk_id  %this_id_find%
		if (RegExMatch(thistitle, titleMatchRegexp) > 0) {
			id_array.Push(this_id_find)
		}
	}

	WinGet, superputtyids, list, ahk_exe SuperPutty.exe
	Loop, %superputtyids%
	{
		this_id_find := superputtyids%A_Index%
		WinGet, superputtycontrols, ControlList, ahk_id %this_id_find%
		Loop, Parse, superputtycontrols, `n
		{
			if ( RegExMatch(A_LoopField, "PuTTY\d+") > 0) {
			ControlGet, ControlID, Hwnd,, %A_LoopField%, ahk_id %this_id_find%
				WinGetTitle, thistitle, ahk_id  %ControlID%
				if (RegExMatch(thistitle, titleMatchRegexp) > 0) {
					id_array.Push(ControlID)
				}
			}
		}
	}
	WinGet, xshellids, list, ahk_exe Xshell.exe
	Loop, %xshellids%
	{
		this_id_find := xshellids%A_Index%
		WinGet, xshellcontrols, ControlList, ahk_id %this_id_find%
		Loop, Parse, xshellcontrols, `n
		{
			if ( RegExMatch(A_LoopField, "AfxFrameOrView\d+") > 0) {
			ControlGet, ControlID, Hwnd,, %A_LoopField%, ahk_id %this_id_find%
				WinGetTitle, thistitle, ahk_id  %ControlID%
				if (RegExMatch(thistitle, titleMatchRegexp) > 0) {
					id_array.Push(ControlID)
				}
			}
		}
	}

	id_array_count := id_array._MaxIndex()
	if (id_array_count == "")
		id_array_count := 0

	; this sort stops the Locate function inverting the display order on successive runs.  Without it, Locate
	; function ( and bitfield window filter selection) alternates between window 1 to N, then N to 1
	if (id_array_count > 1) {
		id_array := InsertionSort(id_array)
		sortedcount := id_array._MaxIndex()
		if (id_array_count != sortedcount)
			id_array_count := sortedcount
	}	

     GuiControl, , %FoundCountID%,  % "Found " id_array_count " window(s)"
	 GoSub, UpdateFoundWindowsFilteredGui
  } else {
	id_array_count := 0
	GuiControl, , %FoundCountID%,   Found 0 window(s)
	GoSub, UpdateFoundWindowsFilteredGui
  }

	

Alpha:
  GuiControlGet, alpha, ,msctls_trackbar321

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinSet, Transparent, %alpha%, ahk_id %this_id%
		}
	} else {
		if ( FilterGroup == 2 ) {
			windowfilter := MatchBits1
		} else if ( FilterGroup == 4 ) {
			windowfilter := MatchBits2
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinSet, Transparent, %alpha%, ahk_id %this_id%
			}
			titlematchbit *= 2
		}
	}


return

; https://autohotkey.com/boards/viewtopic.php?t=12054
InsertionSort(ar)
{
   For i, v in ar
      list .=  v . "`n"
   Sort, list, N U
   Return StrSplit(RTrim(list, "`n"), "`n")
}

; Win+Alt+C
#!c::
	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if (autofocusflag == 0)
		ControlSend, , {Space}, ahk_id %AutoFocusID%
	WinActivate, %windowname%
	WinSet, AlwaysOnTop, Toggle, %windowname%
	WinSet, AlwaysOnTop, Toggle, %windowname%
	ControlFocus, , ahk_id %InputBoxID%
Return

; Win+Alt+D
#!d::
	WinActivate, %windowname%
	WinSet, AlwaysOnTop, Toggle, %windowname%
	WinSet, AlwaysOnTop, Toggle, %windowname%
	ControlGetText, MiniModeTxt, , ahk_id %btnMiniModeID%
	if ( MiniModeTxt != "mini" )
		ControlClick, , ahk_id %btnMiniModeID%
	GoSub, SidePanelToggle
Return

; Win+Alt+T
#!t::
	GoSub, Tile
Return

; Win+Alt+F
#!f::
	GoSub, ToFront
Return

; Win+Alt+B
#!b::
	GoSub, ToBack
Return

; Win+Alt+V
#!v::
	GoSub, GoPaste
Return

; Win+Alt+R
#!l::
	ControlSend, , {Space}, ahk_id %CrLfID%
Return

; Win+Alt+O
#!o::
	GoSub, Locate
Return

; Win+Alt+S
#!s::
	ControlSend, , {Space}, ahk_id %SingleMatchID%
Return

; Win+Alt+1
#!1::
	if (!check1)
		ControlSend, , {Space}, ahk_id %check1ID%
	else
		ControlClick, , ahk_id %InvertMatchID%
Return

; Win+Alt+2
#!2::
	if (!check2)
		ControlSend, , {Space}, ahk_id %check2ID%
	else
		ControlClick, , ahk_id %InvertMatchID%
Return

; Win+Alt+3
#!3::
	if (!check3)
		ControlSend, , {Space}, ahk_id %check3ID%
	else
		ControlClick, , ahk_id %InvertMatchID%
Return

; Win+Alt+4
#!4::
	if (!check4)
		ControlSend, , {Space}, ahk_id %check4ID%
	else
		ControlClick, , ahk_id %InvertMatchID%
Return

; Win+Alt+5
#!5::
	if (!check5)
		ControlSend, , {Space}, ahk_id %check5ID%
	else
		ControlClick, , ahk_id %InvertMatchID%
Return

; Win+Alt+I
#!i::
	;GoSub, MiniModeToggle
	ControlClick, , ahk_id %btnMiniModeID%
Return

; Win+Alt+N
#!n::
	ControlClick, , ahk_id %InvertMatchID%
Return

; Win+Alt+Right
#!Right::
	GoSub, FocusNextWindow
	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if (autofocusflag == 1)
		ControlSend, , {Space}, ahk_id %AutoFocusID%
Return

; Win+Alt+Left
#!Left::
	GoSub, FocusPrevWindow
	ControlGet, autofocusflag, Checked, , , ahk_id %AutoFocusID%
	if (autofocusflag == 1)
		ControlSend, , {Space}, ahk_id %AutoFocusID%
Return

;; https://jacksautohotkeyblog.wordpress.com/2016/02/28/autohotkey-groupadd-command-reduces-script-code-beginning-hotkeys-part-4
;; Ctrl-Alt-k
;^!k::
;  WinGet, WinID, ID, A
;  GroupAdd, WinGroup, ahk_id %WinID%
;  MsgBox, Window %WinID% added to group
;      ,`rCTRL+[ Restore Group
;      ,`rCTRL+] Minimize Group
;      ,`rCTRL+BackSlash Cycle Group
;      ,`rCTRL+BackSpace Reset Group.
;Return
;
;#IfWinExist, ahk_group WinGroup
;   ^[::WinRestore, ahk_group WinGroup
;   ^]::WinMinimize, ahk_group WinGroup
;   ^\::GroupActivate, WinGroup
;   RControl & BackSpace::Reload
;#IfWinExist