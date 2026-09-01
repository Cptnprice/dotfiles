#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../../utils/logging/logging.sh"

# Install zsh and set as default

ZSH_READY=1

if command -v zsh &>/dev/null; then
    ok "zsh is already installed — $(zsh --version)"
else
    ok "Installing zsh..."
    if sudo pacman -S --needed --noconfirm zsh && command -v zsh &>/dev/null; then
        ok "zsh has been installed — $(zsh --version)"
    else
        warn "zsh installation failed (missing sudo credentials?) — skipping default-shell change and oh-my-zsh install."
        ZSH_READY=0
    fi
fi

if [[ $ZSH_READY -eq 1 ]]; then
    ZSH_PATH="$(command -v zsh)"

    if [[ "$SHELL" == "$ZSH_PATH" ]]; then
        ok "zsh is already the default shell."
    else
        ok "Setting zsh as default shell..."
        if chsh -s "$ZSH_PATH"; then
            warn "Log out and back in for the default shell change to take effect."
        else
            warn "Could not change default shell (no password provided?) — skipping. Run 'chsh -s $ZSH_PATH' manually later."
        fi
    fi

    # Install 'oh-my-zsh' framework

    if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
        ok "oh-my-zsh is already installed."
    else
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
            warn "Missing prerequisites — skipping oh-my-zsh installation."
        else
            ok "Installing oh-my-zsh..."
            INSTALL_SCRIPT="$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            CURL_STATUS=$?

            if [[ $CURL_STATUS -eq 0 && -n "$INSTALL_SCRIPT" ]] && sh -c "$INSTALL_SCRIPT"; then
                ok "oh-my-zsh has been installed."
            else
                warn "oh-my-zsh installation failed (network issue, or git set up to use SSH for GitHub with no SSH/GitHub credentials configured on this machine) — skipping. Re-run this step later once credentials/connectivity are set up."
            fi
        fi
    fi
fi

exit 0
