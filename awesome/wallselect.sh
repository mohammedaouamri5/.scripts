#!/usr/bin/env sh


#// set variables

confDir="$HOME/.config"
scrDir="$(dirname "$(realpath "$0")")" 
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"

#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
elem_border=$(( hypr_border * 3 ))


#// scale for monitor


mon_x_res=$(echo "local screen = require('awful').screen.focused(); local width = screen.geometry.width; local scale = screen.dpi / 96; local adjusted_width = math.floor(width * 100 / (scale * 100)); return adjusted_width" | awesome-client | awk '{print $2}' | tr -d '[:space:]') 


#// generate config

elm_width=$(( (28 + 8 + 5) * rofiScale ))
max_avail=$(( mon_x_res - (4 * rofiScale) ))
col_count=$(( max_avail / elm_width ))
r_override="window{width:100%;} listview{columns:${col_count};spacing:5em;} element{border-radius:${elem_border}px;orientation:vertical;} element-icon{size:28em;border-radius:0em;} element-text{padding:1em;}"


#// launch rofi menu

currentWall="$(basename "$(readlink "${hydeThemeDir}/wall.set")")"
wallPathArray=("${hydeThemeDir}")
wallPathArray+=("${wallAddCustomPath[@]}")
get_hashmap "${wallPathArray[@]}"

echo ${currentWall[@]}
echo ${wallPathArray[@]}


# Loop through the wallpaper hash list and display each image
for i in "${!wallList[@]}"; do
    # Get the image path from wallList
    imgPath="${wallList[$i]}"
    # Get the hash from wallHash (optional, but you can use it for reference)
    imgHash="${wallHash[$i]}"
    
    # Print the hash and image path (optional, for verbose output)
        # echo "Hash: ${imgHash}"
        # echo "Image: ${imgPath}"
    
    # Use chafa to display the image in the terminal
    # chafa --size=30x30 "$imgPath"  # You can adjust the size to your preference
done

rofiSel=$(parallel --link echo -en "\$(basename "{1}")"'\\x00icon\\x1f'"{2}"'\\n'   ::: "${wallList[@]}" ::: "${wallList[@]}"   | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${currentWall}")

echo "You Chelected $rofiSel"
#// apply wallpaper
if [ ! -z "${rofiSel}" ] ; then
    feh --bg-fill "$HOME/Pictures/wallpapers notify-send -a "t1" -i "${thmbDir}/$(set_hash "${setWall}").sqre" " ${rofiSel}""
fi

