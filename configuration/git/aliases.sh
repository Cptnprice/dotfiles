#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/colors.sh"

ok "Configuring git aliases..."

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --oneline"
git config --global alias.aliases "config --get-regexp alias"

ok "Git aliases configured."
