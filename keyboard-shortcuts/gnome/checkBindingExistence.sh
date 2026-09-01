#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

if [[ -z "$1" ]]; then
    echo "Usage: $0 <shortcut>"
    echo "Examples:"
    echo "  $0 'Super+e'"
    echo "  $0 'Ctrl+Alt+t'"
    echo "  $0 '<Super>e'"
    exit 1
fi

normalize() {
    local input="$1"

    if [[ "$input" == *"<"* ]]; then
        echo "$input"
        return
    fi

    local result=""
    IFS='+' read -ra parts <<< "$input"
    local key="${parts[-1]}"

    for part in "${parts[@]}"; do
        case "${part,,}" in
            super)   result+="<Super>" ;;
            ctrl)    result+="<Primary>" ;;
            control) result+="<Primary>" ;;
            alt)     result+="<Alt>" ;;
            shift)   result+="<Shift>" ;;
            *)       ;;
        esac
    done

    if [[ ${#key} -eq 1 ]]; then
        result+="${key,,}"
    else
        result+="$key"
    fi

    echo "$result"
}

canonicalize_ctrl() {
    sed -e 's/<Control>/<Primary>/g' -e 's/<Ctrl>/<Primary>/g'
}

NORMALIZED=$(normalize "$1")
echo "Checking: $1  →  normalized: $NORMALIZED"
echo "────────────────────────────────────────────"

FOUND=0

SCHEMAS=(
    "org.gnome.settings-daemon.plugins.media-keys"
    "org.gnome.desktop.wm.keybindings"
    "org.gnome.shell.keybindings"
    "org.gnome.mutter.keybindings"
    "org.gnome.mutter.wayland.keybindings"
)

for schema in "${SCHEMAS[@]}"; do
    if ! gsettings list-keys "$schema" &>/dev/null; then
        continue
    fi

    while IFS= read -r key; do
        value=$(gsettings get "$schema" "$key" 2>/dev/null)
        if canonicalize_ctrl <<< "$value" | grep -qi "'${NORMALIZED}'"; then
            warn "[built-in]  $schema"
            warn "            key: $key"
            warn "            value: $value"
            echo
            FOUND=1
        fi
    done < <(gsettings list-keys "$schema" 2>/dev/null)
done

CUSTOM_PATHS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null \
    | tr -d "[]'" | tr ',' '\n' | xargs)

for path in $CUSTOM_PATHS; do
    [[ -z "$path" ]] && continue
    binding=$(gsettings get "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" binding 2>/dev/null)
    if canonicalize_ctrl <<< "$binding" | grep -qi "'${NORMALIZED}'"; then
        name=$(gsettings get "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" name 2>/dev/null)
        command=$(gsettings get "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" command 2>/dev/null)
        warn "[custom]    $name"
        warn "            command: $command"
        warn "            binding: $binding"
        echo
        FOUND=1
    fi
done

DCONF_HITS=$(dconf dump / 2>/dev/null | canonicalize_ctrl | grep -i "'${NORMALIZED}'")

if [[ -n "$DCONF_HITS" ]]; then
    warn "[dconf]     $DCONF_HITS"
    echo
    FOUND=1
fi

if [[ $FOUND -eq 0 ]]; then
    ok "Free — no conflicts found for: $NORMALIZED"
else
    echo "────────────────────────────────────────────"
    warn "Conflict(s) found — see above."
fi

exit $FOUND
