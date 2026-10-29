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
