#!/usr/bin/env bash
#
# scratch.sh CLIENT
#
# Shows the scratch session in a popup on CLIENT, for one-off commands that keep running once the
# popup is hidden. When the scratch shell is still busy with an earlier command, the session gets
# a new window first, so the popup always opens on a prompt.
#
# The session lives on its own tmux server (socket "scratch"), which keeps it out of session
# cycling and the prefix f launcher. That server loads the same tmux.conf, where the binding that
# runs this script detaches instead, closing the popup. zsh/conf.d/tmux-scratch.zsh sends a
# desktop notification when a command there fails.
#
# tmux.conf binds it to prefix S through run-shell -b: without -b, tmux would hold the client's
# keys until the script exits, so they'd never reach the popup.
#
# Requires: tmux 3.8+.

set -euo pipefail

client=$1
scratch=(tmux -L scratch)

if "${scratch[@]}" has-session -t =scratch 2>/dev/null; then
    busy=$("${scratch[@]}" display-message -p -t =scratch: \
        '#{!=:#{pane_current_command},#{b:default-shell}}')
    (( ! busy )) || "${scratch[@]}" new-window -t =scratch:
fi

tmux display-popup -c "$client" -E -w 80% -h 80% -T ' scratch ' -- \
    "${scratch[@]}" new-session -A -s scratch
