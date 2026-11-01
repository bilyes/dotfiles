# zoxide: smarter cd. Provides `z` (jump) and `zi` (interactive fuzzy jump).
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
