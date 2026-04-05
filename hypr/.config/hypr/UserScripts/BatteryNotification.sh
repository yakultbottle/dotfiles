#!/bin/bash

LOW_BAT=25
HIGH_BAT=80

notified_low=false
notified_high=false

while true; do
    bat_lvl=$(cat /sys/class/power_supply/BAT0/capacity)
    bat_status=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$bat_status" = "Discharging" ] && [ "$bat_lvl" -le "$LOW_BAT" ]; then
        if [ "$notified_low" = false ]; then
            notify-send -u critical "Low Battery" "Battery is at $bat_lvl%."
            notified_low=true
        fi
    else
        notified_low=false
    fi

    if [ "$bat_status" = "Charging" ] && [ "$bat_lvl" -ge "$HIGH_BAT" ]; then
        if [ "$notified_high" = false ]; then
            notify-send -u normal "Battery Optimized" "Battery is at $bat_lvl%."
            notified_high=true
        fi
    else
        notified_high=false
    fi

    sleep 60
done
