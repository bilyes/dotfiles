#!/usr/bin/env bash
#
# sysstat.sh [HIGH_COLOR NORMAL_COLOR]
#
# Prints CPU, RAM and GPU usage and the CPU temperature on one line, each after a Nerd Font
# glyph, for the status bar module in tmux/status/sysstat.conf. A reading at or above its
# threshold below turns HIGH_COLOR, then the text goes back to NORMAL_COLOR.
#
# macmon (brew install macmon) gives all four in one sample, without sudo. Without it, or when it
# fails, CPU comes from iostat, RAM from vm_stat and GPU from ioreg, and the temperature is left
# out: macOS has no built-in way to read it without sudo. Any reading that can't be had is left
# out, so the status bar never shows an error.
#
# macOS only for now: prints nothing elsewhere.

set -euo pipefail

# Percentage and degrees Celsius from which a reading turns HIGH_COLOR
USAGE_HIGH=80
TEMP_HIGH=90

high_color=${1:-}
normal_color=${2:-}

[[ $(uname -s) == Darwin ]] || exit 0

cpu='' ram='' gpu='' temp=''

# One sample, over macmon's default 1s interval. "-" stands in for a missing reading (null): read
# would skip an empty field and shift the ones after it.
if command -v macmon > /dev/null \
    && values=$(macmon pipe -s 1 2> /dev/null | jq -r '[
        .cpu_active_ratio * 100,
        .memory.ram_usage / .memory.ram_total * 100,
        .gpu_active_ratio * 100,
        .temp.cpu_temp_avg
    ] | map(if . == null then "-" else round end) | @tsv' 2> /dev/null); then
    read -r cpu ram gpu temp <<< "$values" || true
fi

if [[ -z $cpu ]]; then
    # Of iostat's two reports, the first covers the time since boot and the second the last second
    cpu=$(iostat -n 0 -c 2 -w 1 | awk 'END { print 100 - $3 }') || true
fi
if [[ -z $ram ]]; then
    # Used memory as macmon counts it: wired, compressed, and the active, inactive and speculative
    # pages, less the purgeable and file-backed (cache) ones
    ram=$(vm_stat | awk -v total="$(sysctl -n hw.memsize)" '
        /page size of/ { page = $8 }
        /^Pages (active|inactive|speculative|wired down|occupied by compressor):/ { used += $NF }
        /^(Pages purgeable|File-backed pages):/ { used -= $NF }
        END { printf "%.0f", used * page / total * 100 }') || true
fi
if [[ -z $gpu ]]; then
    # The busiest GPU, should there be more than one
    gpu=$(ioreg -r -d 1 -c IOAccelerator | awk '
        /"Device Utilization %"=/ {
            sub(/.*"Device Utilization %"=/, "")
            if (!found || $0 + 0 > max) max = $0 + 0
            found = 1
        }
        END { if (found) print max }') || true
fi

# Appends GLYPH VALUE UNIT to $line, unless VALUE isn't a number. VALUE is padded to two digits
# so the status bar module keeps its width.
line=''
add() {
    local glyph=$1 value=$2 unit=$3 threshold=$4 text
    [[ $value =~ ^[0-9]+$ ]] || return 0
    printf -v text '%2d%s' "$value" "$unit"
    if [[ -n $high_color && -n $normal_color ]] && (( value >= threshold )); then
        text="#[fg=$high_color]$text#[fg=$normal_color]"
    fi
    line+="${line:+  }$glyph $text"
}

add "" "$cpu" % "$USAGE_HIGH"
add "" "$ram" % "$USAGE_HIGH"
add "󰢮" "$gpu" % "$USAGE_HIGH"
add "󰔏" "$temp" ° "$TEMP_HIGH"
echo "$line"
