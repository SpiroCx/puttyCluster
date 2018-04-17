#SingleInstance force
#NoTrayIcon
SetWorkingDir %A_ScriptDir%

global bit11state := 0
global bit12state := 0
global bit13state := 0
global bit14state := 0
global bit15state := 0
global bit16state := 0
global bit17state := 0
global bit18state := 0
global bit21state := 0
global bit22state := 0
global bit23state := 0
global bit24state := 0
global bit25state := 0
global bit26state := 0
global bit27state := 0
global bit28state := 0
global windowname = "Mingbo's cluster Putty"
SysGet, ScreenWidth, 0
SysGet, ScreenHeight, 1
global ScreenWidth := ScreenWidth
global ScreenHeight := ScreenHeight - 40
global id
xstep := 50
ystep := 40
global id_array := Object()
global wmargin := 1
global width
global height

; Title Row
Gui, Add, Text,, Windows Title Pattern (RegEx):

; Title matching text boxes
IniRead, edit1, puttyCluster.ini, TitleMatch, Title1, .*
IniRead, edit2, puttyCluster.ini, TitleMatch, Title2, %A_Space%
IniRead, edit3, puttyCluster.ini, TitleMatch, Title3, %A_Space%
IniRead, edit4, puttyCluster.ini, TitleMatch, Title4, %A_Space%
IniRead, edit5, puttyCluster.ini, TitleMatch, Title5, %A_Space%
xpos := 10
ypos := 25
ewidth := 200
Gui, Add, Edit, x%xpos% y%ypos% vtitle1 w%ewidth%, %edit1%
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle2 w%ewidth%, %edit2%
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle3 w%ewidth%, %edit3%
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle4 w%ewidth%, %edit4%
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle5 w%ewidth%, %edit5%

; Enable checkboxes
IniRead, check1, puttyCluster.ini, TitleMatchEnabled, TitleMatch1, 1
IniRead, check2, puttyCluster.ini, TitleMatchEnabled, TitleMatch2, 0
IniRead, check3, puttyCluster.ini, TitleMatchEnabled, TitleMatch3, 0
IniRead, check4, puttyCluster.ini, TitleMatchEnabled, TitleMatch4, 0
IniRead, check5, puttyCluster.ini, TitleMatchEnabled, TitleMatch5, 0
xpos := 220
ypos := 30
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " vcheck1" .  ( check1 ? " Checked" : "" )
ypos := ypos + 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " vcheck2" .  ( check2 ? " Checked" : "" )
ypos := ypos + 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " vcheck3" .  ( check3 ? " Checked" : "" )
ypos := ypos + 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " vcheck4" .  ( check4 ? " Checked" : "" )
ypos := ypos + 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " vcheck5" .  ( check5 ? " Checked" : "" )

; Found n windows and Locate Windows button
xpos := 10
ypos := 165
Gui, Add, Text, x%xpos% y%ypos%, Found 0 window(s)
xpos := 130
ypos := ypos - 5
Gui, Add, button, x%xpos% y%ypos% gLocate -default, locate window(s)

; Found filter radio buttons
IniRead, matchbyte1type, puttyCluster.ini, MatchBits1, MatchByte1Type, 1
IniRead, matchbyte1, puttyCluster.ini, MatchBits1, MatchByte1, FFFF
xpos := 10
ypos := 200
Gui, Add, Text,  x%xpos% y%ypos%, Found windows filter (bitfield HEX eg FFFF):
xpos := xpos + 20
ypos := ypos + 20
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " w23" . " vFilterGroup" .  ( (matchbyte1type == 1) ? " Checked" : "" )
xpos := xpos + 0
ypos := ypos + 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " w23" .  ( (matchbyte1type == 2) ? " Checked" : "" )
xpos := xpos + 90
ypos := ypos - 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " w23" .  ( (matchbyte1type == 3) ? " Checked" : "" )
xpos := xpos - 90
ypos := ypos + 60
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " w23" .  ( (matchbyte1type == 4) ? " Checked" : "" )
xpos := xpos + 23
ypos := ypos - 60
Gui, Add, Text,  x%xpos% y%ypos%, All
xpos := xpos + 90
ypos := ypos - 3
Gui, Add, Edit,  x%xpos% y%ypos% vFindFilterTxt gFindFilterClick w33, %matchbyte1%

