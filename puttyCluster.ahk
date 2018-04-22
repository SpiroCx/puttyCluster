#SingleInstance force
#NoTrayIcon
SetWorkingDir %A_ScriptDir%
;DetectHiddenWindows, On

Menu, Tray, Icon, puttyCluster.ico

; ***** icon source: https://commons.wikimedia.org/wiki/File:PuTTY_icon_128px.png
; ***** icon copyright message:

;Copyright � Simon Tatham
;
;Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
;
;The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
;


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
xstep := 50
ystep := 40
global id_array := Object()
global id_array_count
global wmargin := 1
global width
global height
global fwidth
global fheight
global sidepanelwidth := 200
global AlwaysOnTop
global SidePanelOpen := 0
global FoundWindowsFiltered2 := 11
global FoundWindowsFiltered3 := 22
global FoundWindowsFiltered4 := 33
global TimerPeriod := 1000
global sendstrdata

; ***** Title Row
Gui, Add, Text,, Window Title RegEx:                       En     Inv
;Gui, Add, Text, x250 y5, Enable

; ***** Title matching text boxes
IniRead, edit1, puttyCluster.ini, TitleMatch, Title1, .*
IniRead, edit2, puttyCluster.ini, TitleMatch, Title2, %A_Space%
IniRead, edit3, puttyCluster.ini, TitleMatch, Title3, %A_Space%
IniRead, edit4, puttyCluster.ini, TitleMatch, Title4, %A_Space%
IniRead, edit5, puttyCluster.ini, TitleMatch, Title5, %A_Space%
xpos := 10
ypos := 25
ewidth := 160
Gui, Add, Edit, x%xpos% y%ypos% Hwndedit1ID vtitle1 w%ewidth%, %edit1%
ypos += 27
Gui, Add, Edit, x%xpos% y%ypos% Hwndedit2ID vtitle2 w%ewidth%, %edit2%
ypos += 27
Gui, Add, Edit, x%xpos% y%ypos% Hwndedit3ID vtitle3 w%ewidth%, %edit3%
ypos += 27
Gui, Add, Edit, x%xpos% y%ypos% Hwndedit4ID vtitle4 w%ewidth%, %edit4%
ypos += 27
Gui, Add, Edit, x%xpos% y%ypos% Hwndedit5ID vtitle5 w%ewidth%, %edit5%

; ***** Enable checkboxes
IniRead, check1, puttyCluster.ini, TitleMatchEnabled, TitleMatch1, 1
IniRead, check2, puttyCluster.ini, TitleMatchEnabled, TitleMatch2, 0
IniRead, check3, puttyCluster.ini, TitleMatchEnabled, TitleMatch3, 0
IniRead, check4, puttyCluster.ini, TitleMatchEnabled, TitleMatch4, 0
IniRead, check5, puttyCluster.ini, TitleMatchEnabled, TitleMatch5, 0
IniRead, SingleMatch, puttyCluster.ini, Options, SingleMatch, 0
xpos := 180
ypos := 30
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheck1ID gcheck1 vcheck1" . ( check1 ? " Checked" : "" )
check1_TT := "Enable title match regex 1"
ypos += 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheck2ID gcheck2 vcheck2" . ( check2 ? " Checked" : "" )
check2_TT := "Enable title match regex 2"
ypos += 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheck3ID gcheck3 vcheck3" . ( check3 ? " Checked" : "" )
check3_TT := "Enable title match regex 3"
ypos += 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheck4ID gcheck4 vcheck4" . ( check4 ? " Checked" : "" )
check4_TT := "Enable title match regex 4"
ypos += 27                               
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheck5ID gcheck5 vcheck5" . ( check5 ? " Checked" : "" )
check5_TT := "Enable title match regex 5"

; ***** Invert checkboxes
IniRead, checkinv1, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv1, 0
IniRead, checkinv2, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv2, 0
IniRead, checkinv3, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv3, 0
IniRead, checkinv4, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv4, 0
IniRead, checkinv5, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv5, 0
xpos += 30
ypos := 30
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheckinv1ID gcheckinv1 vcheckinv1" . ( checkinv1 ? " Checked" : "" )
checkinv1_TT := "Invert regex 1 (NOT regex 1)"
ypos += 27
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheckinv2ID gcheckinv2 vcheckinv2" . ( checkinv2 ? " Checked" : "" )
checkinv2_TT := "Invert regex 2 (NOT regex 2)"
ypos += 27
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheckinv3ID gcheckinv3 vcheckinv3" . ( checkinv3 ? " Checked" : "" )
checkinv3_TT := "Invert regex 3 (NOT regex 3)"
ypos += 27
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheckinv4ID gcheckinv4 vcheckinv4" . ( checkinv4 ? " Checked" : "" )
checkinv4_TT := "Invert regex 4 (NOT regex 4)"
ypos += 27
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " Hwndcheckinv5ID gcheckinv5 vcheckinv5" . ( checkinv5 ? " Checked" : "" )
checkinv5_TT := "Invert regex 5 (NOT regex 5)"

; ***** Found n windows and Locate Windows button
xpos := 10
ypos := 165
Gui, Add, Text, x%xpos% y%ypos% HwndFoundCountID, Found 0 window(s)
xpos += 170
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " HwndSingleMatchID vSingleMatch" . ( SingleMatch ? " Checked" : "" ), Single
SingleMatch_TT := "Selecting any regex enable box disables the other regexs"
xpos := 120
ypos -= 5
Gui, Add, button, x%xpos% y%ypos% gLocate -default, Locate


; ***** Found filter radio buttons
IniRead, matchbyte1type, puttyCluster.ini, MatchBits1, MatchByte1Type, 1
IniRead, matchbyte1, puttyCluster.ini, MatchBits1, MatchByte1, FFFF
xpos := 10
ypos := 200
Gui, Add, Text,  x%xpos% y%ypos% vFoundFilterTitle, Found windows filter (bitfield HEX eg FFFF):
xpos += 20
ypos += 20
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " w23" . " vFilterGroup" . ( (matchbyte1type == 1) ? " Checked" : "" )
FilterGroup_TT := "This section lets you filter windows based on the order in which they were found. Regex title matches are applied first, then these are applied"
xpos += 0
ypos += 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " HwndFilterGroup2ID w23" . ( (matchbyte1type == 2) ? " Checked" : "" )
xpos += 90
ypos -= 30
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " HwndFilterGroup3ID w23" . ( (matchbyte1type == 3) ? " Checked" : "" )
xpos -= 90
ypos += 60
Gui, Add, Radio, % "x" . xpos . " y" . ypos . " HwndFilterGroup4ID w23" . ( (matchbyte1type == 4) ? " Checked" : "" )
xpos += 23
ypos -= 60
Gui, Add, Text,  x%xpos% y%ypos%, All
xpos += 90
ypos -= 3
Gui, Add, Edit,  x%xpos% y%ypos% vFindFilterTxt HwndFindFilterID gFindFilterClick w33, %matchbyte1%
xpos += 50
ypos += 5
Gui, Add, Text,  x%xpos% y%ypos% w30 HwndFilterGroup3InfoID vFilterGroup3InfoVal, % "(0/0)"

