#!/bin/zsh

# Get the current default sink
DEFAULT_SINK=$(pactl get-default-sink)

# Get the current volume of the default sink
CURRENT_VOLUME=$(pactl get-sink-volume $DEFAULT_SINK | grep -oP '\d+%' | head -1 | tr -d '%')

# Calculate the new volume
NEW_VOLUME=$((CURRENT_VOLUME + 5))

# Ensure the new volume doesn't exceed 100%
if [ $NEW_VOLUME -gt 100 ]; then
  NEW_VOLUME=100
fi

# Set the new volume
pactl set-sink-volume $DEFAULT_SINK ${NEW_VOLUME}%

echo "Volume increased to ${NEW_VOLUME}%"
