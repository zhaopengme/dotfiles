#!/usr/bin/env zsh
#
# macos-check.zsh
# Simple guard to ensure the installer is running on macOS.
#
# Usage:
#   zsh scripts/macos-check.zsh
#
# This script is intentionally tiny and dependency-free.

set -euo pipefail

main() {
  local uname_s
  uname_s="$(uname -s 2>/dev/null || true)"

  if [[ "$uname_s" != "Darwin" ]]; then
    echo "This private dotfiles template is intended for macOS (Darwin)." >&2
    echo "Detected OS: ${uname_s:-unknown}" >&2
    exit 1
  fi

  # Basic sanity checks for common macOS tooling (non-fatal; informational)
  if ! command -v sw_vers >/dev/null 2>&1; then
    echo "Warning: 'sw_vers' not found; macOS version info unavailable." >&2
    exit 0
  fi

  echo "macOS detected: $(sw_vers -productName 2>/dev/null || echo macOS) $(sw_vers -productVersion 2>/dev/null || true)"
}

main "$@"
