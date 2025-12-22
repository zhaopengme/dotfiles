#!/usr/bin/env zsh

# Linux-specific shell tweaks (Ubuntu/Debian server).

# Ghostty may report TERM=xterm-ghostty, which often lacks terminfo on servers.
# Standardize on a widely available TERM to avoid tmux/ncurses errors.
if [[ "${TERM:-}" == "xterm-ghostty" ]]; then
  export TERM="xterm-256color"
fi
