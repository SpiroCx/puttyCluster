#SingleInstance force
#NoTrayIcon

Gui, Add, Text,, Windows Title Pattern (RegEx):
Gui, Add, Edit,  vtitle1 w200, .*
Gui, Add, Edit,  vtitle2 w200, 
Gui, Add, Edit,  vtitle3 w200, 
Gui, Add, Edit,  vtitle4 w200, 
Gui, Add, Edit,  vtitle5 w200, 
Gui, Add, Text,, found 0 window(s)
Gui, Add, button, X130 y160 gLocate -default, locate window(s)
Gui, Add, Text, x10, Window transparency:
GUI, Add, Slider, x10 Range100-255 w200 gFind, 255
Gui, Add, Text,x10 vignore w100, cluster input:
Gui, Add, Edit,x10 WantTab ReadOnly, 
Gui, Add, button, X140 y265 gGoPaste -default, paste clipboard
Gui, Add, button, X10 y295 gTile -default, Tile
Gui, Add, button, X40 y295 gCascade -default, Cascade
;Gui, Add, Edit, x100 y297 vwidth0 w30 Number, 800
;Gui, Add, Text,x138 y299, X
;Gui, Add, Edit, x150 y297 vheight0 w30 Number, 400
;Gui, Add, Checkbox, x190 y300 vauto, auto

Gui, Add, Checkbox, x220 y30 vcheck1 Checked
Gui, Add, Checkbox, x220 y57 vcheck2
Gui, Add, Checkbox, x220 y84 vcheck3
Gui, Add, Checkbox, x220 y111 vcheck4
Gui, Add, Checkbox, x220 y138 vcheck5

Gui, Add, Radio, x05 y340 gRadioCheck vRadioGroup
Gui, Add, Radio, x05 y367 gRadioCheck
Gui, Add, Radio, x05 y394 gRadioCheck
Gui, Add, Radio, x120 y340 gRadioCheck
Gui, Add, Radio, x120 y367 gRadioCheck
Gui, Add, Radio, x120 y394 gRadioCheck
Gui, Add, Radio, x180 y340 gRadioCheck
Gui, Add, Radio, x180 y367 gRadioCheck
Gui, Add, Radio, x180 y394 gRadioCheck

Gui, Add, Edit,  x35 y335 vwidth1 w30 Number, 400
Gui, Add, Edit,  x35 y362 vwidth2 w30 Number, 400
Gui, Add, Edit,  x35 y389 vwidth3 w30 Number, 400
Gui, Add, Text,  x150 y337, 1x1
Gui, Add, Text,  x150 y364, 1x2
Gui, Add, Text,  x150 y391, 1x3
Gui, Add, Text,  x210 y337, 2x2
Gui, Add, Text,  x210 y364, 2x3
Gui, Add, Text,  x210 y391, 3x3

Gui, Add, Text,  x66 y337, X
Gui, Add, Text,  x66 y364, X
Gui, Add, Text,  x66 y391, X

Gui, Add, Edit,  x75 y335 vheight1 w30 Number, 500
Gui, Add, Edit,  x75 y362 vheight2 w30 Number, 600
Gui, Add, Edit,  x75 y389 vheight3 w30 Number, 700

Gui, Add, button, X95 y295 gToBack -default, ToBack
Gui, Add, button, X147 y295 gToFront -default, ToFront

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
     GuiControl, , Static2,  % "found " found " window(s)"
  }
  else
  {
   id=""
   GuiControl, , Static2,   found 0 window(s)
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
