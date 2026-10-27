#!/bin/bash
if [ -f "$HOME/Welcome.md" ]; then
    if command -v obsidian &> /dev/null; then
        obsidian "$HOME/Welcome.md" &
    else
        kitty -e less "$HOME/Welcome.md" &
    fi
    mv "$HOME/Welcome.md" "$HOME/Welcome.md.viewed"
fi
