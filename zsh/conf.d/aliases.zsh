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

alias v=nvim
alias c=clear
alias chmox="chmod u+x"

# Global aliases expand anywhere in a command, e.g. `git log L` runs `git log | less`
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g J='| jq'
alias -g NE='2>/dev/null'
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias -g C='| pbcopy'
else
  alias -g C='| wl-copy'
fi

# GitHub CLI
alias ghpc="gh pr create"
alias ghpm="gh pr create && gh pr merge --squash --delete-branch"

# Packages: pacman on Arch Linux, Homebrew on macOS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias i="sudo pacman -S"
  alias r="sudo pacman -Rns"
  alias up="sudo pacman -Syu"
else
  alias up="brew upgrade"
  # Without the alias above, `r` would fall back to zsh's builtin, which
  # re-runs the previous command.
  disable r
fi

alias ff="fastfetch"
alias p="python3"
