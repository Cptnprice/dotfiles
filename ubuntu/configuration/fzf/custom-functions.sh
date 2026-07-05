#!/usr/bin/env bash

# Open fuzzy-found file in nano
fe() {
    local file
    file=$(fzf --preview "cat {}")
    [[ -n "$file" ]] && nano "$file"
}
