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

; Window transparency slider
xpos := 10
swidth := 200
Gui, Add, Text, x%xpos%, Window transparency:
GUI, Add, Slider, x%xpos% Range100-255 w%swidth% gFind, 255

; Cluster Input, Paste, CrLf checkbox
xpos := 10
ypos := 265
Gui, Add, Text, x%xpos% vignore w100, cluster input:
Gui, Add, Edit, x%xpos% w80 WantTab ReadOnly, 
xpos := xpos + 83
Gui, Add, button, x%xpos% y%ypos% gGoPaste -default, paste clipboard
xpos := xpos + 90
ypos := ypos + 7
Gui, Add, Checkbox, x%xpos% y%ypos% vcrlfcheck Checked, +CrLf

; Window command buttons Tile, Cascade, ToFront etc
xpos := 10
ypos := 295
Gui, Add, button, x%xpos% y%ypos% gTile -default, Tile
xpos := xpos + 30
Gui, Add, button, x%xpos% y%ypos% gCascade -default, Cascade
xpos := xpos + 55
Gui, Add, button, x%xpos% y%ypos% gToBack -default, ToBack
xpos := xpos + 52
Gui, Add, button, x%xpos% y%ypos% gToFront -default, ToFront

; Radio buttons
xbase := 5
ybase := 335

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
Gui, Add, Radio, x%xpos% y%ypos2% gRadioCheck
Gui, Add, Radio, x%xpos% y%ypos3% gRadioCheck

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

; Radio button text boxes
xpos := xbase + 61
ypos1 := ybase + 2
ypos2 := ybase + 29
ypos3 := ybase + 56
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

Gui, +AlwaysOnTop
Gui, Show, h425 w250, Mingbo's cluster Putty

global width := 400
global heght := 800

onMessage(0x100,"key")  ; key down
onMessage(0x101,"key")  ; key up
onMessage(0x104,"key")  ; alt key down
onMessage(0x105,"key")  ; alt key down

SetTimer, Find , 1000
SetTitleMatchMode, RegEx 
#WinActivateForce


xstep := 50
ystep := 40
SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79
global ScreenWidth := VirtualScreenWidth / 2
global ScreenHeight := VirtualScreenHeight - 40

key(wParam, lParam,msg, hwnd)
{ 
  global paste
  if (paste ==1) {
	return
}
  GuiControlGet, currentInput, Focus  
  if(currentInput="Edit6"){

	  global id
	  Loop, %id%
	  {
		this_id := id%A_Index%		
		if(this_id >0){
		  PostMessage, %msg%,%wParam%, %lParam%  , ,ahk_id %this_id%,
		}		
	  } 
	GuiControl,,Edit6, 
   }
}
return 

RadioCheck:
wmargin := 1
hmargin := 0
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
	height := ScreenHeight / 2 - hmargin
}
else if (RadioGroup = 8) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight / 2 - hmargin
}
else if (RadioGroup = 9) {
	width := ScreenWidth / 3 - wmargin
	height := ScreenHeight / 3 - hmargin
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
		this_id := id%A_Index%		
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
	Loop, %id%
	  {
		this_id := id%A_Index%		
		if( this_id > 0){
				WinActivate, ahk_id %this_id%,				
		}
	  }
	return
	
ToBack:
	Gosub, Find 
	x:=0
	y:=0
	Loop, %id%
	  {
		this_id := id%A_Index%		
		if( this_id > 0){
				;WinMinimize, ahk_id %this_id%,			
				WinSet, Bottom,, ahk_id %this_id%,
		}
	  }
	return
	
Cascade:
	Gosub, Find 
	x:=0
	y:=0
	Loop, %id%
	  {
		this_id := id%A_Index%		
		if( this_id > 0){
				WinMove, ahk_id %this_id%,, x,y,width,height				
				x:=x+xstep
				y:=y+ystep
		}
	  }
	return
	
GoPaste:
    Gosub, Find 
	ControlSetText, Edit6, no input while pasting....
	paste=1
	clipboard=%clipboard%
	if ( crlfcheck == 1 ) {
		clipboard=%clipboard%`r
	}
	Loop, %id%
	  {
		this_id := id%A_Index%		
		if( this_id >0 ){
			WinActivate, ahk_id %this_id%			
			SendRaw, %clipboard%		
		}
	  }  
	paste=0
	ControlSetText, Edit6, 

return

Locate:  
     Gosub, Find 
     Loop, %id%
     {
       this_id := id%A_Index%
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
     WinGet,id, list, %title%
     notPutty := 0
     Loop, %id%
     {
       this_id := id%A_Index%
		WinGet, name, ProcessName, ahk_id %this_id%,
		if(name != "putty.exe" && name != "kitty.exe"){
		  notPutty++
		  id%A_Index%=""
		}
      }
     found := id - notPutty
     GuiControl, , Static2,  % "Found " found " window(s)"
  }
  else
  {
   id=""
   GuiControl, , Static2,   Found 0 window(s)
  }


Alpha:
  GuiControlGet, alpha, ,msctls_trackbar321
  Loop, %id%
  {
    this_id := id%A_Index%	
	if(id%A_Index% >0){
	  WinSet, Transparent, %alpha%, ahk_id %this_id%
	}   
   }
 return
