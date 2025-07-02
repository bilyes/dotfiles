#!/bin/sh

if [ -z $(pidof fuzzel) ]; then
    SEARCH_URL=https://duckduck.go/\?q\=
    QUERY=$(fuzzel --dmenu --prompt-only "󰖟 ") && firefox -P private "$SEARCH_URL$QUERY"
else
    pkill fuzzel
fi
