#!/bin/sh

pkill -x yad 2>/dev/null
sleep 0.1

yad --title="Power Menu" --center --fixed --borders=20 --skip-taskbar --gtkrc=$HOME/.config/yad/yad.css \
    --button=" Lock:1" \
    --button=" Suspend:2" \
    --button=" Logout:3" \
    --button=" Reboot:4" \
    --button=" Shutdown:5" \
    --text="<b>Choose an action:</b>" \
    --text-align=center

ACTION=$?

pkill -x yad 2>/dev/null
sleep 0.1

case $ACTION in
    1) hyprlock ;;
    2) systemctl suspend ;;
    3) hyprctl dispatch 'hl.dsp.exit()' ;;
    4) systemctl reboot ;;
    5) systemctl poweroff ;;
esac