; Found filter bit selection buttons 1
IniRead, bit11state, puttyCluster.ini, MatchBits1, MatchBit11, 0
IniRead, bit12state, puttyCluster.ini, MatchBits1, MatchBit12, 0
IniRead, bit13state, puttyCluster.ini, MatchBits1, MatchBit13, 0
IniRead, bit14state, puttyCluster.ini, MatchBits1, MatchBit14, 0
IniRead, bit15state, puttyCluster.ini, MatchBits1, MatchBit15, 0
IniRead, bit16state, puttyCluster.ini, MatchBits1, MatchBit16, 0
IniRead, bit17state, puttyCluster.ini, MatchBits1, MatchBit17, 0
IniRead, bit18state, puttyCluster.ini, MatchBits1, MatchBit18, 0
xpos := 52
ypos := 247
Gui, Add, Button, x%xpos% y%ypos% w14 gbit11toggle -default, % ( bit11state ? "1" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit12toggle -default, % ( bit12state ? "2" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit13toggle -default, % ( bit13state ? "3" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit14toggle -default, % ( bit14state ? "4" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit15toggle -default, % ( bit15state ? "5" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit16toggle -default, % ( bit16state ? "6" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit17toggle -default, % ( bit17state ? "7" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit18toggle -default, % ( bit18state ? "8" : "" )

; Found filter bit selection buttons 2
IniRead, bit21state, puttyCluster.ini, MatchBits2, MatchBit21, 0
IniRead, bit22state, puttyCluster.ini, MatchBits2, MatchBit22, 0
IniRead, bit23state, puttyCluster.ini, MatchBits2, MatchBit23, 0
IniRead, bit24state, puttyCluster.ini, MatchBits2, MatchBit24, 0
IniRead, bit25state, puttyCluster.ini, MatchBits2, MatchBit25, 0
IniRead, bit26state, puttyCluster.ini, MatchBits2, MatchBit26, 0
IniRead, bit27state, puttyCluster.ini, MatchBits2, MatchBit27, 0
IniRead, bit28state, puttyCluster.ini, MatchBits2, MatchBit28, 0
xpos := 52
ypos := 277
Gui, Add, Button, x%xpos% y%ypos% w14 gbit21toggle -default, % ( bit21state ? "1" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit22toggle -default, % ( bit22state ? "2" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit23toggle -default, % ( bit23state ? "3" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit24toggle -default, % ( bit24state ? "4" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit25toggle -default, % ( bit25state ? "5" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit26toggle -default, % ( bit26state ? "6" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit27toggle -default, % ( bit27state ? "7" : "" )
xpos := xpos + 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 gbit28toggle -default, % ( bit28state ? "8" : "" )


; Window transparency slider
; yposslider := 190
yposslider := 310
xpos := 10
ypos := yposslider
swidth := 230
Gui, Add, Text, x%xpos% y%ypos%, Window transparency:
ypos := ypos + 18
GUI, Add, Slider, x%xpos% y%ypos% Range100-255 w%swidth% gFind, 255

; Cluster Input, Paste, CrLf checkbox, Always on top checkbox
IniRead, AlwaysOnTop, puttyCluster.ini, Options, AlwaysOnTop, 0
IniRead, AddCrLf, puttyCluster.ini, Options, AddCrLf, 0
yposcluster := yposslider + 60
xpos := 10
ypos := yposcluster
Gui, Add, Text, x%xpos% y%ypos% vignore w100, cluster input:
xpos := xpos + 113
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " vOnTopVal gOnTopCheck" .  ( AlwaysOnTop ? " Checked" : "" ), Always On Top
xpos := xpos - 113
ypos := ypos + 20
Gui, Add, Edit, x%xpos% y%ypos% w80 WantTab ReadOnly, 
xpos := xpos + 83
Gui, Add, button, x%xpos% y%ypos% gGoPaste -default, Paste &Clipboard
xpos := xpos + 90
ypos := ypos + 7
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " vCrLfVal gCrLfCheck" .  ( AddCrLf ? " Checked" : "" ),  +Cr&Lf

; Window command buttons Tile, Cascade, ToFront etc
xpos := 10
ypos := yposcluster + 45
Gui, Add, button, x%xpos% y%ypos% gTile -default, &Tile
xpos := xpos + 30
Gui, Add, button, x%xpos% y%ypos% gCascade -default, Cascade
xpos := xpos + 55
Gui, Add, button, x%xpos% y%ypos% gToBack -default, To&Back
xpos := xpos + 52
Gui, Add, button, x%xpos% y%ypos% gToFront -default, To&Front
xpos := xpos + 52
Gui, Add, button, x%xpos% y%ypos% gCloseWin -default, Close

; Window size radio buttons
IniRead, winsize, puttyCluster.ini, WindowSize, Selected, 7
xbase := 5
ybase := yposcluster + 85

xpos := xbase
ypos1 := ybase + 5
ypos2 := ybase + 32
ypos3 := ybase + 59
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " gRadioCheck" . " vRadioGroup" .  ( (winsize == 1) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " gRadioCheck" .  ( (winsize == 2) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gRadioCheck" .  ( (winsize == 3) ? " Checked" : "" )
xpos := xpos + 115
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " gRadioCheck" .  ( (winsize == 4) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " gRadioCheck" .  ( (winsize == 5) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gRadioCheck" .  ( (winsize == 6) ? " Checked" : "" )
xpos := xpos + 60
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " gRadioCheck" .  ( (winsize == 7) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " gRadioCheck" .  ( (winsize == 8) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gRadioCheck" .  ( (winsize == 9) ? " Checked" : "" )

; Radio button text boxes
IniRead, xsize1, puttyCluster.ini, XYSize, x1, 400
IniRead, ysize1, puttyCluster.ini, XYSize, y1, 500
IniRead, xsize2, puttyCluster.ini, XYSize, x2, 400
IniRead, ysize2, puttyCluster.ini, XYSize, y2, 600
IniRead, xsize3, puttyCluster.ini, XYSize, x3, 400
IniRead, ysize3, puttyCluster.ini, XYSize, y3, 700
xpos := xbase + 54
Gui, Add, Text,  x%xpos% y%ypos1%, X
Gui, Add, Text,  x%xpos% y%ypos2%, X
Gui, Add, Text,  x%xpos% y%ypos3%, X
xpos := xpos + 84
Gui, Add, Text,  x%xpos% y%ypos1%, 1x1
Gui, Add, Text,  x%xpos% y%ypos2%, 1x2
Gui, Add, Text,  x%xpos% y%ypos3%, 1x3
xpos := xpos + 60
Gui, Add, Text,  x%xpos% y%ypos1%, 2x2
Gui, Add, Text,  x%xpos% y%ypos2%, 2x3
Gui, Add, Text,  x%xpos% y%ypos3%, 3x3

; Radio button edit boxes
xpos := xbase + 23
ypos1 := ybase
ypos2 := ybase + 27
ypos3 := ybase + 54
Gui, Add, Edit,  x%xpos% y%ypos1% vwidth1 w30 Number, %xsize1%
Gui, Add, Edit,  x%xpos% y%ypos2% vwidth2 w30 Number, %xsize2%
Gui, Add, Edit,  x%xpos% y%ypos3% vwidth3 w30 Number, %xsize3%
xpos := xpos + 40
Gui, Add, Edit,  x%xpos% y%ypos1% vheight1 w30 Number, %ysize1%
Gui, Add, Edit,  x%xpos% y%ypos2% vheight2 w30 Number, %ysize2%
Gui, Add, Edit,  x%xpos% y%ypos3% vheight3 w30 Number, %ysize3%

fheight := yposcluster + 165
fwidth := 250
xpos_default := (ScreenWidth / 2) - (fwidth / 2)
ypos_default := (ScreenHeight / 2) - (fheight / 2)
Iniread, xpos, puttyCluster.ini, Autosave, xpos, %xpos_default%
Iniread, ypos, puttyCluster.ini, Autosave, ypos, %ypos_default%
Gui, Show, h%fheight% w%fwidth% x%xpos% y%ypos%, %windowname%

onMessage(0x100,"key")  ; key down
onMessage(0x101,"key")  ; key up
onMessage(0x104,"key")  ; alt key down
onMessage(0x105,"key")  ; alt key down

SetTimer, Find , 1000
SetTitleMatchMode, RegEx 
#WinActivateForce

GoSub, RadioCheck

key(wParam, lParam,msg, hwnd)
{ 
  global paste
  if (paste ==1) {
	return
  }
  GuiControlGet, currentInput, Focus  
  if(currentInput="Edit7"){

	global id
	global FilterGroup
	global FindFilterTxt
	global bit11state
	global bit12state
	global bit13state
	global bit14state
	global bit15state
	global bit16state
	global bit17state
	global bit18state
	global bit21state
	global bit22state
	global bit23state
	global bit24state
	global bit25state
	global bit26state
	global bit27state
	global bit28state

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
			}
			titlematchbit := titlematchbit * 2
		}
	}


	GuiControl,,Edit7, 
   }
}
return 

OnTopCheck:
	if ( OnTopVal == 0) {
		WinSet, AlwaysOnTop, on, %windowname%
	} else {
		WinSet, AlwaysOnTop, off, %windowname%
	}
Return

CrLfCheck:
	CrLfVal = !CrLfVal
Return

FindFilterClick:
	ControlSend, Button9, {Space}, %windowname%
	ControlFocus, Edit6,  %windowname%
Return

bit11toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit11state := !bit11state
	GuiControl,, Button11, % ( (bit11state) ? "1" : "" )
Return

bit12toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit12state := !bit12state
	GuiControl,, Button12, % ( (bit12state) ? "2" : "" )
Return

bit13toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit13state := !bit13state
	GuiControl,, Button13, % ( (bit13state) ? "3" : "" )
Return

bit14toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit14state := !bit14state
	GuiControl,, Button14, % ( (bit14state) ? "4" : "" )
Return

bit15toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit15state := !bit15state
	GuiControl,, Button15, % ( (bit15state) ? "5" : "" )
Return

bit16toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit16state := !bit16state
	GuiControl,, Button16, % ( (bit16state) ? "6" : "" )
Return

bit17toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit17state := !bit17state
	GuiControl,, Button17, % ( (bit17state) ? "7" : "" )
Return

bit18toggle:
	ControlSend, Button8, {Space}, %windowname%
	bit18state := !bit18state
	GuiControl,, Button18, % ( (bit18state) ? "8" : "" )
Return

bit21toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit21state := !bit21state
	GuiControl,, Button19, % ( (bit21state) ? "1" : "" )
Return

bit22toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit22state := !bit22state
	GuiControl,, Button20, % ( (bit22state) ? "2" : "" )
Return

bit23toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit23state := !bit23state
	GuiControl,, Button21, % ( (bit23state) ? "3" : "" )
Return

bit24toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit24state := !bit24state
	GuiControl,, Button22, % ( (bit24state) ? "4" : "" )
Return

bit25toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit25state := !bit25state
	GuiControl,, Button23, % ( (bit25state) ? "5" : "" )
Return

bit26toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit26state := !bit26state
	GuiControl,, Button24, % ( (bit26state) ? "6" : "" )
Return

bit27toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit27state := !bit27state
	GuiControl,, Button25, % ( (bit27state) ? "7" : "" )
Return

bit28toggle:
	ControlSend, Button10, {Space}, %windowname%
	bit28state := !bit28state
	GuiControl,, Button26, % ( (bit28state) ? "8" : "" )
Return

RadioCheck:
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
	width := width3
	height := height3
}
else if (RadioGroup = 4) {
	width := ScreenWidth
	height := ScreenHeight
}
else if (RadioGroup = 5) {
	width := ScreenWidth / 2 - wmargin
	height := ScreenHeight
}
else if (RadioGroup = 6) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight
}
else if (RadioGroup = 7) {
	width := ScreenWidth / 2 - wmargin
	height := ScreenHeight / 2
}
else if (RadioGroup = 8) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight / 2
}
else if (RadioGroup = 9) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight / 3
}
Return


GuiClose:
	WinGetPos, xpos, ypos
	ControlGetText, edit1, Edit1
	ControlGetText, edit2, Edit2
	ControlGetText, edit3, Edit3
	ControlGetText, edit4, Edit4
	ControlGetText, edit5, Edit5
	ControlGet, enable1, Checked, , Button1
	ControlGet, enable2, Checked, , Button2
	ControlGet, enable3, Checked, , Button3
	ControlGet, enable4, Checked, , Button4
	ControlGet, enable5, Checked, , Button5
	ControlGet, size1, Checked, , Button35
	ControlGet, size2, Checked, , Button36
	ControlGet, size3, Checked, , Button37
	ControlGet, size4, Checked, , Button38
	ControlGet, size5, Checked, , Button39
	ControlGet, size6, Checked, , Button40
	ControlGet, size7, Checked, , Button41
	ControlGet, size8, Checked, , Button42
	ControlGet, size9, Checked, , Button43
	winsize := size1 + size2 * 2 + size3 * 3 + size4 * 4 + size5 * 5 + size6 * 6 + size7 * 7 + size8 * 8
	ControlGetText, xsize1, Edit8
	ControlGetText, xsize2, Edit9
	ControlGetText, xsize3, Edit10
	ControlGetText, ysize1, Edit11
	ControlGetText, ysize2, Edit12
	ControlGetText, ysize3, Edit13
	ControlGetText, edit6, Edit6
	ControlGet, bitfield1type1, Checked, , Button7
	ControlGet, bitfield1type2, Checked, , Button8
	ControlGet, bitfield1type3, Checked, , Button9
	ControlGet, bitfield1type4, Checked, , Button10
	bitfield1type := bitfield1type1 + bitfield1type2 * 2 + bitfield1type3 * 3 + bitfield1type4 * 4
	ControlGet, AlwaysOnTop, Checked, , Button27
	ControlGet, AddCrLf, Checked, , Button29
	
	IniWrite, %xpos%, puttyCluster.ini, Autosave, xpos
	IniWrite, %ypos%, puttyCluster.ini, Autosave, ypos
	IniWrite, %edit1%, puttyCluster.ini, TitleMatch, Title1
	IniWrite, %edit2%, puttyCluster.ini, TitleMatch, Title2
	IniWrite, %edit3%, puttyCluster.ini, TitleMatch, Title3
	IniWrite, %edit4%, puttyCluster.ini, TitleMatch, Title4
	IniWrite, %edit5%, puttyCluster.ini, TitleMatch, Title5
	IniWrite, %enable1%, puttyCluster.ini, TitleMatchEnabled, TitleMatch1
	IniWrite, %enable2%, puttyCluster.ini, TitleMatchEnabled, TitleMatch2
	IniWrite, %enable3%, puttyCluster.ini, TitleMatchEnabled, TitleMatch3
	IniWrite, %enable4%, puttyCluster.ini, TitleMatchEnabled, TitleMatch4
	IniWrite, %enable5%, puttyCluster.ini, TitleMatchEnabled, TitleMatch5
	IniWrite, %winsize%, puttyCluster.ini, WindowSize, Selected
	IniWrite, %xsize1%, puttyCluster.ini, XYSize, x1
	IniWrite, %ysize1%, puttyCluster.ini, XYSize, y1
	IniWrite, %xsize2%, puttyCluster.ini, XYSize, x2
	IniWrite, %ysize2%, puttyCluster.ini, XYSize, y2
	IniWrite, %xsize3%, puttyCluster.ini, XYSize, x3
	IniWrite, %ysize3%, puttyCluster.ini, XYSize, y3
	IniWrite, %bit11state%, puttyCluster.ini, MatchBits1, MatchBit11
	IniWrite, %bit12state%, puttyCluster.ini, MatchBits1, MatchBit12
	IniWrite, %bit13state%, puttyCluster.ini, MatchBits1, MatchBit13
	IniWrite, %bit14state%, puttyCluster.ini, MatchBits1, MatchBit14
	IniWrite, %bit15state%, puttyCluster.ini, MatchBits1, MatchBit15
	IniWrite, %bit16state%, puttyCluster.ini, MatchBits1, MatchBit16
	IniWrite, %bit17state%, puttyCluster.ini, MatchBits1, MatchBit17
	IniWrite, %bit18state%, puttyCluster.ini, MatchBits1, MatchBit18
	IniWrite, %bit21state%, puttyCluster.ini, MatchBits2, MatchBit21
	IniWrite, %bit22state%, puttyCluster.ini, MatchBits2, MatchBit22
	IniWrite, %bit23state%, puttyCluster.ini, MatchBits2, MatchBit23
	IniWrite, %bit24state%, puttyCluster.ini, MatchBits2, MatchBit24
	IniWrite, %bit25state%, puttyCluster.ini, MatchBits2, MatchBit25
	IniWrite, %bit26state%, puttyCluster.ini, MatchBits2, MatchBit26
	IniWrite, %bit27state%, puttyCluster.ini, MatchBits2, MatchBit27
	IniWrite, %bit28state%, puttyCluster.ini, MatchBits2, MatchBit28
	IniWrite, %edit6%, puttyCluster.ini, MatchBits1, MatchByte1
	IniWrite, %bitfield1type%, puttyCluster.ini, MatchBits1, MatchByte1Type
	IniWrite, %AlwaysOnTop%, puttyCluster.ini, Options, AlwaysOnTop
	IniWrite, %AddCrLf%, puttyCluster.ini, Options, AddCrLf
	
ExitApp

Tile:
	Gosub, Find 
	x:=0
	y:=0
				
	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			;WinActivate, ahk_id %this_id%,				
			WinMove, ahk_id %this_id%,, x,y,width,height
			x:=x+width
			if( (x+width) >= A_ScreenWidth){
				x:=0
				y:=y+height
			}
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				;WinActivate, ahk_id %this_id%,				
				WinMove, ahk_id %this_id%,, x,y,width,height
				x:=x+width
				if( (x+width) >= A_ScreenWidth){
					x:=0
					y:=y+height
				}
			}
			titlematchbit := titlematchbit * 2
		}
	}

return
	
ToFront:
	Gosub, Find 
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			WinActivate, ahk_id %this_id%,				
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinActivate, ahk_id %this_id%,				
			}
			titlematchbit := titlematchbit * 2
		}
	}


	return
	
ToBack:
	Gosub, Find 
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			;WinMinimize, ahk_id %this_id%,			
			WinSet, Bottom,, ahk_id %this_id%,
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				;WinMinimize, ahk_id %this_id%,			
				WinSet, Bottom,, ahk_id %this_id%,
			}
			titlematchbit := titlematchbit * 2
		}
	}


return
	
CloseWin:
	Gosub, Find 
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			WinClose, ahk_id %this_id%,
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinClose, ahk_id %this_id%,
			}
			titlematchbit := titlematchbit * 2
		}
	}


