#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/colors.sh"

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

ok "Git aliases configured."
