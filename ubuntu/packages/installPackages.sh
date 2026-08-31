#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

PACKAGES=(
    git
    curl
    tmux
    fzf
)

ok "Refreshing package lists..."
if ! sudo apt update -qq; then
    warn "Could not refresh package lists (missing sudo credentials?) — continuing with existing cache."
fi

for package in "${PACKAGES[@]}"; do
    if dpkg -s "$package" &>/dev/null; then
        ok "$package is already installed — $(dpkg -s "$package" | grep '^Version' | awk '{print $2}')"
        continue
    fi

    ok "Installing $package..."
    sudo apt install -y "$package"

    if dpkg -s "$package" &>/dev/null; then
        ok "$package has been installed — $(dpkg -s "$package" | grep '^Version' | awk '{print $2}')"
    else
        error "Failed to install $package."
    fi
done
