#!/bin/sh

WORKSPACES=$(hyprctl workspaces -j | grep -o '"id": [0-9]*' | awk '{print $2}' | sort -n)
CURRENT=$(hyprctl activeworkspace -j | grep -o '"id": [0-9]*' | head -n1 | awk '{print $2}')

if [ "$CURRENT" -le 0 ] 2>/dev/null; then
    CURRENT=0
fi

if [ "$1" = "next" ]; then
    NEXT=$(echo "$WORKSPACES" | awk -v cur="$CURRENT" '$1 > cur {print; exit}')
    if [ -z "$NEXT" ]; then NEXT=$(echo "$WORKSPACES" | head -n1); fi
    hyprctl dispatch "hl.dsp.focus({ workspace = $NEXT })"

elif [ "$1" = "prev" ]; then
    PREV=$(echo "$WORKSPACES" | awk -v cur="$CURRENT" '$1 < cur {last=$1} END {print last}')
    if [ -z "$PREV" ]; then PREV=$(echo "$WORKSPACES" | tail -n1); fi
    hyprctl dispatch "hl.dsp.focus({ workspace = $PREV })"
fi