; ***** Found filter bit selection buttons 1
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
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit11ID gbit11toggle -default, % ( bit11state ? "1" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit12ID gbit12toggle -default, % ( bit12state ? "2" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit13ID gbit13toggle -default, % ( bit13state ? "3" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit14ID gbit14toggle -default, % ( bit14state ? "4" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit15ID gbit15toggle -default, % ( bit15state ? "5" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit16ID gbit16toggle -default, % ( bit16state ? "6" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit17ID gbit17toggle -default, % ( bit17state ? "7" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit18ID gbit18toggle -default, % ( bit18state ? "8" : "" )
xpos += 30
ypos += 5
Gui, Add, Text,  x%xpos% y%ypos% w30 HwndFilterGroup2InfoID vFilterGroup2InfoVal, % "(0/0)"

; ***** Found filter bit selection buttons 2
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
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit21ID gbit21toggle -default, % ( bit21state ? "1" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit22ID gbit22toggle -default, % ( bit22state ? "2" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit23ID gbit23toggle -default, % ( bit23state ? "3" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit24ID gbit24toggle -default, % ( bit24state ? "4" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit25ID gbit25toggle -default, % ( bit25state ? "5" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit26ID gbit26toggle -default, % ( bit26state ? "6" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit27ID gbit27toggle -default, % ( bit27state ? "7" : "" )
xpos += 16                   
Gui, Add, Button, x%xpos% y%ypos% w14 HwndbtnBit28ID gbit28toggle -default, % ( bit28state ? "8" : "" )
xpos += 30
ypos += 5
Gui, Add, Text,  x%xpos% y%ypos% w30 HwndFilterGroup4InfoID vFilterGroup4InfoVal, % "(0/0)"

; ***** Window transparency slider
; yposslider := 190
yposslider := 310
xpos := 10
ypos := yposslider
swidth := 230
Gui, Add, Text, x%xpos% y%ypos%, Window transparency:
ypos += 18
GUI, Add, Slider, x%xpos% y%ypos% Range100-255 w%swidth% gFind, 255

; ***** Cluster Input, Paste, CrLf checkbox, Always on top checkbox
IniRead, OnTopVal, puttyCluster.ini, Options, AlwaysOnTop, 0
IniRead, CrLfVal, puttyCluster.ini, Options, AddCrLf, 0
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
Gui, Add, button, x%xpos% y%ypos% gGoPaste -default, Paste &Clipboard
Paste_Clipboard_TT := "_clipboard_"
xpos += 90
ypos += 7
Gui, Add, Checkbox, % "x" . xpos . " y" . ypos . " HwndCrLfID vCrLfVal gCrLfCheck" .  ( CrLfVal ? " Checked" : "" ),  +Cr&Lf

; ***** Window command buttons Tile, Cascade, ToFront etc
xpos := 10
ypos := yposcluster + 45
Gui, Add, button, x%xpos% y%ypos% gTile -default, &Tile
xpos += 30
Gui, Add, button, x%xpos% y%ypos% gCascade -default, Cascade
xpos += 55
Gui, Add, button, x%xpos% y%ypos% gToBack -default, To&Back
xpos += 52
Gui, Add, button, x%xpos% y%ypos% gToFront -default, To&Front
xpos += 52
Gui, Add, button, x%xpos% y%ypos% gCloseWin -default, Close

; ***** Window size radio buttons
IniRead, winsize, puttyCluster.ini, WindowSize, Selected, 7
xbase := 5
ybase := yposcluster + 85

xpos := xbase
ypos1 := ybase + 5
ypos2 := ybase + 32
ypos3 := ybase + 59
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " gRadioCheck" . " vRadioGroup" .  ( (winsize == 1) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " gRadioCheck" . ( (winsize == 2) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gRadioCheck" . ( (winsize == 3) ? " Checked" : "" )
xpos += 115
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " gRadioCheck" . ( (winsize == 4) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " gRadioCheck" . ( (winsize == 5) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gRadioCheck" . ( (winsize == 6) ? " Checked" : "" )
xpos += 60
Gui, Add, Radio, % "x" . xpos . " y" . ypos1 . " w23" . " gRadioCheck" . ( (winsize == 7) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos2 . " w23" . " gRadioCheck" . ( (winsize == 8) ? " Checked" : "" )
Gui, Add, Radio, % "x" . xpos . " y" . ypos3 . " w23" . " gRadioCheck" . ( (winsize == 9) ? " Checked" : "" )

; ***** Radio button text boxes
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
xpos += 84
Gui, Add, Text,  x%xpos% y%ypos1%, 1x1
Gui, Add, Text,  x%xpos% y%ypos2%, 1x2
Gui, Add, Text,  x%xpos% y%ypos3%, 1x3
xpos += 60
Gui, Add, Text,  x%xpos% y%ypos1%, 2x2
Gui, Add, Text,  x%xpos% y%ypos2%, 2x3
Gui, Add, Text,  x%xpos% y%ypos3%, 3x3

; ***** Radio button edit boxes
xpos := xbase + 23
ypos1 := ybase
ypos2 := ybase + 27
ypos3 := ybase + 54
Gui, Add, Edit,  x%xpos% y%ypos1% Hwndwidth1ID vwidth1 w30 Number, %xsize1%
Gui, Add, Edit,  x%xpos% y%ypos2% Hwndwidth2ID vwidth2 w30 Number, %xsize2%
Gui, Add, Edit,  x%xpos% y%ypos3% Hwndwidth3ID vwidth3 w30 Number, %xsize3%
xpos += 40
Gui, Add, Edit,  x%xpos% y%ypos1% Hwndheight1ID vheight1 w30 Number, %ysize1%
Gui, Add, Edit,  x%xpos% y%ypos2% Hwndheight2ID vheight2 w30 Number, %ysize2%
Gui, Add, Edit,  x%xpos% y%ypos3% Hwndheight3ID vheight3 w30 Number, %ysize3%

fheight := yposcluster + 165
fwidth := 250
xpos_default := (ScreenWidth / 2) - (fwidth / 2)
ypos_default := (ScreenHeight / 2) - (fheight / 2)
Iniread, xpos, puttyCluster.ini, Autosave, xpos, %xpos_default%
Iniread, ypos, puttyCluster.ini, Autosave, ypos, %ypos_default%

; ***** Sidepanel toggle button
xsidepanelbutton := fwidth - 20
ysidepanelbutton := 0
Gui, Add, button, x%xsidepanelbutton% y%ysidepanelbutton% gSidePanelToggle HwndbtnToggleSidebarID -default, >>
GTGT_TT := "Show launcher sidedar"
LTLT_TT := "Hide launcher sidedar"

; ***** Sidepanel about button
xsidepanel := xsidepanelbutton + 172
ysidepanel := 6
Gui, Add, text, x%xsidepanel% y%ysidepanel% gAboutBox, About

; ***** Sidepanel application launchers
xsidepanel := xsidepanelbutton + 30
ysidepanel := 20
Gui, Add, Text, x%xsidepanel% y%ysidepanel%, Application launchers:
ysidepanel += 20
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnLauncher1 gbtnLauncher1 HwndbtnLauncher1ID -default, Launcher1
IniRead, Launcher1label, puttyCluster.ini, Launcher1, Label, NoINI
IniRead, btnLauncher1_TT, puttyCluster.ini, Launcher1, Tooltip,Configure launcher by editing puttyCluster.ini file
IniRead, launcher1command, puttyCluster.ini, Launcher1, Command, notepad.exe
IniRead, launcher1dir, puttyCluster.ini, Launcher1, Dir, C:\
ControlSetText, , %Launcher1label%, ahk_id %btnLauncher1ID%
xsidepanel += 65
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnLauncher2 gbtnLauncher2 HwndbtnLauncher2ID -default, Launcher2
IniRead, Launcher2label, puttyCluster.ini, Launcher2, Label, NoINI
IniRead, btnLauncher2_TT, puttyCluster.ini, Launcher2, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, Launcher2command, puttyCluster.ini, Launcher2, Command, notepad.exe
IniRead, Launcher2dir, puttyCluster.ini, Launcher2, Dir, C:\
ControlSetText, , %Launcher2label%, ahk_id %btnLauncher2ID%
xsidepanel += 65
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnLauncher3 gbtnLauncher3 HwndbtnLauncher3ID -default, Launcher3
IniRead, Launcher3label, puttyCluster.ini, Launcher3, Label, NoINI
IniRead, btnLauncher3_TT, puttyCluster.ini, Launcher3, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, Launcher3command, puttyCluster.ini, Launcher3, Command, notepad.exe
IniRead, Launcher3dir, puttyCluster.ini, Launcher3, Dir, C:\
ControlSetText, , %Launcher3label%, ahk_id %btnLauncher3ID%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnLauncher4 gbtnLauncher4 HwndbtnLauncher4ID -default, Launcher4
IniRead, Launcher4label, puttyCluster.ini, Launcher4, Label, NoINI
IniRead, btnLauncher4_TT, puttyCluster.ini, Launcher4, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, Launcher4command, puttyCluster.ini, Launcher4, Command, notepad.exe
IniRead, Launcher4dir, puttyCluster.ini, Launcher4, Dir, C:\
ControlSetText, , %Launcher4label%, ahk_id %btnLauncher4ID%
xsidepanel += 65
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnLauncher5 gbtnLauncher5 HwndbtnLauncher5ID -default, Launcher5
IniRead, Launcher5label, puttyCluster.ini, Launcher5, Label, NoINI
IniRead, btnLauncher5_TT, puttyCluster.ini, Launcher5, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, Launcher5command, puttyCluster.ini, Launcher5, Command, notepad.exe
IniRead, Launcher5dir, puttyCluster.ini, Launcher5, Dir, C:\
ControlSetText, , %Launcher5label%, ahk_id %btnLauncher5ID%
xsidepanel += 65
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnLauncher6 gbtnLauncher6 HwndbtnLauncher6ID -default, Launcher6
IniRead, Launcher6label, puttyCluster.ini, Launcher6, Label, NoINI
IniRead, btnLauncher6_TT, puttyCluster.ini, Launcher6, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, Launcher6command, puttyCluster.ini, Launcher6, Command, notepad.exe
IniRead, Launcher6dir, puttyCluster.ini, Launcher6, Dir, C:\
ControlSetText, , %Launcher6label%, ahk_id %btnLauncher6ID%

; ***** Sidepanel putty session launchers
xsidepanel := xsidepanelbutton + 30
ysidepanel += 40
Gui, Add, Text, x%xsidepanel% y%ysidepanel%, Putty session launchers:
ysidepanel += 20
Gui, Add, button, x%xsidepanel% y%ysidepanel% w65 vbtnPutty1 gbtnPutty1 HwndbtnPutty1ID -default, Putty1
IniRead, btnputty1label, puttyCluster.ini, PuttySession1, Label, NoINI
IniRead, btnPutty1_TT, puttyCluster.ini, PuttySession1, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, btnputty1command, puttyCluster.ini, PuttySession1, Command, ubuntu-r210-8_av
IniRead, btnputty1dir, puttyCluster.ini, PuttySession1, Dir, C:\
ControlSetText, , %btnputty1label%, ahk_id %btnPutty1ID%
xsidepanel += 67
IniRead, edtPutty, puttyCluster.ini, PuttySession1, Putty11Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty11 HwndedtPutty11ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty11UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession1, Putty12Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty12 HwndedtPutty12ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty12UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession1, Putty13Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty13 HwndedtPutty13ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty13UpDown Range0-10, %edtPutty%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% w65 vbtnPutty2 gbtnPutty2 HwndbtnPutty2ID -default, Putty2
IniRead, btnputty2label, puttyCluster.ini, PuttySession2, Label, NoINI
IniRead, btnPutty2_TT, puttyCluster.ini, PuttySession2, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, btnputty2command, puttyCluster.ini, PuttySession2, Command, ubuntu-r210-8_av
IniRead, btnputty2dir, puttyCluster.ini, PuttySession2, Dir, C:\
ControlSetText, , %btnputty2label%, ahk_id %btnPutty2ID%
xsidepanel += 67
IniRead, edtPutty, puttyCluster.ini, PuttySession2, Putty21Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty21 HwndedtPutty21ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty21UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession2, Putty22Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty22 HwndedtPutty22ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty22UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession2, Putty23Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty23 HwndedtPutty23ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty23UpDown Range0-10, %edtPutty%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% w65 vbtnPutty3 gbtnPutty3 HwndbtnPutty3ID -default, Putty3
IniRead, btnputty3label, puttyCluster.ini, PuttySession3, Label, NoINI
IniRead, btnPutty3_TT, puttyCluster.ini, PuttySession3, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, btnputty3command, puttyCluster.ini, PuttySession3, Command, ubuntu-r210-8_av
IniRead, btnputty3dir, puttyCluster.ini, PuttySession3, Dir, C:\
ControlSetText, , %btnputty3label%, ahk_id %btnPutty3ID%
xsidepanel += 67
IniRead, edtPutty, puttyCluster.ini, PuttySession3, Putty31Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty31 HwndedtPutty31ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty31UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession3, Putty32Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty32 HwndedtPutty32ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty32UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession3, Putty33Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty33 HwndedtPutty33ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty33UpDown Range0-10, %edtPutty%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% w65 vbtnPutty4 gbtnPutty4 HwndbtnPutty4ID -default, Putty4
IniRead, btnputty4label, puttyCluster.ini, PuttySession4, Label, NoINI
IniRead, btnPutty4_TT, puttyCluster.ini, PuttySession4, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, btnputty4command, puttyCluster.ini, PuttySession4, Command, ubuntu-r210-8_av
IniRead, btnputty4dir, puttyCluster.ini, PuttySession4, Dir, C:\
ControlSetText, , %btnputty4label%, ahk_id %btnPutty4ID%
xsidepanel += 67
IniRead, edtPutty, puttyCluster.ini, PuttySession4, Putty41Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty41 HwndedtPutty41ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty41UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession4, Putty42Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty42 HwndedtPutty42ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty42UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession4, Putty43Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty43 HwndedtPutty43ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty43UpDown Range0-10, %edtPutty%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% w65 vbtnPutty5 gbtnPutty5 HwndbtnPutty5ID -default, Putty5
IniRead, btnputty5label, puttyCluster.ini, PuttySession5, Label, NoINI
IniRead, btnPutty5_TT, puttyCluster.ini, PuttySession5, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, btnputty5command, puttyCluster.ini, PuttySession5, Command, ubuntu-r210-8_av
IniRead, btnputty5dir, puttyCluster.ini, PuttySession5, Dir, C:\
ControlSetText, , %btnputty5label%, ahk_id %btnPutty5ID%
xsidepanel += 67
IniRead, edtPutty, puttyCluster.ini, PuttySession5, Putty51Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty51 HwndedtPutty51ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty51UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession5, Putty52Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty52 HwndedtPutty52ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty52UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession5, Putty53Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty53 HwndedtPutty53ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty53UpDown Range0-10, %edtPutty%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% w65 vbtnPutty6 gbtnPutty6 HwndbtnPutty6ID -default, Putty6
IniRead, btnputty6label, puttyCluster.ini, PuttySession6, Label, NoINI
IniRead, btnPutty6_TT, puttyCluster.ini, PuttySession6, Tooltip, Configure launcher by editing puttyCluster.ini file
IniRead, btnputty6command, puttyCluster.ini, PuttySession6, Command, ubuntu-r210-8_av
IniRead, btnputty6dir, puttyCluster.ini, PuttySession6, Dir, C:\
ControlSetText, , %btnputty6label%, ahk_id %btnPutty6ID%
xsidepanel += 67
IniRead, edtPutty, puttyCluster.ini, PuttySession6, Putty61Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty61 HwndedtPutty61ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty61UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession6, Putty62Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty62 HwndedtPutty62ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty62UpDown Range0-10, %edtPutty%
xsidepanel += 40
IniRead, edtPutty, puttyCluster.ini, PuttySession6, Putty63Count, 0
Gui, Add, Edit, x%xsidepanel% y%ysidepanel% vedtPutty63 HwndedtPutty63ID w37
Gui, Add, UpDown, x%xsidepanel% y%ysidepanel% vPutty63UpDown Range0-10, %edtPutty%
xsidepanel := xsidepanelbutton + 97
ysidepanel += 30
Gui, Add, button, x%xsidepanel% y%ysidepanel% w30 vbtnCol1 gbtnCol1 HwndbtnCol1ID -default, Col
btnCol1_TT := "Launch the 1st column of sessions"
xsidepanel += 40
Gui, Add, button, x%xsidepanel% y%ysidepanel% w30 vbtnCol2 gbtnCol2 HwndbtnCol2ID -default, Col
btnCol2_TT := "Launch the 2nd column of sessions"
xsidepanel += 40
Gui, Add, button, x%xsidepanel% y%ysidepanel% w30 vbtnCol3 gbtnCol3 HwndbtnCol3ID -default, Col
btnCol3_TT := "Launch the 3rd column of sessions"

; ***** Sidepanel Putty commands
xsidepanel := xsidepanelbutton + 30
ysidepanel += 40
Gui, Add, Text, x%xsidepanel% y%ysidepanel%, Putty commands:
ysidepanel += 25
IniRead, command01, puttyCluster.ini, PuttyCommands, Command01, Cmd1
IniRead, btnCommand1_TT, puttyCluster.ini, PuttyCommands, Command01Tooltip, %command01%
IniRead, cmdlbl01, puttyCluster.ini, PuttyCommands, Command01label, %command01%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand1 gbtnCommand1 HwndbtnCommand1ID -default, %cmdlbl01%
xsidepanel += 65
IniRead, command02, puttyCluster.ini, PuttyCommands, Command02, Cmd2
IniRead, btnCommand2_TT, puttyCluster.ini, PuttyCommands, Command02Tooltip, %command02%
IniRead, cmdlbl02, puttyCluster.ini, PuttyCommands, Command02label, %command02%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand2 gbtnCommand2 HwndbtnCommand2ID -default, %cmdlbl02%
xsidepanel += 65
IniRead, command03, puttyCluster.ini, PuttyCommands, Command03, Cmd3
IniRead, btnCommand3_TT, puttyCluster.ini, PuttyCommands, Command03Tooltip, %command03%
IniRead, cmdlbl03, puttyCluster.ini, PuttyCommands, Command03label, %command03%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand3 gbtnCommand3 HwndbtnCommand3ID -default, %cmdlbl03%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 25
IniRead, command04, puttyCluster.ini, PuttyCommands, Command04, Cmd4
IniRead, btnCommand4_TT, puttyCluster.ini, PuttyCommands, Command04Tooltip, %command04%
IniRead, cmdlbl04, puttyCluster.ini, PuttyCommands, Command04label, %command04%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand4 gbtnCommand4 HwndbtnCommand4ID -default, %cmdlbl04%
xsidepanel += 65
IniRead, command05, puttyCluster.ini, PuttyCommands, Command05, Cmd5
IniRead, btnCommand5_TT, puttyCluster.ini, PuttyCommands, Command05Tooltip, %command05%
IniRead, cmdlbl05, puttyCluster.ini, PuttyCommands, Command05label, %command05%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand5 gbtnCommand5 HwndbtnCommand5ID -default, %cmdlbl05%
xsidepanel += 65
IniRead, command06, puttyCluster.ini, PuttyCommands, Command06, Cmd6
IniRead, btnCommand6_TT, puttyCluster.ini, PuttyCommands, Command06Tooltip, %command06%
IniRead, cmdlbl06, puttyCluster.ini, PuttyCommands, Command06label, %command06%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand6 gbtnCommand6 HwndbtnCommand6ID -default, %cmdlbl06%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 25
IniRead, command07, puttyCluster.ini, PuttyCommands, Command07, Cmd7
IniRead, btnCommand7_TT, puttyCluster.ini, PuttyCommands, Command07Tooltip, %command07%
IniRead, cmdlbl07, puttyCluster.ini, PuttyCommands, Command07label, %command07%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand7 gbtnCommand7 HwndbtnCommand7ID -default, %cmdlbl07%
xsidepanel += 65
IniRead, command08, puttyCluster.ini, PuttyCommands, Command08, Cmd8
IniRead, btnCommand8_TT, puttyCluster.ini, PuttyCommands, Command08Tooltip, %command08%
IniRead, cmdlbl08, puttyCluster.ini, PuttyCommands, Command08label, %command08%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand8 gbtnCommand8 HwndbtnCommand8ID -default, %cmdlbl08%
xsidepanel += 65
IniRead, command09, puttyCluster.ini, PuttyCommands, Command09, Cmd9
IniRead, btnCommand9_TT, puttyCluster.ini, PuttyCommands, Command09Tooltip, %command09%
IniRead, cmdlbl09, puttyCluster.ini, PuttyCommands, Command09label, %command09%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand9 gbtnCommand9 HwndbtnCommand9ID -default, %cmdlbl09%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 25
IniRead, command10, puttyCluster.ini, PuttyCommands, Command10, Cmd10
IniRead, btnCommand10_TT, puttyCluster.ini, PuttyCommands, Command10Tooltip, %command10%
IniRead, cmdlbl10, puttyCluster.ini, PuttyCommands, Command10label, %command10%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand10 gbtnCommand10 HwndbtnCommand10ID -default, %cmdlbl10%
xsidepanel += 65
IniRead, command11, puttyCluster.ini, PuttyCommands, Command11, Cmd11
IniRead, btnCommand11_TT, puttyCluster.ini, PuttyCommands, Command11Tooltip, %command11%
IniRead, cmdlbl11, puttyCluster.ini, PuttyCommands, Command11label, %command11%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand11 gbtnCommand11 HwndbtnCommand11ID -default, %cmdlbl11%
xsidepanel += 65
IniRead, command12, puttyCluster.ini, PuttyCommands, Command12, Cmd12
IniRead, btnCommand12_TT, puttyCluster.ini, PuttyCommands, Command12Tooltip, %command12%
IniRead, cmdlbl12, puttyCluster.ini, PuttyCommands, Command12label, %command12%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand12 gbtnCommand12 HwndbtnCommand12ID -default, %cmdlbl12%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 25
IniRead, command13, puttyCluster.ini, PuttyCommands, Command13, Cmd13
IniRead, btnCommand13_TT, puttyCluster.ini, PuttyCommands, Command13Tooltip, %command13%
IniRead, cmdlbl13, puttyCluster.ini, PuttyCommands, Command13label, %command13%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand13 gbtnCommand13 HwndbtnCommand13ID -default, %cmdlbl13%
xsidepanel += 65
IniRead, command14, puttyCluster.ini, PuttyCommands, Command14, Cmd14
IniRead, btnCommand14_TT, puttyCluster.ini, PuttyCommands, Command14Tooltip, %command14%
IniRead, cmdlbl14, puttyCluster.ini, PuttyCommands, Command14label, %command14%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand14 gbtnCommand14 HwndbtnCommand14ID -default, %cmdlbl14%
xsidepanel += 65
IniRead, command15, puttyCluster.ini, PuttyCommands, Command15, Cmd15
IniRead, btnCommand15_TT, puttyCluster.ini, PuttyCommands, Command15Tooltip, %command15%
IniRead, cmdlbl15, puttyCluster.ini, PuttyCommands, Command15label, %command15%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand15 gbtnCommand15 HwndbtnCommand15ID -default, %cmdlbl15%
xsidepanel := xsidepanelbutton + 30
ysidepanel += 25
IniRead, command16, puttyCluster.ini, PuttyCommands, Command16, Cmd16
IniRead, btnCommand16_TT, puttyCluster.ini, PuttyCommands, Command16Tooltip, %command16%
IniRead, cmdlbl16, puttyCluster.ini, PuttyCommands, Command16label, %command16%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand16 gbtnCommand16 HwndbtnCommand16ID -default, %cmdlbl16%
xsidepanel += 65
IniRead, command17, puttyCluster.ini, PuttyCommands, Command17, Cmd17
IniRead, btnCommand17_TT, puttyCluster.ini, PuttyCommands, Command17Tooltip, %command17%
IniRead, cmdlbl17, puttyCluster.ini, PuttyCommands, Command17label, %command17%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand17 gbtnCommand17 HwndbtnCommand17ID -default, %cmdlbl17%
xsidepanel += 65
IniRead, command18, puttyCluster.ini, PuttyCommands, Command18, Cmd18
IniRead, btnCommand18_TT, puttyCluster.ini, PuttyCommands, Command18Tooltip, %command18%
IniRead, cmdlbl18, puttyCluster.ini, PuttyCommands, Command18label, %command18%
Gui, Add, button, x%xsidepanel% y%ysidepanel% w64 vbtnCommand18 gbtnCommand18 HwndbtnCommand18ID -default, %cmdlbl18%

Gui, Show, h%fheight% w%fwidth% x%xpos% y%ypos%, %windowname%
ControlFocus, , ahk_id %InputBoxID%
WinActivate, %windowname%
	
onMessage(0x100,"key")  ; key down
onMessage(0x101,"key")  ; key up
onMessage(0x104,"key")  ; alt key down
onMessage(0x105,"key")  ; alt key down
OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x53, "WM_HELP")

SetTimer, Find , %TimerPeriod%
SetTitleMatchMode, RegEx 
#WinActivateForce

GoSub, RadioCheck
GoSub, OnTopCheck

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
		StringReplace, CurrControlTT, CurrControlTT, <<, LTLT
		StringReplace, CurrControlTT, CurrControlTT, >>, GTGT
		StringReplace, CurrControlTT, CurrControlTT, &,
		StringReplace, CurrControlTT, CurrControlTT, %A_Space%, _
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
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
;			PostMessage, %msg%,%wParam%, , ,ahk_id %this_id%,
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
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
;				PostMessage, %msg%,%wParam%, , ,ahk_id %this_id%,
			}
			titlematchbit *= 2
		}
	}

	ControlSetText, , , ahk_id %InputBoxID% 
   }
}
return 

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
	homepage = https://github.com/SpiroCx/puttyCluster
	MajorVersion = 1.0
	AboutMessage1 = % "Version: " . MajorVersion
	FileGetTime, FileTime, %A_ScriptFullPath%
	FormatTime, FileTime, %FileTime%
	; Include the scriptname also to remind us which is running for when both exe and ahk are in the folder
	AboutMessage2 = % "`r" . "Last modification date:`r" . A_ScriptName . ": " . FileTime
	AboutMessage=
	(
		%AboutMessage1%
		%AboutMessage2%
	)

	Gui, 2:Font, cBlue
	Gui, 2:Add, Text, vAboutLink gGotoSite, %homepage%
	AboutLink_TT := "Launch link in defaut browser"
	Gui, 2:Font, cBlack
	Gui, 2:Add, Text, , %AboutMessage%
	Gui, 2:Add, Button, x120 y100 w40 h25 gbtnOk, Ok
	xposabout := ScreenWidth / 2 - 120
	yposabout := ScreenHeight / 2 - 70
	Gui, 2:Show, x%xposabout% y%yposabout% h140 w280, About
Return
btnOk:
	Gui, 2:Destroy
Return
GotoSite:
	Run, %homepage%
Return

check1:
	gui, submit, nohide
	if ((SingleMatch == 1) && (Check1 == 1)) {
		if (check2 == 1)
			ControlSend, , {Space}, ahk_id %Check2ID%
		if (check3 == 1)
			ControlSend, , {Space}, ahk_id %Check3ID%
		if (check4 == 1)
			ControlSend, , {Space}, ahk_id %Check4ID%
		if (check5 == 1)
			ControlSend, , {Space}, ahk_id %Check5ID%
	}
	ControlFocus, , ahk_id %InputBoxID%
Return

check2:
	gui, submit, nohide
	if ((SingleMatch == 1) && (Check2 == 1)) {
		if (check1 == 1)
			ControlSend, , {Space}, ahk_id %Check1ID%
		if (check3 == 1)
			ControlSend, , {Space}, ahk_id %Check3ID%
		if (check4 == 1)
			ControlSend, , {Space}, ahk_id %Check4ID%
		if (check5 == 1)
			ControlSend, , {Space}, ahk_id %Check5ID%
	}
	ControlFocus, , ahk_id %InputBoxID%
Return

check3:
	gui, submit, nohide
	if ((SingleMatch == 1) && (Check3 == 1)) {
		if (check1 == 1)
			ControlSend, , {Space}, ahk_id %Check1ID%
		if (check2 == 1)
			ControlSend, , {Space}, ahk_id %Check2ID%
		if (check4 == 1)
			ControlSend, , {Space}, ahk_id %Check4ID%
		if (check5 == 1)
			ControlSend, , {Space}, ahk_id %Check5ID%
	}
	ControlFocus, , ahk_id %InputBoxID%
Return

check4:
	gui, submit, nohide
	if ((SingleMatch == 1) && (Check4 == 1)) {
		if (check1 == 1)
			ControlSend, , {Space}, ahk_id %Check1ID%
		if (check2 == 1)
			ControlSend, , {Space}, ahk_id %Check2ID%
		if (check3 == 1)
			ControlSend, , {Space}, ahk_id %Check3ID%
		if (check5 == 1)
			ControlSend, , {Space}, ahk_id %Check5ID%
	}
	ControlFocus, , ahk_id %InputBoxID%
Return

check5:
	gui, submit, nohide
	if ((SingleMatch == 1) && (Check5 == 1)) {
		if (check1 == 1)
			ControlSend, , {Space}, ahk_id %Check1ID%
		if (check2 == 1)
			ControlSend, , {Space}, ahk_id %Check2ID%
		if (check3 == 1)
			ControlSend, , {Space}, ahk_id %Check3ID%
		if (check4 == 1)
			ControlSend, , {Space}, ahk_id %Check4ID%
	}
	ControlFocus, , ahk_id %InputBoxID%
Return

checkinv1:
checkinv2:
checkinv3:
checkinv4:
checkinv5:
	ControlFocus, , ahk_id %InputBoxID%
Return

btnLauncher1:
	Run, %launcher1command%, %launcher1dir%
Return
btnLauncher2:
	Run, %launcher2command%, %launcher2dir%
Return
btnLauncher3:
	Run, %launcher3command%, %launcher3dir%
Return
btnLauncher4:
	Run, %launcher4command%, %launcher4dir%
Return
btnLauncher5:
	Run, %launcher5command%, %launcher5dir%
Return
btnLauncher6:
	Run, %launcher6command%, %launcher6dir%
Return

btnPutty1:
	Run, %btnputty1command%, %btnputty1dir%
Return
btnPutty2:
	Run, %btnputty2command%, %btnputty2dir%
Return
btnPutty3:
	Run, %btnputty3command%, %btnputty3dir%
Return
btnPutty4:
	Run, %btnputty4command%, %btnputty4dir%
Return
btnPutty5:
	Run, %btnputty5command%, %btnputty5dir%
Return
btnPutty6:
	Run, %btnputty6command%, %btnputty6dir%
Return

btnCol1:
	ControlGetText, edtPutty11, , ahk_id %edtPutty11ID%
	Loop, %edtPutty11%
		GoSub, btnPutty1
	ControlGetText, edtPutty21, , ahk_id %edtPutty21ID%
	Loop, %edtPutty21%
		GoSub, btnPutty2
	ControlGetText, edtPutty31, , ahk_id %edtPutty31ID%
	Loop, %edtPutty31%
		GoSub, btnPutty3
	ControlGetText, edtPutty41, , ahk_id %edtPutty41ID%
	Loop, %edtPutty41%
		GoSub, btnPutty4
	ControlGetText, edtPutty51, , ahk_id %edtPutty51ID%
	Loop, %edtPutty51%
		GoSub, btnPutty5
	ControlGetText, edtPutty61, , ahk_id %edtPutty61ID%
	Loop, %edtPutty61%
		GoSub, btnPutty6
Return
btnCol2:
	ControlGetText, edtPutty12, , ahk_id %edtPutty12ID%
	Loop, %edtPutty12%
		GoSub, btnPutty1
	ControlGetText, edtPutty22, , ahk_id %edtPutty22ID%
	Loop, %edtPutty22%
		GoSub, btnPutty2
	ControlGetText, edtPutty32, , ahk_id %edtPutty32ID%
	Loop, %edtPutty32%
		GoSub, btnPutty3
	ControlGetText, edtPutty42, , ahk_id %edtPutty42ID%
	Loop, %edtPutty42%
		GoSub, btnPutty4
	ControlGetText, edtPutty52, , ahk_id %edtPutty52ID%
	Loop, %edtPutty52%
		GoSub, btnPutty5
	ControlGetText, edtPutty62, , ahk_id %edtPutty62ID%
	Loop, %edtPutty62%
		GoSub, btnPutty6
Return
btnCol3:
	ControlGetText, edtPutty13, , ahk_id %edtPutty13ID%
	Loop, %edtPutty13%
		GoSub, btnPutty1
	ControlGetText, edtPutty23, , ahk_id %edtPutty23ID%
	Loop, %edtPutty23%
		GoSub, btnPutty2
	ControlGetText, edtPutty33, , ahk_id %edtPutty33ID%
	Loop, %edtPutty33%
		GoSub, btnPutty3
	ControlGetText, edtPutty43, , ahk_id %edtPutty43ID%
	Loop, %edtPutty43%
		GoSub, btnPutty4
	ControlGetText, edtPutty53, , ahk_id %edtPutty53ID%
	Loop, %edtPutty53%
		GoSub, btnPutty5
	ControlGetText, edtPutty63, , ahk_id %edtPutty63ID%
	Loop, %edtPutty63%
		GoSub, btnPutty6
Return

btnCommand1:
	sendstrdata=%command01%
	if (CrLfVal) {
		sendstrdata=%command01%`r
	}
	GoSub, SendString
Return
btnCommand2:
	sendstrdata=%command02%
	if (CrLfVal) {
		sendstrdata=%command02%`r
	}
	GoSub, SendString
Return
btnCommand3:
	sendstrdata=%command03%
	if (CrLfVal) {
		sendstrdata=%command03%`r
	}
	GoSub, SendString
Return
btnCommand4:
	sendstrdata=%command04%
	if (CrLfVal) {
		sendstrdata=%command04%`r
	}
	GoSub, SendString
Return
btnCommand5:
	sendstrdata=%command05%
	if (CrLfVal) {
		sendstrdata=%command05%`r
	}
	GoSub, SendString
Return
btnCommand6:
	sendstrdata=%command06%
	if (CrLfVal) {
		sendstrdata=%command06%`r
	}
	GoSub, SendString
Return
btnCommand7:
	sendstrdata=%command07%
	if (CrLfVal) {
		sendstrdata=%command07%`r
	}
	GoSub, SendString
Return
btnCommand8:
	sendstrdata=%command08%
	if (CrLfVal) {
		sendstrdata=%command08%`r
	}
	GoSub, SendString
Return
btnCommand9:
	sendstrdata=%command09%
	if (CrLfVal) {
		sendstrdata=%command09%`r
	}
	GoSub, SendString
Return
btnCommand10:
	sendstrdata=%command10%
	if (CrLfVal) {
		sendstrdata=%command10%`r
	}
	GoSub, SendString
Return
btnCommand11:
	sendstrdata=%command11%
	if (CrLfVal) {
		sendstrdata=%command11%`r
	}
	GoSub, SendString
Return
btnCommand12:
	sendstrdata=%command12%
	if (CrLfVal) {
		sendstrdata=%command12%`r
	}
	GoSub, SendString
Return
btnCommand13:
	sendstrdata=%command13%
	if (CrLfVal) {
		sendstrdata=%command13%`r
	}
	GoSub, SendString
Return
btnCommand14:
	sendstrdata=%command14%
	if (CrLfVal) {
		sendstrdata=%command14%`r
	}
	GoSub, SendString
Return
btnCommand15:
	sendstrdata=%command15%
	if (CrLfVal) {
		sendstrdata=%command15%`r
	}
	GoSub, SendString
Return
btnCommand16:
	sendstrdata=%command16%
	if (CrLfVal) {
		sendstrdata=%command16%`r
	}
	GoSub, SendString
Return
btnCommand17:
	sendstrdata=%command17%
	if (CrLfVal) {
		sendstrdata=%command17%`r
	}
	GoSub, SendString
Return
btnCommand18:
	sendstrdata=%command18%
	if (CrLfVal) {
		sendstrdata=%command18%`r
	}
	GoSub, SendString
Return

SidePanelToggle:
	ControlGetText, ToggleSidebarTxt, , ahk_id %btnToggleSidebarID%
	WinGetPos, xpos, ypos, , ,%windowname%
	if ( ToggleSidebarTxt == ">>" ) {
		SidePanelOpen := 1
		ControlSetText, , <<, ahk_id %btnToggleSidebarID%
		widewidth := fwidth + sidepanelwidth
		widexpos := xpos - sidepanelwidth - 10 ; 10 may be a fudge.  Wouldn't line up without it
		gui +resize
		Gui, Show, h%fheight% w%widewidth%  x%widexpos% y%ypos%
		xbutton := widewidth - 10
		GuiControl, Move, %btnToggleSidebarID%, x%xbutton%
		gui -resize
	} else {
		SidePanelOpen := 0
		ControlSetText, , >>, ahk_id %btnToggleSidebarID%
		gui +resize
		narrowwidth := fwidth - 10 ; 2018-04-18 This may be a fudge.  The resize doesn't come back to the same width as the original Gui Show did
		narrowxpos := xpos + sidepanelwidth + 10
		Gui, Show, h%fheight% w%narrowwidth% x%narrowxpos% y%ypos%
		GuiControl, Move, %btnToggleSidebarID%, x%xsidepanelbutton%
		gui -resize
	}
Return

OnTopCheck:
	gui, submit, nohide
	if ( OnTopVal == 1) {
		WinSet, AlwaysOnTop, on, %windowname%
	} else {
		WinSet, AlwaysOnTop, off, %windowname%
	}
Return

CrLfCheck:
	gui, submit, nohide
	CrLfVal = !CrLfVal
Return

FindFilterClick:
	ControlSend, , {Space}, ahk_id %FilterGroup3ID%
	ControlFocus, , ahk_id %FindFilterID%
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit11toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit11state := !bit11state
	GuiControl,, %btnBit11ID%, % ( (bit11state) ? "1" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit12toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit12state := !bit12state
	GuiControl,, %btnBit12ID%, % ( (bit12state) ? "2" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit13toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit13state := !bit13state
	GuiControl,, %btnBit13ID%, % ( (bit13state) ? "3" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit14toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit14state := !bit14state
	GuiControl,, %btnBit14ID%, % ( (bit14state) ? "4" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit15toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit15state := !bit15state
	GuiControl,, %btnBit15ID%, % ( (bit15state) ? "5" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit16toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit16state := !bit16state
	GuiControl,, %btnBit16ID%, % ( (bit16state) ? "6" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit17toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit17state := !bit17state
	GuiControl,, %btnBit17ID%, % ( (bit17state) ? "7" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit18toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup2ID%
	bit18state := !bit18state
	GuiControl,, %btnBit18ID%, % ( (bit18state) ? "8" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit21toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit21state := !bit21state
	GuiControl,, %btnBit21ID%, % ( (bit21state) ? "1" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit22toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit22state := !bit22state
	GuiControl,, %btnBit22ID%, % ( (bit22state) ? "2" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit23toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit23state := !bit23state
	GuiControl,, %btnBit23ID%, % ( (bit23state) ? "3" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit24toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit24state := !bit24state
	GuiControl,, %btnBit24ID%, % ( (bit24state) ? "4" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit25toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit25state := !bit25state
	GuiControl,, %btnBit25ID%, % ( (bit25state) ? "5" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit26toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit26state := !bit26state
	GuiControl,, %btnBit26ID%, % ( (bit26state) ? "6" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit27toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit27state := !bit27state
	GuiControl,, %btnBit27ID%, % ( (bit27state) ? "7" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
Return

bit28toggle:
	ControlSend, , {Space}, ahk_id %FilterGroup4ID%
	bit28state := !bit28state
	GuiControl,, %btnBit28ID%, % ( (bit28state) ? "8" : "" )
	GoSub, UpdateFoundWindowsFilteredGui
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
	if (SidePanelOpen == 1)
		xpos += sidepanelwidth + 10
	ControlGetText, edit1, , ahk_id %edit1ID%
	ControlGetText, edit2, , ahk_id %edit2ID%
	ControlGetText, edit3, , ahk_id %edit3ID%
	ControlGetText, edit4, , ahk_id %edit4ID%
	ControlGetText, edit5, , ahk_id %edit5ID%
	ControlGet, enable1, Checked, , , ahk_id %check1ID%
	ControlGet, enable2, Checked, , , ahk_id %check2ID%
	ControlGet, enable3, Checked, , , ahk_id %check3ID%
	ControlGet, enable4, Checked, , , ahk_id %check4ID%
	ControlGet, enable5, Checked, , , ahk_id %check5ID%
	ControlGet, enableinv1, Checked, , , ahk_id %checkinv1ID%
	ControlGet, enableinv2, Checked, , , ahk_id %checkinv2ID%
	ControlGet, enableinv3, Checked, , , ahk_id %checkinv3ID%
	ControlGet, enableinv4, Checked, , , ahk_id %checkinv4ID%
	ControlGet, enableinv5, Checked, , , ahk_id %checkinv5ID%
	ControlGetText, xsize1, , ahk_id %width1ID%
	ControlGetText, xsize2, , ahk_id %width2ID%
	ControlGetText, xsize3, , ahk_id %width3ID%
	ControlGetText, ysize1, , ahk_id %height1ID%
	ControlGetText, ysize2, , ahk_id %height2ID%
	ControlGetText, ysize3, , ahk_id %height3ID%
	ControlGetText, edit6, , ahk_id %FindFilterID%
	ControlGet, AlwaysOnTop, Checked, , , ahk_id %OnTopID%
	ControlGet, AddCrLf, Checked, , , ahk_id %CrLfID%
	ControlGet, SingleMatch, Checked, , , ahk_id %SingleMatchID%
	ControlGetText, edtPutty11, , ahk_id %edtPutty11ID%
	ControlGetText, edtPutty12, , ahk_id %edtPutty12ID%
	ControlGetText, edtPutty13, , ahk_id %edtPutty13ID%
	ControlGetText, edtPutty21, , ahk_id %edtPutty21ID%
	ControlGetText, edtPutty22, , ahk_id %edtPutty22ID%
	ControlGetText, edtPutty23, , ahk_id %edtPutty23ID%
	ControlGetText, edtPutty31, , ahk_id %edtPutty31ID%
	ControlGetText, edtPutty32, , ahk_id %edtPutty32ID%
	ControlGetText, edtPutty33, , ahk_id %edtPutty33ID%
	ControlGetText, edtPutty41, , ahk_id %edtPutty41ID%
	ControlGetText, edtPutty42, , ahk_id %edtPutty42ID%
	ControlGetText, edtPutty43, , ahk_id %edtPutty43ID%
	ControlGetText, edtPutty51, , ahk_id %edtPutty51ID%
	ControlGetText, edtPutty52, , ahk_id %edtPutty52ID%
	ControlGetText, edtPutty53, , ahk_id %edtPutty53ID%
	ControlGetText, edtPutty61, , ahk_id %edtPutty61ID%
	ControlGetText, edtPutty62, , ahk_id %edtPutty62ID%
	ControlGetText, edtPutty63, , ahk_id %edtPutty63ID%
	
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
	IniWrite, %enableinv1%, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv1
	IniWrite, %enableinv2%, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv2
	IniWrite, %enableinv3%, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv3
	IniWrite, %enableinv4%, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv4
	IniWrite, %enableinv5%, puttyCluster.ini, TitleMatchEnabled, TitleMatchInv5
	IniWrite, %RadioGroup%, puttyCluster.ini, WindowSize, Selected
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
	IniWrite, %FilterGroup%, puttyCluster.ini, MatchBits1, MatchByte1Type
	IniWrite, %AlwaysOnTop%, puttyCluster.ini, Options, AlwaysOnTop
	IniWrite, %AddCrLf%, puttyCluster.ini, Options, AddCrLf
	IniWrite, %SingleMatch%, puttyCluster.ini, Options, SingleMatch
	IniWrite, %edtPutty11%, puttyCluster.ini, PuttySession1, Putty11Count
	IniWrite, %edtPutty12%, puttyCluster.ini, PuttySession1, Putty12Count
	IniWrite, %edtPutty13%, puttyCluster.ini, PuttySession1, Putty13Count
	IniWrite, %edtPutty21%, puttyCluster.ini, PuttySession2, Putty21Count
	IniWrite, %edtPutty22%, puttyCluster.ini, PuttySession2, Putty22Count
	IniWrite, %edtPutty23%, puttyCluster.ini, PuttySession2, Putty23Count
	IniWrite, %edtPutty31%, puttyCluster.ini, PuttySession3, Putty31Count
	IniWrite, %edtPutty32%, puttyCluster.ini, PuttySession3, Putty32Count
	IniWrite, %edtPutty33%, puttyCluster.ini, PuttySession3, Putty33Count
	IniWrite, %edtPutty41%, puttyCluster.ini, PuttySession4, Putty41Count
	IniWrite, %edtPutty42%, puttyCluster.ini, PuttySession4, Putty42Count
	IniWrite, %edtPutty43%, puttyCluster.ini, PuttySession4, Putty43Count
	IniWrite, %edtPutty51%, puttyCluster.ini, PuttySession5, Putty51Count
	IniWrite, %edtPutty52%, puttyCluster.ini, PuttySession5, Putty52Count
	IniWrite, %edtPutty53%, puttyCluster.ini, PuttySession5, Putty53Count
	IniWrite, %edtPutty61%, puttyCluster.ini, PuttySession6, Putty61Count
	IniWrite, %edtPutty62%, puttyCluster.ini, PuttySession6, Putty62Count
	IniWrite, %edtPutty63%, puttyCluster.ini, PuttySession6, Putty63Count
	
ExitApp

UpdateFoundWindowsFilteredGui:
	windowfilter := bit11state + bit12state * 2 + bit13state * 4 + bit14state * 8 + bit15state * 16 + bit16state * 32 + bit17state * 64 + bit18state * 128
	titlematchbit := 1
	matchcount := 0
	Loop, %id_array_count%
	{
		if ( ( titlematchbit & windowfilter ) > 0 ) {
			matchcount += 1
		}
		titlematchbit *= 2
	}
	FoundWindowsFiltered2 := matchcount

	windowfilter := bit21state + bit22state * 2 + bit23state * 4 + bit24state * 8 + bit25state * 16 + bit26state * 32 + bit27state * 64 + bit28state * 128
	titlematchbit := 1
	matchcount := 0
	Loop, %id_array_count%
	{
		if ( ( titlematchbit & windowfilter ) > 0 ) {
			matchcount += 1
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
Return

Tile:
	Gosub, Find 
	GoSub, DisableTimers
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			;WinActivate, ahk_id %this_id_tile%,				
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
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				;WinActivate, ahk_id %this_id_tile%,				
				WinMove, ahk_id %this_id%,, x,y,width,height
				x:=x+width
				if( (x+width) >= A_ScreenWidth){
					x:=0
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
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinActivate, ahk_id %this_id%,			
			WinWaitActive, ahk_id %this_id%, , 0	
			if (ErrorLevel) {
				WinActivate, ahk_id %this_id%		
				WinWaitActive, ahk_id %this_id%, , 0		
				if (ErrorLevel) {
					WinActivate, ahk_id %this_id%		
					WinWaitActive, ahk_id %this_id%, , 0		
					if (ErrorLevel) {
						WinActivate, ahk_id %this_id%		
						WinWaitActive, ahk_id %this_id%, , 0		
					}
				}
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
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
				WinActivate, ahk_id %this_id%,	
				WinWaitActive, ahk_id %this_id%, , 0		
				if (ErrorLevel) {
					WinActivate, ahk_id %this_id%		
					WinWaitActive, ahk_id %this_id%, , 0		
					if (ErrorLevel) {
						WinActivate, ahk_id %this_id%		
						WinWaitActive, ahk_id %this_id%, , 0		
						if (ErrorLevel) {
							WinActivate, ahk_id %this_id%		
							WinWaitActive, ahk_id %this_id%, , 0		
						}
					}
				}
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
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			;WinMinimize, ahk_id %this_id_toback%,			
			WinSet, Bottom, , ahk_id %this_id%
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

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
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
	Gosub, Find 
	GoSub, DisableTimers
	x:=0
	y:=0

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinMove, ahk_id %this_id%, , x,y,width,height				
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
	ControlSetText, , , ahk_id %InputBoxID% 
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
	GoSub, EnableTimers
Return

SendString:
    ;Gosub, Find 
	GoSub, DisableTimers
	ControlSetText, , no input while pasting...., ahk_id %InputBoxID%
	paste=1
	GoSub, SendString_LeaveTimers
	paste=0
	ControlSetText, , , ahk_id %InputBoxID% 
	ControlFocus, , ahk_id %InputBoxID%
	WinActivate, %windowname%
	GoSub, EnableTimers
Return

SendString_LeaveTimers:
	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			PostMessage, 0x102, % Asc(sendstrdata), 1, ,ahk_id %this_id%,
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

	if ( FilterGroup == 1 ){
		Loop, %id_array_count%
	    {
			this_id := id_array[A_Index]
			WinSet, Transparent, 30, ahk_id %this_id%
			Sleep, 200
			WinSet, Transparent, %alpha%, ahk_id %this_id%
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
		Loop, %id_array_count%
		{
			if ( ( titlematchbit & windowfilter ) > 0 ) {
				this_id := id_array[A_Index]
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

Find:
  gui, Submit, nohide
  titletmp := ""
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
  title := LTrim(titletmp, "|")
  if( title != "")
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
		if (RegExMatch(thistitle, title) > 0) {
			id_array.Push(this_id_find)
		}
	}
	
	WinGet, kittyids, list, ahk_exe kitty.exe
	Loop, %kittyids%
	{
		this_id_find := kittyids%A_Index%
		WinGetTitle, thistitle, ahk_id  %this_id_find%
		if (RegExMatch(thistitle, title) > 0) {
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
				if (RegExMatch(thistitle, title) > 0) {
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
				if (RegExMatch(thistitle, title) > 0) {
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
  }
  else
  {
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
	WinActivate, %windowname%
	ControlFocus, Edit7,  %windowname%
Return

; Win+Alt+D
#!d::
	WinActivate, %windowname%
	GoSub, SidePanelToggle
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