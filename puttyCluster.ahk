#SingleInstance force
#NoTrayIcon

; Title Row
Gui, Add, Text,, Windows Title Pattern (RegEx):

; Title matching text boxes
xpos := 10
ypos := 25
ewidth := 200
Gui, Add, Edit, x%xpos% y%ypos% vtitle1 w%ewidth%, .*
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle2 w%ewidth%, 
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle3 w%ewidth%, 
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle4 w%ewidth%, 
ypos := ypos + 27
Gui, Add, Edit, x%xpos% y%ypos% vtitle5 w%ewidth%, 

; Enable checkboxes
xpos := 220
ypos := 30
Gui, Add, Checkbox, x%xpos% y%ypos% vcheck1 Checked
ypos := ypos + 27
Gui, Add, Checkbox, x%xpos% y%ypos% vcheck2
ypos := ypos + 27
Gui, Add, Checkbox, x%xpos% y%ypos% vcheck3
ypos := ypos + 27
Gui, Add, Checkbox, x%xpos% y%ypos% vcheck4
ypos := ypos + 27
Gui, Add, Checkbox, x%xpos% y%ypos% vcheck5

; Found n windows and Locate Windows button
xpos := 10
ypos := 165
Gui, Add, Text, x%xpos% y%ypos%, Found 0 window(s)
xpos := 130
ypos := ypos - 5
Gui, Add, button, x%xpos% y%ypos% gLocate -default, locate window(s)

; Found filter radio buttons
xpos := 10
ypos := 200
Gui, Add, Text,  x%xpos% y%ypos%, Found windows filter (bitfield HEX eg FFFF):
xpos := xpos + 20
ypos := ypos + 20
Gui, Add, Radio, x%xpos% y%ypos% gFilterCheck vFilterGroup Checked
xpos := xpos + 100
Gui, Add, Radio, x%xpos% y%ypos% gFilterCheck
xpos := xpos - 70
Gui, Add, Text,  x%xpos% y%ypos%, All
xpos := xpos + 100
ypos := ypos - 3
Gui, Add, Edit,  x%xpos% y%ypos% vfindfiltertxt w40, FFFF

; Window transparency slider
; yposslider := 190
yposslider := 250
xpos := 10
ypos := yposslider
swidth := 230
Gui, Add, Text, x%xpos% y%ypos%, Window transparency:
ypos := ypos + 18
GUI, Add, Slider, x%xpos% y%ypos% Range100-255 w%swidth% gFind, 255

; Cluster Input, Paste, CrLf checkbox
yposcluster := yposslider + 60
xpos := 10
ypos := yposcluster
Gui, Add, Text, x%xpos% y%ypos% vignore w100, cluster input:
ypos := ypos + 20
Gui, Add, Edit, x%xpos% y%ypos% w80 WantTab ReadOnly, 
xpos := xpos + 83
Gui, Add, button, x%xpos% y%ypos% gGoPaste -default, paste clipboard
xpos := xpos + 90
ypos := ypos + 7
Gui, Add, Checkbox, x%xpos% y%ypos% vcrlfcheck Checked, +CrLf

; Window command buttons Tile, Cascade, ToFront etc
xpos := 10
ypos := yposcluster + 45
Gui, Add, button, x%xpos% y%ypos% gTile -default, Tile
xpos := xpos + 30
Gui, Add, button, x%xpos% y%ypos% gCascade -default, Cascade
xpos := xpos + 55
Gui, Add, button, x%xpos% y%ypos% gToBack -default, ToBack
xpos := xpos + 52
Gui, Add, button, x%xpos% y%ypos% gToFront -default, ToFront

; Window size radio buttons
xbase := 5
ybase := yposcluster + 85

xpos := xbase
ypos1 := ybase + 5
ypos2 := ybase + 32
ypos3 := ybase + 59
Gui, Add, Radio, x%xpos% y%ypos1% gRadioCheck vRadioGroup
Gui, Add, Radio, x%xpos% y%ypos2% gRadioCheck
Gui, Add, Radio, x%xpos% y%ypos3% gRadioCheck
xpos := xpos + 115
Gui, Add, Radio, x%xpos% y%ypos1% gRadioCheck
Gui, Add, Radio, x%xpos% y%ypos2% gRadioCheck
Gui, Add, Radio, x%xpos% y%ypos3% gRadioCheck
xpos := xpos + 60
Gui, Add, Radio, x%xpos% y%ypos1% gRadioCheck
Gui, Add, Radio, x%xpos% y%ypos2% gRadioCheck Checked
Gui, Add, Radio, x%xpos% y%ypos3% gRadioCheck

