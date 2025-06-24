#!/bin/sh

if [ -z $(pidof fuzzel) ]; then
    fuzzel --show drun
else
    pkill fuzzel
fi
