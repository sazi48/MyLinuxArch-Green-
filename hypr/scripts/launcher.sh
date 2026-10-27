#!/bin/sh

if pgrep -x "wofi" > /dev/null; then
    pkill -x "wofi"
    exit 0
fi


wofi --show drun --normal-window --width 600 --height 400
