#!/usr/bin/env bash
#
# launcher.sh CLIENT
#
# Fuzzy-finds every pane across every session, with a live preview of its
# contents, in a popup centered on CLIENT's window. Enter jumps to the picked
# pane (switching sessions/windows as needed); Esc cancels.
#
# tmux.conf binds it to prefix f through run-shell -b: without -b, tmux would
# hold the client's keys until the script exits, so they'd never reach the popup.
#
# Requires: tmux 3.8+ (list-panes -F) and fzf 0.60+.

set -euo pipefail

client=$1

list=$(mktemp)
pick=$(mktemp)
trap 'rm -f "$list" "$pick"' EXIT

# One line per pane: hidden pane id, then a human-readable label that doubles as
# the fuzzy-search text.
tab=$'\t'
tmux list-panes -a -F \
    "#{pane_id}${tab}#{session_name}  #{window_index}:#{window_name}  pane #{pane_index}  #{pane_current_command}  #{pane_title}  #{pane_current_path}" \
  > "$list"

fzf_opts=(
    --layout reverse --style full
    --delimiter "$tab" --with-nth 2 --accept-nth 1
    --input-label ' Panes (session / window / pane) '
    --preview 'tmux capture-pane -p -e -S -80 -t {1}'
    --preview-window 'right,60%,wrap,noinfo'
    --preview-label ' Pane content '
)

tmux display-popup -c "$client" -E -B -w 92% -h 80% -- \
    sh -c 'list=$1 pick=$2; shift 2; fzf "$@" < "$list" > "$pick"' sh "$list" "$pick" "${fzf_opts[@]}" \
  || true

[[ -s $pick ]] || exit 0
IFS="${tab}" read -r pane_id _rest < "$pick"

session=$(tmux display-message -p -t "$pane_id" '#{session_name}')
window=$(tmux display-message -p -t "$pane_id" '#{window_id}')
tmux switch-client -c "$client" -t "$session" \; select-window -t "$window" \; select-pane -t "$pane_id"