#!/bin/sh

if [ -z $(pidof fuzzel) ]; then
    fuzzel --show drun "--launch-prefix=uwsm app --"
else
    pkill fuzzel
fi
