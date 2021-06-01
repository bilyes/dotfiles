# https://github.com/atweiden/fzf-extras/blob/master/fzf-extras.sh
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local IFS=$'\n'
  local files=()
  files=(
    "$(fzf-tmux \
          --query="$1" \
          --multi \
          --select-1 \
          --exit-0 \
          --preview="${FZF_PREVIEW_CMD}" \
          --preview-window='right:hidden:wrap' \
          --bind=ctrl-v:toggle-preview \
          --bind=ctrl-x:toggle-sort \
          --header='(view:ctrl-v) (sort:ctrl-x)'
    )"
  ) || return
  "${EDITOR:-vim}" "${files[@]}"
}

# fgl - git log browser
fgl() {
  local git_cmd
  local execute
  local fzf_cmd

  # %s: comment
  # %d: branch/tag
  # %h: hash
  # %cd: date
  # %an: author
  git_cmd='git log \
    --all \
    --graph \
    --date-order \
    --format=format:"%C(auto)%s %d %h %C(cyan)%cd %C(bold black)%an %C(auto)" \
    --date=short \
    --color=always'

  execute="grep -o '[a-f0-9]\{7\}' \
    | head -1 \
    | xargs -I % sh -c 'git show --color=always % | less -R'"

  fzf_cmd='fzf \
    --height=100% \
    --ansi \
    --reverse \
    --no-sort \
    --tiebreak=index \
    --bind=ctrl-x:toggle-sort'
  fzf_cmd="$fzf_cmd --bind \"ctrl-m:execute: ($execute) <<'FZF-EOF'
    {}
  FZF-EOF\""

  eval "$git_cmd | $fzf_cmd"
}

# fbr - checkout git branch (including remote branches)
#   - sorted by most recent commit
#   - limit 30 last branches
fgco() {
  local branches
  local num_branches
  local branch
  local target

  branches="$(
    git for-each-ref \
      --count=30 \
      --sort=-committerdate \
      refs/heads/ \
      --format='%(refname:short)'
  )" || return

  num_branches="$(wc -l <<< "$branches")"

  branch="$(
    echo "$branches" \
      | fzf-tmux -d "$((2 + $num_branches))" +m
  )" || return

  target="$(
    echo "$branch" \
      | sed "s/.* //" \
      | sed "s#remotes/[^/]*/##"
  )" || return

  git checkout "$target"
}


# fco - checkout git branch/tag
#fco() {
  #local tags
  #local branches
  #local target

  #tags="$(
    #git tag \
      #| awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
  #)" || return

  #branches="$(
    #git branch --all \
      #| grep -v HEAD \
      #| sed 's/.* //' \
      #| sed 's#remotes/[^/]*/##' \
      #| sort -u \
      #| awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
  #)" || return

  #target="$(
    #printf '%s\n%s' "$tags" "$branches" \
      #| fzf-tmux \
          #-l40 \
          #-- \
          #--no-hscroll \
          #--ansi \
          #+m \
          #-d '\t' \
          #-n 2 \
          #-1 \
          #-q "$*"
  #)" || return

  #git checkout "$(echo "$target" | awk '{print $2}')"
#}
