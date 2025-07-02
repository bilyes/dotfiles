#!/bin/sh

# Set the path to your documents directory
DOCS=

if [ -z $(pidof fuzzel) ]; then
    xdg-open $(fd -e ods -e odt -e pdf . $DOCS | fuzzel --dmenu --counter --prompt "󰈞 ")
else
    pkill fuzzel
fi
