#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../../utils/logging/logging.sh"

ZSHRC="$HOME/.zshrc"
BUILTIN_BINDINGS="source /usr/share/doc/fzf/examples/key-bindings.zsh"
CUSTOM_FUNCTIONS="source $(realpath "$(dirname "${BASH_SOURCE[0]}")/custom-functions.sh")"

if [[ ! -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    warn "fzf key-bindings file not found — is fzf installed? Adding the source line anyway; it will take effect once fzf is installed."
fi

# built-in fzf bindings
if grep -qsxF "$BUILTIN_BINDINGS" "$ZSHRC"; then
    ok "fzf built-in bindings already in .zshrc."
else
    echo "$BUILTIN_BINDINGS" >> "$ZSHRC"
    ok "fzf built-in bindings added to .zshrc."
fi

# custom fzf functions
if grep -qsxF "$CUSTOM_FUNCTIONS" "$ZSHRC"; then
    ok "fzf custom functions already in .zshrc."
elif grep -qs "^source .*/custom-functions\.sh$" "$ZSHRC"; then
    sed -i "s|^source .*/custom-functions\.sh$|$CUSTOM_FUNCTIONS|" "$ZSHRC"
    ok "fzf custom functions path updated in .zshrc."
else
    echo "$CUSTOM_FUNCTIONS" >> "$ZSHRC"
    ok "fzf custom functions added to .zshrc."
fi
