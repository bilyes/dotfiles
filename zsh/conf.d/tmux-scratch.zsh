# Desktop notification when a command fails in tmux's scratch popup (tmux/scripts/scratch.sh).
# Its shells run on the tmux server whose socket is named "scratch", which $TMUX starts with.
# On macOS, the notification comes from Script Editor, which needs notifications allowed.
[[ $TMUX == */scratch,* ]] || return 0

function _scratch_preexec() {
  _scratch_cmd=$1
}

function _scratch_precmd() {
  local code=$? cmd=$_scratch_cmd
  # An empty line keeps the previous status, so only report right after a command ran
  _scratch_cmd=
  [[ -n $cmd ]] || return 0
  # 130 and 148: interrupted with Ctrl-C or suspended with Ctrl-Z
  (( code != 0 && code != 130 && code != 148 )) || return 0

  cmd=${cmd//$'\n'/ }
  (( ${#cmd} <= 100 )) || cmd="${cmd[1,99]}…"
  local message="$cmd exited $code"
  if [[ $OSTYPE == darwin* ]]; then
    # Through argv, so quotes in the command can't break the AppleScript
    osascript -e 'on run argv' \
      -e 'display notification (item 1 of argv) with title "tmux scratch" sound name "Basso"' \
      -e 'end run' "$message" &>/dev/null &!
  elif (( $+commands[notify-send] )); then
    notify-send -a "tmux scratch" "tmux scratch" "$message" &>/dev/null &!
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _scratch_preexec
add-zsh-hook precmd _scratch_precmd
