#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK_BINDING="$SCRIPT_DIR/checkBindingExistence.sh"

SHORTCUTS=(
    "Firefox|firefox|<Super>b"
    "File Manager|nautilus|<Super>e"
)

set_shortcuts() {
    local index=0
    local paths=()

    for shortcut in "${SHORTCUTS[@]}"; do
        IFS='|' read -r name command binding <<< "$shortcut"

        if ! bash "$CHECK_BINDING" "$binding" &>/dev/null; then
            echo "Skipping '$name' ($binding) — already in use"
            ((index++))
            continue
        fi

        local path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${index}/"
        paths+=("'$path'")

        gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" name    "$name"
        gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" command "$command"
        gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" binding "$binding"

        echo "Set '$name' → $binding"
        ((index++))
    done

    if [[ ${#paths[@]} -gt 0 ]]; then
        local joined
        joined=$(IFS=', '; echo "${paths[*]}")
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[${joined}]"
    fi
}

set_shortcuts
