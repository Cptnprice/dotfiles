#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../../utils/logging/logging.sh"

ok "Configuring git..."

git config --global core.editor nano
git config --global init.defaultBranch master

ok "Git has been configured."
