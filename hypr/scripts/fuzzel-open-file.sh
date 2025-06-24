#!/bin/sh

if [ -z $(pidof fuzzel) ]; then
    xdg-open $(fd -e ods -e odt -e pdf . ~/documents/ | fuzzel --dmenu --counter)
else
    pkill fuzzel
fi
