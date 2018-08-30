#!/bin/sh

sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
userresources=$HOME/.dotfiles/.Xresources
usermodmap=$HOME/.dotfiles/.Xmodmap
resourcefilescript=$HOME/.dotfiles/scripts/Xresources.sh
screenlayoutscript=$HOME/.dotfiles/scripts/xrandr.sh

if [ -f $screenlayoutscript ]; then
    source $screenlayoutscript
fi

if [ -f $resourcefilescript ]; then
    source $resourcefilescript
fi

if [ -f $resourcefile ]; then
    xrdb -merge $resourcefile
fi

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f $userresources ]; then
    xrdb -merge $userresources
fi

if [ -f $usermodmap ]; then
    xmodmap $usermodmap
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ - "$f" ] && . "$f"
    done
    unset f
fi

#/usr/bin/start-pulseaudio-x11
#/usr/bin/setxkbmap de
#exec i3
