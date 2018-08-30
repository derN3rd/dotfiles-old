#!/usr/bin/env bash

for s in $(pactl list sinks | grep Sink | awk '{print $2}' | sed 's/#/ /'); do

    if [[ "$1" = "plus" ]]; then
        pactl set-sink-volume $s +5%
    fi
    
    if [[ "$1" = "minus" ]]; then
        pactl set-sink-volume $s -5%
    fi
    
    if [[ "$1" = "mute" ]]; then
        pactl set-sink-mute $s toggle
    fi
done
