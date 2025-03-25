#!/bin/sh

rofi -show drun \
    -theme-str 'configuration { icon-theme: "Tela-circle-purple"; }' \
    -theme-str 'window { border: 1px; border-radius: 10px; }' \
    -theme-str 'element { border-radius: 100px; }' \
    -config ~/.config/rofi/styles/style_4.rasi
