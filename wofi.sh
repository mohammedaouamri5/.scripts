#!/bin/bash

# Check if wofi is running
if pgrep -x "wofi" > /dev/null
then
    # Wofi is running, so let's kill it
    echo "Killing wofi"
    pkill -x wofi
else
    # Wofi is not running, so let's start it
    echo "running wofi"
    wofi &
fi
