#!/usr/bin/env bash
#
# center-wide.sh
#
# Lays out the focused workspace's 3 windows side by side, with the middle window
# a third wider than each outer one: 30% / 40% / 30% of the width left after gaps.
# Works from any starting arrangement (nested, stacked, floating) and with any gaps.
#
# Requires: aerospace. Window positions are read with osascript (JXA), part of macOS.

set -euo pipefail

AEROSPACE=/opt/homebrew/bin/aerospace

# The middle window is CENTER_NUM / CENTER_DEN times as wide as each outer window.
CENTER_NUM=4
CENTER_DEN=3

fail() {
    osascript -e "display notification \"$1\" with title \"center-wide\"" &>/dev/null || true
    exit 1
}

# Prints "<window id> <x>" (in points) for each given window that's on screen.
window_positions() {
    osascript -l JavaScript -e '
        ObjC.import("CoreGraphics");
        function run(argv) {
            var ids = argv.map(Number);
            // kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID
            var windows = ObjC.deepUnwrap(ObjC.castRefToObject($.CGWindowListCopyWindowInfo(1 | 16, 0)));
            return windows
                .filter(function (w) { return ids.indexOf(w.kCGWindowNumber) !== -1; })
                .map(function (w) { return w.kCGWindowNumber + " " + Math.round(w.kCGWindowBounds.X); })
                .join("\n");
        }' "$@"
}

count=$("$AEROSPACE" list-windows --workspace focused --count)
[[ $count -eq 3 ]] || fail "Found $count window(s); this layout needs exactly 3."

# One row of three tiled windows with equal weights. AeroSpace's layout command
# exits 1 when there's nothing to change, so only run it when needed.
ids=()
while read -r id layout; do
    ids+=("$id")
    if [[ $layout == floating ]]; then
        "$AEROSPACE" layout tiling --window-id "$id"
    fi
done <<< "$("$AEROSPACE" list-windows --workspace focused --format '%{window-id} %{window-layout}')"
"$AEROSPACE" flatten-workspace-tree
layouts=$("$AEROSPACE" list-windows --workspace focused --format '%{window-layout}')
if [[ ${layouts%%$'\n'*} != h_tiles ]]; then
    "$AEROSPACE" layout h_tiles --window-id "${ids[0]}"
fi
"$AEROSPACE" balance-sizes

# Read the positions back once two consecutive reads agree, i.e. the layout settled
positions="" previous=""
for _ in 1 2 3 4 5 6 7 8 9 10; do
    positions=$(window_positions "${ids[@]}" | sort -n -k2)
    [[ -n $positions && $positions == "$previous" ]] && break
    previous=$positions
    sleep 0.05
done
[[ $(grep -c . <<< "$positions") -eq 3 ]] \
    || fail "Couldn't read the positions of all 3 windows (minimized or hidden?)."
read -r _ left_x center_id center_x _ right_x <<< "$(tr '\n' ' ' <<< "$positions")"

# Work from positions, not widths: an app with a minimum width can ignore the size
# it's given, but it still sits where AeroSpace puts it. AeroSpace starts each window
# where the previous one's weight ends, shifted by half an inner gap, then trims half
# a gap from each outer window and a full gap from the middle one. With equal
# weights, middle-to-right is a third of the row and left-to-middle adds half a gap.
third=$(( right_x - center_x ))
inner_gap=$(( 2 * (center_x - left_x - third) ))
(( inner_gap > 0 )) || inner_gap=0
frames_total=$(( 3 * third - 2 * inner_gap ))
target_side_w=$(( frames_total * CENTER_DEN / (2 * CENTER_DEN + CENTER_NUM) ))
target_center_w=$(( frames_total - 2 * target_side_w ))

# The middle window's weight is its frame width plus one gap. Setting it takes the
# difference evenly from the other two, so after balance-sizes one resize is enough.
"$AEROSPACE" resize width $(( target_center_w + inner_gap )) --window-id "$center_id"
