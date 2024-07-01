#!/bin/zsh

# Get the current default sink
DEFAULT_SINK=$(pactl get-default-sink)

# Check if the default sink is muted
MUTE_STATE=$(< get-sink-mute $DEFAULT_SINK | awk '{print $2}')

# Toggle mute state
if [ "$MUTE_STATE" = "yes" ]; then
  pactl set-sink-mute $DEFAULT_SINK 0
  echo "Volume unmuted"
else
  pactl set-sink-mute $DEFAULT_SINK 1
  echo "Volume muted"
fi
