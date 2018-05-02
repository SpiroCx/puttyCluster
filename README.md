# puttyCluster

Fork of https://github.com/mingbowan/puttyCluster which is described there as:
* puttyCluster putty cluster / multi-session / multi-window input
* Simple AutoHotkey script to enable sending input to multiple putty window simultaneously.

For me personally this makes the script even more useful with a few simple extensions. It was already good.

### Features

* Multiple title match windows with enable checkboxes so you can have sets of putty sessions open.  These can be OR'd and inverted
* Preset seach pattern in the first title match checkbox to "all putty windows"
* Multiple preset screen sizes with a selector for quick switching between them for when you have few windows/lots of windows
* Add CrLf to "paste clipboard" so you can keep one liners in a text file for example
* ToBack and To Front buttons to quickly bring the matched windows to the front on the Desktop
* Laucher side panel for apps, Putty sessions and Putty commands.  
* INI file for configuration if you want to compile to exe
* Global shortcuts to bring to top and toggle side panel.  There is also a StayOnTop flag if you prefer that to keyboard shortcuts
* Mulitple monitor supprt for Tile/Cascade functions

### install

1.  Install putty.  If you use ExtraPutty (http://www.extraputty.com) or any putty that keeps putty sessions as separate files on HDD rather than the registry, right clicking on blank Putty Session Launcher button to pick existing session will work nicely.  Set up your sessions in ExtraPutty so it's working to your liking.  Optionally setup PuttyAgent also for authentication. It makes logging into multiple sessions fast.

2.  Install this script
```
git clone git://github.com/SpiroCx/puttyCluster.git
cd puttyCluster\
```
3.  Edit puttyCluster.ini to set DefaultPuttyCommandPrefix, DefaultPuttyDir, DefaultPuttySessionDir.

4. Then if you have autohotkey installed you can directly run the script:
```
puttyCluster.ahk
```
Or you may build it for example with:
```
Ahk2Exe.exe /in "puttyCluster.ahk" /out "puttyCluster.exe" /icon "puttyCluster.ico" /bin "<path to ahk>\Compiler\Unicode 64-bit.bin"
```
And run the generated puttyCluster.exe

5. Open the Launcher sidebar by clicking on the '>>' icon top left and setup application launchers (eg PuttyAgent, Putty itself for creating sessions, VcXsrv to display X window apps), Putty session launchers (mileage will vary depending your version of Putty, but if you use ExtraPutty, and setup the path to ExtraPutty in clusterPutty.ini, then right clicking on a blank Putty Session Launcher button will take you to the ExtraPutty sessions folder when you can pick a session for the button.  If you don't already have existing putty sessions to choose from, then run putty, set up some devices with sessions, then import them into puttyCluster.  The Putty Commands launchers can be used for commonly used commands.  Right click on one to edit it.

### Usage

After launching the script ...
6.  Set up multiple devices using the Putty Session launchers.  The 3 columns let you open multple sessions per device, to multiple devices, by pressing the Col button.

7.  Use the Window Title regex filters to find and use some or all of your open Putty session windows.  "Locate" helps you find which ones are currently identified by the the filters.  Window position fileters are applied after the window title filter.  It lets you further filter windows based on their screen position (after the title matches are applied).  This is useful if, say, you have putty windows arranged in groups per device (eg 3 on your Linux server, and 3 on your embedded device) and you temporarily only want one window from each of these groups to respond.  Lets say for example you switch from a command for all windows (ls, pwd, tail log.txt), to a command you only want to run once on each box (apt update, apt install).  That's when you use the Found Windows filter.  There are 3 options.  "All" just goes ahead and selects all windows as determined by the 5 title matching boxes, "1-8 on/off toggle" lets you pick up to the first 8 windows individually, and the text box (init value FFFF) lets you use a bitfield to specify the box positions.  Lets say you wanted boxes 2, 4, 7 and 8, the you put CA in this text box. 

8.  If you use multiple monitors, the Tile button supports right clicking to Tile on the other monitor (which can be set in puttyCluster.ini)

Tips: 
* Use the Locate button (or Win-Alt-O) to regualarly check which windows you are currently hitting with your filters
* Use prompt/title tagging (see notes below) to assist in creating groups of windows
* Commit your Title/Position filters to memory and try the Mini mode (Win-Alt-I) to shrink the Gui down to almost just the input box.  The hotkeys for filter switching still work so you can still switch between groups
* The Invert Match Flag labelled "!(..)" is probably more useful than the individual invert flags which are ignored when this flag is set.  It inverts the overall combination of the title matches.  This lets you use the title matches to find the windows you want to ignore, then set the invert flag to get the others.
* With the titlebar removed from the Mini Mode, it's harder now to change the location of the Gui.  You need to use the keyboard. Alt, Space, Move, press any arrow key, then use the mouse.  To offset this invconvenience, the X Y coordinates of the mini mode are now stored/restored to/from the puttyCluster.ini file.  Al least this way you only have to do it occasionally.  With the Always On Top flag turned on, it's quote convenient to place the Mini Mode location somewhere over the Windows task bar

In addition to original useage (https://github.com/mingbowan/puttyCluster):

* Multiple regex's can be applied so windows can be kept in groups
* Regex's can be inverted.  !match
* Screen size for  Tile/Cascade can be quick switched with selector
* Paste Clipboard adds cr(lf)
* Optional command line parameter for optional alternate ini file. eg: puttyCluster <work.ini>
* Right click on sidebar launchers to edit item
* There are 5 areas that support multpile pages. Windows Title regex matches, Windows position (bitfield) matches, App launchers, Putty session launchers and Command launchers.  To create a new page, copy an existing ini file to a new name, then add the new ini file to the main app init file puttyCluster.ini in the relevant section. Then, clicking on the "next page" button in the section Title will scroll to the new ini file settings.

### Keyboard Shortcuts

* Win-Alt-C 	 Bring ClusterPutty window to the top
* Win-Alt-D 	 Toggle the launcher sidebar (+ bring to top)
* Win-Alt-T 	 Tile Putty windows
* Win-Alt-F 	 Bring Putty windows to the top of the desktop
* Win-Alt-B 	 Push Putty windows to the back of the desktop (hide them)
* Win-Alt-V 	 Paste current clipboard to all windows
* Win-Alt-L 	 Toggle 'Append CrLf' flag
* Win-Alt-O 	 Locate Putty Windows (Bring to top, flash border)
* Win-Alt-S 	 Toggle 'Single regex match' flag
* Win-Alt-1..5 	 Toggle Enable 1..5 flag
* Win-Alt-I 	 Toggle Mini mode
* Win-Alt-N 	 Toggle Invert Match flag

#### A good Putty window title greatly assists in window filtering

This script regex searches all the text in the Putty window titles.  Adding more info to your Putty window title gives you more power for filtering the windows out.  There are some crazy complicated prompts out there eg https://www.askapache.com/linux/bash-power-prompt/.  This relatively modest prompt puts the hostname and current path into the Putty window title.  
on the command line.  Here is a prompt that places a tag in the title and prompt, as well as an ip address in the title.  This works for both a full bash shell and even busybox:
```
IP=$(ifconfig | grep 120 | sed -n '1s/[^:]*:\([^ ]*\).*/\1/p'); PS1="\[\e]0;\u@\h: \w[C][$IP]\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\][C]$\[\e[m\] "
```
(Note in the above example the 120 that I grep is specific to my lan segment of interest).
![Tags Example](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot4_putty_tags.png)
  
### Known issues
* Most of the script is useless if you don't run it as Administrator.  At least ToBack and ToFront don't get access to the windows without it.
* I have used "SetWinDelay, -1" to make Tile/Cascade fast (which they are).  The AHK help file says not to do this though as the PostMessages may fail under heavy CPU load.  If there are any suspicions in regards to this, these lines should be switched to "SetWinDelay, 0" at least (if not "SetWinDelay, 10")
*  There is only very partial (and experimental) support for SuperPutty and Xshell Beta 6.  In both cases, pretty much only the multi typing works and only the bitfield window selection filters work.  No title matching, locate, ToFront, ToBack.  In addition to this, for Superputty, only the visible tabs respond.  This Superputty limitation is a bit of a show stopper.  The Xshell support is kind of useable but not a lot better than Xshells own multi window input capabilities.
* The individual inverted regex's are based on this expression: 
```
^((?!MATCH).)*$ 
```
where MATCH is regex edit box term.  Using multiple enabled regex searches with inversion results in this sort of internally used expression:
```
^((?!MATCH1).)*$)|(^((?!MATCH2).)*$)
```
These results can get confusing.  I usually use the invert operator on a single title match this way.  First tag a group of putty windows (with "[A] + IP" in this example):
```
IP=$(ifconfig | grep 120 | sed -n '1s/[^:]*:\([^ ]*\).*/\1/p'); PS1="\[\e]0;\u@\h: \w[A][$IP]\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\][A]$\[\e[m\] "
```
then Tile them to another monitor, open a new set of putty windows, turn on the invert operator on the first tag eg "[A]" to isolate the new set of windows, then tag the second set of windows (with "[B]" in this case):
```
IP=$(ifconfig | grep 120 | sed -n '1s/[^:]*:\([^ ]*\).*/\1/p'); PS1="\[\e]0;\u@\h: \w[B][$IP]\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\][B]$\[\e[m\] "
```
The inverted match checkbox (labelled !(..)) generates this expression:
```
^((?!(MATCH1)|(MATCH2)|(MATCH3)|(MATCH4)|(MATCH5)).)*$ 
```
So the individual invert flags are ignored, in favour of combining all the title regex's and inverting the result


### Screenshots

![Main collapsed](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot1_main_collapsed.png)
![Main expanded](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot2_main_expanded.png)
![About](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot3_about.png)
![Edit Launcher](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot5_edit_Launcher.png)
![Edit Session](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot6_edit_session.png)
![Edit Command](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot7_edit_command.png)
![Demo Application](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot8_socket_test.png)
![Mini Mode](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot9_mini_mode.png)

### ToDo

* Add sanity checking to the launchers.  The script throws and error for invalid paths/commands. Script still works ok (doesn't crash) but it's ugly.
* Find space for the label "Select Monitor" above the monitor selection radio buttons
* Make the hotkeys configurable
* Add shortcut for Always On Top

### license
* free as in free beer and free as in free speech
* use at your own risk
