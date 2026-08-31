#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../../utils/logging/logging.sh"

if ! command -v git &>/dev/null; then
    warn "git is not installed — skipping git alias configuration. Run the package install step first."
    exit 0
fi

ok "Configuring git aliases..."

# Staging
git config --global alias.a  "add"
git config --global alias.aa "add --all"

# Committing
git config --global alias.ci "commit"
git config --global alias.st "status"

# Branching
git config --global alias.co "checkout"
git config --global alias.br "branch"

# Remote
git config --global alias.p  "push"
git config --global alias.pl "pull"
git config --global alias.f  "fetch"
git config --global alias.fa "fetch --all"

# Logs
git config --global alias.lg "log --oneline"

# Utility
git config --global alias.aliases "config --get-regexp alias"

ok "Git aliases have been configured."
