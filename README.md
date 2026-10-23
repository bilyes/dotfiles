# dotfiles

Configs for macOS (AeroSpace) and Arch Linux (Hyprland + Noctalia).

| Config | Platform |
| --- | --- |
| `git`, `nvim`, `tmux`, `kitty`, `opencode`, `oh-my-zsh` | macOS and Linux |
| `aerospace` | macOS |
| `hypr`, `noctalia`, `uwsm` | Linux |

## Requirements

- git, zsh and [Oh My Zsh](https://ohmyz.sh/)
- tmux
- Neovim 0.12+, plus:
  - make and a C compiler (telescope-fzf-native)
  - the `tree-sitter` CLI (nvim-treesitter)
  - Node.js (copilot.vim)
  - fd and ripgrep (Telescope)
  - yazi (file manager)
- fzf and fd (shell functions in `oh-my-zsh/fzf-functions.zsh`)
- kitty and these Nerd Fonts: FiraCode, Roboto Mono, JetBrains Mono
- macOS: AeroSpace
- Linux: Hyprland started through uwsm, and Noctalia

## Installation

```sh
git clone https://github.com/bilyes/dotfiles.git ~/.config/dotfiles
~/.config/dotfiles/install.sh
```

`install.sh` can be re-run safely. It:

- links each config into `~/.config`, moving anything already there to `<name>.bak.<timestamp>`
- links the files in `oh-my-zsh/` into `$ZSH_CUSTOM`
- creates an empty `~/.gitconfig` if there isn't one, so `git config --global` writes there
  instead of into this repo's `git/config`
- installs zsh-autosuggestions, powerlevel10k and TPM, and turns on the plugin and theme in `~/.zshrc`
- installs the tmux and Neovim plugins

Afterwards:

- Open a new shell. The first one runs powerlevel10k's setup wizard.
- On Linux, log out and back in so uwsm loads `uwsm/env`. Noctalia then writes the kitty colors to
  `kitty/themes/noctalia.conf` (git-ignored).

## Notes

- `~/.zshrc` isn't in this repo. For machine-specific shell config (e.g. work aliases), add a
  `*.zsh` file to `$ZSH_CUSTOM`; Oh My Zsh loads all of them.
- Machine-specific Neovim plugin settings go in `nvim/lua/plugins/local.lua` (git-ignored).
  lazy.nvim merges it with the plugin specs in this repo.
- `nvim/scripts/test-config.sh` checks that the Neovim config in its checkout loads without errors.
- `scripts/` is on `PATH` (see `oh-my-zsh/custom.zsh`). `tmain` opens a tmux session running btop
  and fastfetch, which need to be installed.

#### Terminal tips

In zsh's vi normal mode, `v` opens the current command in `$EDITOR`.
