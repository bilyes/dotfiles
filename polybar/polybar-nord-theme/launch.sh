#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

ROOT=$HOME/.config/polybar/polybar-nord-theme

# Launch bar1 and bar2
if [ "$1" == "light" ]
then
	polybar -c $ROOT/light-config nord-top &
	#polybar -c $ROOT/light-config nord-down &
else
	polybar -c $ROOT/dark-config nord-top &
	#polybar -c $ROOT/dark-config nord-down &
fi

echo "Bars launched..."
