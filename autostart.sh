#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of AwesomeWM
# TODO: run_once


function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

# run picom -CGb &
# run nitrogen --restore & 
# run /usr/lib/polkit-kde-authentication-agent-1 &
run clipcatd --no-daemon &
# run xfce4-power-manager
run gammy
run dunst
run nm-applet
# run blueman-applet
rAaun ~/.fehbg
# run setxkbmap fr 

setxkbmap -layout us -variant bruh   
xrandr --output HDMI-0 --mode 1920x1080 --rate 100
