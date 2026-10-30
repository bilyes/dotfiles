#!/usr/bin/env bash
#
# keybinds.sh CLIENT
#
# Fuzzy-finds the tmux bindings that have a description (bind-key -N), copy-mode ones included,
# in a popup centered on CLIENT's window, with the highlighted binding's command shown below the
# list. Enter runs the picked binding as if its keys were typed; Esc runs nothing.
#
# tmux.conf binds it to prefix ? through run-shell -b: without -b, tmux would hold the client's
# keys until the script exits, so they'd never reach the popup.
#
# Requires: tmux 3.8+ (list-keys -F) and fzf 0.60+ (--accept-nth).

set -euo pipefail

client=$1
tab=$'\t'

read -r width pane < <(tmux display-message -p -c "$client" '#{window_width} #{pane_id}')
# 78 columns fit the longest description, but tmux refuses a popup wider than the window
(( width <= 78 )) || width=78

list=$(mktemp)
pick=$(mktemp)
trap 'rm -f "$list" "$pick"' EXIT

# One line per binding: table, key, label and description (padded into columns), command
for table in prefix root copy-mode-vi; do
    case $table in
        prefix) label='#{key_prefix} ' ;;
        root) label='' ;;
        copy-mode-vi) label='copy-mode ' ;;
    esac
    tmux list-keys -N -T "$table" \
        -F "#{key_table}$tab#{key_string}$tab$label#{key_string}$tab#{key_note}$tab#{key_command}"
done | awk -F '\t' -v OFS='\t' '
    { line[NR] = $0; if (length($3) > width) width = length($3) }
    END {
        for (i = 1; i <= NR; i++) {
            split(line[i], f, "\t")
            print f[1], f[2], sprintf("%-" width "s  %s", f[3], f[4]), f[5]
        }
    }' > "$list"

fzf_opts=(
    --layout reverse --style full --input-label ' Key bindings ' --info inline-right
    --delimiter '\t' --with-nth 3 --accept-nth 1,2
    --preview "printf '%s\n' {4}" --preview-window down,2,wrap-word,noinfo --preview-label ' Command '
)
# Several arguments make tmux run the popup's command without a shell, so fzf's options need no
# quoting; sh is only there for the redirections. display-popup returns once the popup closes, with
# fzf's exit status, which isn't 0 after Esc.
tmux display-popup -c "$client" -E -B -w "$width" -h 60% -- \
    sh -c 'list=$1 pick=$2; shift 2; fzf "$@" < "$list" > "$pick"' sh "$list" "$pick" "${fzf_opts[@]}" \
    || true

[[ -s $pick ]] || exit 0
IFS=$tab read -r table key < "$pick"
# A lone ; would end the tmux command
[[ $key != ';' ]] || key='\;'

# Copy-mode keys only do something in copy mode; copy-mode leaves a pane already in it as it is
case $table in
    copy-mode-vi) enter=(copy-mode -t "$pane") ;;
    *) enter=(switch-client -c "$client" -T "$table") ;;
esac
tmux "${enter[@]}" \; send-keys -c "$client" -K "$key"
