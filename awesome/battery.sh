#!/bin/bash

# Store the previous clipboard content
previous_clipboard=""

while true; do
    # Get the current clipboard content
    current_clipboard=$(xclip -selection clipboard -o 2>/dev/null)

    # If the content has changed, print it
    if [[ "$current_clipboard" != "$previous_clipboard" ]]; then
        echo "Copied: $current_clipboard"
        previous_clipboard="$current_clipboard"
    fi

    # Wait for a short time before checking again
    sleep 0.5
done
