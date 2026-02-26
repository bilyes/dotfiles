#!/usr/bin/env bash
#
# center-wide.sh
#
# Resizes a 3-column horizontal tile layout to 25% / 50% / 25% proportions.
# Windows are sorted left-to-right by their actual on-screen X position.
#
# Requires: aerospace, swift (bundled with Xcode CLT), python3

set -euo pipefail

AEROSPACE=/opt/homebrew/bin/aerospace

# ── 1. Get focused workspace's window IDs ──
windows=$("$AEROSPACE" list-windows --workspace focused --json)
count=$(echo "$windows" | python3 -c "import json,sys; print(len(json.load(sys.stdin)))")

if [[ "$count" -ne 3 ]]; then
    osascript -e "display notification \"Found $count window(s) — need exactly 3 for 30/40/30 layout.\" with title \"center-wide\"" &>/dev/null
    exit 1
fi

# Collect the aerospace window IDs on this workspace
aerospace_ids=$(echo "$windows" | python3 -c "
import json, sys
for w in json.load(sys.stdin):
    print(w['window-id'])
")

# ── 2. Sort window IDs left-to-right by actual X position via CGWindowList ──
sorted_ids=$(swift -e "
import AppKit

let aerospaceIds: Set<Int> = Set([$(echo "$aerospace_ids" | tr '\n' ',' | sed 's/,$//')]) 

let windowList = CGWindowListCopyWindowInfo(
    [.optionOnScreenOnly, .excludeDesktopElements],
    kCGNullWindowID
) as! [[String: Any]]

var matches: [(id: Int, x: CGFloat)] = []
for w in windowList {
    guard let wid = w[kCGWindowNumber as String] as? Int,
          aerospaceIds.contains(wid),
          let bounds = w[kCGWindowBounds as String] as? [String: CGFloat],
          let x = bounds[\"X\"] else { continue }
    matches.append((id: wid, x: x))
}

matches.sort { \$0.x < \$1.x }
for m in matches { print(m.id) }
" 2>/dev/null)

sorted_count=$(echo "$sorted_ids" | wc -l | tr -d ' ')
if [[ "$sorted_count" -ne 3 ]]; then
    osascript -e "display notification \"Could not resolve positions for all 3 windows (got $sorted_count).\" with title \"center-wide\"" &>/dev/null
    exit 1
fi

id_left=$(echo   "$sorted_ids" | sed -n '1p')
id_center=$(echo "$sorted_ids" | sed -n '2p')
id_right=$(echo  "$sorted_ids" | sed -n '3p')

# ── 3. Get focused monitor's pixel width ──
monitor_name=$("$AEROSPACE" list-monitors --focused --json | python3 -c "import json,sys; print(json.load(sys.stdin)[0]['monitor-name'])")

monitor_w=$(swift -e "
import AppKit
let target = \"$monitor_name\"
for screen in NSScreen.screens {
    if screen.localizedName == target {
        print(Int(screen.frame.size.width))
    }
}
" 2>/dev/null)

if [[ -z "$monitor_w" ]]; then
    osascript -e "display notification \"Could not determine monitor width for: $monitor_name\" with title \"center-wide\"" &>/dev/null
    exit 1
fi

# ── 4. Compute pixel widths (accounting for gaps) ──
# inner.horizontal gap is applied between windows (2 gaps for 3 columns)
inner_gap=$("$AEROSPACE" config --get gaps.inner.horizontal 2>/dev/null || echo 0)
outer_left=$("$AEROSPACE" config --get gaps.outer.left 2>/dev/null || echo 0)
outer_right=$("$AEROSPACE" config --get gaps.outer.right 2>/dev/null || echo 0)

usable_w=$((monitor_w - outer_left - outer_right - 2 * inner_gap))

w_side=$(( usable_w * 30 / 100 ))
w_center=$(( usable_w - 2 * w_side ))

# ── 5. Apply sizes ──
"$AEROSPACE" resize width "$w_side"   --window-id "$id_left"
"$AEROSPACE" resize width "$w_center" --window-id "$id_center"
"$AEROSPACE" resize width "$w_side"   --window-id "$id_right"
