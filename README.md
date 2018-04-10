# puttyCluster

Fork of https://github.com/mingbowan/puttyCluster which is described there as:
* puttyCluster putty cluster / multi-session / multi-window input
* Simple AutoHotkey script to enable sending input to multiple putty window simultaneously.

For me personally this makes the script even more useful with a few simple extensions. It was already great.

### Features

* Multiple title match windows with enable checkboxes so you can have sets of putty sessions open.  These can be OR'd
* Preset seach pattern in the first title match checkbox to "all putty windows"
* Multiple preset screen sizes with a selector for quick switching between them for when you have few windows/lots of windows
* Add CrLf to "paste clipboard" so you can keep one liners in a text file for example
* ToBack and To Front buttons to quickly bring the matched windows to the front on the Desktop

### install

First checkout the repository, then checkout this branch.  This example uses ssh to clone.  I notice that if you checkout using https, the commands are different.  This works but you have to sort out your ssh keys first (generate them locally and then add them to GitHUB).  Note that the master branch is current unmodified from the upstream repo.
```
git clone git://github.com/SpiroCx/puttyCluster.git
cd puttyCluster\
git branch -a
git checkout -b scMods origin/scMods
git branch -vv
```
The last command just confirms that it worked.

### Usage

![Usage](https://raw.github.com/SpiroCx/puttyCluster/scMods/screenshot.PNG)

In addition to original useage (https://github.com/mingbowan/puttyCluster):

* Multiple regex's can be applied so windows can be kept in groups
* Screen size for  Tile/Cascade can be quick switched with selector
* Paste Clipboard adds cr(lf)
* The Found Windows Filter lets you further filter windows based on their screen position.  This is useful if, say, you have putty windows arranged in groups per device (eg 3 on your Linux server, and 3 on your embedded device) and you temporarily only want one window from each of these groups to respond.  Lets say for example you switch from a command for all windows (ls, pwd, tail log.txt), to a command you only want to run once on each box (apt update, apt install).  That's when you use the Found Windows filter.  There are 3 options.  "All" just goes ahead and selects all windows as determined by the 5 title matching boxes, "1-8 on/off toggle" lets you pick up to the first 8 windows individually, and the text box (init value FFFF) lets you use a bitfield to specify the box positions.  Lets say you wanted boxes 2, 4, 7 and 8, the you put CA in this text box. 

   
### ToDo

* Add version number and display in title or add About Box
* Add explainatory "Enable" text above current checkboxes
* Add system wide hotkeys
* Add ini file so hotkeys can be configurable
* Add Mimimise To Tray once the hotkeys are working
* Add a second column of checkboxes.  The first (current) columnd is "Enable Regex", the second is "Toggle Always On Top Flag"
* Possibly add configurable launcher buttons down the bottom for pagent, putty session manager, or even some specific sessions

### license
* free as in free beer and free as in free speech
* use at your own risk
