#!/usr/bin/env bash

# Custom global keyboard shortcuts for KDE Plasma 6.
#
# Plasma 6 dropped khotkeys, so "run a command on a keypress" is modelled as an
# application launcher: for each entry we drop a .desktop launcher into
# ~/.local/share/applications and bind a global shortcut to it in
# kglobalshortcutsrc, then reload kglobalaccel so the change takes effect.
#
# NOTE: KDE shortcut scripting is version-sensitive — validate on a real
# Plasma 6 session. The kglobalshortcutsrc value format is:
#   _launch=<activeShortcut>,<defaultShortcut>,<friendlyName>

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK_BINDING="$SCRIPT_DIR/checkBindingExistence.sh"

APPS_DIR="$HOME/.local/share/applications"
SHORTCUTS_FILE="kglobalshortcutsrc"

# name|command|binding  (KDE shortcut syntax, e.g. Meta+B)
SHORTCUTS=(
    "Firefox|firefox|Meta+B"
    "File Manager|dolphin|Meta+E"
)

if ! command -v kwriteconfig6 &>/dev/null; then
    error "kwriteconfig6 not found — this script targets KDE Plasma 6."
    exit 1
fi

mkdir -p "$APPS_DIR"

set_shortcuts() {
    local changed=0

    for shortcut in "${SHORTCUTS[@]}"; do
        IFS='|' read -r name command binding <<< "$shortcut"

        if ! bash "$CHECK_BINDING" "$binding" &>/dev/null; then
            warn "Skipping '$name' ($binding) — already in use"
            continue
        fi

        local id="dotfiles-${command}"
        local desktop="$APPS_DIR/${id}.desktop"

        cat > "$desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$name
Exec=$command
NoDisplay=true
EOF

        kwriteconfig6 --file "$SHORTCUTS_FILE" \
            --group services --group "${id}.desktop" \
            --key _launch "$binding,none,$name"
        kwriteconfig6 --file "$SHORTCUTS_FILE" \
            --group services --group "${id}.desktop" \
            --key _k_friendly_name "$name"

        ok "Set '$name' → $binding"
        changed=1
    done

    if [[ $changed -eq 1 ]]; then
        ok "Reloading KDE services and global shortcuts..."
        kbuildsycoca6 &>/dev/null
        if systemctl --user restart plasma-kglobalaccel.service &>/dev/null; then
            ok "Global shortcuts reloaded."
        else
            warn "Could not reload kglobalaccel automatically — log out and back in to apply."
        fi
    fi
}

set_shortcuts
