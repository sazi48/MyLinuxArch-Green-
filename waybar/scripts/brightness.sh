#!/bin/sh
CUR=$(brightnessctl g)
MAX=$(brightnessctl m)
STEP=$((MAX / 100))

if [ "$1" = "up" ]; then
    NEW=$((CUR + STEP))
    if [ "$NEW" -gt "$MAX" ]; then NEW=$MAX; fi
    brightnessctl set $NEW
elif [ "$1" = "down" ]; then
    NEW=$((CUR - STEP))
    if [ "$NEW" -lt 0 ]; then NEW=0; fi
    brightnessctl set $NEW
fi
