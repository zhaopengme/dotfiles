#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${0:A}")" && pwd)"

main() {
  "$SCRIPT_DIR/scripts/common/brew-private-install.zsh"
  "$SCRIPT_DIR/scripts/common/link-private.zsh"
}

main "$@"

