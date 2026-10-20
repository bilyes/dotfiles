#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .cache --ignore .npm --ignore .cargo --ignore .yarn --ignore .steam --ignore .electron-gyp --ignore .wine --ignore "*.otf" --ignore "*.png" --ignore "*.jpg" -f -g "" --depth 10' # requires silversearch-ag
#export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!{.git, .cache, .npm, .cargo, .yarn, .steam, .electron-gyp, .wine, *.otf, *.png, *.jpg}" --max-depth 10' # requires ripgrep

# Directories to exclude from fzf file/dir listings
_fzf_exclude_dirs=(.git .cache .npm .cargo .yarn node_modules .steam .electron-gyp .wine .gem .vim)
# File patterns to exclude (only applies to file listings)
_fzf_exclude_files=("*.otf" "*.png" "*.jpg")

_fzf_dir_excludes=""
for d in "${_fzf_exclude_dirs[@]}"; do _fzf_dir_excludes+=" --exclude $d"; done
_fzf_file_excludes=""
for f in "${_fzf_exclude_files[@]}"; do _fzf_file_excludes+=" --exclude '$f'"; done

export FZF_DEFAULT_COMMAND="fd --type f --hidden${_fzf_dir_excludes}${_fzf_file_excludes} --max-depth 10"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden${_fzf_dir_excludes} --max-depth 10"
export FZF_PREVIEW_CMD="cat {}"

unset _fzf_dir_excludes _fzf_file_excludes _fzf_exclude_dirs _fzf_exclude_files
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

  # %h: hash
  # %s: comment
  # %d: branch/tag
  # %cd: date
  # %an: author
  git_cmd='git log \
    --all \
    --graph \
    --date-order \
    --format=format:"%C(auto)%h %s %d %C(cyan)%cd %C(bold black)%an %C(auto)" \
    --date=short \
    --color=always'

  # The hash is the first hex run on the line (graph characters aren't hex), and
  # {7,} keeps the full abbreviation git printed, which may be longer than 7.
  execute="grep -oE '[a-f0-9]{7,}' \
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

# fgco [QUERY] - checkout a local git branch, most recently committed first
#   - opens in a tmux popup inside tmux (--tmux is ignored elsewhere)
fgco() {
  local branch
  branch="$(
    git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' \
      | fzf --tmux --no-multi --query="$1" --select-1 --exit-0
  )" || return
  git checkout "$branch"
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

# Arch Linux package helpers (pacman / yay)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
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
fi
