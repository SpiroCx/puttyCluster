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
* Fast Putty Session button set up (...if you use ExtraPutty or any putty that keeps putty sessions as separate files on HDD rather than the registry). Right click on blank button to pick existing session.

### install

```
git clone git://github.com/SpiroCx/puttyCluster.git
cd puttyCluster\
```

### Usage

In addition to original useage (https://github.com/mingbowan/puttyCluster):

* Multiple regex's can be applied so windows can be kept in groups
* Regex's can be inverted.  !match
* Screen size for  Tile/Cascade can be quick switched with selector
* Paste Clipboard adds cr(lf)
* The Found Windows Filters let you further filter windows based on their screen position (after the title matches are applied).  This is useful if, say, you have putty windows arranged in groups per device (eg 3 on your Linux server, and 3 on your embedded device) and you temporarily only want one window from each of these groups to respond.  Lets say for example you switch from a command for all windows (ls, pwd, tail log.txt), to a command you only want to run once on each box (apt update, apt install).  That's when you use the Found Windows filter.  There are 3 options.  "All" just goes ahead and selects all windows as determined by the 5 title matching boxes, "1-8 on/off toggle" lets you pick up to the first 8 windows individually, and the text box (init value FFFF) lets you use a bitfield to specify the box positions.  Lets say you wanted boxes 2, 4, 7 and 8, the you put CA in this text box. 
* App shortcuts Alt-C (Paste Clipboard), Alt-L (toggle "add +CrLF" to clipboard paste), Alt-T (Tile), Alt+B/F (To Back/Front)
* Optional command line parameter for optional alternate ini file. eg: puttyCluster <work01.ini>
* Right click on sidebar launchers to edit item
* The exe file included in the repo is built with: "Ahk2Exe.exe" /in "puttyCluster.ahk" /out "scputtyCluster.exe" /icon "C:\_Portable\__scIcons\Notepad++.ico" /bin "<path to ahk>\Compiler\Unicode 64-bit.bin"

### Keyboard Shortcuts

* Win-Alt-C 	Bring ClusterPutty window to the top
* Win-Alt-D 	Toggle the launcher sidebar (+ bring to top)
* Win-Alt-T		Tile Putty Windows
* Win-Alt-F		Bring Putty Windows to the top of the desktop
* Win-Alt-B		Push Putty Winows to the back of the desktop (hide them)
* Win-Alt-V		Paste current clipboard to all windows
* Win-Alt-L		Toggle "Append CrLf to paste" flag

#### A good Putty window title greatly assists in window filtering

This script regex searches all the text in the Putty window titles.  Adding more info to your Putty window title gives you more power for filtering the windows out.  There are some crazy complicated prompts out there eg https://www.askapache.com/linux/bash-power-prompt/.  This relatively modest prompt puts the hostname and current path into the Putty window title.  
on the command line:
```
PS1="\[\e]0;\u@\h: \w\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\]$\[\e[m\] "
```
You can also add a custom tag in between the \w and \a which lets you put arbitrary text in the title.  This allows you to group Putty windows arbitrarily with puttyCluster.  On a session running a full bash, you can add a script to poke in a title tag like this:
in .bashrc or .profile:
```
getputtytag(){
   echo $puttytag
}
PS1="\[\e]0;\u@\h: \w\$(getputtytag)\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\]$\[\e[m\] "
```
which allows you to set the Title tag with:
on the command line:
```
export puttytag=[AAA]
```
Smaller embeded platforms tend use busybox instead of a full shell.  If you are working with busybox, the getputtytag() script won't work (at least it doesn't on any of mine) but you can include a tag in the title directly in the PS1 command:
on the command line:
```
PS1="\[\e]0;\u@\h: \w[AAA]\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\]$\[\e[m\] "
```
I am using this one at the moment which includes git info, an ip address in the title, and an additional tag in the prompt to remind myself which puttyCluster group the putty session is part of:
in .bashrc or .profile:
```
getip120(){
   ifconfig | grep 120 | sed -n '1s/[^:]*:\([^ ]*\).*/\1/p'
}
getip235(){
   ifconfig | grep 235 | sed -n '1s/[^:]*:\([^ ]*\).*/\1/p'
}
getputtytitle(){
   echo $puttytitle
}
getputtyprompt(){
   echo $puttyprompt
}
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\[\e]0;\u@\h: \w\$(getputtytitle)\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[36m\]\w\[\e[31m\]$(parse_git_branch)\[\e[36m\]\$(getputtyprompt)$\[\e[m\] "
```
(Note in the above example the 120 and 235 are specific to my lan segments of interest).  I can then set putty terminal with:
```
puttyprompt=[A]; puttytitle=[A][$(getip120)]
```
![Tags Example](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot4_putty_tags.png.png)
  
### Known issues
* Most of the script is useless if you don't run it as Administrator.  At least ToBack and ToFront don't get access to the windows without it.
* I have used "SetWinDelay, -1" to make Tile/Cascade fast (which they are).  The AHK help file says not to do this though as the PostMessages may fail under heavy CPU load.  If there are any suspicions in regards to this, these lines should be switched to "SetWinDelay, 0" at least (if not "SetWinDelay, 10")
*  There is only very partial (and experimental) support for SuperPutty and Xshell Beta 6.  In both cases, pretty much only the multi typing works and only the bitfield window selection filters work.  No title matching, locate, ToFront, ToBack.  In addition to this, for Superputty, only the visible tabs respond.  This Superputty limitation is a bit of a show stopper.  The Xshell support is kind of useable but not a lot better than Xshells own multi window input capabilities.
* The inverted regex's are based on this expression: 
```
^((?!MATCH).)*$ 
```
where MATCH is regex edit box term.  Using multiple enabled regex searches with inversion results in this sort of internally used expression:
```
^((?!MATCH1).)*$)|(^((?!MATCH2).)*$)
```
These results can get confusing.  I usually use the invert operator on a single title match this way.  First tag a group of putty windows:
```
(puttyprompt=[A]; puttytitle=[A][$(getip120)])
```
then open a new set of putty windows, turn on the invert operator on the first tag eg "[A]" to isolate the new set of windows, then tag the second set of windows
```
(puttyprompt=[B]; puttytitle=[B][$(getip120)])
```

### Screenshots

![Main collapsed](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot1_main_collapsed.png)
![Main expanded](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot2_main_expanded.png)
![About](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot3_about.png)
![Edit Launcher](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot5_edit_Launcher.png)
![Edit Session](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot6_edit_session.png)
![Edit Command](https://raw.github.com/SpiroCx/puttyCluster/screenshots/screenshot7_edit_command.png)

### ToDo

* Add Mimimise To Tray once the hotkeys are working
* Add configurable hotkeys to INI file

### license
* free as in free beer and free as in free speech
* use at your own risk
