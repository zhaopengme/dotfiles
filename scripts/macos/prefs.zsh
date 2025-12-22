#!/usr/bin/env zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${0:A}")/../.." && pwd)"
PREFS_DIR="$ROOT_DIR/scripts/macos/prefs.d"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "macOS prefs can only be applied on macOS." >&2
  exit 1
fi

if [[ ! -d "$PREFS_DIR" ]]; then
  echo "Prefs directory not found: $PREFS_DIR" >&2
  exit 1
fi

echo "Applying macOS preferences (subset tuned for development)..."

prefs=(
  dock.zsh
  finder.zsh
  keyboard.zsh
  trackpad.zsh
  ui_ux.zsh
  app_store.zsh
  textedit.zsh
  security_privacy.zsh
  sudo_touchid.zsh
)

for name in "${prefs[@]}"; do
  f="$PREFS_DIR/$name"
  [[ -f "$f" ]] || continue
  echo "-> $f"
  if [[ -x "$f" ]]; then
    "$f"
  else
    bash "$f"
  fi
done

echo "Done. Some changes may require restarting apps or logging out/in."
