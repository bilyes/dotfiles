# Docker
alias doc="docker"
alias di="docker images"
alias dcls="docker container ls"
alias dstat="docker stats --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.NetIO}}'"

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
alias i="sudo pacman -S"
alias r="sudo pacman -Rss"
alias up="sudo pacman -Syy && sudo pacman -Syu"
alias t="tmux"
