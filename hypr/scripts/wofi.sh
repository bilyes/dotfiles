#!/bin/sh

if [ -z $(pidof wofi) ]; then
    wofi --show drun
else
    pkill wofi
fi
