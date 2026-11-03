#!/bin/sh
# Export the current Noctalia user config into the dotfiles repo.
#
# Machine-specific values are stripped on purpose: location, wallpaper paths
# and the plugin search folder stay in the local state layer
# (~/.local/state/noctalia/settings.toml) and are re-created per machine.
# The lock screen layout is left out too: it's in lockscreen.toml, which the
# merged export includes.
#
# Usage: ~/.config/noctalia/scripts/export.sh
# Result: ~/.config/noctalia/config.toml

set -eu

config_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
out="$config_dir/config.toml"

command -v noctalia >/dev/null 2>&1 || {
    echo "noctalia: command not found" >&2
    exit 1
}

raw=$(mktemp)
filtered=$(mktemp)
trap 'rm -f "$raw" "$filtered"' EXIT

noctalia config export merged > "$raw"

# Drop [location], [wallpaper], [lockscreen_widgets] (including sub-tables) and
# search_folder, and round float noise like 0.74999998323619366 to 0.75,
# keeping whole numbers floats (2.0).
awk '
    /^[[:space:]]*\[/ {
        name = $0
        sub(/^[[:space:]]*\[/, "", name)
        sub(/[."].*$/, "", name)
        sub(/\]$/, "", name)
        drop = (name == "location" || name == "wallpaper" || name == "lockscreen_widgets")
    }
    drop { next }
    /^[[:space:]]*search_folder[[:space:]]*=/ { next }
    /=[[:space:]]*-?[0-9]+\.[0-9]+[[:space:]]*$/ {
        split($NF, parts, ".")
        if (length(parts[2]) >= 10) {
            rounded = sprintf("%.6g", $NF)
            if (rounded !~ /[.e]/) rounded = rounded ".0"
            sub(/-?[0-9]+\.[0-9]+[[:space:]]*$/, rounded)
        }
    }
    { print }
' "$raw" > "$filtered"

if grep -qE '/home/' "$filtered"; then
    echo "warning: machine-specific values remain in the export:" >&2
    grep -nE '/home/' "$filtered" >&2
fi

noctalia config validate "$filtered"
mv "$filtered" "$out"

echo "wrote $out"