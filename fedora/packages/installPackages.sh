#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

PACKAGES=(
    git
    curl
    tmux
    fzf
)

ok "Refreshing package metadata..."
sudo dnf makecache -q

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
