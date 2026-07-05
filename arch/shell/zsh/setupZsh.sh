#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../../utils/logging/logging.sh"

# Install zsh and set as default

if command -v zsh &>/dev/null; then
    ok "zsh is already installed — $(zsh --version)"
else
    ok "Installing zsh..."
    sudo pacman -S --needed --noconfirm zsh

    if ! command -v zsh &>/dev/null; then
        error "zsh installation failed."
        exit 1
    fi

    ok "zsh has been installed — $(zsh --version)"
fi

ZSH_PATH="$(which zsh)"

if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    ok "zsh is already the default shell."
else
    ok "Setting zsh as default shell..."
    chsh -s "$ZSH_PATH"
    warn "Log out and back in for the default shell change to take effect."
fi

# Install 'oh-my-zsh' framework

ok "Checking oh-my-zsh prerequisites..."

MISSING=0

if command -v zsh &>/dev/null; then
    ok "zsh — $(zsh --version)"
else
    error "zsh is not installed."
    MISSING=1
fi

if command -v curl &>/dev/null; then
    ok "curl — $(curl --version 2>&1 | head -1)"
else
    error "curl is not installed."
    MISSING=1
fi

if command -v git &>/dev/null; then
    ok "git — $(git --version)"
else
    error "git is not installed."
    MISSING=1
fi

if [[ $MISSING -eq 1 ]]; then
    error "Missing prerequisites — skipping oh-my-zsh installation."
    exit 1
fi

ok "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