; Radio button text boxes
xpos := xbase + 61
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
xpos := xbase + 30
ypos1 := ybase
ypos2 := ybase + 27
ypos3 := ybase + 54
Gui, Add, Edit,  x%xpos% y%ypos1% vwidth1 w30 Number, 400
Gui, Add, Edit,  x%xpos% y%ypos2% vwidth2 w30 Number, 400
Gui, Add, Edit,  x%xpos% y%ypos3% vwidth3 w30 Number, 400
xpos := xpos + 40
Gui, Add, Edit,  x%xpos% y%ypos1% vheight1 w30 Number, 500
Gui, Add, Edit,  x%xpos% y%ypos2% vheight2 w30 Number, 600
Gui, Add, Edit,  x%xpos% y%ypos3% vheight3 w30 Number, 700

Gui, +AlwaysOnTop
fheight := yposcluster + 165
Gui, Show, h%fheight% w250, Mingbo's cluster Putty

global width := 400
global heght := 800
global windowfilter := -1

onMessage(0x100,"key")  ; key down
onMessage(0x101,"key")  ; key up
onMessage(0x104,"key")  ; alt key down
onMessage(0x105,"key")  ; alt key down

SetTimer, Find , 1000
SetTitleMatchMode, RegEx 
#WinActivateForce

global id
xstep := 50
ystep := 40
SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79
global ScreenWidth := VirtualScreenWidth / 2
global ScreenHeight := VirtualScreenHeight - 40
global id_array := Object()
global wmargin := 1
global width := ScreenWidth / 3 - wmargin
global height := ScreenHeight / 2

key(wParam, lParam,msg, hwnd)
{ 
  global paste
  if (paste ==1) {
	return
}
  GuiControlGet, currentInput, Focus  
  if(currentInput="Edit7"){

	  global id
	  Loop, %id%
	  {
		;this_id := id%A_Index%		
		this_id := id_array[A_Index]
		if(this_id >0){
		  PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
		}		
	  } 
	GuiControl,,Edit7, 
   }
}
return 

; "Better way to convert Hex to Decimal (function)": https://autohotkey.com/boards/viewtopic.php?t=6434
;HexToDec(hex)
;{
;    VarSetCapacity(dec, 66, 0)
;    , val := DllCall("msvcrt.dll\_wcstoui64", "Str", hex, "UInt", 0, "UInt", 16, "CDECL Int64")
;    , DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", dec, "UInt", 10, "CDECL")
;    return dec
;}

FilterCheck:
;gui, submit, nohide
;if (FilterGroup = 1) {
;	windowfilter := 0
;}
;else {
;	;windowfilter = HexToDec(findfiltertxt)
;	VarSetCapacity(dec, 66, 0)
;    , val := DllCall("msvcrt.dll\_wcstoui64", "Str", findfiltertxt, "UInt", 0, "UInt", 16, "CDECL Int64")
;    , DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", dec, "UInt", 10, "CDECL")
;    windowfilter =  %dec%
;}
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
ExitApp

Tile:
	Gosub, Find 
	x:=0
	y:=0
	Loop, %id%
	  {
		this_id := id_array[A_Index]
		if( this_id > 0){
				;WinActivate, ahk_id %this_id%,				
				WinMove, ahk_id %this_id%,, x,y,width,height
				x:=x+width
				if( (x+width) >= A_ScreenWidth){
					x:=0
					y:=y+height
				}
		}
	  }
	return
	
ToFront:
	Gosub, Find 
	x:=0
	y:=0
	titlematchbit := 1
	Loop, %id%
	  {
		this_id := id%A_Index%		
		if( this_id > 0){
			;bittest := titlematchbit & windowfilter
			;if ( ( FilterGroup == 1 ) || ( bittest > 0 ) ){
			;	WinActivate, ahk_id %this_id%,				
			;}

			if ( FilterGroup == 1 ){
				WinActivate, ahk_id %this_id%,				
			}
			else {
				VarSetCapacity(windowfilter, 66, 0)
				, val := DllCall("msvcrt.dll\_wcstoui64", "Str", findfiltertxt, "UInt", 0, "UInt", 16, "CDECL Int64")
				, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
				bittest := titlematchbit & windowfilter
				if ( bittest > 0 ) {
					WinActivate, ahk_id %this_id%,				
				}
			}

			titlematchbit := titlematchbit * 2
		}
	  }
	return
	
