#!/bin/sh
resourcefile=$HOME/.dotfiles/.Xresources.d/i3wm
echo "" > $resourcefile
i=1
for s in $(xrandr --current | awk '/ connected/ {print $1}'); do
    printf "i3wm.dp$i: $s\n" >> $resourcefile
    i=$(( i + 1 ))
done
xrdb -merge $resourcefile
unset i
unset line
unset screens
unset resourcefile
