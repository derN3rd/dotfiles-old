#!/bin/bash
sed -i 's/"exit_type":"Crashed"/"exit_type":"none"/g' /home/max/.config/google-chrome/Default/Preferences
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/g' /home/max/.config/google-chrome/Default/Preferences
