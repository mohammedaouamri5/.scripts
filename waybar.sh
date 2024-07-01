#!/bin/bash

# Check if Waybar is running
if pgrep -x "waybar" > /dev/null
then
    echo "Waybar is running. Stopping Waybar."
    pkill -x "waybar"
else
    echo "Waybar is not running. Starting Waybar."
    waybar &
fi
