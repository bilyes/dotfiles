# Docker
alias doc="docker"
alias di="docker images"
alias dcls="docker container ls"
alias dstat="docker stats --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.NetIO}}'"
alias dclean="docker image prune -f"     # dangling images
alias ddestroy="docker image prune -af"  # every image no container uses

# Docker Compose
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcr="docker compose run --rm"
alias dcs="docker compose stop"

# Git
alias grm="git rebase main"

alias v=nvim
alias c=clear
alias chmox="chmod u+x"

alias -g G='| grep'

# pacman (Arch Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias i="sudo pacman -S"
  alias r="sudo pacman -Rns"
  alias up="sudo pacman -Syu"
else
  # Without the alias above, `r` would fall back to zsh's builtin, which
  # re-runs the previous command.
  disable r
fi

alias t="tmux"
alias ff="fastfetch"
alias p="python3"
