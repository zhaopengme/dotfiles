#!/usr/bin/env zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PREFS_DIR="$ROOT_DIR/scripts/macos-prefs.d"

run_if_exists() {
  local script="$1"
  if [[ -x "$script" ]]; then
    echo "▶ Running $(basename "$script")"
    "$script"
  elif [[ -f "$script" ]]; then
    echo "▶ Running $(basename "$script")"
    zsh "$script"
  fi
}

main() {
  echo "Applying macOS preferences (subset tuned for development)..."

  run_if_exists "$PREFS_DIR/dock.zsh"
  run_if_exists "$PREFS_DIR/finder.zsh"
  run_if_exists "$PREFS_DIR/keyboard.zsh"
  run_if_exists "$PREFS_DIR/trackpad.zsh"
  run_if_exists "$PREFS_DIR/ui_ux.zsh"
  run_if_exists "$PREFS_DIR/app_store.zsh"
  run_if_exists "$PREFS_DIR/textedit.zsh"
  run_if_exists "$PREFS_DIR/security_privacy.zsh"
  run_if_exists "$PREFS_DIR/sudo_touchid.zsh"

  echo "Done. Some changes may require log out / restart to fully apply."
}

main "$@"

