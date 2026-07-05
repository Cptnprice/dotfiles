#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../utils/logging/logging.sh"

PACKAGES=(
    git
    curl
    tmux
    fzf
)

for package in "${PACKAGES[@]}"; do
    if pacman -Qi "$package" &>/dev/null; then
        ok "$package is already installed — $(pacman -Q "$package" | awk '{print $2}')"
        continue
    fi

    ok "Installing $package..."
    sudo pacman -S --needed --noconfirm "$package"

    if pacman -Qi "$package" &>/dev/null; then
        ok "$package has been installed — $(pacman -Q "$package" | awk '{print $2}')"
    else
        error "Failed to install $package."
    fi
done
