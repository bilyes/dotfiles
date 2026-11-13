function drmi() {
  if [[ -z "$1" ]]; then
    echo "Please provide a string to use when matching image names. Usage: drmi my-img"
    return 1
  fi

  # Each ID once: an image is listed once per matching tag
  local ids
  ids=(${(uf)"$(docker images --format "{{ .ID }}" --filter "reference=$1*")"}) || return
  if (( ! ${#ids} )); then
    echo "No images match '$1*'"
    return 1
  fi

  docker rmi -f "${ids[@]}"
}

# bak FILE... - copy each FILE to FILE.bak.<timestamp>, the name install.sh gives its backups
function bak() {
  if (( ! $# )); then
    echo "Please provide the files to back up. Usage: bak FILE..."
    return 1
  fi

  local file stamp
  stamp=$(date +%Y%m%d%H%M%S)
  for file in "$@"; do
    # Without the trailing slash, so `bak dir/` copies to dir.bak.<timestamp>, not inside dir
    file=${file%/}
    cp -a -- "$file" "$file.bak.$stamp" || return
  done
}

# port PORT - show the processes listening on TCP port PORT
#   - only your own processes, unless run with sudo
function port() {
  if [[ -z "$1" ]]; then
    echo "Please provide a port number. Usage: port 3000"
    return 1
  fi

  lsof -nP -iTCP:"$1" -sTCP:LISTEN || { echo "Nothing is listening on port $1"; return 1; }
}

# t [tmux arguments] - tmux; without arguments, attach to the last session or start one
#   - inside tmux, pick a session instead (attaching there would nest tmux)
function t() {
  if (( $# )); then
    tmux "$@"
  elif [[ -n "$TMUX" ]]; then
    tmux choose-tree -s
  else
    tmux attach 2>/dev/null || tmux new-session
  fi
}
