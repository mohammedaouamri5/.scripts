#!/bin/zsh

# Get the current default sink
DEFAULT_SINK=$(pactl get-default-sink)

# Get the current volume of the default sink
CURRENT_VOLUME=$(pactl get-sink-volume $DEFAULT_SINK | grep -oP '\d+%' | head -1 | tr -d '%')

# Calculate the new volume
NEW_VOLUME=$((CURRENT_VOLUME - 5))

# Ensure the new volume doesn't go below 0%
if [ $NEW_VOLUME -lt 0 ]; then
  NEW_VOLUME=0
fi

# Set the new volume
pactl set-sink-volume $DEFAULT_SINK ${NEW_VOLUME}%

echo "Volume decreased to ${NEW_VOLUME}%"
