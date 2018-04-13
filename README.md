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
* Global shortcut Win-Alt-C brings ClusterPutty window to the foreground
* App shortcuts Alt-C (Paste Clipboard), Alt-L (toggle "add +CrLF" to clipboard paste), Alt-T (Tile), Alt+B/F (To Back/Front)

#### A good Putty window title greatly assists in window filtering

This script regex searches all the text in the Putty window titles.  Adding more info to your Putty window title gives you more power for filtering the windows out.  There are some crazy complicated prompts out there eg https://www.askapache.com/linux/bash-power-prompt/.  This relatively modest prompt puts the hostname and current path into the Putty window title.  
on the command line:
```
PS1="\[\e]0;\u@\h: \w\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\]$\[\e[m\] "
```
You can also add a custom tag in between the \w and \a which lets you put arbitrary text in the title.  This allows you to group Putty windows arbitrarily for the purposes of Cluster Putty.  On a session running a full bash, you can add a script to poke in a title tag like this:
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
Smaller embeded platforms tend use busybox instead of a full shell.  If you are working with busybox, the script won't work (at least it doesn't on any of mine) but you can include a tag in the title directly in the PS1 command:
on the command line:
```
PS1="\[\e]0;\u@\h: \w[AAA]\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]\[\e[36m\]$\[\e[m\] "
```
I am using this one at the moment which includes git info:
in .bashrc or .profile:
```
getputtytag(){
   echo $puttytag
}
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\[\e]0;\u@\h: \w\$(getputtytag)\a\]\[\e[33m\]\u@\h:\[\e[m\]\[\e[31m\]\w\[\e[31m\]$(parse_git_branch)\[\e[36m\]$\[\e[m\] "
```
  
### ToDo

* Add version number and display in title or add About Box
* Add explainatory "Enable" text above current checkboxes
* Add ini file so hotkeys can be configurable, window posisition can be remembered
* Add Mimimise To Tray once the hotkeys are working
* Add a button that sets the Putty window title.  A pop window asks for which tag to use.  The prompt template is in the INI file.
* Possibly add configurable launcher buttons down the bottom for pagent, putty session manager, some specific putty sessions, or even commonly used commands (sudo, apt update etc, exit, ip addr show)

### license
* free as in free beer and free as in free speech
* use at your own risk
