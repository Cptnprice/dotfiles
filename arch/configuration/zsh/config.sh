#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../../utils/logging/logging.sh"

ZSHRC="$HOME/.zshrc"

ok "Configuring zsh..."

declare -A OPTIONS=(
    [HIST_IGNORE_DUPS]="don't save duplicate commands in history"
    [HIST_IGNORE_SPACE]="don't save commands prefixed with a space"
)

for option in "${!OPTIONS[@]}"; do
    if grep -qsF "setopt $option" "$ZSHRC"; then
        ok "$option already set."
    else
        echo "setopt $option" >> "$ZSHRC"
        ok "$option added — ${OPTIONS[$option]}."
    fi
done

ok "zsh has been configured."