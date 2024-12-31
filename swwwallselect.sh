#!/usr/bin/env sh


#// set variables

confDir="$HOME/.config"
scrDir="$(dirname "$(realpath "$0")")" 
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"

echo $confDir
echo $scrDir
echo $rofiConf

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



rofiSel=$(parallel --link echo -en "\$(basename "{1}")"'\\x00icon\\x1f'"${thmbDir}"'/'"{2}"'.sqre\\n' ::: "${wallList[@]}" ::: "${wallHash[@]}" ) # | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${currentWall}")


#// apply wallpaper

if [ ! -z "${rofiSel}" ] ; then
    for i in "${!wallPathArray[@]}" ; do
        setWall="$(find "${wallPathArray[i]}" -type f -name "${rofiSel}")"
        [ -z "${setWall}" ] || break
    done
    "${scrDir}/swwwallpaper.sh" -s "${setWall}"
    notify-send -a "t1" -i "${thmbDir}/$(set_hash "${setWall}").sqre" " ${rofiSel}"
fi

