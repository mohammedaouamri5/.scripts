
#!/usr/bin/env bash

# Directory containing images
IMAGE_DIR="$1"

# Exit if no directory is provided
if [ -z "$IMAGE_DIR" ]; then
    echo "Usage: $0 <image_directory>"
    exit 1
fi

# Loop through all image files (jpg, jpeg, png, webp, bmp)
find "$IMAGE_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) | while read -r img; do
    echo "Upscaling: $img"
    tmpfile="${img%.*}_tmp.${img##*.}"

    # Run Upscay with 10x scale
    upscay --scale 10 "$img" -o "$tmpfile"

    # Replace the original file
    mv "$tmpfile" "$img"
done

echo "✅ All images upscaled successfully!"
