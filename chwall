savedir=~/wallpapers



# Use FZF to select and set a wallpaper interactively
selected_wallpaper=$(find "$savedir" -type f | fzf --preview 'chafa --colors=256 --size 40x20 {}')

# If a wallpaper was selected, set it using swww
if [ -n "$selected_wallpaper" ]; then
    swww img "$selected_wallpaper"
else
    echo "No wallpaper selected."
fi
