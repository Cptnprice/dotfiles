#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK_BINDING="$SCRIPT_DIR/checkBindingExistence.sh"

SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
CUSTOM_BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

SHORTCUTS=(
    "Firefox|firefox|<Super>b"
    "File Manager|nautilus|<Super>e"
)

set_shortcuts() {
    local existing_str
    existing_str=$(gsettings get "$SCHEMA" custom-keybindings 2>/dev/null | tr -d "[]'" | tr ',' '\n' | xargs)
    local existing_paths=()

    for path in $existing_str; do
        [[ -n "$path" ]] && existing_paths+=("$path")
    done

    local next_index=0
    for path in "${existing_paths[@]}"; do
        if [[ "$path" =~ custom([0-9]+)/?$ ]]; then
            local n="${BASH_REMATCH[1]}"
            (( n >= next_index )) && next_index=$((n + 1))
        fi
    done

    local paths=()

    for shortcut in "${SHORTCUTS[@]}"; do
        local name="${shortcut%%|*}"
        local binding="${shortcut##*|}"
        local command="${shortcut#*|}"
        command="${command%|*}"

        if ! bash "$CHECK_BINDING" "$binding" &>/dev/null; then
            warn "Skipping '$name' ($binding) — already in use"
            continue
        fi

        local path="${CUSTOM_BASE}/custom${next_index}/"
        ((next_index++))
        paths+=("'$path'")

        gsettings set "${SCHEMA}.custom-keybinding:$path" name    "$name"
        gsettings set "${SCHEMA}.custom-keybinding:$path" command "$command"
        gsettings set "${SCHEMA}.custom-keybinding:$path" binding "$binding"

        ok "Set '$name' → $binding"
    done

    for existing in "${existing_paths[@]}"; do
        local keep="'$existing'"
        local already_included=0
        for p in "${paths[@]}"; do
            [[ "$p" == "$keep" ]] && already_included=1 && break
        done
        [[ $already_included -eq 0 ]] && paths+=("$keep")
    done

    local joined
    joined=$(IFS=', '; echo "${paths[*]}")
    gsettings set "$SCHEMA" custom-keybindings "[${joined}]"
}

set_shortcuts
