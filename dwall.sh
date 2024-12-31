
#!/bin/bash

# Get the list of files/directories
LIST=$(ls ~/.wallpaper)

# Show the list in rofi and capture the selection
SELECTION=$(echo "$LIST" | rofi -dmenu -p "Select:")

# Check if the user selected something
if [[ -n "$SELECTION" ]]; then
    # Example action when picking a file/directory
    echo "You selected: $SELECTION"
    # Replace the following command with the one you want to run
    xdg-open "$SELECTION"  # Example: Open the file with its default application
else
    echo "No selection made."
fi
