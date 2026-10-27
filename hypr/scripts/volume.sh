#!/bin/sh
case $1 in
    up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+ ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%- ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac
