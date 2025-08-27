#!/usr/bin/env sh


if [ -f "${save_dir}/${save_file}" ]; then
	notify-send "WIW"
fi
XDG_CURRENT_DESKTOP=sway
flameshot gui



