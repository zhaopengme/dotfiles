#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<EOF
Usage: zsh install.zsh [command]

Commands:
  (empty) | base   Run basic setup: macOS check, Homebrew + packages, link dotfiles, mise setup
  help             Show this help

This script is intentionally simple; 后续所有定制通过编辑 src/config/* 和 brew/*.txt 完成。
EOF
}

main() {
  local cmd="${1:-base}"

  case "$cmd" in
    base)
      "$SCRIPT_DIR/scripts/macos-check.zsh"
      "$SCRIPT_DIR/scripts/brew-install.zsh"
      "$SCRIPT_DIR/scripts/oh-my-zsh-install.zsh"
      "$SCRIPT_DIR/scripts/bash-profile-bootstrap.zsh"
      "$SCRIPT_DIR/scripts/link-dotfiles.zsh"
      "$SCRIPT_DIR/scripts/mise-setup.zsh"
      ;;
    help|-h|--help)
      usage
      ;;
    *)
      echo "Unknown command: $cmd" >&2
      usage
      exit 1
      ;;
  esac
}

main "$@"
