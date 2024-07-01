#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <image>"
  exit 1
fi

IMAGE="$1"

# Clear the terminal
clear

# Use ueberzug to display the image
ueberzug layer --parser bash <<EOF
{ "action": "add", "identifier": "preview", "x": 3, "y": 3, "width": 40, "height": 20, "path": "$IMAGE" }
EOF

# Wait for user input to clear the image
read -n 1 -s -r -p "Press any key to clear the image"

# Clear the terminal
clear
