#!/usr/bin/env bash
# Symlinks configs and scripts into place and installs shell, tmux and Neovim plugins.
# Safe to re-run: correct links are skipped, anything else in the way is backed up.
set -Eeuo pipefail
trap 'echo "install.sh: line $LINENO failed: $BASH_COMMAND" >&2' ERR

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Configs and scripts go where the XDG Base Directory spec puts them, so nothing but these links
# depends on where this repo is.
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# Oh My Zsh's custom folder: $ZSH_CUSTOM if exported, else the one inside $ZSH (which the
# standard .zshrc exports), else the default install location.
ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}"

die() {
    echo "install.sh: $*" >&2
    exit 1
}

# Moves $1 to $1.bak.<timestamp>.
backup() {
    local bak
    bak="$1.bak.$(date +%Y%m%d%H%M%S)"
    mv "$1" "$bak"
    echo "backed up $1 to $bak"
}

# Points $2 at $1, backing up whatever is in the way.
ensure_link() {
    local src=$1 dst=$2
    if [[ -L $dst && $(readlink "$dst") == "$src" ]]; then
        return 0
    fi
    if [[ -e $dst || -L $dst ]]; then
        backup "$dst"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "linked $dst"
}

ensure_clone() {
    local repo=$1 dst=$2
    if [[ ! -d $dst ]]; then
        git clone --depth=1 "$repo" "$dst"
    fi
}

# Preflight
for cmd in git zsh nvim tmux; do
    command -v "$cmd" > /dev/null || die "missing dependency: $cmd"
done
[[ -d $ZSH_CUSTOM ]] || die "oh-my-zsh not found at $ZSH_CUSTOM; install it, or run ZSH_CUSTOM=/path/to/its/custom $0"
case "$(uname -s)" in
    Darwin) os_configs=(aerospace) ;;
    Linux) os_configs=(hypr noctalia uwsm) ;;
    *) die "unsupported OS: $(uname -s)" ;;
esac

# Configs
for dir in git nvim tmux kitty opencode zsh "${os_configs[@]}"; do
    ensure_link "$DOTFILES/$dir" "$CONFIG_HOME/$dir"
done
# Scripts go in ~/.local/bin, the spec's place for user executables. Other tools install there
# too, so only a missing file or a link into this repo gets replaced; anything else is skipped.
for script in "$DOTFILES"/scripts/*; do
    dst="$HOME/.local/bin/${script##*/}"
    if [[ -L $dst && $(readlink "$dst") == "$DOTFILES"/* ]] || [[ ! -e $dst && ! -L $dst ]]; then
        ensure_link "$script" "$dst"
    else
        echo "install.sh: skipped $dst, which isn't a link into this repo" >&2
    fi
done
# Links left behind by scripts that were renamed or removed
for link in "$HOME/.local/bin"/*; do
    if [[ -L $link && ! -e $link && $(readlink "$link") == "$DOTFILES"/scripts/* ]]; then
        rm "$link"
        echo "removed $link"
    fi
done
# zsh/zshrc loads the zsh files now; remove the links older installs made to them.
for link in "$ZSH_CUSTOM"/*.zsh "$HOME/.p10k.zsh"; do
    if [[ -L $link && $(readlink "$link") == "$DOTFILES"/* ]]; then
        rm "$link"
        echo "removed $link"
    fi
done
# Without ~/.gitconfig, `git config --global` writes into $CONFIG_HOME/git/config, which is
# this repo's git/config. An empty ~/.gitconfig takes machine-specific settings instead.
if [[ ! -e $HOME/.gitconfig && ! -L $HOME/.gitconfig ]]; then
    touch "$HOME/.gitconfig"
    echo "created $HOME/.gitconfig"
fi

# Zsh plugin and theme
ensure_clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
ensure_clone https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
# ~/.zshrc stays a machine-specific file that loads zsh/zshrc rather than a link to it:
# installers and tools such as tec append their setup to ~/.zshrc, which would land in the repo.
if ! grep -qsF zsh/zshrc "$HOME/.zshrc"; then
    note=
    if [[ -e $HOME/.zshrc || -L $HOME/.zshrc ]]; then
        backup "$HOME/.zshrc"
        note="; move any machine-specific lines from the backup into it"
    fi
    {
        echo "# Shared config from the dotfiles repo; machine-specific lines go below it."
        [[ ${ZSH:-$HOME/.oh-my-zsh} == "$HOME/.oh-my-zsh" ]] || echo "export ZSH=\"$ZSH\""
        [[ $ZSH_CUSTOM == "${ZSH:-$HOME/.oh-my-zsh}/custom" ]] || echo "ZSH_CUSTOM=\"$ZSH_CUSTOM\""
        echo 'source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshrc"'
    } > "$HOME/.zshrc"
    echo "wrote $HOME/.zshrc$note"
fi

# tmux and Neovim plugins (no-ops when already installed)
ensure_clone https://github.com/tmux-plugins/tpm "$CONFIG_HOME/tmux/plugins/tpm"
"$CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins"
# Neovim installs missing plugins at their lazy-lock.json versions while starting up;
# exit non-zero if a plugin is still missing (failed clone) or its install errored.
nvim --headless "+lua
    for _, p in pairs(require('lazy.core.config').plugins) do
        if not p._.installed or require('lazy.core.plugin').has_errors(p) then
            io.stderr:write('\n' .. p.name .. ' failed to install\n')
            vim.cmd.cquit()
        end
    end" +qa || die "Neovim plugins failed to install; fix the error above and re-run install.sh"

echo "Done."
