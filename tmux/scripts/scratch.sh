#!/usr/bin/env bash
#
# scratch.sh CLIENT
#
# Slides the scratch session down from the top of CLIENT's window, in a popup for one-off
# commands that keep running once it's hidden, and dims the panes behind it. When the scratch
# shell is still busy with an earlier command, the session gets a new window first, so the popup
# always opens on a prompt.
#
# The session lives on its own tmux server (socket "scratch"), which keeps it out of session
# cycling and the prefix f launcher. That server loads the same tmux.conf, where the binding that
# runs this script detaches instead, closing the popup. zsh/conf.d/tmux-scratch.zsh sends a
# desktop notification when a command there fails.
#
# The popup is a modal floating pane rather than a display-popup, since only a pane can be moved
# once it's open. Like a display-popup, it keeps every key, the prefix included, for itself.
#
# Requires: tmux 3.8+ (floating panes).

set -euo pipefail

WIDTH_PERCENT=70
HEIGHT_PERCENT=50
# How much darker the panes behind the popup get
DIM_PERCENT=40
# Steps of the slide, slowing down towards the end
FRAMES=8

client=$1
scratch=(tmux -L scratch)

if "${scratch[@]}" has-session -t =scratch 2>/dev/null; then
    busy=$("${scratch[@]}" display-message -p -t =scratch: \
        '#{!=:#{pane_current_command},#{b:default-shell}}')
    (( ! busy )) || "${scratch[@]}" new-window -t =scratch:
fi

read -r pane window window_width window_height < <(tmux display-message -p -c "$client" \
    '#{pane_id} #{window_id} #{window_width} #{window_height}')
width=$(( window_width * WIDTH_PERCENT / 100 ))
height=$(( window_height * HEIGHT_PERCENT / 100 ))
# As far up as new-pane allows: it keeps the bottom border and the last line on screen
start=$(( 2 - height ))

# window-style only styles inactive panes, and the modal popup is the active one, so this dims
# every pane behind it. The popup's command lifts it once the session inside detaches.
dimmed="$(tmux show-options -gwv window-style),dim=$DIM_PERCENT"

# -O modal, -K every key to it, -A above a zoomed pane. It opens at its final size, so the
# session inside is drawn once, and only moves after that.
popup=$(tmux set-option -w -t "$window" window-style "$dimmed" \; \
    new-pane -t "$pane" -OKA -x "$width" -y "$height" \
    -X $(( (window_width - width) / 2 )) -Y "$start" -P -F '#{pane_id}' -- \
    sh -c 'window=$1; shift; "$@"; tmux set-option -wu -t "$window" window-style' \
    sh "$window" "${scratch[@]}" new-session -A -s scratch) \
    || { tmux set-option -wu -t "$window" window-style; exit 1; }
tmux set-option -p -t "$popup" pane-border-status top \; \
    set-option -p -t "$popup" pane-border-format ' scratch '

for (( frame = 1; frame <= FRAMES; frame++ )); do
    sleep 0.01
    left=$(( FRAMES - frame ))
    # Hiding it before the slide ends closes the pane
    tmux move-pane -t "$popup" -Y $(( start * left * left / (FRAMES * FRAMES) )) 2>/dev/null \
        || exit 0
done
