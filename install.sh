#!/usr/bin/env bash
# Symlinks configs into place and installs shell, tmux and Neovim plugins.
# Safe to re-run: correct links are skipped, anything else in the way is backed up.
set -Eeuo pipefail
trap 'echo "install.sh: line $LINENO failed: $BASH_COMMAND" >&2' ERR

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

die() {
    echo "install.sh: $*" >&2
    exit 1
}

# Points $2 at $1, backing up whatever is in the way.
ensure_link() {
    local src=$1 dst=$2
    if [[ -L $dst && $(readlink "$dst") == "$src" ]]; then
        return 0
    fi
    if [[ -e $dst || -L $dst ]]; then
        mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
        echo "backed up $dst"
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

# Applies sed expression $2 to ~/.zshrc unless pattern $1 already matches, then
# checks the edit took. Plain sed (no -i) behaves the same on macOS and Linux.
ensure_zshrc() {
    local pattern=$1 edit=$2 tmp
    if grep -q "$pattern" "$HOME/.zshrc"; then
        return 0
    fi
    tmp="$(mktemp)"
    sed "$edit" "$HOME/.zshrc" > "$tmp"
    cat "$tmp" > "$HOME/.zshrc"
    rm -f "$tmp"
    grep -q "$pattern" "$HOME/.zshrc" || die "couldn't update ~/.zshrc (expected: $pattern); edit it by hand"
}

# Preflight
for cmd in git zsh nvim tmux; do
    command -v "$cmd" > /dev/null || die "missing dependency: $cmd"
done
[[ -d $ZSH_CUSTOM ]] || die "oh-my-zsh not found at $ZSH_CUSTOM; install it first"
[[ -f $HOME/.zshrc ]] || die "$HOME/.zshrc not found"
case "$(uname -s)" in
    Darwin) os_configs=(aerospace) ;;
    Linux) os_configs=(hypr noctalia uwsm) ;;
    *) die "unsupported OS: $(uname -s)" ;;
esac

# Configs
for dir in git nvim tmux kitty opencode "${os_configs[@]}"; do
    ensure_link "$DOTFILES/$dir" "$HOME/.config/$dir"
done
for file in custom aliases functions fzf-functions; do
    ensure_link "$DOTFILES/oh-my-zsh/$file.zsh" "$ZSH_CUSTOM/$file.zsh"
done

# Zsh plugin and theme (~/.zshrc itself stays machine-specific)
ensure_clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
ensure_clone https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
ensure_zshrc '^plugins=(.*zsh-autosuggestions' 's/^plugins=(/plugins=(zsh-autosuggestions /'
ensure_zshrc '^ZSH_THEME="powerlevel10k/powerlevel10k"' 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|'

# tmux and Neovim plugins (no-ops when already installed)
ensure_clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
"$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
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
