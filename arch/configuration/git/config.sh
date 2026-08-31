#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../../utils/logging/logging.sh"

if ! command -v git &>/dev/null; then
    warn "git is not installed — skipping git configuration. Run the package install step first."
    exit 0
fi

ok "Configuring git..."

git config --global core.editor nano
git config --global init.defaultBranch master

ok "Git has been configured."
