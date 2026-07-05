#!/usr/bin/env bash

# Exit 0 = free, exit 1 = conflict.

source "$(dirname "${BASH_SOURCE[0]}")/../../utils/logging/logging.sh"

if [[ -z "$1" ]]; then
    echo "Usage: $0 <shortcut>"
    echo "Example: $0 'Meta+E'"
    exit 1
fi

BINDING="$1"
SHORTCUTS_FILE="$HOME/.config/kglobalshortcutsrc"

echo "Checking: $BINDING"
echo "────────────────────────────────────────────"

if [[ ! -f "$SHORTCUTS_FILE" ]]; then
    ok "Free — no kglobalshortcutsrc yet, nothing bound."
    exit 0
fi

FOUND=0
group=""

while IFS= read -r line; do
    # Track the current group header for reporting
    if [[ "$line" =~ ^\[.*\]$ ]]; then
        group="$line"
        continue
    fi

    # Only key=value lines carry bindings
    [[ "$line" == *=* ]] || continue

    key="${line%%=*}"
    value="${line#*=}"
    active="${value%%,*}"   # first comma-field is the active shortcut

    if [[ "$active" == "$BINDING" ]]; then
        warn "[kglobalshortcutsrc] $group"
        warn "            $key = $value"
        echo
        FOUND=1
    fi
done < "$SHORTCUTS_FILE"

if [[ $FOUND -eq 0 ]]; then
    ok "Free — no conflicts found for: $BINDING"
else
    echo "────────────────────────────────────────────"
    warn "Conflict(s) found — see above."
fi

exit $FOUND
