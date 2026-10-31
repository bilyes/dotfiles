#!/bin/sh
# Export the current Noctalia user config into the dotfiles repo.
#
# Machine-specific values are stripped on purpose: location, wallpaper paths
# and the plugin search folder stay in the local state layer
# (~/.local/state/noctalia/settings.toml) and are re-created per machine.
#
# Usage: ~/.config/dotfiles/scripts/noctalia-export.sh
# Result: ~/.config/dotfiles/noctalia/config.toml

set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
out_dir="$repo_dir/noctalia"
out="$out_dir/config.toml"

command -v noctalia >/dev/null 2>&1 || {
    echo "noctalia: command not found" >&2
    exit 1
}

mkdir -p "$out_dir"

raw=$(mktemp)
filtered=$(mktemp)
trap 'rm -f "$raw" "$filtered"' EXIT

noctalia config export merged > "$raw"

# Drop [location], [wallpaper] (including sub-tables) and search_folder.
awk '
    /^[[:space:]]*\[/ {
        name = $0
        sub(/^[[:space:]]*\[/, "", name)
        sub(/[."].*$/, "", name)
        sub(/\]$/, "", name)
        drop = (name == "location" || name == "wallpaper")
    }
    drop { next }
    /^[[:space:]]*search_folder[[:space:]]*=/ { next }
    { print }
' "$raw" > "$filtered"

if grep -qE '/home/' "$filtered"; then
    echo "warning: machine-specific values remain in the export:" >&2
    grep -nE '/home/' "$filtered" >&2
fi

noctalia config validate "$filtered"
mv "$filtered" "$out"

echo "wrote $out"