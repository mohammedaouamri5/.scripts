#!/bin/bash

# Infinite loop to keep checking the battery status



notifide_20=false
notifide_10=false


while true; do
    # Get the battery percentage and charging status using acpi
    battery_info=$(acpi -b)

    # Extract the percentage and charging status
    battery_percentage=$(echo "$battery_info" | grep -oP '\d+(?=%)')
    charging_status=$(echo "$battery_info" | grep -oP '(Charging|Discharging|Not\ charging)')

    # Set the charging status icon
    charging_status_icon=
    if [[ "$charging_status" == "Charging" ]]; then
        charging_status_icon="󱐋"  # Icon for charging
    elif [[ "$charging_status" == "Not charging" ]]; then
         charging_status_icon="󰻷"  # Icon for not charging
    else
        charging_status_icon=" "  # Icon for discharging
    fi

    # Determine which icon to show based on the percentage
    if [ "$battery_percentage" -ge 100 ]; then
        echo "$charging_status_icon $battery_percentage%  | "  # Icon for full battery
    elif [ "$battery_percentage" -ge 90 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 90-99%
    elif [ "$battery_percentage" -ge 80 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 80-89%
    elif [ "$battery_percentage" -ge 70 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 70-79%
    elif [ "$battery_percentage" -ge 60 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 60-69%
    elif [ "$battery_percentage" -ge 50 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 50-59%
    elif [ "$battery_percentage" -ge 40 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 40-49%
    elif [ "$battery_percentage" -ge 30 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 30-39%
    elif [ "$battery_percentage" -ge 20 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 20-29%
            notifide_20=false
    elif [ "$battery_percentage" -ge 10 ]; then
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery 10-19%
        if ! $notifide_20; then
            notify-send " your battery is $battery_percentage"
            notifide_20=true
        fi
            notifide_10=false
    else
        echo "$charging_status_icon $battery_percentage%  |"  # Icon for battery alert (5% or less)
        if ! $notifide_10; then
            notify-send " your battery is $battery_percentage"
            notifide_10=true
        fi
    fi




    # Sleep for 5 seconds before updating again
    sleep 0.6
done
