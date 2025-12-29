#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .cache --ignore .npm --ignore .cargo --ignore .yarn --ignore .steam --ignore .electron-gyp --ignore .wine --ignore "*.otf" --ignore "*.png" --ignore "*.jpg" -f -g "" --depth 10' # requires silversearch-ag
#export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!{.git, .cache, .npm, .cargo, .yarn, .steam, .electron-gyp, .wine, *.otf, *.png, *.jpg}" --max-depth 10' # requires ripgrep
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude ".cache" --exclude ".npm" --exclude ".cargo" --exclude ".yarn" --exclude ".steam" --exclude ".electron-gyp" --exclude ".wine" --exclude ".vim" --exclude "*.otf" --exclude "*.png" --exclude "*.jpg" --max-depth 10' # requires fd (fd-find)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_PREVIEW_CMD="cat {}"
source <(fzf --zsh)

# https://github.com/atweiden/fzf-extras/blob/master/fzf-extras.sh
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local IFS=$'\n'
  local files=()
  files=(
    "$(fzf \
          --height=40% \
          --query="$1" \
          --multi \
          --select-1 \
          --exit-0 \
          --layout=reverse \
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

fco() {
    git checkout $(git for-each-ref refs/heads/ --format='%(refname:short)' | fzf)
}

fcn() {
  local IFS=$'\n'
  local namespaces=()
  namespaces=(
    "$(kubectl get ns --no-headers -o custom-columns=name:.metadata.name | fzf \
          --height=40% \
          --query="$1" \
          --select-1 \
          --exit-0 \
          --layout=reverse
    )"
  ) || return
  kubectl config set-context --current --namespace "${namespaces[@]}"
}

fip() {
  fzf_args=(
    --multi
    --preview 'pacman -Sii {1}'
    --preview-label='alt-p: toggle description, alt-j/k: scroll, tab: multi-select'
    --preview-label-pos='bottom'
    --preview-window 'down:65%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --color 'pointer:green,marker:green'
  )
  
  pkg_names=$(pacman -Slq | fzf "${fzf_args[@]}")
  
  if [[ -n "$pkg_names" ]]; then
    # Convert newline-separated selections to space-separated for yay
    #echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -S --noconfirm
    sudo pacman -S $(echo "$pkg_names" | tr '\n' ' ')
  fi
}

fiap() {
  fzf_args=(
    --multi
    --preview 'yay -Siia {1}'
    --preview-label='alt-p: toggle description, alt-b/B: toggle PKGBUILD, alt-j/k: scroll, tab: multi-select'
    --preview-label-pos='bottom'
    --preview-window 'down:65%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --bind 'alt-b:change-preview:yay -Gpa {1} | tail -n +5'
    --bind 'alt-B:change-preview:yay -Siia {1}'
    --color 'pointer:green,marker:green'
  )
  
  pkg_names=$(yay -Slqa | fzf "${fzf_args[@]}")
  
  if [[ -n "$pkg_names" ]]; then
    # Convert newline-separated selections to space-separated for yay
    #echo "$pkg_names" | tr '\n' ' ' | xargs yay -S --noconfirm
    yay -S $(echo "$pkg_names" | tr '\n' ' ')
  fi
}

frp() {
  fzf_args=(
    --multi
    --preview 'yay -Qi {1}'
    --preview-label='alt-p: toggle description, alt-j/k: scroll, tab: multi-select'
    --preview-label-pos='bottom'
    --preview-window 'down:65%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --color 'pointer:red,marker:red'
  )
  
  pkg_names=$(yay -Qqe | fzf "${fzf_args[@]}")
  
  if [[ -n "$pkg_names" ]]; then
    # Convert newline-separated selections to space-separated for yay
    #echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -Rns --noconfirm
    sudo pacman -Rns $(echo "$pkg_names" | tr '\n' ' ')
  fi
}