return
	
Cascade:
	Gosub, Find 
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			WinMove, ahk_id %this_id%,, x,y,width,height				
			x:=x+xstep
			y:=y+ystep
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinMove, ahk_id %this_id%,, x,y,width,height				
				x:=x+xstep
				y:=y+ystep
			}
			titlematchbit := titlematchbit * 2
		}
	}


	return
	
GoPaste:
    Gosub, Find 
	ControlSetText, Edit7, no input while pasting....
	paste=1
	clipboardcopy=%clipboard%
	if (CrLfVal) {
		clipboardcopy=%clipboard%`r
	}

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			WinActivate, ahk_id %this_id%			
			SendRaw, %clipboardcopy%		
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinActivate, ahk_id %this_id%			
				SendRaw, %clipboardcopy%		
			}
			titlematchbit := titlematchbit * 2
		}
	}

	paste=0
	ControlSetText, Edit7, 

return

Locate:  
     Gosub, Find 

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			WinActivate, ahk_id %this_id%,				
			; PostMessage, 0x112, 0xF020,,, ahk_id %this_id%,
			; PostMessage, 0x112, 0xF120,,, ahk_id %this_id%,
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinActivate, ahk_id %this_id%,				
				; PostMessage, 0x112, 0xF020,,, ahk_id %this_id%,
				; PostMessage, 0x112, 0xF120,,, ahk_id %this_id%,
			}
			titlematchbit := titlematchbit * 2
		}
	}


return 

Find:
  gui, Submit, nohide
  titletmp := ""
  if( check1 && title1 != "" )
	titletmp = (%title1%)
  if( check2 && title2 != "" ) {
	titletmp = %titletmp%|(%title2%)
  }
  if( check3 && title3 != "" ) {
	titletmp = %titletmp%|(%title3%)
  }
  if( check4 && title4 != "" ) {
	titletmp = %titletmp%|(%title4%)
  }
  if( check5 && title5 != "" ) {
	titletmp = %titletmp%|(%title5%)
  }
  title := LTrim(titletmp, "|")
  if( title != "")
  {
	 id_array_count := 0
	 
	WinGet, puttyids, list, ahk_exe putty.exe
	Loop, %puttyids%
	{
		this_id := puttyids%A_Index%
		WinGetTitle, thistitle, ahk_id  %this_id%
		if (RegExMatch(thistitle, title) > 0) {
			id_array_count := id_array_count + 1
			id_array[id_array_count] := this_id
		}
	}
	WinGet, kittyids, list, ahk_exe kitty.exe
	Loop, %kittyids%
	{
		this_id := kittyids%A_Index%
		WinGetTitle, thistitle, ahk_id  %this_id%
		if (RegExMatch(thistitle, title) > 0) {
			id_array_count := id_array_count + 1
			id_array[id_array_count] := this_id
		}
	}
	WinGet, superputtyids, list, ahk_exe SuperPutty.exe
	Loop, %superputtyids%
	{
		this_id := superputtyids%A_Index%
		WinGet, superputtycontrols, ControlList, ahk_id %this_id%
		Loop, Parse, superputtycontrols, `n
		{
			if ( RegExMatch(A_LoopField, "PuTTY\d+") > 0) {
			ControlGet, ControlID, Hwnd,, %A_LoopField%, ahk_id %this_id%
				WinGetTitle, thistitle, ahk_id  %ControlID%
				if (RegExMatch(thistitle, title) > 0) {
					id_array_count := id_array_count + 1
					id_array[id_array_count] := ControlID
				}
			}
		}
	}
	WinGet, xshellids, list, ahk_exe Xshell.exe
	Loop, %xshellids%
	{
		this_id := xshellids%A_Index%
		WinGet, xshellcontrols, ControlList, ahk_id %this_id%
		Loop, Parse, xshellcontrols, `n
		{
			if ( RegExMatch(A_LoopField, "AfxFrameOrView\d+") > 0) {
			ControlGet, ControlID, Hwnd,, %A_LoopField%, ahk_id %this_id%
				WinGetTitle, thistitle, ahk_id  %ControlID%
				if (RegExMatch(thistitle, title) > 0) {
					id_array_count := id_array_count + 1
					id_array[id_array_count] := ControlID
				}
			}
		}
	}

	id := id_array_count
	 if (id > 1) {
		id_array := InsertionSort(id_array)
	 }	
	
     GuiControl, , Static2,  % "Found " id " window(s)"
  }
  else
  {
   id=0
   GuiControl, , Static2,   Found 0 window(s)
  }


Alpha:
  GuiControlGet, alpha, ,msctls_trackbar321

	if ( FilterGroup == 1 ){
		Loop, %id%
	    {
			this_id := id_array[A_Index]
			WinSet, Transparent, %alpha%, ahk_id %this_id%
		}
	}
	else {
		if ( FilterGroup == 2 ) {
			windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
		} else if ( FilterGroup == 4 ) {
			windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
		} else {
			VarSetCapacity(windowfilter, 66, 0)
			, val := DllCall("msvcrt.dll\_wcstoui64", "Str", FindFilterTxt, "UInt", 0, "UInt", 16, "CDECL Int64")
			, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
		}
		titlematchbit := 1
		Loop, %id%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinSet, Transparent, %alpha%, ahk_id %this_id%
			}
			titlematchbit := titlematchbit * 2
		}
	}


return

; https://autohotkey.com/boards/viewtopic.php?t=12054
InsertionSort(ar)
{
   For i, v in ar
      list .=  v . "`n"
   Sort, list, N
   Return StrSplit(RTrim(list, "`n"), "`n")
}

; Win+Alt+C
#!c::
	WinActivate, %windowname%
	ControlFocus, Edit7,  %windowname%
Return