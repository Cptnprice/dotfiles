#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

ZSHRC="$HOME/.zshrc"
BUILTIN_BINDINGS="source /usr/share/fzf/key-bindings.zsh"
CUSTOM_FUNCTIONS="source $(realpath "$(dirname "${BASH_SOURCE[0]}")/custom-functions.sh")"

# built-in fzf bindings
if grep -qF "$BUILTIN_BINDINGS" "$ZSHRC"; then
    ok "fzf built-in bindings already in .zshrc."
else
    echo "$BUILTIN_BINDINGS" >> "$ZSHRC"
    ok "fzf built-in bindings added to .zshrc."
fi

# custom fzf functions
if grep -qF "$CUSTOM_FUNCTIONS" "$ZSHRC"; then
    ok "fzf custom functions already in .zshrc."
else
    echo "$CUSTOM_FUNCTIONS" >> "$ZSHRC"
    ok "fzf custom functions added to .zshrc."
fi
