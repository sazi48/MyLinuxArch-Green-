#!/bin/sh
CUR=$(brightnessctl g)
MAX=$(brightnessctl m)
PERCENT=$((CUR * 100 / MAX))
echo " $PERCENT%"