ToBack:
	Gosub, Find 
	x:=0
	y:=0
	titlematchbit := 1
	Loop, %id%
	  {
		this_id := id%A_Index%		
		if( this_id > 0){
			;bittest := titlematchbit & windowfilter
			;if ( ( FilterGroup == 1 ) || ( bittest > 0 ) ){
			;	;WinMinimize, ahk_id %this_id%,			
			;	WinSet, Bottom,, ahk_id %this_id%,
			;}

			if ( FilterGroup == 1 ){
				;WinMinimize, ahk_id %this_id%,			
				WinSet, Bottom,, ahk_id %this_id%,
			}
			else {
				VarSetCapacity(windowfilter, 66, 0)
				, val := DllCall("msvcrt.dll\_wcstoui64", "Str", findfiltertxt, "UInt", 0, "UInt", 16, "CDECL Int64")
				, DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", windowfilter, "UInt", 10, "CDECL")
				bittest := titlematchbit & windowfilter
				if ( bittest > 0 ) {
					;WinMinimize, ahk_id %this_id%,			
					WinSet, Bottom,, ahk_id %this_id%,
				}
			}

			titlematchbit := titlematchbit * 2
		}
	  }
	return
	
Cascade:
	Gosub, Find 
	x:=0
	y:=0
	Loop, %id%
	  {
		this_id := id_array[A_Index]
		if( this_id > 0){
				WinMove, ahk_id %this_id%,, x,y,width,height				
				x:=x+xstep
				y:=y+ystep
		}
	  }
	return
	
GoPaste:
    Gosub, Find 
	ControlSetText, Edit7, no input while pasting....
	paste=1
	clipboard=%clipboard%
	if ( crlfcheck == 1 ) {
		clipboard=%clipboard%`r
	}
	Loop, %id%
	  {
		this_id := id_array[A_Index]
		if( this_id >0 ){
			WinActivate, ahk_id %this_id%			
			SendRaw, %clipboard%		
		}
	  }  
	paste=0
	ControlSetText, Edit7, 

return

Locate:  
     Gosub, Find 
     Loop, %id%
     {
	   this_id := id_array[A_Index]
	   if( this_id >0){
		WinActivate, ahk_id %this_id%,
		 ; PostMessage, 0x112, 0xF020,,, ahk_id %this_id%,
 		 ; PostMessage, 0x112, 0xF120,,, ahk_id %this_id%,
		}
      }  
return 

Find:
  gui, Submit, nohide
  title := ""
  if( check1 == 1 && title1 != "" )
  {
	title = (%title1%)
  }
  if( check2 == 1 && title2 != "" )
  {
	if( title == "")
	{
		title =  (%title2%)
	}
	else
	{
		title = %title%|(%title2%)
	}
  }
  if( check3 == 1 && title3 != "" )
  {
	if( title == "")
	{
		title =  (%title3%)
	}
	else
	{
		title = %title%|(%title3%)
	}
  }
  if( check4 == 1 && title4 != "" )
  {
	if( title == "")
	{
		title =  (%title4%)
	}
	else
	{
		title = %title%|(%title4%)
	}
  }
  if( check5 == 1 && title5 != "" )
  {
	if( title == "")
	{
		title =  (%title5%)
	}
	else
	{
		title = %title%|(%title5%)
	}
  }
  if( title != "")
  {
	 id_array_count := 0
     WinGet,id, list, %title%
     notPutty := 0
     Loop, %id%
     {
       this_id := id%A_Index%
		WinGet, name, ProcessName, ahk_id %this_id%,
		if(name == "putty.exe" || name == "kitty.exe"){
			id_array_count := id_array_count + 1
			id_array[id_array_count] := this_id
		}
      }
	 id := id_array_count
	 if (id > 0) {
		;Sort, id_array, N,
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
  Loop, %id%
  {
	this_id := id_array[A_Index]
	if(id%A_Index% >0){
	  WinSet, Transparent, %alpha%, ahk_id %this_id%
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