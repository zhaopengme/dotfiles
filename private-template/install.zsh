#!/usr/bin/env zsh
#
# Private dotfiles template — install entrypoint
#
# What this does:
#  - (Optional) installs private Homebrew packages (git-secret, gnupg, etc.)
#  - links private overlay files (~/.gitconfig.local, ~/.zshrc.local, ~/.envconfig.local)
#  - DOES NOT automatically reveal secrets by default (run secret-helper explicitly)
#
# Usage:
#   zsh install.zsh
#   zsh install.zsh base
#   zsh install.zsh brew
#   zsh install.zsh link
#   zsh install.zsh reveal
#   zsh install.zsh help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'EOF'
Usage: zsh install.zsh [command]

Commands:
  (empty) | base   Run: macOS check, private brew (best-effort), link private overlay
  brew             Install private brew packages from brew/*.private.txt
  link             Link private overlay files into $HOME
  reveal           Reveal secrets AND install them via secrets/manifest.yml (calls reveal-install)
  help             Show this help

Notes:
  - This repo is intended to be PRIVATE.
  - Sensitive files should be managed under secrets/ using git-secret.
  - The public dotfiles repo should source/include:
      ~/.zshrc.local
      ~/.envconfig.local
      ~/.gitconfig.local
EOF
}

main() {
  local cmd="${1:-base}"

  case "$cmd" in
    base)
      "$SCRIPT_DIR/scripts/macos-check.zsh"
      # brew step is best-effort so a missing Homebrew doesn't block linking
      "$SCRIPT_DIR/scripts/brew-install-private.zsh" || true
      "$SCRIPT_DIR/scripts/link-private.zsh"
      ;;
    brew)
      "$SCRIPT_DIR/scripts/macos-check.zsh"
      "$SCRIPT_DIR/scripts/brew-install-private.zsh"
      ;;
    link)
      "$SCRIPT_DIR/scripts/link-private.zsh"
      ;;
    reveal)
      "$SCRIPT_DIR/scripts/secret-helper.zsh" reveal-install
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
