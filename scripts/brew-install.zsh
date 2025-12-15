#!/usr/bin/env zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  echo "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
  elif [[ -d "/usr/local/bin" ]]; then
    export PATH="/usr/local/bin:$PATH"
  fi
}

install_cli_packages() {
  local file="$ROOT_DIR/brew/cli.txt"
  [[ -f "$file" ]] || return

  while IFS= read -r pkg; do
    pkg="${pkg%%#*}"
    pkg="${pkg%%[[:space:]]*}"
    [[ -n "$pkg" ]] || continue

    if brew list --formula "$pkg" >/dev/null 2>&1; then
      echo "brew formula already installed: $pkg"
    else
      echo "Installing brew formula: $pkg"
      brew install "$pkg"
    fi
  done <"$file"
}

install_cask_packages() {
  local file="$ROOT_DIR/brew/cask.txt"
  [[ -f "$file" ]] || return

  while IFS= read -r pkg; do
    pkg="${pkg%%#*}"
    pkg="${pkg%%[[:space:]]*}"
    [[ -n "$pkg" ]] || continue

    if brew list --cask "$pkg" >/dev/null 2>&1; then
      echo "brew cask already installed: $pkg"
    else
      echo "Installing brew cask: $pkg"
      brew install --cask "$pkg"
    fi
  done <"$file"
}

main() {
  ensure_homebrew
  brew update
  install_cli_packages
  install_cask_packages
}

main "$@"

