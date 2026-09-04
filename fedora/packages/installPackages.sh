#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

PACKAGES=(
    git
    curl
    tmux
    fzf
    nano
    vim
    firefox
)

ok "Refreshing package metadata..."
if ! sudo dnf makecache -q; then
    warn "Could not refresh package metadata (missing sudo credentials?) — continuing with existing cache."
fi

for package in "${PACKAGES[@]}"; do
    if rpm -q "$package" &>/dev/null; then
        ok "$package is already installed — $(rpm -q --qf '%{VERSION}-%{RELEASE}' "$package")"
        continue
    fi

    ok "Installing $package..."
    sudo dnf install -y "$package"

    if rpm -q "$package" &>/dev/null; then
        ok "$package has been installed — $(rpm -q --qf '%{VERSION}-%{RELEASE}' "$package")"
    else
        error "Failed to install $package."
    fi
done
